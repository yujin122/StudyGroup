package com.study.model;

import java.util.List;

public interface TodoDAO {
	
	public List<TodoDTO> getTodoList(String id); // todo 리스트를 가져오는 메서드
	public int insertTodo(String todo_text, String session_id); // todo 추가하는 메서드
	public int tododel(String[] chbox); // todo 삭제하는 메서드
	public int finishTodo(String[] chbox);

 }
