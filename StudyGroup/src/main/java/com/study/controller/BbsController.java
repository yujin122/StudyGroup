package com.study.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.study.model.BoardDAO;
import com.study.model.BoardDTO;
import com.study.model.Board_commDAO;
import com.study.model.Board_commDTO;

@Controller
public class BbsController {

	@Autowired
	private BoardDAO dao;
	@Autowired
	private Board_commDAO cdao;
	
	
	@RequestMapping("/bbs_list.do")
	public String bbsList(@RequestParam("page") int pageNo, Model model, HttpSession session) {
		
		// 페이징 작업
		int rowsize = 15;       // 한 페이지당 보여질 게시물의 수
		int block = 5;         // 아래에 보여질 페이지의 최대 수 - 예) [1][2][3] / [4][5][6]
		int totalRecord = 0;   // DB 상의 게시물 전체 수
		int allPage = 0;       // 전체 페이지 수
		int allBlock = 0;	   // 전체 블럭 수
		int page = pageNo;     // 현재 페이지 변수
		
		// 해당 페이지에서 게시물 시작 번호
		int startNo = (page * rowsize) - (rowsize - 1);  // => (page-1)*rowsize + 1
		
		// 해당 페이지의 게시물 끝 번호
		int endNo = (page * rowsize);
		
		// 해당 페이지의 시작 블럭
		int startBlock = (((page-1)/block)*block)+1;     // => page ??
		
		// 해당 페이지의 마지막 블럭
		int endBlock = (((page-1)/block)*block)+ block;  // => page+block-1
		
		// DB 상의 전체 게시물의 수를 확인하는 메서드.
		totalRecord = dao.getListCount();
		
		// 전체 게시물의 수를 한 페이지당 보여질 게시물의 수로 나누어 주어야 함.
		// 이 과정을 거치면 전체 페이지 수가 나옴.
		// 전체 페이지 수가 나올 때 나머지가 있으면 무조건 올려주어야 함.
		allPage = (int)Math.ceil(totalRecord / (double)rowsize);
		
		if(endBlock > allPage) {
		    endBlock = allPage;
		}
		
		allBlock = (int)Math.ceil((allPage/(double)block));
		
		// 페이지에 해당하는 게시물을 가져오는 메서드 호출
		List<BoardDTO> pageList = dao.getBoardList(page, rowsize);
		
		// 지금까지 페이징 처리 시 작업했던 모든 값들을  키로 저장하자.
		model.addAttribute("page", page);
		model.addAttribute("rowsize", rowsize);
		model.addAttribute("block", block);
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("allPage", allPage);
		model.addAttribute("startNo", startNo);
		model.addAttribute("endNo", endNo);
		model.addAttribute("startBlock", startBlock);
		model.addAttribute("endBlock", endBlock);
		model.addAttribute("bbsList", pageList);
		
		model.addAttribute("allBlock", allBlock);
		
		model.addAttribute("cdao", cdao);
		
		//session.setAttribute("mem_id", "kim");
		model.addAttribute("mem_id", session.getAttribute("session_mem_id"));
		
		return "board/bbs_list";
	}
	
	@RequestMapping("/bbs_cont.do")
	public String bbsCont(@RequestParam("no") int board_no, @RequestParam("page") int page, @RequestParam("str") String str, 
			@RequestParam("opt") String opt, @RequestParam("text") String text, Model model, HttpSession session) {
		
		this.dao.hitBoard(board_no);
		BoardDTO dto = this.dao.getBoardCont(board_no);
		
		model.addAttribute("cont", dto);
		model.addAttribute("no", dto.getBoard_no());
		model.addAttribute("mem_id", session.getAttribute("session_mem_id"));
		model.addAttribute("rep_count", cdao.countReply(board_no));
		
		model.addAttribute("page", page);
		model.addAttribute("str", str);
		model.addAttribute("opt", opt);
		model.addAttribute("text", text);
		
		return "board/bbs_cont";
		
	}
	
	@RequestMapping("/bbs_write.do")
	public String bbsWrite(Model model, HttpSession session) {
		
		model.addAttribute("mem_id", session.getAttribute("session_mem_id"));
		model.addAttribute("mem_nickname", dao.getNickname((String)session.getAttribute("session_mem_id")));
		return "board/bbs_write";
	}
	
	@RequestMapping("/bbs_write_ok.do")
	public String bbsWriteOk(BoardDTO dto, Model model) {
	
		int	res = this.dao.writeBoard(dto);
		
		if(res>0) {
			return "redirect:bbs_list.do?page=1";
			
		} else {
			return "redirect:bbs_write.do";
		}
	}
	
	@RequestMapping("/bbs_edit.do")
	public String bbsEdit(@RequestParam("no") int no, @RequestParam("page") int page, @RequestParam("str") String str,
			@RequestParam("opt") String opt, @RequestParam("text") String text, Model model) {
		
		BoardDTO dto = this.dao.getBoardCont(no);
		
		model.addAttribute("cont", dto);
		
		model.addAttribute("page", page);
		model.addAttribute("str", str);
		model.addAttribute("opt", opt);
		model.addAttribute("text", text);
		
		return "board/bbs_edit";
	}
	
