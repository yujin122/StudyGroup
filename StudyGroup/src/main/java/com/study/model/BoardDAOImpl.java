package com.study.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAOImpl implements BoardDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public int getListCount() {
		
		return this.sqlSession.selectOne("bbsCount");
	}

	@Override
	public List<BoardDTO> getBoardList(int page, int rowsize) {
		
		// 해당 페이지에서 시작 번호
		int startNo = (page * rowsize) - (rowsize - 1);
		
		// 해당 페이지의 끝 번호
		int endNo = (page * rowsize);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", startNo);
		map.put("end", endNo);
		
		return this.sqlSession.selectList("bbsList", map);
	}

	@Override
	public int catgListCount(String catg) {

		return this.sqlSession.selectOne("catgCount", catg);
	}

	@Override
	public List<BoardDTO> catgBoardList(String catg, int page, int rowsize) {
		
		// 해당 페이지에서 시작 번호
		int startNo = (page * rowsize) - (rowsize - 1);
		
		// 해당 페이지의 끝 번호
		int endNo = (page * rowsize);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", startNo);
		map.put("end", endNo);
		map.put("catg", catg);
		
		return this.sqlSession.selectList("catgList", map);
	}

	@Override
	public int searchListCount(String opt, String text) {
		
		if(opt.equals("title")) {
			return this.sqlSession.selectOne("searchCount1", text);
		} else if(opt.equals("cont")) {
			return this.sqlSession.selectOne("searchCount2", text);
		} else {
			return this.sqlSession.selectOne("searchCount3", text);
		}
		
	}

	@Override
	public List<BoardDTO> searchBoardList(String opt, String text, int page, int rowsize) {
		
		// 해당 페이지에서 시작 번호
		int startNo = (page * rowsize) - (rowsize - 1);
		
		// 해당 페이지의 끝 번호
		int endNo = (page * rowsize);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", startNo);
		map.put("end", endNo);
		map.put("text", text);
		
		if(opt.equals("title")) {
			return this.sqlSession.selectList("searchList1", map);
		} else if(opt.equals("cont")) {
			return this.sqlSession.selectList("searchList2", map);
		} else {
			return this.sqlSession.selectList("searchList3", map);
		}

	}
	
	
	@Override
	public int writeBoard(BoardDTO dto) {
		
		return this.sqlSession.insert("bbsWrite", dto);
	}

	@Override
	public BoardDTO getBoardCont(int board_no) {
		
		return this.sqlSession.selectOne("bbsCont", board_no);
	}
	
	@Override
	public void hitBoard(int board_no) {
		
		this.sqlSession.update("bbsHit", board_no);
	}

	@Override
	public int editBoard(BoardDTO dto) {
		
		return this.sqlSession.update("bbsEdit", dto);
	}

	@Override
	public int deleteBoard(int board_no) {
		
		return this.sqlSession.delete("bbsDelete", board_no);
	}

	//닉네임 가져오기
	@Override
	public String getNickname(String mem_id) {
		
		return this.sqlSession.selectOne("getNick", mem_id);
	}


	

}
