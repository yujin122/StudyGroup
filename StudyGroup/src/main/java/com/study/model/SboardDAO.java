package com.study.model;

import java.util.List;

public interface SboardDAO {
	
	public List<StudyListDTO> getSboardAllList(int num, String category); 	
	
	public int insertSboard(SboardDTO dto); 					
	
	public StudyListDTO getSboardCont(int num);
	
	public SboardDTO getCont(int num);
	
	public void hitSboard(int num); 				
	
	public int editSboard(SboardDTO dto);	
	
	public int deleteSboard(int num);
	
	public int updateHelp(int num, String txt);
	
	public String helpCheck(int num);
	
	public void deleteAllBoard(int num);
	
	public List<Integer> getSboardNum(int study_num);
}
