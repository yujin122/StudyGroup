package com.study.model;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TipCheckDAOImpl implements TipCheckDAO{
	
	@Autowired private SqlSessionTemplate sqlSession;
	
	@Override
	public int tipCheck(int num, String mem_id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("mem_id", mem_id);
		
		return sqlSession.selectOne("tipCheck", map);
	}
	
	@Override
	public int tipInsert(int num, String mem_id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("mem_id", mem_id);
		
		return sqlSession.insert("tipInsert", map);
	}
	
	@Override
	public int tipDelete(int num, String mem_id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		map.put("mem_id", mem_id);
		
		return sqlSession.delete("tipDelete", map);
	}
	
	@Override
	public void deleteTipAll(int study_num) {
		sqlSession.delete("deleteTipAll", study_num);
	}
}
