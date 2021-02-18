package com.study.model;

import java.util.List;

public interface BoardDAO {
	
	public int getListCount();
	public List<BoardDTO> getBoardList(int page, int rowsize);
	
	public int catgListCount(String catg);
	public List<BoardDTO> catgBoardList(String catg, int page, int rowsize);
	
	public int searchListCount(String opt, String text);
	public List<BoardDTO> searchBoardList(String opt, String text, int page, int rowsize);
	
	public int writeBoard(BoardDTO dto);
	public BoardDTO getBoardCont(int board_no);
	public void hitBoard(int board_no);
	public int editBoard(BoardDTO dto);
	public int deleteBoard(int board_no);
	
	public String getNickname(String mem_id);
	
}
