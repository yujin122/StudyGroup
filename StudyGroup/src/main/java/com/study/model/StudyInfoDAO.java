package com.study.model;

import java.util.List;

public interface StudyInfoDAO {
	public int getStudyListCnt(String cate, String mento);										// 전체 스터디 모임 수
	public List<StudyInfoDTO> getStudyList(Pagination pagination, String cate, String mento);		// 스터디 모임 가져오기
	public int insertStudyInfo(StudyInfoDTO dto);												// 스터디모임 등록
	public int getMaxNum();
	public StudyInfoDTO getStudyCont(int study_num);
	public int updateStudyInfo(StudyInfoDTO dto);
	public StudyInfoDTO getPeople(int num);	//특정 스터디의 정원 수 가져오기
	public List<StudyInfoDTO> getMyStList(String id);
	public List<StudyInfoDTO> getWStList(String id);
	public StudyInfoDTO getStudyInfo(int study_num);
	public int deleteInfo(int study_num);
	public StudyInfoDTO delStudyCont(int study_num);
}
