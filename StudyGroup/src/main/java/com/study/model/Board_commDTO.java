package com.study.model;

import lombok.Data;

@Data
public class Board_commDTO {
	
	private int bcomm_no;
	private int board_no;
	private String bcomm_cont;
	private String bcomm_writer;
	private String bcomm_regdate;
	private int bcomm_group;
	private int bcomm_step;
	private int bcomm_indent;
	private String bcomm_nickname;
	
	public int getBcomm_no() {
		return bcomm_no;
	}
	public void setBcomm_no(int bcomm_no) {
		this.bcomm_no = bcomm_no;
	}
	public int getBoard_no() {
		return board_no;
	}
	public void setBoard_no(int board_no) {
		this.board_no = board_no;
	}
	public String getBcomm_cont() {
		return bcomm_cont;
	}
	public void setBcomm_cont(String bcomm_cont) {
		this.bcomm_cont = bcomm_cont;
	}
	public String getBcomm_writer() {
		return bcomm_writer;
	}
	public void setBcomm_writer(String bcomm_writer) {
		this.bcomm_writer = bcomm_writer;
	}
	public String getBcomm_regdate() {
		return bcomm_regdate;
	}
	public void setBcomm_regdate(String bcomm_regdate) {
		this.bcomm_regdate = bcomm_regdate;
	}
	public int getBcomm_group() {
		return bcomm_group;
	}
	public void setBcomm_group(int bcomm_group) {
		this.bcomm_group = bcomm_group;
	}
	public int getBcomm_step() {
		return bcomm_step;
	}
	public void setBcomm_step(int bcomm_step) {
		this.bcomm_step = bcomm_step;
	}
	public int getBcomm_indent() {
		return bcomm_indent;
	}
	public void setBcomm_indent(int bcomm_indent) {
		this.bcomm_indent = bcomm_indent;
	}
	public String getBcomm_nickname() {
		return bcomm_nickname;
	}
	public void setBcomm_nickname(String bcomm_nickname) {
		this.bcomm_nickname = bcomm_nickname;
	}
	
	
}
