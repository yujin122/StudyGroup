<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "${pageContext.request.contextPath }"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link href="${path }/resources/css/user.css" rel = "stylesheet">
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"/></script>
<script src="${path }/resources/js/join.js"/></script>
<script type = "text/javascript">
	function id_check(){
		var id = $("#mem_id").val();
		
		$.ajax({
			url: "${path}/id_check.do",
			dataType: "text",
			data: {
				"mem_id": id
			},
			success: function(data){
				if(data <= 0){
					alert('사용 가능한 아이디입니다.');
				}else{
					alert('중복된 아이디가 존재합니다.');
					$("#mem_id").val("");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	function phone_check(){
		var id = $("#mem_phone").val();
		
		$.ajax({
			url: "${path}/phone_check.do",
			dataType: "text",
			data: {
				"mem_phone": id
			},
			success: function(data){
				if(data <= 0){
					alert('사용 가능한 전화번호입니다.');
				}else{
					alert('중복된 전화번호가 존재합니다.');
					$("#mem_phone").val("");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
</script>
<body>
	<div id = "sign_up_cont">
		<a href = "${path }/"><img src="${path }/resources/img/study_logo.png"></a>
		<form method="post" action="${path }/sign_up_ok.do"
			enctype="multipart/form-data" onsubmit="return sign_up_check()">
	        <table>
	        	<tr>
	        		<th>이름</th>
	        		<td>
						<input type="text" name = "mem_name" id="mem_name" placeholder="이름">
					</td>
	        	</tr>
	        	<tr>
	        		<th>아이디</th>
	        		<td>
						<input type="text" name="mem_id" id="mem_id" placeholder="아이디">
						<input type = "button" class = "btn_white" onclick = "id_check()" value="중복확인">
					</td>
	        	</tr>
	         	<tr>
	         		<th>비밀번호</th>
	         		<td>
	        		 	<input type="password" id="mem_pwd" name="mem_pwd" placeholder="비밀번호">
	        	 	</td>
	         	</tr>
	         	<tr>
	         		<th>비밀번호 확인</th>
	         		<td>
	        		 	<input type="password" id="mem_pwd_check"><br>
	        		 	<span id = "pwd_txt"></span>
	        		 	<input type = "hidden" id = "pwd_check" value = "0">
	        	 	</td>
	         	</tr>
	         	<tr>
	         		<th>닉네임</th>
	         		<td>
						<input type="text" name = "mem_nickname" id = "mem_nickname" placeholder="닉네임">
					</td>
	         	</tr>
	         	<tr>
	         		<th>나이</th>
	         		<td>
						<input type="text" name = "mem_age" placeholder="나이">
					</td>
	         	</tr>
	         	<tr>
	         		<th rowspan="4">주소</th>
	         		<td>
	         			<input type="text" id="sample4_postcode" placeholder="우편번호" name="mem_addr_1" readonly="readonly">
	         			<input type = "button" onclick="sample4_execDaumPostcode()" value="우편번호" class = "btn_white">
	         		</td>
	         	</tr>
	         	<tr>
	         		<td>
	         			<input type="text" id="sample4_roadAddress" placeholder="도로명주소" name="mem_addr_2" size="30" readonly="readonly">
	         		</td>
	         	</tr>
	         	<tr>
	         		<td>
	         			<input type="text" id="sample4_detailAddress" placeholder="상세주소" name="mem_addr_3" size="30">
	         		</td>
	         	</tr>
	         	<tr>
	         		<td>
	         			<input type="text" id="sample4_extraAddress" placeholder="참고항목" name="mem_addr_4" size="30">
	         		</td>
	         	</tr>
	         	<tr>
	         		<th>전화번호</th>
	         		<td>
	         			<input type="text" name="mem_phone" id="mem_phone" placeholder="'-'를 포함하여 입력해주세요">
						<input type = "button" class = "btn_white" onclick = "phone_check()" value = "중복확인">
	         		</td>
	         	</tr>
	         	<tr>
	         		<th>이메일</th>
	         		<td>
	         			<input type="text" name = "mem_email" id="mem_email" placeholder="이메일">
	         		</td>
	         	</tr>
	         	<tr>
	         		<th>프로필 사진</th>
	         		<td>
	         			<input type = "file" name = "pro_img">
	         		</td>
	         	</tr>
	        </table>
	        <div id="btn_box">
				<input type="submit" value = "회원가입" class = "btn_red">
			</div>
		</form>
	</div>
</body>
</html>