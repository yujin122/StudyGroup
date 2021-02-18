package com.study.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.study.model.SboardDAO;
import com.study.model.SboardDTO;
import com.study.model.ScommDAO;
import com.study.model.ScommDTO;
import com.study.model.StudyCalendarDAO;
import com.study.model.StudyCalendarDTO;
import com.study.model.StudyCategoryDAO;
import com.study.model.StudyCategoryDTO;
import com.study.model.StudyFileDAO;
import com.study.model.StudyFileDTO;
import com.study.model.StudyInfoDAO;
import com.study.model.StudyInfoDTO;
import com.study.model.StudyJoinDAO;
import com.study.model.StudyListDTO;
import com.study.model.StudyManageDAO;
import com.study.model.StudyManageDTO;
import com.study.model.StudyMemberDAO;
import com.study.model.TipCheckDAO;


@Controller
public class StudyController {
	
	@Autowired private StudyCalendarDAO cal_dao;
	@Autowired private StudyInfoDAO info_dao;
	@Autowired private StudyCategoryDAO cate_dao;
	@Autowired private StudyManageDAO manage_dao;
	@Autowired private Upload upload;
	@Autowired private SboardDAO board_dao;
	@Autowired private ScommDAO scomm_dao;
	@Autowired private StudyMemberDAO smem_dao;
	@Autowired private StudyFileDAO file_dao;
	@Autowired private TipCheckDAO tip_dao;
	@Autowired private StudyJoinDAO join_dao;
	
	// 스터디 게시판
	@RequestMapping("/sboard_main.do")
	public String list(@RequestParam(required = false, defaultValue = "%%") String category, @RequestParam(required = false, defaultValue = "0") int num, 
						HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();

		if(num != 0) {
			// 스터디 번호 저장
			session.setAttribute("session_study_num", num);
			// 스터디 정보 저장
			StudyInfoDTO info_dto = info_dao.getStudyInfo(num);
			session.setAttribute("session_study_img", info_dto.getStudy_img());
			session.setAttribute("session_study_name", info_dto.getStudy_name());
		}else {
			num = Integer.parseInt(session.getAttribute("session_study_num").toString());
		}		
		
		List<StudyListDTO> list = board_dao.getSboardAllList(num, category);
		
		model.addAttribute("SboardList", list);		
		model.addAttribute("category", category);
	
		return "study/study_board_main";		
	}
	
	@RequestMapping("/sboard_write.do") 
	public String write(Model model, HttpSession session, @RequestParam(required = false, defaultValue = "%%") String category) {		
		
		model.addAttribute("mem_id", session.getAttribute("session_mem_id"));
		model.addAttribute("category", category);
		
		return "study/study_write";		
	}
	// 스터디 게시글 작성
	@RequestMapping("/sboard_write_ok.do")
	public void writeOk(@ModelAttribute SboardDTO dto, MultipartHttpServletRequest mRequest, HttpServletResponse response, 
					HttpSession session, @RequestParam(required = false, defaultValue = "%%") String category) throws IOException {		
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\StudyGroup\\src\\main\\webapp\\resources\\upload\\study_board\\";
		
		response.setContentType("text/html; charset=UTF-8");		
		PrintWriter out = response.getWriter();
		
		dto.setStudy_num((Integer)session.getAttribute("session_study_num"));

		int result = this.board_dao.insertSboard(dto);	
		
		if(result > 0) {
			Map<String, Object> map = new HashMap<String, Object>();
			List<MultipartFile> fileList = mRequest.getFiles("sboard_file");
			
			List<Map<String, Object>> file_list = new ArrayList<Map<String,Object>>();
			
			for(MultipartFile mf : fileList) {
				String newFileName = upload.fileUplaod(mf,path);
				if(!newFileName.equals("")) {
					map.put("original", mf.getOriginalFilename());
					map.put("new", newFileName);
					
					file_list.add(map);
					file_dao.fileInsert(map);
				}
				
			}
			
			out.println("<script>");
			out.println("location.href='sboard_main.do?category="+category+"'");
			out.println("</script>");
		}
	}
	
