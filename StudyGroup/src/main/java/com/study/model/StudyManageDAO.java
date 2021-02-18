package com.study.model;

import java.util.List;

public interface StudyManageDAO {
	
	public List<StudyManageDTO> getSMemList(int num); // 스터디 멤버를 보여주는 메서드
	public StudyManageDTO getLeader(int num); // 스터디 리더 정보를 보여주는 메서드
	public List<StudyManageDTO> getWMemList(int num); //스터디 가입 승인 대기인을 보여주는 메서드
	public StudyManageDTO countLeader(int num); // 스터디 리더 수를 세는 메서드
	public StudyManageDTO countMember(int num); // 스터디 멤버 수를 세는 메서드
	public int deleteMember(int num, String id); // 스터디 멤버를 삭제하는 메서드
	public int rejectJoin(int num, String id); // 스터디 가입을 거절하는 메서드
	public int addMember(int num, String id); // 스터디 가입을 승인하는 메서드

}
