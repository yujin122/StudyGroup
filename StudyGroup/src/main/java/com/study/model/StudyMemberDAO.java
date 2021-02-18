package com.study.model;

public interface StudyMemberDAO {
	public int searchStudyMember(String study_mem_id, int study_mem_num);	// 스터디 가입시 이미 스터디에 가입한 회원인지 확인
	public int insertStudyMember(StudyMemberDTO dto);							// 스터디 멤버 등록
	public String getMemberPosition(int study_num, String mem_id);
	public void deleteStudyMember(int study_num);
}

