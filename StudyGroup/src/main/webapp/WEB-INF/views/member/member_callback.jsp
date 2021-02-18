<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri ="http://java.sun.com/jsp/jstl/core" %> 
<c:set var = "path" value = "${pageContext.request.contextPath }"/>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
</head>
<link href="${path }/resources/css/user.css" rel = "stylesheet">
<body>
	<div id = "naver_login">
		<div id = "all_cont">
			<a href = "${path }/"><img src="${path }/resources/img/study_logo.png"></a>
			<table>
				<tr>
					<td>${result }</td>
				</tr>
				<tr>
					<td><input type="button" id="to_main_btn" value="메인으로" onclick="location.href='${path }/'"></td>
				</tr>
			</table>
		</div>
	</div>
	
	
</body>
</html>