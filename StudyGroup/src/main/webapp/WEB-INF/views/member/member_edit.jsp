<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var = "path" value = "${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<link href="${path }/resources/css/user.css" rel = "stylesheet">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"/></script>
<script src="${path }/resources/js/join.js"/></script>
<script type = "text/javascript">

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
		<form method="post" action="<%=request.getContextPath() %>/member_edit_ok.do" 
			enctype="multipart/form-data" onsubmit="return sign_up_check()">
	       
	        <table>
	        	<c:set var ="dto" value = "${edit_cont }"/>
			
	        	<tr>
	        		<th>이름</th>
	        		<td>
						<input type="text" name = "mem_name" id="mem_name"  value = "${dto.getMem_name() }">
					</td>
	        	</tr>
	        	<tr>
	        		<th>아이디</th>
	        		<td>
	        			<input type = "hidden" name = "mem_id" value = "${dto.getMem_id() }">
						${dto.getMem_id() }
					</td>
	        	</tr>
	         	<tr>
	         		<th>비밀번호</th>
	         		<td>
	        		 	<input type="password" id="mem_pwd" name="mem_pwd"  value = "${dto.getMem_pwd() }">
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
						<input type="text" name = "mem_nickname" id = "mem_nickname"  value = "${dto.getMem_nickname() }">
					</td>
	         	</tr>
	         	<tr>
	         		<th>나이</th>
	         		<td>
						<input type="text" name = "mem_age"  value = "${dto.getMem_age() }">
					</td>
	         	</tr>
	         	<tr>
	         		<th rowspan="4">주소</th>
	         		<c:set var = "addr" value = "${dto.getMem_addr() }" />
						<c:set var = "addrArr" value = "${fn:split(addr, '/')}" />
	         		<td>
	         			<input type="text" id="sample4_postcode" placeholder="우편번호" name="mem_addr_1" readonly="readonly"  value = "${addrArr[0] }">
	         			<input type = "button" onclick="sample4_execDaumPostcode()" value="우편번호" class = "btn_white">
	         		</td>
	         	</tr>
	         	<tr>
	         		<td>
	         			<input type="text" id="sample4_roadAddress" placeholder="도로명주소" name="mem_addr_2" size="30" readonly="readonly"  value = "${addrArr[1] }">
	         		</td>
	         	</tr>
	         	<tr>
	         		<td>
	         			<input type="text" id="sample4_detailAddress" placeholder="상세주소" name="mem_addr_3" size="30" value = "${addrArr[2] }">
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
	         			<input type="text" name="mem_phone" id="mem_phone" placeholder="'-'를 포함하여 입력해주세요"  value = "${dto.getMem_phone() }">
						<input type = "button" class = "btn_white" onclick = "phone_check()" value = "중복확인">
	         		</td>
	         	</tr>
	         	<tr>
	         		<th>이메일</th>
	         		<td>
	         			<input type="text" name = "mem_email" id="mem_email"  value = "${dto.getMem_email() }">
	         		</td>
	         	</tr>
	         	<tr>
	         		<th>프로필 사진</th>
	         		<td>
	         			<input type = "hidden" name = "mem_img"  value = "${dto.getMem_img() }">
	         			<input type = "file" name = "pro_img">
	         		</td>
	         	</tr>
	         	
	        </table>
	        <div id="btn_box">
				<input type="submit" value = "수정" class = "btn_red">
			</div>
			
		</form>
	</div>
</body>
</html>