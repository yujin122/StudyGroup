<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/bbs.css"/>
</head>
<body>

	<jsp:include page="../include/top.jsp" />

	<div id="content">
		<div>
			<h1><a href="bbs_list.do?page=1">자유게시판</a></h1>
		</div>
		
		<div id="bbs_list">
			<div id="list_nav">
				<ul class="nav nav-tabs">
				  <li class="active"><a href="#">검색 결과</a></li>
				</ul>
			</div>
			<br/>
			
			<div align="center">
				<table class="table table-hover">
					<tr>
						<th> 글번호</th>
						<th> 제 목 </th>
						<th> 작성자 </th>
						<th> 게시날짜 </th>
						<th> 조회 수</th>
					</tr>
					<c:set var="list" value="${bbsList }"/>
					<c:if test="${!empty list }">
						<c:forEach items="${list }" var="dto">
							<tr>
								<td> ${dto.getBoard_no() } </td>
								<td><a href="<%=request.getContextPath() %>/bbs_cont.do?no=${dto.getBoard_no()}&page=${page}&str=search&opt=${opt }&text=${text}"> ${dto.getBoard_title() }</a>
									<c:if test="${cdao.countReply(dto.getBoard_no()) ne 0 }"><span id = "comm_cnt">${cdao.countReply(dto.getBoard_no())}</span></c:if>
								</td>
								<td> ${dto.getBoard_nickname() } </td>
								<td> ${dto.getBoard_regdate().substring(0,10) } </td>
								<td> ${dto.getBoard_hit() } </td>
							</tr>
						</c:forEach>
					</c:if>
					
					<c:if test="${empty list }">
						<tr>
							<td colspan="5">
								<h3>검색된 결과가 없습니다.</h3>
							</td>
						</tr>
					</c:if>
				</table>
				
				<c:if test="${!empty mem_id }" >
				<p align="right">
					<input type="button" class="btn_red" value="글쓰기" onclick="location.href='<%=request.getContextPath()%>/bbs_write.do'">
					&nbsp;
					<input type="button" value="전체목록" class="btn_white" onclick="location.href='<%=request.getContextPath()%>/bbs_list.do?page=1'">
				</p>
				</c:if>
				
				<nav>
				  <ul class="pagination pagination-sm">
				 	 <c:if test="${page > block}">	
					 	<li><a href="search_list.do?page=1&opt=${opt }&text=${text}">≪</a></li>
					 	<li><a href="search_list.do?page=${startBlock -1}&opt=${opt }&text=${text}">＜</a></li>
					 </c:if>
					 
				 	<c:forEach begin="${startBlock}" end="${endBlock }" var = "i" >
				 		<c:if test="${page eq i }">
				 			<li class="active"><a href="search_list.do?page=${i }&opt=${opt }&text=${text}">${i }</a></li>
				 		</c:if>
				 		<c:if test="${page ne i }">
				 			<li><a href="search_list.do?page=${i }&opt=${opt }&text=${text}">${i }</a></li>
				 		</c:if>
					</c:forEach>
					
					<c:if test="${page <= ((allBlock-1)*block)}">
					 	<li><a href="search_list.do?page=${endBlock+1 }&opt=${opt }&text=${text}">＞</a></li>
					 	<li><a href="search_list.do?page=${allPage }&opt=${opt }&text=${text}">≫</a></li>
					</c:if>
				  </ul>
				</nav>
				
			</div>
			
			<div align="center">
				<form method="get" action="search_list.do">
				<input type="hidden" name="page" value="1">
				<select name="opt">
					<option value="title">제목</option>
					<option value="cont">내용</option>
					<option value="id">작성자</option>
				</select>
				<input type="text" name="text">
				&nbsp;
				<input type="submit" class="btn_red" value="검색">	
				</form>
			</div>
		</div> <!-- bbs_list -->
	</div> <!-- id="content" -->
	
	<jsp:include page="../include/bottom.jsp" />
</body>
</html>