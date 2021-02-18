package com.study.model;

public interface StudyJoinDAO {
	public int searchStudyMem(StudyJoinDTO dto);		// 스터디 가입 신청을 했는지 확인
	public int insertStudyJoin(StudyJoinDTO dto);		// 스터디 가입 신청
	public void deleteJoinAll(int study_num);
}