	@RequestMapping("/bbs_edit_ok.do")
	public void bbsEditOk(BoardDTO dto, @RequestParam("page") int page, @RequestParam("str") String str,
			@RequestParam("opt") String opt, @RequestParam("text") String text, HttpServletResponse response) throws IOException {
		
		int res = this.dao.editBoard(dto);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if(res>0) {
			out.println("<script>");
			out.println("location.href='bbs_cont.do?no="+dto.getBoard_no()+"&page="+page+"&str="+str+"&opt="+opt+"&text="+text+"'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('수정 실패')");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	@RequestMapping("/bbs_delete.do")
	public void bbsDelete(@RequestParam("no") int no, @RequestParam("page") int page, @RequestParam("str") String str,
			@RequestParam("opt") String opt, @RequestParam("text") String text, HttpServletResponse response) throws IOException {
		
		int res = this.dao.deleteBoard(no);
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if(res>0) {
			out.println("<script>");
			if(str.equals("bbs")) {
				out.println("location.href='bbs_list.do?page="+page+"'");
			} else if(str.equals("search")) {
				out.println("location.href='search_list.do?page="+page+"&opt="+opt+"&text="+text+"'");
			} else {
				out.println("location.href='bbs_catg.do?page="+page+"&catg="+str+"'");
			}
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('삭제 실패')");
			out.println("history.back()");
			out.println("</script>");
		}	
	}
	
	@RequestMapping("/bbs_catg.do")
	public String catgList(@RequestParam("page") int pageNo, @RequestParam("catg") String catg, Model model, HttpSession session) {
		
		// 페이징 작업
		int rowsize = 15;       // 한 페이지당 보여질 게시물의 수
		int block = 5;         // 아래에 보여질 페이지의 최대 수 - 예) [1][2][3] / [4][5][6]
		int totalRecord = 0;   // DB 상의 게시물 전체 수
		int allPage = 0;       // 전체 페이지 수
		int allBlock = 0;	   // 전체 블럭 수
		int page = pageNo;     // 현재 페이지 변수
		
		// 해당 페이지에서 게시물 시작 번호
		int startNo = (page * rowsize) - (rowsize - 1);  // => (page-1)*rowsize + 1
		
		// 해당 페이지의 게시물 끝 번호
		int endNo = (page * rowsize);
		
		// 해당 페이지의 시작 블럭
		int startBlock = (((page-1)/block)*block)+1;     // => page ??
		
		// 해당 페이지의 마지막 블럭
		int endBlock = (((page-1)/block)*block)+ block;  // => page+block-1
		
		// DB 상의 전체 게시물의 수를 확인하는 메서드.
		totalRecord = dao.catgListCount(catg);
		
		// 전체 게시물의 수를 한 페이지당 보여질 게시물의 수로 나누어 주어야 함.
		// 이 과정을 거치면 전체 페이지 수가 나옴.
		// 전체 페이지 수가 나올 때 나머지가 있으면 무조건 올려주어야 함.
		allPage = (int)Math.ceil(totalRecord / (double)rowsize);
		
		if(endBlock > allPage) {
		    endBlock = allPage;
		}
		
		allBlock = (int)Math.ceil((allPage/(double)block));
		
		// 페이지에 해당하는 게시물을 가져오는 메서드 호출
		List<BoardDTO> pageList = dao.catgBoardList(catg, page, rowsize);
		
		// 지금까지 페이징 처리 시 작업했던 모든 값들을  키로 저장하자.
		model.addAttribute("page", page);
		model.addAttribute("rowsize", rowsize);
		model.addAttribute("block", block);
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("allPage", allPage);
		model.addAttribute("startNo", startNo);
		model.addAttribute("endNo", endNo);
		model.addAttribute("startBlock", startBlock);
		model.addAttribute("endBlock", endBlock);
		model.addAttribute("bbsList", pageList);
		
		model.addAttribute("allBlock", allBlock);
		
		model.addAttribute("catg", catg);
		model.addAttribute("cdao", cdao);
		
		model.addAttribute("mem_id", session.getAttribute("session_mem_id"));
	
		return "board/bbs_catg_list";
	}

	@RequestMapping("/search_list.do")
	public String searchList(@RequestParam("page") int pageNo, @RequestParam("opt") String opt,
			@RequestParam("text") String text, Model model, HttpSession session) {
		
		// 페이징 작업
		int rowsize = 15;       // 한 페이지당 보여질 게시물의 수
		int block = 5;         // 아래에 보여질 페이지의 최대 수 - 예) [1][2][3] / [4][5][6]
		int totalRecord = 0;   // DB 상의 게시물 전체 수
		int allPage = 0;       // 전체 페이지 수
		int allBlock = 0;	   // 전체 블럭 수
		int page = pageNo;     // 현재 페이지 변수
		
		// 해당 페이지에서 게시물 시작 번호
		int startNo = (page * rowsize) - (rowsize - 1);  // => (page-1)*rowsize + 1
		
		// 해당 페이지의 게시물 끝 번호
		int endNo = (page * rowsize);
		
		// 해당 페이지의 시작 블럭
		int startBlock = (((page-1)/block)*block)+1;     // => page ??
		
		// 해당 페이지의 마지막 블럭
		int endBlock = (((page-1)/block)*block)+ block;  // => page+block-1
		
		// DB 상의 전체 게시물의 수를 확인하는 메서드.
		totalRecord = dao.searchListCount(opt, text);
		
		// 전체 게시물의 수를 한 페이지당 보여질 게시물의 수로 나누어 주어야 함.
		// 이 과정을 거치면 전체 페이지 수가 나옴.
		// 전체 페이지 수가 나올 때 나머지가 있으면 무조건 올려주어야 함.
		allPage = (int)Math.ceil(totalRecord / (double)rowsize);
		
		if(endBlock > allPage) {
		    endBlock = allPage;
		}
		
		allBlock = (int)Math.ceil((allPage/(double)block));
		
		// 페이지에 해당하는 게시물을 가져오는 메서드 호출
		List<BoardDTO> pageList = dao.searchBoardList(opt, text, page, rowsize);
		
		// 지금까지 페이징 처리 시 작업했던 모든 값들을  키로 저장하자.
		model.addAttribute("page", page);
		model.addAttribute("rowsize", rowsize);
		model.addAttribute("block", block);
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("allPage", allPage);
		model.addAttribute("startNo", startNo);
		model.addAttribute("endNo", endNo);
		model.addAttribute("startBlock", startBlock);
		model.addAttribute("endBlock", endBlock);
		model.addAttribute("bbsList", pageList);
		
		model.addAttribute("allBlock", allBlock);
		model.addAttribute("cdao", cdao);
		
		model.addAttribute("opt", opt);
		model.addAttribute("text", text);
		
		model.addAttribute("mem_id", session.getAttribute("session_mem_id"));
		
		return "board/bbs_search_list";
	}
	
	
	
	// 댓글 영역
	// 댓글 리스트
	@RequestMapping(value= "/bcomm_list.do", produces= "application/text; charset=utf8")
	@ResponseBody
	public String getReplyList(@RequestParam("no") int board_no, @RequestParam("count") int num) {
		
		int count=num;
		
		List<Board_commDTO> cList = this.cdao.getReplyList(board_no, count);
		
		String json = "";
		
		try {
			ObjectMapper mapper = new ObjectMapper();
			json = mapper.writeValueAsString(cList);
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		//System.out.println(json);
		
		return json;
	}
	
	//댓글 쓰기
	@RequestMapping(value="/bcomm_write.do", produces= "application/text; charset=utf8")
	@ResponseBody
	public void writeReply(HttpServletRequest request, HttpSession session) {
		int board_no = Integer.parseInt(request.getParameter("board_no"));
		String bcomm_cont = request.getParameter("bcomm_cont");
		String mem_id = (String)session.getAttribute("session_mem_id");
		String bcomm_nickname = dao.getNickname(mem_id);
		//System.out.println(board_no + bcomm_cont);
		
		this.cdao.writeReply(board_no, bcomm_cont, mem_id, bcomm_nickname);
	}
	
	// 댓글 삭제
	@RequestMapping(value="/bcomm_delete.do", produces= "application/text; charset=utf8")
	@ResponseBody
	public void delteReply(HttpServletRequest request) {
		int bcomm_no = Integer.parseInt(request.getParameter("bcomm_no"));
		
		//System.out.println(bcomm_no);
		
		this.cdao.deleteReply(bcomm_no);
	}
	
	// 댓글 수정
	@RequestMapping(value="/bcomm_edit.do", produces="application/text; charset=utf8")
	@ResponseBody
	public void editReply(HttpServletRequest request) {
		int bcomm_no = Integer.parseInt(request.getParameter("bcomm_no"));
		String edit_cont = request.getParameter("edit_cont");
		
		this.cdao.editReply(bcomm_no, edit_cont);
	}
	
	// 대댓 저장
	@RequestMapping(value="/bcomm_rrep.do", produces="application/text; charset=utf8")
	@ResponseBody
	public void rrepReply(HttpServletRequest request, HttpSession session) {
		int board_no = Integer.parseInt(request.getParameter("board_no"));
		int bcomm_no = Integer.parseInt(request.getParameter("bcomm_no"));
		String rrep_cont = request.getParameter("rrep_cont");
		String mem_id = (String)session.getAttribute("session_mem_id");
		String bcomm_nickname = dao.getNickname(mem_id);
		
		this.cdao.rrepReply(board_no, bcomm_no, rrep_cont, mem_id, bcomm_nickname);
	}
	
	
	
}
