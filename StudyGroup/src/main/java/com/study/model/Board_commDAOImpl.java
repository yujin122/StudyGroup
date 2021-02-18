package com.study.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class Board_commDAOImpl implements Board_commDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public List<Board_commDTO> getReplyList(int board_no, int count) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("board_no", board_no);
		map.put("count", count);
		
		return this.sqlSession.selectList("replyList", map);
	}

	@Override
	public int writeReply(int board_no, String bcomm_cont, String mem_id, String bcomm_nickname) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("board_no", board_no);
		map.put("bcomm_cont", bcomm_cont);
		map.put("bcomm_writer", mem_id);
		map.put("bcomm_nickname", bcomm_nickname);
		
		if(countBcomm() == 0) {
			return this.sqlSession.insert("writeFirst", map);
		} else {
			return this.sqlSession.insert("writeReply", map);
		}
		
	}

	@Override
	public int editReply(int bcomm_no, String edit_cont) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bcomm_no", bcomm_no);
		map.put("edit_cont", edit_cont);
		
		return this.sqlSession.insert("editReply", map);
	}

	@Override
	public int deleteReply(int bcomm_no) {
	
		return this.sqlSession.delete("deleteReply", bcomm_no);
	}

	@Override
	public int rrepReply(int board_no, int bcomm_no, String rrep_cont, String mem_id, String bcomm_nickname) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("board_no", board_no);
		map.put("bcomm_no", bcomm_no);
		map.put("rrep_cont", rrep_cont);
		map.put("bcomm_writer", mem_id);
		map.put("bcomm_nickname", bcomm_nickname);
		
		this.sqlSession.update("updateStep", map);
		
		return this.sqlSession.insert("rrepReply", map);
	}

	
	
	// 댓글 갯수
	@Override
	public int countReply(int board_no) {
		
		return this.sqlSession.selectOne("countReply", board_no);
	}

	@Override
	public int countBcomm() {
		
		return this.sqlSession.selectOne("countBcomm");
	}

}
