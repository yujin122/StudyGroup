package com.study.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SboardDAOImpl implements SboardDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<StudyListDTO> getSboardAllList(int num, String category) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("category", category);
		
		return sqlSession.selectList("list", map);
	}

	@Override
	public int insertSboard(SboardDTO dto) {
		return this.sqlSession.insert("write", dto); 
	}

	@Override
	public StudyListDTO getSboardCont(int num) {
		return this.sqlSession.selectOne("getSboardCont", num);
	}
	
	@Override
	public SboardDTO getCont(int num) {
		return this.sqlSession.selectOne("cont", num);
	}

	@Override
	public void hitSboard(int num) {
		this.sqlSession.update("hit", num);
	}

	@Override
	public int editSboard(SboardDTO dto) {
		return this.sqlSession.update("edit", dto);
	}

	@Override
	public int deleteSboard(int num) {
		return this.sqlSession.delete("delete", num);
	}

	@Override
	public int updateHelp(int num, String txt) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("txt", txt);
		
		return sqlSession.update("updateHelp", map);
	}
	
	@Override
	public String helpCheck(int num) {
		return sqlSession.selectOne("helpCheck", num);
	}
	
	@Override
	public void deleteAllBoard(int num) {
		sqlSession.delete("deleteAllBoard", num);
	}
	
	@Override
	public List<Integer> getSboardNum(int study_num) {
		return sqlSession.selectList("getSboardNum", study_num);
	}
}
