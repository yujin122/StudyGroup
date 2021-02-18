package com.study.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class StudyFileDAOImpl implements StudyFileDAO{
	
	@Autowired private SqlSessionTemplate sqlSession;
	
	@Override
	public int fileInsert(Map<String, Object> file_list) {
		return sqlSession.insert("fileInsert", file_list);
	}
	
	@Override
	public int fileDelete() {
		return sqlSession.delete("fileDelete");
	}
	
	@Override
	public int fileUpdate(String fileName) {
		return sqlSession.update("fileUpdate",fileName);
	}
	
	@Override
	public List<StudyFileDTO> getFiles() {
		return sqlSession.selectList("getDelFiles");
	}
	
	@Override
	public List<StudyFileDTO> getFiles(int sboard_num) {
		return sqlSession.selectList("getFile", sboard_num);
	}
	
	@Override
	public int fileUpdateInsert(Map<String, Object> file_list) {
		return sqlSession.insert("fileUpdateInsert", file_list);
	}
	
	@Override
	public int fileUpdate(int num) {
		return sqlSession.update("fileCancleUpdate", num);
	}
	
	@Override
	public void deleteFileAll(int sboard_num) {
		sqlSession.delete("deleteFileAll", sboard_num);
	}
}
