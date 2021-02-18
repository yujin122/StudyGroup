package com.study.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyInfoDAOImpl implements StudyInfoDAO{
	
	@Autowired private SqlSessionTemplate sqlSession;
	
	@Override
	public int getStudyListCnt(String cate, String mento) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cate", cate);
		map.put("mento", mento);
		
		return sqlSession.selectOne("studyCnt", map);
	}
	
	@Override
	public List<StudyInfoDTO> getStudyList(Pagination pagination,String cate, String mento) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("startNo", pagination.getStartNo());
		map.put("endNo", pagination.getEndNo());
		map.put("cate", cate);
		map.put("mento", mento);
		
		return sqlSession.selectList("studyAllList", map);
	}
	
	@Override
	public int getMaxNum() {
		return sqlSession.selectOne("mainStudyMax");
	}
	
	@Override
	public int insertStudyInfo(StudyInfoDTO dto) {
		return sqlSession.insert("mainStudyInsert", dto);
	}
	
	@Override
	public StudyInfoDTO getStudyCont(int study_num) {
		return sqlSession.selectOne("studyCont", study_num);
	}
	
	@Override
	public int updateStudyInfo(StudyInfoDTO dto) {
		return sqlSession.update("updateStudyInfo", dto);
	}
	
	@Override
	public StudyInfoDTO getPeople(int num) {
		
		return sqlSession.selectOne("studyPeople", num);
	}
	
	@Override
	public List<StudyInfoDTO> getMyStList(String id) {
		
		return this.sqlSession.selectList("MyStudy", id);
	}

	@Override
	public List<StudyInfoDTO> getWStList(String id) {
		
		return this.sqlSession.selectList("WaitStudy", id);
	}
	
	@Override
	public StudyInfoDTO getStudyInfo(int study_num) {
		return sqlSession.selectOne("getStudyInfo", study_num);
	}
	
	@Override
	public int deleteInfo(int study_num) {
		return sqlSession.delete("deleteInfo", study_num);
	}
	
	@Override
	public StudyInfoDTO delStudyCont(int study_num) {
		return sqlSession.selectOne("delStudyCont", study_num);
	}
}
