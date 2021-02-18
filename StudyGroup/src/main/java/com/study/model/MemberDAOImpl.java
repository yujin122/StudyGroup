package com.study.model;

import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private JavaMailSender mailSender;
	
	@Override
	public int loginIdCheck(String mem_id) {
		return sqlSession.selectOne("loginIdCheck", mem_id);
	}
	
	@Override
	public int login(MemberDTO dto) {
		return sqlSession.selectOne("login", dto);
	}
	
	//id 찾기
	@Override
	public MemberDTO findidOk(String number) {
		
		MemberDTO dto = this.sqlSession.selectOne("member_find_id",number);
		if(dto != null) {
			return dto;
		} else {
			dto = new MemberDTO();
			dto.setMem_id("none");
			dto.setMem_pwd("none");
			dto.setMem_phone("none");
			dto.setMem_nickname("none");
			dto.setMem_name("none");
			dto.setMem_img("none");
			dto.setMem_email("none");
			dto.setMem_age("none");
			dto.setMem_addr("none");
			
			return dto;
		}
	
	}

	//pwd 찾기
	@Override
	public MemberDTO findpwOk(String mem_id) {
		
		MemberDTO dto = this.sqlSession.selectOne("member_find_pw",mem_id);
		
		if(dto != null) {
			return dto;
		} else {
			dto = new MemberDTO();
			dto.setMem_id("none");
			dto.setMem_pwd("none");
			dto.setMem_phone("none");
			dto.setMem_nickname("none");
			dto.setMem_name("none");
			dto.setMem_img("none");
			dto.setMem_email("none");
			dto.setMem_age("none");
			dto.setMem_addr("none");
			
			return dto;
		}
	}
	
	@Override
	public void findpwEmail(MemberDTO dto) {
		
		MimeMessage msg = mailSender.createMimeMessage();
		
		String title = "TOGETHER- " +dto.getMem_name()+ "님 비밀번호 찾기 메일입니다.";
		String cont = "아이디 '" +dto.getMem_id()+ "'의 비밀번호는 '" +dto.getMem_pwd()+ "'입니다.";
		
		try {
			msg.addRecipient(RecipientType.TO, new InternetAddress(dto.getMem_email()));
			msg.setSubject(title,"utf-8");
			msg.setText(cont, "utf-8");
			
			mailSender.send(msg);
			
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
	
	@Override
	public int naverJoin(MemberDTO dto) {
		return this.sqlSession.insert("naver_info", dto);
	}
	
	@Override
	public int JoinOk(MemberDTO dto) {
		return this.sqlSession.insert("member_sign_up",dto);
	}

	@Override
	public int phoneCheck(String mem_number) {
		
		return this.sqlSession.selectOne("phoneCheck", mem_number);
	}
	
	@Override
	public int IdCheck(String mem_id) {
		
		return this.sqlSession.selectOne("idCheck", mem_id);
	}
	
	@Override
	public int editphoneCheck(String mem_number) {
		
		return this.sqlSession.selectOne("edit_phoneCheck", mem_number);
	}
	
	@Override
	public MemberDTO edit_cont(String mem_id) {
		
		return this.sqlSession.selectOne("edit_cont",mem_id);
	}

	
	@Override
	public int EditOk(MemberDTO dto) {
		return this.sqlSession.update("member_edit",dto);
	}
}
