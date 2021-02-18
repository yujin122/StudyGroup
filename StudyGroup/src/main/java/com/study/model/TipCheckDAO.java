package com.study.model;

public interface TipCheckDAO {
	public int tipCheck(int num, String mem_id);
	public int tipInsert(int num, String mem_id);
	public int tipDelete(int num, String mem_id);
	public void deleteTipAll(int study_num);
	
}
