package com.study.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.study.model.MemberDAO;
import com.study.model.MemberDTO;
import com.study.model.NaverLoginBO;

@Controller
public class MemberController {
	//네이버 로그인
	private NaverLoginBO naverLoginBO;
	private String apiResult = null;
	
	@Autowired
	private void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}	
	
	@Autowired private MemberDAO dao;
	@Autowired private Upload upload;
	//로그인페이지이동
	@RequestMapping("/member_login.do")
	public String loginmove(Model model, HttpSession session) {

		//네이버 아이디로 로그인 설정
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		System.out.println("네이버:" + naverAuthUrl);
		model.addAttribute("naver_login_url", naverAuthUrl);
		
		return "member/member_login";
	}
	
	// 네이버 로그인
	@RequestMapping("callback.do")
	public String callback(Model model, @RequestParam String code, @RequestParam String state, HttpSession session) throws IOException, ParseException {

		OAuth2AccessToken oauthToken;
		oauthToken = naverLoginBO.getAccessToken(session, code, state);
		
		//1. 로그인 사용자 정보를 읽어온다.
		apiResult = naverLoginBO.getUserProfile(oauthToken);
				
		//2. String형식인 apiResult를 json형태로 바꿈
		JSONParser parser = new JSONParser();
		Object obj = parser.parse(apiResult);
		JSONObject jsonObj = (JSONObject) obj;
				
		//3. 데이터
		JSONObject response_obj = (JSONObject)jsonObj.get("response");

		// db에 회원 정보 체크 
		String naver_id = (String)response_obj.get("id");
		int res = dao.loginIdCheck(naver_id);

		if(res == 0) {

			session.setAttribute("session_mem_id",naver_id);
			
			MemberDTO dto = new MemberDTO();
			dto.setMem_name((String)response_obj.get("name"));
			dto.setMem_id(naver_id);
			dto.setMem_email((String)response_obj.get("email"));
			dto.setMem_nickname((String)response_obj.get("name"));
			dto.setMem_phone((String)response_obj.get("mobile"));
			dao.naverJoin(dto);
			model.addAttribute("result", "네이버 아이디로 로그인되었습니다.");
				

		}else {
			// 네이버 아이디로 로그인
			session.setAttribute("session_mem_id",naver_id);
			model.addAttribute("result", "네이버 아이디로 로그인되었습니다.");
		}

		return "/member/member_callback";
	}
		
	//가입페이지 이동
	@RequestMapping("/member_sign_up.do")
	public String signupmove() {
		return "member/member_sign_up";
	}
	
	//로그인
	@RequestMapping("/login_ok.do")
	public String Login(MemberDTO dto, HttpServletRequest request, RedirectAttributes rtts) {
		String msg = "";
		
		if(dao.loginIdCheck(dto.getMem_id()) > 0) {
			if(dao.login(dto) > 0) {
				HttpSession session = request.getSession();
				session.setAttribute("session_mem_id", dto.getMem_id());

				return "redirect:/";
			}else {
				msg = "비밀번호가 틀렸습니다.";
			}
		}else {
			msg = "아이디가 존재하지 않습니다.";
		}
		
		rtts.addFlashAttribute("msg", msg);
		return "redirect:member_login.do";
	}
	
	// 로그아웃
	@RequestMapping("/logout.do")
	public String member_logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		
		session.invalidate();
		
		return "redirect:/";
	}
	
	// id 찾기
	@RequestMapping("/member_find_id.do")
	public String findid() {
		
		return "member/member_find_id";
	}
	
	@RequestMapping("/member_find_id_ok.do")	
	public String findid (HttpServletRequest request, Model model) {
		
		String mem_name = request.getParameter("mem_name");
		String mem_number = request.getParameter("mem_number");
		

		String msg = "";
		
		MemberDTO dto = dao.findidOk(mem_number);
		
		if(dto.getMem_name().equals(mem_name)) {
			model.addAttribute("mem_name", dto.getMem_name());
			model.addAttribute("mem_id", dto.getMem_id());
			return "member/member_find_id_ok";
			
		} else {
			if(dto.getMem_name() == "none") {
				msg="가입된 아이디가 없습니다.";
				
			} else {
				msg="이름을 확인해 주세요.";
			}
			
			model.addAttribute("msg", msg);
			return "member/member_find_id";
		} //if
		
	}
	
	//pwd 찾기
	@RequestMapping("/member_find_pwd.do")
	public String findpwdmove() {
		
		return "member/member_find_pwd";
	}
	
	@RequestMapping("/member_find_pwd_ok.do")
	public String findpwd(HttpServletRequest request, Model model) {
		
		String mem_id = request.getParameter("mem_id");
		String mem_name = request.getParameter("mem_name");
		
		MemberDTO dto = dao.findpwOk(mem_id);
		String msg = "";
		
		if(dto.getMem_name().equals(mem_name)) {
			dao.findpwEmail(dto);
			model.addAttribute("mem_id", dto.getMem_id());
			model.addAttribute("mem_email", dto.getMem_email());
			return "member/member_find_pwd_ok";
			
		} else {
			if(dto.getMem_name() == "none") {
				msg="가입된 아이디가 아닙니다.";
				
			} else {
				msg="이름을 확인해 주세요.";
			}
			
			model.addAttribute("msg", msg);
			return "member/member_find_pwd";
		} //if
		
	}
	
	@ResponseBody
	@RequestMapping("/id_check.do")
	public int id_check(@RequestParam String mem_id) {
		return dao.IdCheck(mem_id);
	}
	
	@ResponseBody
	@RequestMapping("/phone_check.do")
	public int phone_check(@RequestParam String mem_phone) {
		return dao.phoneCheck(mem_phone);
	}
	
	@RequestMapping("/sign_up_ok.do")
	public String JoinOk(@ModelAttribute MemberDTO dto, MultipartHttpServletRequest mRequest, RedirectAttributes rtts, HttpSession session){
		String msg = "";
		
		String mem_addr = mRequest.getParameter("mem_addr_1") + "/" + mRequest.getParameter("mem_addr_2") + "/" + mRequest.getParameter("mem_addr_3");
		
		MultipartFile mFile = mRequest.getFile("pro_img");
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\StudyGroup\\resources\\upload\\user\\";
		String mem_img = upload.fileUplaod(mFile, path);
		
		dto.setMem_addr(mem_addr);
		dto.setMem_img(mem_img);
		
		int res = dao.JoinOk(dto);
		
		if(res > 0) {
			session.setAttribute("session_mem_id", dto.getMem_id());
			return "redirect:/";
		}else {
			msg = "회원가입 실패";
			rtts.addFlashAttribute("msg", msg);
			return "redirect:member_join.do";
		}
	}
	
	@ResponseBody
	@RequestMapping("/edit_phone_check.do")
	public int edit_phone_check(@RequestParam String mem_phone) {
		return dao.phoneCheck(mem_phone);
	}
	
	@RequestMapping("/member_edit.do")
	public String edit_cont(Model model, HttpSession session) {
		String mem_id = session.getAttribute("session_mem_id").toString();
		
		MemberDTO dto = this.dao.edit_cont(mem_id);
		
		model.addAttribute("edit_cont",dto);
		
		return "member/member_edit";
	}
	
	@RequestMapping("/member_edit_ok.do")
	public void Edit_Ok(@ModelAttribute MemberDTO dto, MultipartHttpServletRequest mRequest, HttpServletResponse response) throws IOException {
		String mem_addr = mRequest.getParameter("mem_addr_1") + "/" + mRequest.getParameter("mem_addr_2") + "/" + mRequest.getParameter("mem_addr_3");
		dto.setMem_addr(mem_addr);
		
		MultipartFile mFile = mRequest.getFile("pro_img");
		String path = "C:\\Users\\yyj01\\OneDrive\\문서\\GitHub\\Study\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\StudyGroup\\resources\\upload\\user\\";
		String mem_img = upload.fileUplaod(mFile, path);
		
		if(mem_img != "") {
			dto.setMem_img(mem_img);
		}
		
		int res = this.dao.EditOk(dto);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if(res>0) {
			out.println("<script>");
			out.println("alert('수정 완료')");
			out.println("location.href='member_edit.do'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('수정 실패')");
			out.println("history.back()");
			out.println("</script>");
		}
			
	}
}
	

