<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri ="http://java.sun.com/jsp/jstl/core" %> 
<c:set var = "path" value = "${pageContext.request.contextPath }"/>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${path }/resources/css/user.css" rel = "stylesheet">
</head>
<body>
	
	<div id="login_cont">
		<div id = "all_cont">
			<a href = "${path }/"><img src="${path }/resources/img/study_logo.png"></a>
		  	<h3>비밀번호 찾기 결과</h3>
			<table>
				<tr>
					<td>
					<span>아이디 ${mem_id }의 비밀번호 찾기 결과를 </span> 
					<p>${mem_email }로</p>
					<span>발송하였습니다.</span>
					</td>
				</tr>
				<tr>
					<td>
					<input type = "button" class="btn_red" value = "메인으로" onclick="location.href='${path }/'">
					</td>
				</tr>
				<tr>
					<td><a href = "${path }/member_login.do">로그인</a></td>
				</tr>
			</table>
		</div>
	</div>
	
</body>
</html>