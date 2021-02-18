<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study_main.css">
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
	$(function(){
		if('${msg}' != ''){
			alert('${msg}');
		}
		
		// 스터디 이름
		$("input[name='study_name']").keyup(function(){
			var len = $("input[name='study_name']").val().length;
			
			$("#name_limit").text(len + '/20');
			if(len >= 20){
				$("#name_limit").css('color', 'red');
			}
			if(len < 20){
				$("#name_limit").css('color', 'blue');
			}
			
		});
		
		// 한줄소개
		$("input[name='study_short_intro']").keyup(function(){
			var len = $("input[name='study_short_intro']").val().length;
			
			$("#short_limit").text(len + '/45');
			if(len >= 45){
				$("#short_limit").css('color', 'red');
			}
			if(len < 45){
				$("#short_limit").css('color', 'blue');
			}
			
		});
		
		// 해시태그
		$("input[name='study_hashtag']").keyup(function(){
			var len = $("input[name='study_hashtag']").val().length;
			
			$("#hash_limit").text(len + '/60');
			if(len >= 60){
				$("#hash_limit").css('color', 'red');
			}
			if(len < 60){
				$("#hash_limit").css('color', 'blue');
			}
			
		});
	});
	
	function study_check() {
		if($("input[name='study_name']").val() == ''){
			alert('스터디모임 이름을 입력하세요');
			$("input[name='study_name']").focus();
			return false;
		}
		
		if($("select[name='study_category'] option:selected").val() == ''){
			alert('카테고리를 선택해주세요');
			$("input[name='study_category']").focus();
			return false;
		}
		
		if(!$("input[name='study_type']").is(":checked")){
			alert('멘토 유무를 선택해주세요');
			$("input[name='study_type']").focus();
			return false;
		}
		
		if($("input[name='study_short_intro']").val() == ''){
			alert('한 줄 소개를 입력해주세요.');
			$("input[name='study_short_intro']").focus();
			return false;
		}
		
		if($("input[name='study_long_intro']").val() == ''){
			alert('상세설명을 입력해주세요');
			$("input[name='study_long_intro']").focus();
			return false;
		}
		
		if($("input[name='study_people']").val() == ''){
			alert('가입 가능 인원을 입력해주세요.');
			$("input[name='study_people']").focus();
			return false;
		}
		
		if($("input[name='study_sdate']").val() == '' || $("input[name='study_edate']").val() == ''){
			alert('가입 날짜를 입력해주세요.');
			$("input[name='study_sdate']").focus();
			return false;
		}
	}
</script>
</head>
<body>

	<%@include file="../include/top.jsp" %>
	
	<div id = "content">
		<h1>스터디그룹 개설하기</h1>
		<div id = "study_form">
			<form method = "post" action = "${path }/study_insert.do" enctype="multipart/form-data" onsubmit="return study_check()">
				<table>
					<tr>
						<th>스터디모임 이름<span>*</span></th>
					</tr>
					<tr>
						<td>
						<input type = "text" name = "study_name" placeholder="스터디 그룹 이름을 입력해주세요" maxlength="20"><br>
						<span id = "name_limit">0/20</span>
						<p>간략하면서 주제가 잘 드러나는 이름이 좋아요!</p>
						</td>
					</tr>
					<tr>
						<th>그룹 카테고리 선택<span>*</span></th>
					</tr>
					<tr>
						<td>
							<select name = "study_category">
								<option value = "">카테고리 선택</option>
								<c:set var = "list" value="${list }" />
								<c:if test="${!empty list }">
								<c:forEach items="${list }" var = "cate">
									<option value = "${cate.getStudy_cate_num() }">${cate.getStudy_cate_name() }</option>
								</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
					<tr>
						<th>멘토<span>*</span></th>
					</tr>
					<tr>
						<td>
							<input type = "radio" name = "study_type" value = "Y">유
							<input type = "radio" name = "study_type" value = "N">무
						</td>
					</tr>
					<tr>
						<th>한 줄 소개<span>*</span></th>
					</tr>
					<tr>
						<td>
							<input type = "text" placeholder="한 줄 소개를 입력해주세요" maxlength="45" name = "study_short_intro"><br>
							<span id = "short_limit">0/45</span>
						</td>
					</tr>
					<tr>
						<th>상세설명<span>*</span></th>
					</tr>
					<tr>
						<td>
							<textarea placeholder="소개를 입력해주세요" name = "study_long_intro"></textarea>
							<p>스터디 모임의 주제와 규칙 등 자세한 설명을 입력해주세요</p>
						</td>
					</tr>
					<tr>
						<th>해시태그</th>
					</tr>
					<tr>
						<td>
							<input type = "text" placeholder="#스터디그룹 #공무원" maxlength="60" name = "study_hashtag"><br>
							<span id = "hash_limit">0/60</span>
						</td>
					</tr>
					<tr>
						<th>대표 썸네일</th>
					</tr>
					<tr>
						<td>
							<input type = "file" name = "file_img">
						</td>
					</tr>
					<tr>
						<th>가입 가능 인원<span>*</span></th>
					</tr>
					<tr>
						<td><input type = "number" name = "study_people" min="1"> 명</td>
					</tr>
					<tr>
						<th>가입 기간<span>*</span></th>
					</tr>
					<tr>
						<td><input type = "date" name = "study_sdate"> ~ <input type = "date" name = "study_edate"></td>
					</tr>
				</table>
				<div id = "study_frm_btn">
					<input type = "submit" class = "btn_red" value = "등록"><br>
					<input type = "button" class = "btn_white" onclick = "javascript:history.back()" value = "취소">
				</div>
			</form>
		</div>
	</div>
	
	<%@include file="../include/bottom.jsp" %>
</body>
</html>