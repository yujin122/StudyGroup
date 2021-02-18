package com.study.model;

import lombok.Data;

@Data
public class Pagination {
	private int rowsize;		// 페이지 당 게시글 수
	private int block = 5;		// 블럭 당 페이지 수
	private int totalRecord;	// 총 게시글 수
	private int allPage;		// 총 페이지 수
	private int page;			// 현재 페이지
	private int startNo;		// 현재 블럭의 게시글 시작 번호
	private int endNo;			// 현재 블럭의 게시글 마지막 번호
	private int startPage;		// 시작 페이지
	private int endPage;		// 끝 페이지
	private boolean prev;
	private boolean next;
	
	public void pageInfo(int page, int rowsize, int totalRecord) {
		this.page = page;
		this.rowsize = rowsize;
		this.totalRecord = totalRecord;
		
		this.startNo = (page * rowsize) - (rowsize - 1);
		this.endNo = (page * rowsize);
		
		this.startPage = (((page -1) / block) * block) + 1;
		this.endPage = (((page - 1) / block) * block) + block;
		
		this.allPage = (int)Math.ceil(totalRecord/(double)rowsize);
		
		this.prev = page < block ? false : true;
		
		this.next = endPage > allPage ? false : true;
		if(this.endPage > this.allPage) {
			this.endPage = this.allPage;
			this.next = false;
		}
	}
}
