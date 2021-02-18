package com.study.model;

import lombok.Data;

@Data
public class StudyCalendarDTO {
	private int scal_num;
	private int study_num;
	private String scal_title;
	private String scal_sdate;
	private String scal_edate;
	private String scal_place;
	private String scal_cont;
	private String study_name;
}
