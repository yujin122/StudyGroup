package com.study.model;

import java.util.List;

public interface StudyCalendarDAO {
	public List<StudyCalendarDTO> getStudyCal(int study_num);		// 일정 전체
	public StudyCalendarDTO getStudyCalCont(int scal_num);			// 일정 상세
	public int insertStudyCal(StudyCalendarDTO dto);
	public int calMaxNum();
	public int calCnt();
	public int deleteStudyCal(int scal_num);
	public List<StudyCalendarDTO> getWeekly(String session_id);
	public void deleteAllCal(int study_num);
}
