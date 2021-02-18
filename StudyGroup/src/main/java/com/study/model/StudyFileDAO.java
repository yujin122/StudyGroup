package com.study.model;

import java.util.List;
import java.util.Map;

public interface StudyFileDAO {
	public int fileInsert(Map<String, Object> file_list);
	public int fileUpdateInsert(Map<String, Object> file_list);
	public int fileDelete();
	public int fileUpdate(String fileName);
	public int fileUpdate(int num);
	public List<StudyFileDTO> getFiles();
	public List<StudyFileDTO> getFiles(int sboard_num);
	public void deleteFileAll(int sboard_num);
}
