package com.study.model;

import java.util.List;

public interface Board_commDAO {

	public List<Board_commDTO> getReplyList(int board_no, int count);
	
	public int writeReply(int board_no, String bcomm_cont, String mem_id, String bcomm_nickname);
	
	public int editReply(int bcomm_no, String edit_cont);
	
	public int deleteReply(int bcomm_no);
	
	public int rrepReply(int board_no, int bcomm_no, String edit_cont, String mem_id, String bcomm_nickname);
	
	public int countReply(int board_no);
	
	public int countBcomm();
}
