package com.study.model;

import lombok.Data;

@Data
public class TodoDTO {
	
	private String mem_id;
	private int todo_num;
	private String todo_text;
	private String todo_state;
}
