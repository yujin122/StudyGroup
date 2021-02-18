<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/top.css">
</head>
<body>
	<div class = "wrap">
		<div id = "header">
			<a href = "${path }/"><img src="${path }/resources/img/main_logo.png"></a>
			<nav>
				<ul>
					<li><a href = "${path }/">스터디</a></li>
					<li><a href = "${path }/bbs_list.do?page=1">자유게시판</a></li>
					<c:if test="${empty session_mem_id }">
						<li><a href = "javascript:alert('로그인 후 이용가능합니다.')">스터디관리</a></li>
					</c:if>
					<c:if test="${!empty session_mem_id }">
						<li><a href = "${path }/manage.do">스터디관리</a></li>
					</c:if>
				</ul>
			</nav>
			<div id = "user_box">
				<c:if test="${empty session_mem_id }">
					<ul>
						<li><a href = "${path }/member_login.do">로그인</a></li>
						<li><a href = "${path }/member_sign_up.do">회원가입</a></li>
					</ul>
				</c:if>
				<c:if test="${!empty session_mem_id }">
					<ul>
						<li><a href = "${path }/logout.do">로그아웃</a></li>
						<li><a href = "${path }/member_edit.do">내정보</a></li>
					</ul>
				</c:if>
			</div>
		</div>