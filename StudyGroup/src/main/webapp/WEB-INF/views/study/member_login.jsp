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
<script type="text/javascript">
	$(function(){
		if('${msg}' != ''){
			alert('${msg}');
		}
	});
</script>
</head>
<link href="${path }/resources/css/user.css" rel = "stylesheet">
<body>
	<div id = "login_cont">
		<a href = "${path }/"><img src="${path }/resources/img/study_logo.png"></a>
		<form action = "${path }/login_ok.do" method = "post">
			<table>
				<tr>
					<td colspan="2"><input type = "text" name = "mem_id" placeholder="아이디를 입력해주세요."></td>
				</tr>
				<tr>
					<td colspan="2"><input type = "password" name = "mem_pwd" placeholder="비밀번호를 입력해주세요."></td>
				</tr>
				<tr>
					<td colspan="2"><input type = "submit" value = "로그인"></td>
				</tr>
				<tr>
					<td><a href = "${path }/member_sign_up.do">회원가입</a></td>
					<td><a href = "${path }/member_find_id.do">아이디 </a><a href = "${path }/member_find_pwd.do">비밀번호 찾기</a></td>
				</tr>
			</table>
		</form>
		<span><button type="button" id="naverLogin" onclick="location.href='${naver_login_url }'"><img src="${path }/resources/img/naverlogin.png"></button></span>
	</div>
	
</body>
</html>