	// 스터디 게시판 상세내용
	@RequestMapping("/sboard_cont.do")
	public String cont(@RequestParam("num")int sboard_num, Model model, HttpSession session,
					@RequestParam(required = false, defaultValue = "%%") String category) {
		
		this.board_dao.hitSboard(sboard_num);
		
		StudyListDTO dto = this.board_dao.getSboardCont(sboard_num);
		List<StudyFileDTO> file_list = file_dao.getFiles(sboard_num);
		
		List<ScommDTO> scomm_list = scomm_dao.getScommList(sboard_num);
		ScommDTO dto1 = this.scomm_dao.getCont(sboard_num);
		model.addAttribute("scomm_cont", dto1);
		model.addAttribute("scomm_list", scomm_list);
		
		model.addAttribute("sboard_cont", dto);
		model.addAttribute("file_list", file_list);
		model.addAttribute("category", category);
		
		return "study/study_write_detail";
	}
	// 도움됐어요 체크
	@ResponseBody
	@RequestMapping("/tip_check.do")
	public String tip_check(@RequestParam int num, HttpSession session) {
		String mem_id = session.getAttribute("session_mem_id").toString();
		
		int res = tip_dao.tipCheck(num, mem_id);
		
		if(res > 0) {
			return "tip.png";
		}else {
			return "tip_empty.png";
		}
	}
	// 도움됐어요 눌렀을때
	@ResponseBody
	@RequestMapping("/tip_add.do")
	public int tip_add(@RequestParam int num, HttpSession session) {
		String mem_id = session.getAttribute("session_mem_id").toString();
		
		if(tip_dao.tipCheck(num, mem_id) > 0) {
			return tip_dao.tipDelete(num, mem_id);
		}else {
			return tip_dao.tipInsert(num, mem_id);
		}	
	}
	// 질문 체크 확인
	@ResponseBody
	@RequestMapping("/question_check.do")
	public String question_check(@RequestParam int num) {
		return board_dao.helpCheck(num);
	}
	// 질문 눌렀을때
	@ResponseBody
	@RequestMapping("/question.do")
	public int question(@RequestParam int num) {
		String txt = "";
		SboardDTO dto = board_dao.getCont(num);
		
		if(dto.getSboard_help().equals("unsolved")) {
			txt = "solved";
		}else {
			txt = "unsolved";
		}
		
		return board_dao.updateHelp(num, txt);
	}
	
