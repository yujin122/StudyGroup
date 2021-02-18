package com.study.model;

import lombok.Data;

@Data
public class StudyInfoDTO {
	private int study_num;
	private String study_name;
	private int study_category;
	private String study_type;
	private String study_short_intro;
	private String study_long_intro;
	private String study_hashtag;
	private String study_img;
	private String study_people;
	private String study_sdate;
	private String study_edate;
	
	private int study_mem_cnt;
	
	private String mem_nickname;
	private String mem_img;
}
