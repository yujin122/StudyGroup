<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
	$(function(){
		var cate = '${category}';
		
		if(cate == '공지'){
			$("#menu_bar li:nth-child(2) a").css("color", "#ED6560");
		}else if(cate == "질문"){
			$("#menu_bar li:nth-child(3) a").css("color", "#ED6560");
		}else if(cate == "TIP"){
			$("#menu_bar li:nth-child(4) a").css("color", "#ED6560");
		}else if(cate == "자료"){
			$("#menu_bar li:nth-child(5) a").css("color", "#ED6560");
		}
	});
</script>
</head>
<body>

	<div class="side_bar">
		<div class="side_title">
			<c:if test="${!empty session_study_img }">
				<img src="${path }/resources/upload/study/${session_study_img }" alt="스터디 아이콘">
			</c:if>	
			<c:if test="${empty session_study_img }">
				<img src="${path }/resources/img/study_main_default.png" alt="스터디 아이콘">
			</c:if>
			<h3>${session_study_name }</h3>
		</div>
		<ul id = "menu_bar">
			<li><a href="${path }/sboard_main.do">전체</a></li>
			<li><a href="${path }/sboard_main.do?category=공지">공지</a></li>
			<li><a href="${path }/sboard_main.do?category=질문">질문</a></li>
			<li><a href="${path }/sboard_main.do?category=TIP">TIP</a></li>
			<li><a href="${path }/sboard_main.do?category=자료">자료</a></li>
			<li><a href="${path }/study_calendar.do">일정</a></li>
		</ul>
		<ul id = "manage_bar">
			<li><a href="${path }/study_manage_main.do">스터디 관리</a></li>
		</ul>
	</div>

</body>
</html>