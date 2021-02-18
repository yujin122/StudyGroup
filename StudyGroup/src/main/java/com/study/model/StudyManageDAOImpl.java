package com.study.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyManageDAOImpl implements StudyManageDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	//------------강의 관리---------------------------
	// 나중에 스터디 방 번호 추가하기 & study.xml
	@Override
	public List<StudyManageDTO> getSMemList(int num) {
		// 강의 관리 - 구성원 관리에서 스터디 멤버를 보여주는 메서드
		
		return this.sqlSession.selectList("SMemList", num);
	}
	
	@Override
	public StudyManageDTO getLeader(int num) {
		// 구성원 관리와 가입 승인에서 스터디 리더를 보여주는 메서드
		return this.sqlSession.selectOne("leaderInfo", num);
	}
	
	@Override
	public List<StudyManageDTO> getWMemList(int num) {

		return this.sqlSession.selectList("WMemList", num);
	}
	
	@Override
	public StudyManageDTO countMember(int num) {
	
		return this.sqlSession.selectOne("countMember", num);
	}

	@Override
	public StudyManageDTO countLeader(int num) {

		return this.sqlSession.selectOne("countLeader", num);
	}

	@Override
	public int deleteMember(int num, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("num", num);
		return this.sqlSession.delete("deleteMember",map);
	}

	@Override
	public int rejectJoin(int num, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("num", num);
		return this.sqlSession.delete("rejectJoin", map);
	}

	@Override
	public int addMember(int num, String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("num", num);
		return this.sqlSession.insert("addMember", map);
	}
	
	
}
