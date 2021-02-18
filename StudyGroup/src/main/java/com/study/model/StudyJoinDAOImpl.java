package com.study.model;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyJoinDAOImpl implements StudyJoinDAO{
	
	@Autowired private SqlSessionTemplate sqlSession;
	
	@Override
	public int searchStudyMem(StudyJoinDTO dto) {
		return sqlSession.selectOne("searchStudyMem", dto);
	}
	
	@Override
	public int insertStudyJoin(StudyJoinDTO dto) {
		return sqlSession.insert("insertStudyJoin", dto);
	}
	
	@Override
	public void deleteJoinAll(int study_num) {
		sqlSession.delete("deleteJoinAll", study_num);
	}
}
