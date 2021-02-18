<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<html>
<head>
<title>Home</title>
<link rel ="stylesheet" href = "${path }/resources/css/study_main.css">
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
	$(function(){
		$("#mento").on('change', function(){
			var cate = $("#cate").val();
			var mento = $("#mento").val();
			
			location = "${path}/?cate="+cate+"&mento="+mento;
		});
		
		$("#cate").on('change', function(){
			var cate = $("#cate").val();
			var mento = $("#mento").val();
			
			location = "${path}/?cate="+cate+"&mento="+mento;
		});
	});
</script>
</head>
<body>
	
	<%@include file="./include/top.jsp" %>
	
	<div id = "content">
		<h1><a href = "${path }/">스터디 그룹</a></h1>
		<div id = "option_box">
			<label>멘토</label>
			<select id = "mento">
				<option value = "%%">전체</option>
				<option value = "Y" <c:if test="${mento == 'Y' }">selected</c:if>>유</option>
				<option value = "N" <c:if test="${mento == 'N' }">selected</c:if>>무</option>
			</select>
			<label>카테고리</label>
			<select id = "cate">
				<c:set var = "cate_list" value = "${cate_list }" />
				<c:if test="${!empty cate_list }">
					<option value = "%%">전체</option>
					<c:forEach items="${cate_list }" var = "category">
						<option value = "${category.getStudy_cate_num() }" <c:if test="${cate == category.getStudy_cate_num().toString() }">selected</c:if>>${category.getStudy_cate_name() }</option>
					</c:forEach>
				</c:if>
				<c:if test="${empty cate_list }">
					<option>:::: 카테고리 ::::</option>
				</c:if>
			</select>
			<c:if test="${!empty session_mem_id }">
				<button class = "btn_red" onclick = "location = '${path }/study_form.do'">스터디 만들기</button>
			</c:if>
			<c:if test="${empty session_mem_id }">
				<button class = "btn_red" onclick = "javascript:alert('로그인 후 이용 가능합니다.')">스터디 만들기</button>
			</c:if>	
		</div>
		<div id = "item_list">
			<c:set value="${study_list }" var = "study_list" />
				<c:if test="${!empty study_list }">
					<c:forEach items="${study_list }" var = "study">
						<c:set var = "cnt" value = "${cnt+1}" />
						<table onclick = "location = '${path }/study_cont.do?num=${study.getStudy_num() }&mento=${mento }&category=${cate }&page=${pagination.page }'">
							<tr>
								<td rowspan = "3">
								<c:if test="${!empty study.getStudy_img() }">
									<img src="${path }/resources/upload/study/${study.getStudy_img() }">
								</c:if>
								<c:if test="${empty study.getStudy_img() }">
									<img src="${path }/resources/img/study_main_default.png">
								</c:if>
								</td>
								<td>
									<c:if test="${study.getStudy_type() == 'Y' }">
										<img src="${path }/resources/img/icon.png">	
									</c:if>
								</td>
							</tr>
							<tr>
								<td rowspan = "2">${study.getStudy_name() }</td>
							</tr>
							<tr></tr>
							<tr>
								<td colspan = "2">${study.getStudy_short_intro() }</td>
							</tr>
							<tr>
								<td colspan = "2">${study.getStudy_hashtag() }</td>
							</tr>
							<tr>
								<td colspan = "2">${study.getStudy_mem_cnt() }/${study.getStudy_people() }명 
								<c:if test="${study.getStudy_mem_cnt() == study.getStudy_people() }">
									마감
								</c:if>
								<c:if test="${study.getStudy_mem_cnt() != study.getStudy_people() }">
									모집중
								</c:if>
							</tr>
						</table>
						
						<c:if test="${cnt%4 == 0 }">
						<br>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${empty study_list }">
					<h2>스터디 모임이 존재하지 않습니다.</h2>
					<p>스터디 모임을 직접 만들어보세요!</p>
				</c:if>
		</div>
		<div id = "paging_box">
			<c:if test="${pagination.allPage != 1 }">
				<c:if test="${pagination.prev }">
					<a href = "${path }/?page=${pagination.startPage-1 }"><</a>
				</c:if>
				<c:forEach begin="${pagination.startPage }" end = "${pagination.endPage }" var = "i">
					<c:if test="${pagination.page == i }">
						<b><a href = "${path }/?page=${i }">[${i }]</a></b>
					</c:if>
					<c:if test="${pagination.page != i }">
						<a href = "${path }/?page=${i }">[${i }]</a>
					</c:if>
				</c:forEach>
				<c:if test="${pagination.next }">
					<a href = "${path }/?page=${pagination.endPage+1 }">></a>
				</c:if>
			</c:if>
		</div>
	</div>
	<%@include file="./include/bottom.jsp" %>
	
	
