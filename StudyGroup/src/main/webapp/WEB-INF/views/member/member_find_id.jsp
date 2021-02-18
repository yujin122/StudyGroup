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
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		if('${msg}' != ''){
			alert('${msg}');
		}
	});
</script>
</head>
<body>
	
	<div id="find_cont">
		<div id = "all_cont">
			<a href = "${path }/"><img src="${path }/resources/img/study_logo.png"></a>
			<form action = "${path }/member_find_id_ok.do" method = "post">
			  	<h3>아이디 찾기</h3>
				<table>
					<tr>
						<td colspan="2"><input type = "text" name = "mem_name" placeholder="이름을 입력해주세요."></td>
					</tr>
					<tr>
						<td colspan="2"><input type = "tel" name = "mem_number" placeholder="전화번호를 입력해주세요."></td>
					</tr>
					<tr>
						<td colspan="2">
						<input type = "submit" value = "찾기">
						<input type="button" class="btn_white" value="취소" onclick="location.href='member_login.do'">
						</td>
					</tr>
					<tr>
						<td><a href = "${path }/member_sign_up.do">회원가입</a></td>
						<td><a href = "${path }/member_find_pwd.do">비밀번호 찾기</a></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
</body>
</html>