<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${path }/resources/css/study/study_top.css">
</head>
<body>

	<div id="header">

		<img src="${path }/resources/img/study_logo.png" alt="로고" onclick = "location = '${path }/sboard_main.do?category=%%'">
		
		<a href = "${path }/manage.do"><img src="${path }/resources/img/study_back.png" alt="뒤로가기"></a>
	</div>

</body>
</html>
