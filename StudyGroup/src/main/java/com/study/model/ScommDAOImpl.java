package com.study.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ScommDAOImpl implements ScommDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public List<ScommDTO> getScommList(int sboard_num) {
		return this.sqlSession.selectList("scomm_list",sboard_num);
	}

	@Override
	public int writeScomm(ScommDTO dto) {
		return this.sqlSession.insert("scomm_write", dto);
	}

	@Override
	public int updateScomm(ScommDTO dto) {
		return this.sqlSession.update("update", dto);
	}

	@Override
	public ScommDTO getCont(int num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int deleteScomm(int num) {
		return this.sqlSession.delete("scomm_delete", num);
	}

	@Override
	public ScommDTO selectScomm(int num) {
		return this.sqlSession.selectOne("scomm_select", num);
	}

	@Override
	public void deleteStudyComm(int study_num) {
		sqlSession.delete("study_comm", study_num);
	}
	
	@Override
	public void deleteBoard(int sboard_num) {
		sqlSession.delete("deleteBoard", sboard_num);
	}
	
}
