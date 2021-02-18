package com.study.model;

import java.util.List;

public interface ScommDAO {
	
	public List<ScommDTO> getScommList(int sboard_num);
	
	public int writeScomm(ScommDTO dto);
	
	public ScommDTO getCont(int num);
	
	public int updateScomm(ScommDTO dto);
	
	public int deleteScomm(int num);
	
	public ScommDTO selectScomm(int num);

	public void deleteStudyComm(int study_num);

	public void deleteBoard(int sboard_num);
}
