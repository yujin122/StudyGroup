package com.study.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.study.model.Pagination;
import com.study.model.StudyCalendarDAO;
import com.study.model.StudyCalendarDTO;
import com.study.model.StudyCategoryDAO;
import com.study.model.StudyCategoryDTO;
import com.study.model.StudyInfoDAO;
import com.study.model.StudyInfoDTO;
import com.study.model.StudyJoinDAO;
import com.study.model.StudyJoinDTO;
import com.study.model.StudyMemberDAO;
import com.study.model.StudyMemberDTO;
import com.study.model.TodoDAO;
import com.study.model.TodoDTO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class MainController {
	
	@Autowired private StudyInfoDAO si_dao;
	@Autowired private StudyCategoryDAO sc_dao;
	@Autowired private StudyMemberDAO sm_dao;
	@Autowired private StudyJoinDAO sj_dao;
	@Autowired private TodoDAO td_dao;
	@Autowired private Upload upload;
	@Autowired private StudyCalendarDAO cal_dao;
	
	// 메인페이지
	@RequestMapping("/")
	public String main(@RequestParam(required = false, defaultValue = "1") int page, 
					@RequestParam(required = false, defaultValue = "%%") String cate,
					@RequestParam(required = false, defaultValue = "%%") String mento, Model model) {	
		// 카테고리 가져오기
		List<StudyCategoryDTO> cate_list = sc_dao.getCateList();
		
		// 스터디 정보 총 갯수
		int totalRecord = si_dao.getStudyListCnt(cate, mento);
		
		// 페이징
		Pagination pagination = new Pagination();
		pagination.pageInfo(page, 12, totalRecord);
		
		// 스터디 정보 가져오기
		List<StudyInfoDTO> study_list = si_dao.getStudyList(pagination, cate, mento);
		
		model.addAttribute("cate_list", cate_list);
		model.addAttribute("study_list", study_list);
		model.addAttribute("pagination", pagination);
		if(!cate.equals("%%")) {
			model.addAttribute("cate", cate);
		}
		if(!mento.equals("%%")) {
			model.addAttribute("mento", mento);
		}
		
		return "main";
	}
	
	// 스터디모임 등록 폼
	@RequestMapping("/study_form.do")
	public String form(Model model) {
		List<StudyCategoryDTO> list = sc_dao.getCateList();
		
		model.addAttribute("list", list);
		
		return "study_main/study_form";
	}
	
	// 스터디 등록
	@RequestMapping("/study_insert.do")
	public String study_insert(@ModelAttribute StudyInfoDTO dto, MultipartHttpServletRequest mRequest, 
				RedirectAttributes rtts, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		  
		String study_mem_id = session.getAttribute("session_mem_id").toString();
		
		MultipartFile mFile = mRequest.getFile("file_img");
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\StudyGroup\\resources\\upload\\study\\";
		
		String study_img = upload.fileUplaod(mFile, path);
		
		int study_num = 1;
			
		if(si_dao.getStudyListCnt("%%", "%%") != 0) {
			study_num = si_dao.getMaxNum()+1;
		}
		
		dto.setStudy_num(study_num);
		dto.setStudy_img(study_img);
		
		int res = si_dao.insertStudyInfo(dto);
		
		if(res > 0) {
			StudyMemberDTO sm_dto = new StudyMemberDTO();
			sm_dto.setStudy_mem_id(study_mem_id);
			sm_dto.setStudy_mem_num(study_num);
			sm_dto.setStudy_mem_position("L");
			
			int mem_res = sm_dao.insertStudyMember(sm_dto);
			
			if(mem_res > 0) {
				return "redirect:/";
			}else {
				rtts.addFlashAttribute("msg", "스터디모임 멤버 입력 실패");
				
				return "redirect:study_form.do";
			}
		}else {
			rtts.addFlashAttribute("msg", "스터디모임 정보 입력 실패");
			
			return "redirect:study_form.do";
		}
	}
	
	// 스터디 상세페이지
	@RequestMapping("/study_cont.do")
	public String study_cont(@RequestParam int num, @RequestParam(required = false) String mento, @RequestParam(required = false) String category,
							@RequestParam(required = false, defaultValue = "1") int page, @RequestParam(required = false) String menu, Model model) {
		StudyInfoDTO dto = si_dao.getStudyCont(num);
		StudyCategoryDTO cate = sc_dao.getCateCont(dto.getStudy_category());
		
		model.addAttribute("dto", dto);
		model.addAttribute("cate", cate);
		model.addAttribute("mento", mento);
		model.addAttribute("category", category); 
		model.addAttribute("page", page);
		model.addAttribute("menu", menu);
		
		return "study_main/study_cont";
	}
	
	// 스터디 가입신청
	@RequestMapping("/study_join.do")
	public String study_join(@RequestParam int num, RedirectAttributes rtts, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String study_mem_id = session.getAttribute("session_mem_id").toString();
		
		StudyJoinDTO dto = new StudyJoinDTO();
		dto.setStudy_mem_id(study_mem_id);
		dto.setStudy_num(num);
		
		int s_mem = sm_dao.searchStudyMember(study_mem_id, num);
		
		if(s_mem > 0) {
			rtts.addFlashAttribute("msg", "이미 가입한 스터디 모임입니다.");
		}else {
			int join = sj_dao.searchStudyMem(dto);
			
			if(join > 0) {
				rtts.addFlashAttribute("msg", "이미 가입 신청한 스터디 모임입니다.");
				
			}else {
				int res = sj_dao.insertStudyJoin(dto);
				
				if(res > 0) {
					rtts.addFlashAttribute("msg", "가입 신청 성공");
				}else {
					rtts.addFlashAttribute("msg", "가입 신청 실패");
				}
			}
		}		
		return "redirect:study_cont.do?num="+num;
	}
	
	// 스터디 관리 페이지
	@RequestMapping("/manage.do")
	public String d(Model model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String session_id = session.getAttribute("session_mem_id").toString();
		
		// ToDO 목록
		List<TodoDTO> todoList = this.td_dao.getTodoList(session_id);
		// 이번주 일정
		List<StudyCalendarDTO> Weekly = this.cal_dao.getWeekly(session_id);
		// 가입한 스터디 목록
		List<StudyInfoDTO> MyStudy = this.si_dao.getMyStList(session_id);
		// 가입 대기 스터디 목록
		List<StudyInfoDTO> WtStudy = this.si_dao.getWStList(session_id);
			
		model.addAttribute("todoList", todoList);
		model.addAttribute("weekly", Weekly);
		model.addAttribute("MyStudy", MyStudy);
		model.addAttribute("WaitStudy", WtStudy);
		return "main_manage/manage_main";
	}
	
	// 스터디 관리 todo 목록 상세 페이지
	@ResponseBody
	@RequestMapping("todo_listDetail.do")
	public List<TodoDTO> getList(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String session_id = session.getAttribute("session_mem_id").toString();
		List<TodoDTO> list = td_dao.getTodoList(session_id);
		
		return list;
	}
	
	// 스터디 관리 todo 목록 삭제
	@ResponseBody
	@RequestMapping("/todo_delete.do")
	public int tododelete(@RequestParam(value = "checkArr") String [] chbox) {
			
		int result = this.td_dao.tododel(chbox);
	
		return result;
	}
	
	// 스터디 관리 todo 목록 중 완료 항목
	@ResponseBody
	@RequestMapping("/todo_finish.do")
	public int todoFinish(@RequestParam(value = "checkArr") String [] chbox) {
		
		int result = this.td_dao.finishTodo(chbox);
		
		return result;
	}
	
	// 스터디 관리 todo 목록 내용 추가
	@ResponseBody
	@RequestMapping("/todo_insert.do")
	public int todoinsert(@RequestParam(value = "todo_text") String todo_text, HttpServletResponse response, HttpServletRequest request) throws IOException {
		
	  HttpSession session = request.getSession();
	  String session_id = session.getAttribute("session_mem_id").toString();
	
      response.setContentType("text/html; charset=UTF-8");
      int result = this.td_dao.insertTodo(todo_text, session_id);

      return result;
   }
	
}
