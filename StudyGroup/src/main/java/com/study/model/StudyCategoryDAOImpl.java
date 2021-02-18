package com.study.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyCategoryDAOImpl implements StudyCategoryDAO{
	
	@Autowired private SqlSessionTemplate sqlSession;
	
	@Override
	public List<StudyCategoryDTO> getCateList() {
		return sqlSession.selectList("cateAllList");
	}
	
	@Override
	public StudyCategoryDTO getCateCont(int study_num) {
		return sqlSession.selectOne("cateCont", study_num);
	}
}