	// 파일다운로드
	@RequestMapping("/fileDownload.do")
	public void fileDownload(@RequestParam String newFile, @RequestParam String originalFile, HttpServletRequest request, HttpServletResponse response) throws IOException {
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\StudyGroup\\src\\main\\webapp\\resources\\upload\\study_board\\";
		
		String realPath = "";
		
		try {
			String browser = request.getHeader("User-Agent");
			if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")) {
				originalFile = URLEncoder.encode(originalFile, "utf-8").replaceAll("\\\\", "%20");
				originalFile = originalFile.replaceAll("\\+", "%20");
			}else {
				originalFile = new String(originalFile.getBytes("utf-8"), "ISO-8859-1");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		realPath = path + newFile;
		response.setHeader("Content-Disposition", "attachment;filename=\"" + originalFile + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(realPath);
			FileCopyUtils.copy(fis, out);
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(fis != null) {
				try {
					fis.close();
				}catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
	}
	
	// 스터디 게시판 수정 폼
	@RequestMapping("/sboard_edit.do")
	public String edit(@RequestParam("num")int sboard_num, Model model, 
				@RequestParam(required = false, defaultValue = "%%") String category) {
		
		SboardDTO dto = this.board_dao.getCont(sboard_num);
		
		model.addAttribute("sboard_cont", dto);
		model.addAttribute("category", category);
		
		return "study/study_write_edit";
	}
	
	// 스터디 게시판 수정 
	@RequestMapping("/sboard_edit_ok.do")
	public void editOk(@ModelAttribute SboardDTO dto, HttpServletResponse response,  MultipartHttpServletRequest mRequest,
				@RequestParam(required = false, defaultValue = "%%") String category) throws IOException {
		// 파일 삭제
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\StudyGroup\\src\\main\\webapp\\resources\\upload\\study_board\\";
		List<StudyFileDTO> list = file_dao.getFiles();
		
		for(int i = 0; i < list.size(); i++) {
			StudyFileDTO file_dto = list.get(i);
			String delFileName = path + file_dto.getBoard_img_new();
			
			File file = new File(delFileName);
			
			if(file.exists()) {
				file.delete();
			}
		}
		
		file_dao.fileDelete();
		
		// 파일 업로드
		Map<String, Object> map = new HashMap<String, Object>();
		List<MultipartFile> fileList = mRequest.getFiles("sboard_file");
		
		for(MultipartFile mf : fileList) {
			String newFileName = upload.fileUplaod(mf,path);
			if(!newFileName.equals("")) {
				map.put("num", dto.getSboard_num());
				map.put("original", mf.getOriginalFilename());
				map.put("new", newFileName);
				
				file_dao.fileUpdateInsert(map);
			}
		}
		
		// 내용 수정
		int result = this.board_dao.editSboard(dto);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		if(result>0) {
			out.println("<script>");
			out.println("location.href='sboard_cont.do?num="+dto.getSboard_num()+"&category="+category+"'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('다시 시도해주세요.')");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	@ResponseBody
	@RequestMapping("/getFile.do")
	public List<StudyFileDTO> getFile(@RequestParam int num){
		return file_dao.getFiles(num);
	}
	
	@ResponseBody
	@RequestMapping("/file_delete.do")
	public int file_delete(@RequestParam String fileName) {
		return file_dao.fileUpdate(fileName);
	}
	
	@ResponseBody
	@RequestMapping("file_delete_cancle.do")
	public int file_delete_cancle(@RequestParam int num) {
		return file_dao.fileUpdate(num);
	}
	
	// 스터디 게시판 삭제
	@RequestMapping("/sboard_delete.do")
	public void delete(@RequestParam("num") int sboard_num, HttpServletResponse response, 
				@RequestParam(required = false, defaultValue = "%%") String category) throws IOException {
		scomm_dao.deleteBoard(sboard_num);
		int result = this.board_dao.deleteSboard(sboard_num);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		if(result>0) {
			out.println("<script>");
			out.println("location.href='sboard_main.do?category="+category+"'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('삭제 실패')");
			out.println("history.back()");
			out.println("</script>");
		}	
	}

	// 스터디 게시판 댓글 작성
	@RequestMapping("/scomm_write.do")
	public void scomm_write(@RequestParam("num")int sboard_num, ScommDTO dto, HttpServletResponse response, 
				@RequestParam(required = false, defaultValue = "%%") String category) throws IOException {		
		
		int result = this.scomm_dao.writeScomm(dto);
		
		response.setContentType("text/html; charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		
		if(result>0) {
			out.println("<script>");
			out.println("location.href='sboard_cont.do?num="+dto.getSboard_num()+"&category="+category+"'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("history.back()");
			out.println("</script>");
		} 
	}
	
	@RequestMapping("/scomm_delete.do")
	public void scomm_delete(@RequestParam("commnum") int scomm_num, @RequestParam("boardnum") int board_num, 
						HttpServletResponse response, @RequestParam(required = false, defaultValue = "%%") String category) throws IOException {
	
		int result = this.scomm_dao.deleteScomm(scomm_num);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		if(result>0) {
			out.println("<script>");
			out.println("location.href='sboard_cont.do?num="+board_num+"&category="+category+"'"); 
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	@RequestMapping("/scomm_update.do")
	public void scomm_update(@RequestParam("num") int scomm_num, @RequestParam("snum") int sboard_num, ScommDTO dto,
						HttpServletResponse response, @RequestParam(required = false, defaultValue = "%%") String category) throws IOException {
	
		int result = this.scomm_dao.updateScomm(dto);
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		if(result>0) {
			out.println("<script>");
			out.println("location.href='sboard_cont.do?num="+sboard_num+"&category="+category+"'"); 
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	// 관리페이지
	@RequestMapping("/study_manage_main.do")
	public ModelAndView studyM(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String mem_id = session.getAttribute("session_mem_id").toString();
		int study_num = (Integer)session.getAttribute("session_study_num");
		
		String mem_position = smem_dao.getMemberPosition(study_num, mem_id);
		
		ModelAndView mv = new ModelAndView();
		
		if(mem_position.equals("L")) {
			mv.setViewName("/study/study_manage_main");
		}else {
			mv.setViewName("/study/study_manage_main_mem");
		}
		
		return mv;
	}
	
	// 멤버관리
	@RequestMapping("study_manage_member.do")
	public String studyMem(Model model, HttpServletRequest request) {
		// 스터디 번호 세션 받기
		HttpSession session = request.getSession();
		int num = (Integer) session.getAttribute("session_study_num");
		
		// 멘티 정보
		StudyManageDTO dto = this.manage_dao.getLeader(num);
		// 스터디 멤버 정보
		List<StudyManageDTO> SMemList = this.manage_dao.getSMemList(num);
		// 멤버 수
		StudyManageDTO countMember = this.manage_dao.countMember(num);
		
		model.addAttribute("countMember", countMember);
		model.addAttribute("leaderInfo", dto);
		model.addAttribute("SMemList", SMemList);
		
		return "/study/study_member";
	}
	
	// 스터디모임 가입 승인 관리
	@RequestMapping("study_manage_join.do")
	public String StudyJoin(Model model, HttpServletRequest request) {
		
		// 스터디 번호 세션 받기
		HttpSession session = request.getSession();
		int num = (Integer) session.getAttribute("session_study_num");
				
		// 스터디 정원
		StudyInfoDTO si_dto = this.info_dao.getPeople(num);
		// 멤버 수
		StudyManageDTO countMember = this.manage_dao.countMember(num);

		// 멘티 정보
		StudyManageDTO dto = this.manage_dao.getLeader(num);
		// 대기하는 멤버 정보
		List<StudyManageDTO> WMemList = this.manage_dao.getWMemList(num);
		
		model.addAttribute("countMember", countMember);
		model.addAttribute("studyPeople", si_dto);
		model.addAttribute("leaderInfo", dto);
		model.addAttribute("WMemList", WMemList);
		
		return "/study/study_join";
	}
	
	@RequestMapping("study_member_delete.do")
	public void deleteMember(@RequestParam("id") String study_mem_id,
			HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 스터디 번호 세션 받기
		HttpSession session = request.getSession();
		int num = (Integer) session.getAttribute("session_study_num");
				
		response.setContentType("text/html; charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		 
		// 스터디 멤버 삭제(강퇴)
		int result = this.manage_dao.deleteMember(num, study_mem_id);
		
		
		if(result>0) {
			out.println("<script>");
			out.println("alert('멤버를 탈퇴시켰습니다.')");
			out.println("location.href='study_manage_member.do'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('삭제 실패')");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	@RequestMapping("study_reject_join.do")
	public void reject(@RequestParam("id") String study_mem_id, 
			HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		// 스터디 번호 세션 받기
		HttpSession session = request.getSession();
		int num = (Integer)session.getAttribute("session_study_num");
		
		response.setContentType("text/html; charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		
		// 멤버 승인 거절
		int result = this.manage_dao.rejectJoin(num, study_mem_id);
		
		
		if(result>0) {
			out.println("<script>");
			out.println("alert('가입이 거절되었습니다.')");
			out.println("location.href='study_manage_join.do'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('삭제 실패')");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	@RequestMapping("study_member_insert.do")
	public void insert(@RequestParam("id") String id, 
			HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		//세션 추가
		HttpSession session = request.getSession();
		int num = (Integer)session.getAttribute("session_study_num");
		
		// 대기에서 삭제
		this.manage_dao.rejectJoin(num, id);
		
		// 멤버로 추가(study_join에서 study_member)
		int result = this.manage_dao.addMember(num, id);
		
		if(result>0) {
			out.println("<script>");
			out.println("alert('스터디 멤버로 승인되었습니다.')");
			out.println("location.href='study_manage_join.do'");
			out.println("</script>");
		}else {
			out.println("<script>");
			out.println("alert('승인 실패')");
			out.println("history.back()");
			out.println("</script>");
		}
	}
	
	@RequestMapping("study_member_info.do")
	public String study_mem_info(Model model, HttpServletRequest request) {
		// 스터디 번호 세션 받기
		HttpSession session = request.getSession();
		int num = (Integer) session.getAttribute("session_study_num");
		
		// 멘티 정보
		StudyManageDTO dto = this.manage_dao.getLeader(num);
		// 스터디 멤버 정보
		List<StudyManageDTO> SMemList = this.manage_dao.getSMemList(num);
		// 멤버 수
		StudyManageDTO countMember = this.manage_dao.countMember(num);
		// 리더 수
		StudyManageDTO countLeader = this.manage_dao.countLeader(num);
		
		model.addAttribute("countMember", countMember);
		model.addAttribute("countLeader", countLeader);
		model.addAttribute("leaderInfo", dto);
		model.addAttribute("SMemList", SMemList);
				
		return "/study/study_member_mem";
	}
	
	// 일정페이지 이동
	@RequestMapping("/study_calendar.do")
	public String study_calendar() {
		return "study/study_calendar";
	}
	
	// 일정 리스트
	@ResponseBody
	@RequestMapping("/getStudyCalendar.do")
	public List<StudyCalendarDTO> getStudyCalendar(HttpSession session) {
		int study_num = (Integer)session.getAttribute("session_study_num");
		
		return cal_dao.getStudyCal(study_num);
	}
	
	// 일정 상세내용
	@ResponseBody
	@RequestMapping("/study_calendar_cont.do")
	public StudyCalendarDTO getStudyCalendarCont(@RequestParam int scal_num) {
		return cal_dao.getStudyCalCont(scal_num);
	}
	
	// 스터디 모임 정보 관리 페이지 이동
	@RequestMapping("/study_info_form.do")
	public String study_info_form(Model model, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		int study_num = Integer.parseInt(session.getAttribute("session_study_num").toString());
		
		StudyInfoDTO dto = info_dao.getStudyCont(study_num);
		List<StudyCategoryDTO> list = cate_dao.getCateList();
		
		model.addAttribute("dto", dto);
		model.addAttribute("list", list);
		
		return "study/study_info_edit";
	}
	
	// 스터디 모임 정보 수정
	@RequestMapping("/study_info_update.do")
	public String study_info_update(@ModelAttribute StudyInfoDTO dto, MultipartHttpServletRequest mRequest, RedirectAttributes rtts, HttpSession session) {
		
		String study_img = "";
		
		MultipartFile mFile = mRequest.getFile("file_img");
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\StudyGroup\\resources\\upload\\study\\";
		
		study_img = upload.fileUplaod(mFile, path);
		
		if(!study_img.equals("")) {
			dto.setStudy_img(study_img);
		}
		
		int res = info_dao.updateStudyInfo(dto);
		
		if(res > 0) {
			session.setAttribute("session_study_img", dto.getStudy_img());
			session.setAttribute("session_study_name", dto.getStudy_name());
			
			return "redirect:study_info_form.do";
		}else {
			rtts.addFlashAttribute("msg", "수정 실패");
			
			return "redirect:study_info_form.do";
		}
	}
	
	// 스터디 정보 페이지
	@RequestMapping("/study_info.do")
	public String study_info(Model model, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		int study_num = Integer.parseInt(session.getAttribute("session_study_num").toString());
		
		StudyInfoDTO dto = info_dao.getStudyCont(study_num);
		
		model.addAttribute("dto", dto);
		
		return "study/study_info";
	}
	
	// 스터디 모임 삭제
	@RequestMapping("/study_delete.do")
	public String study_delete(@RequestParam int study_num, RedirectAttributes rtts) {
		// 댓글 삭제
		scomm_dao.deleteStudyComm(study_num);
		// 게시물, 게시물 파일 삭제
		List<Integer> list = board_dao.getSboardNum(study_num);
		
		for(int i = 0; i < list.size(); i++) {
			String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\StudyGroup\\src\\main\\webapp\\resources\\upload\\study_board\\";
			int sboard_num = list.get(i);
			
			List<StudyFileDTO> file_list = file_dao.getFiles(sboard_num);
			
			for(int j = 0; j < file_list.size(); j++) {
				StudyFileDTO file_dto = file_list.get(j);
				String delFile = path + file_dto.getBoard_img_new();
				
				File file = new File(delFile);
				
				if(file.exists()) {
					file.delete();
				}
			}
			
			file_dao.deleteFileAll(sboard_num);
		}
		
		board_dao.deleteAllBoard(study_num);
		// 스터디 일정삭제
		cal_dao.deleteAllCal(study_num);
		// 스터디 가입신청 삭제
		join_dao.deleteJoinAll(study_num);
		// tip 정보 삭제
		tip_dao.deleteTipAll(study_num);
		// 스터디 멤버 정보 삭제
		smem_dao.deleteStudyMember(study_num);
		// 스터디 정보 삭제
		StudyInfoDTO info_dto = info_dao.delStudyCont(study_num);
		String info_path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\StudyGroup\\resources\\upload\\study\\";
		String infoFile = info_path + info_dto.getStudy_img();
		
		File file = new File(infoFile);
		if(file.exists()) {
			file.delete();
		}
		int res = info_dao.deleteInfo(study_num);
		
		if(res > 0) {
			return "redirect:manage.do";
		}else {
			rtts.addFlashAttribute("msg", "삭제 실패");
			return "redirect:study_info_form.do";
		}
	}
	
	// 스터디 일정 관리 페이지 이동
	@RequestMapping("/study_calendar_manage.do")
	public String study_calendar_manage(Model model, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		int study_num = Integer.parseInt(session.getAttribute("session_study_num").toString());
		
		List<StudyCalendarDTO> list = cal_dao.getStudyCal(study_num);
		
		model.addAttribute("list", list);
		
		return "study/study_manage_calendar";
	}
	
	// 스터디 일정 추가
	@RequestMapping("/calendar_insert.do")
	public String calendar_insert(@ModelAttribute StudyCalendarDTO dto, HttpServletRequest request, RedirectAttributes rtts) {
		
		HttpSession session = request.getSession();
		int study_num = Integer.parseInt(session.getAttribute("session_study_num").toString());
		 
		int scal_num = 1;
		
		if(cal_dao.calCnt() > 0) {
			scal_num = cal_dao.calMaxNum()+1;
		}
		
		dto.setScal_num(scal_num);
		dto.setStudy_num(study_num);
		
		dto.setScal_sdate(dto.getScal_sdate().substring(0,10) + " " + dto.getScal_sdate().substring(11,16));
		dto.setScal_edate(dto.getScal_edate().substring(0,10) + " " + dto.getScal_edate().substring(11,16));
		
		int res = cal_dao.insertStudyCal(dto);
		
		if(res > 0) {
			return "redirect:study_calendar_manage.do";
		}else {
			rtts.addFlashAttribute("msg", "일정 등록 실패");
			
			return "redirect:study_calendar_manage.do";
		}
	}
	
	// 스터디 모임 일정 삭제
	@RequestMapping("/calendar_delete.do")
	public String calendar_delete(@RequestParam int[] delCheck, RedirectAttributes rtts) {
		int res = 0;
		
		for(int i = 0; i < delCheck.length; i++) {
			res += cal_dao.deleteStudyCal(delCheck[i]);
		}
		System.out.println(delCheck.length);
		System.out.println(res);
		if(res == delCheck.length) {
			return "redirect:study_calendar_manage.do";
		}else {
			rtts.addFlashAttribute("msg", "일정 삭제 실패");
			
			return "redirect:study_calendar_manage.do";
		}
	}
	
}
