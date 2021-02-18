package com.study.model;

import lombok.Data;

@Data
public class ScommDTO {
	
	private int scomm_num;
	private int sboard_num;
	private String scomm_cont;
	private String scomm_writer;
	private String scomm_regdate;
	
	private String mem_name;
}