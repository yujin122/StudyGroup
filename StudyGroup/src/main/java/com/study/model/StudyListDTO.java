package com.study.model;

import lombok.Data;

@Data
public class StudyListDTO {
	private int sboard_num;
	private String sboard_menu;
	private String sboard_title;
	private String sboard_cont;
	private String sboard_writer;
	private String sboard_regdate;
	private String sboard_help;
	private int sboard_hit;
	
	private String study_mem_position;
	private String mem_name;
	private int comm_cnt;
	private int tip_cnt;
	
}
