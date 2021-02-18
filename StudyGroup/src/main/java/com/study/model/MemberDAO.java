package com.study.model;

public interface MemberDAO {
	public int loginIdCheck(String mem_id);
	public int login(MemberDTO dto);
	public MemberDTO findidOk(String number);
	public MemberDTO findpwOk(String mem_id);
	public void findpwEmail(MemberDTO dto);
	public int naverJoin(MemberDTO dto);
	public int JoinOk(MemberDTO dto);
	public int IdCheck(String mem_id);
	public int phoneCheck(String mem_number);
	public MemberDTO edit_cont(String mem_id);
	public int EditOk(MemberDTO dto);
	public int editphoneCheck(String mem_number);
}
