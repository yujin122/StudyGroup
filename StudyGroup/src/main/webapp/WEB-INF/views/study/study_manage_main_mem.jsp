<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study/study_manage.css">
</head>
<body>
<body>
	
	<jsp:include page="../include/study_board_top.jsp" />
	
	<div id="content">
		<jsp:include page="../include/study_board_side.jsp" />
		<div class="study_form">
		<div id = "form_top">
		</div>
		<div id = "form_cont">
			<h2>스터디</h2>
			<ul>
				<li><a href="${path }/study_info.do">스터디 정보</a></li>
			</ul>
			<br/> 
			<hr>                                                                                                                                                                                                                                                                                                                                                                                                     
			<h2>구성원</h2>
			<ul>
				<li><a href="${path }/study_member_info.do">구성원 정보</a></li>
			</ul>

		</div>
		</div>
	</div>
</body>
</body>
</html>