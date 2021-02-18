package com.study.model;

import lombok.Data;

@Data
public class SboardDTO {
	
	private int sboard_num;
	private int study_num;
	private String sboard_menu;
	private String sboard_title;
	private String sboard_cont;
	private String sboard_writer;
	private String sboard_regdate;
	private int sboard_hit;
	private String sboard_help;
}
