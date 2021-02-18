package com.study.model;

import java.util.List;

public interface StudyCategoryDAO {
	
	public List<StudyCategoryDTO> getCateList();
	public StudyCategoryDTO getCateCont(int study_num);
}
