package com.study.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyCalendarDAOImpl implements StudyCalendarDAO{
	
	@Autowired SqlSessionTemplate sqlSession;
	
	@Override
	public List<StudyCalendarDTO> getStudyCal(int study_num) {
		return sqlSession.selectList("getStudyCal", study_num);
	}
	
	@Override
	public StudyCalendarDTO getStudyCalCont(int scal_num) {
		return sqlSession.selectOne("getStudyCalCont", scal_num);
	}
	
	@Override
	public int insertStudyCal(StudyCalendarDTO dto) {
		return sqlSession.insert("insertStudyCal", dto);
	}
	
	@Override
	public int calMaxNum() {
		return sqlSession.selectOne("calMaxNum");
	}
	
	@Override
	public int calCnt() {
		return sqlSession.selectOne("calCnt");
	}
	
	@Override
	public int deleteStudyCal(int scal_num) {
		return sqlSession.delete("deleteStudyCal", scal_num);
	}
	
	@Override
	public List<StudyCalendarDTO> getWeekly(String session_id) {
		return sqlSession.selectList("weekly", session_id);
	}
	
	@Override
	public void deleteAllCal(int study_num) {
		sqlSession.delete("deleteAllCal", study_num);
	}
}
