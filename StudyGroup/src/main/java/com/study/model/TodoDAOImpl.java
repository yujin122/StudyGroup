package com.study.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TodoDAOImpl implements TodoDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public List<TodoDTO> getTodoList(String id) {
		// todo 리스트를 보여주는 메서드
		return this.sqlSession.selectList("todoList", id);
	}

	@Override
	public int insertTodo(String todo_text, String id) {
		// todo 리스트를 추가하는 메서드
		Map<String , Object> map = new HashMap<String, Object>();
		map.put("todo_text", todo_text);
		map.put("mem_id", id);
		return this.sqlSession.insert("todoinsert", map);
	}

	@Override
	public int tododel(String[] chbox) {

		ArrayList<String> list = new ArrayList<String>();
		for(int i = 0; i<chbox.length; i++) {
			list.add(chbox[i]);
		}
		return this.sqlSession.delete("todoDel", list);
	}

	@Override
	public int finishTodo(String [] chbox) {
		ArrayList<String> list = new ArrayList<String>();
		for(int i = 0; i<chbox.length; i++) {
			list.add(chbox[i]);
		}
		return this.sqlSession.update("todoFinish", list);
	}

}