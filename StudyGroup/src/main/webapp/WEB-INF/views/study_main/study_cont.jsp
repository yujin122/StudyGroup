<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study_main.css">
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
	$(function(){
		if('${msg}' != ''){
			alert('${msg}');
		}
	});
	
	function back_btn(){
		var mento = '${mento}';
		var category = '${category}';
		var page = '${page}';
		var menu = '${menu}';
		
		if(menu != ''){
			location = "${path}/manage.do";
		}else{

			if(mento == '' && category == ''){
				location = "${path}/?page="+page;	
			}else if(mento == ''){
				location = "${path}/?cate="+category+"&page="+page;
			}else if(category == ''){
				location = "${path}/?mento="+mento+"&page="+page;
			}else{
				location = "${path}/?mento="+mento+"&cate="+category+"&page="+page;
			}	
		}		
	}
</script>
</head>
<body>

	<%@include file="../include/top.jsp" %>
	
	<div id = "content">
		
		<c:set var = "category" value = "${cate }" />
		<img id = "back_img" src="${path }/resources/img/back2.png" onclick = "back_btn()">
		<h2 id = "cont_cate">${category.getStudy_cate_name() } </h2>
		<div id = "study_cont">
			<c:set var = "info" value = "${dto }" />
			<table id = "study_cont_tb">
				<tr>
					<td rowspan = "3">
					<c:if test="${!empty info.getStudy_img() }">
						<img src="${path }/resources/upload/study/${info.getStudy_img() }">
					</c:if>
					<c:if test="${empty info.getStudy_img() }">
						<img src="${path }/resources/img/study_main_default.png">
					</c:if>
					</td>
					<td>
						<c:if test="${info.getStudy_type() == 'Y'}">
							<img src="${path }/resources/img/icon.png">
						</c:if>
					</td>
				</tr>
				<tr>
					<td>${info.getStudy_name() }</td>
				</tr>
				<tr>
					<td>${info.getStudy_hashtag() }</td>
				</tr>
				<tr>
					<td colspan = "2">
						<c:if test="${info.getMem_img() == null }">
							<img src="${path }/resources/img/user.png"> 
						</c:if>
						<c:if test="${info.getMem_img() != null }">
							<img src="${path }/resources/upload/user/${info.getMem_img() }"> 
						</c:if>
						<span>${info.getMem_nickname() }</span></td>
				</tr>
				<tr>
					<th colspan = "2"><h3>기본정보</h3><hr></th>
				</tr>
				<tr>
					<td colspan = "2">
						<table id = "study_info">
							<tr>
								<td rowspan = "2"><img src="${path }/resources/img/calendar2.png"></td>
								<td>모집 기간</td>
							</tr>
							<tr>
								<td>${info.getStudy_sdate().substring(0,10) } ~ ${info.getStudy_edate().substring(0,10) }</td>
							</tr>
							<tr>
								<td rowspan = "2"><img src="${path }/resources/img/per4.png"></td>
								<td>모집 인원</td>
							</tr>
							<tr>
								<td>${info.getStudy_mem_cnt() }/${info.getStudy_people() }명</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th colspan = "2"><h3>상세내용</h3><hr></th>
				</tr>
				<tr>
					<td colspan = "2">${info.getStudy_long_intro() }</td>
				</tr>
			</table>
			<div id = "study_cont_btn">
				<c:if test="${!empty session_mem_id }">
					<c:if test="${info.getStudy_mem_cnt() != info.getStudy_people() }">
					<button class = "btn_red" onclick = "location = '${path}/study_join.do?num=${info.getStudy_num() }'" >가입 신청</button>
					</c:if>
					<c:if test="${info.getStudy_mem_cnt() == info.getStudy_people() }">
						<button class = "btn_red" onclick = "javascript:alert('모집이 마감되었습니다.')" >가입 신청</button>
					</c:if>
				</c:if>
				<c:if test="${empty session_mem_id }">
					<button class = "btn_red" onclick = "javascript:alert('로그인 후 이용가능합니다.')" >가입 신청</button>
				</c:if>
			</div>
		</div>
	</div>
	
	<%@include file="../include/bottom.jsp" %>
	
	