package com.study.model;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyMemberDAOImpl implements StudyMemberDAO {
	
	@Autowired private SqlSessionTemplate sqlSession;
	
	public int insertStudyMember(StudyMemberDTO dto) {
		return sqlSession.insert("insertStudyMember", dto);
	};
	
	@Override
	public int searchStudyMember(String study_mem_id, int study_mem_num) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("study_mem_id", study_mem_id);
		map.put("study_mem_num", study_mem_num);
		
		return sqlSession.selectOne("searchStudyMember", map);
	}
	
	@Override
	public String getMemberPosition(int study_num, String mem_id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("study_num", study_num);
		map.put("mem_id", mem_id);
		
		return sqlSession.selectOne("getMemberPosition", map);
	}
	
	@Override
	public void deleteStudyMember(int study_num) {
		sqlSession.delete("deleteStudyMember", study_num);
	}
}
