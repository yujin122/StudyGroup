<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study/study_manage.css">
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
	
	function info_update_check() {
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
	<%@include file="../include/study_board_top.jsp" %>
	
		<div id = "content">
			<%@include file="../include/study_board_side.jsp" %>
			<div class = "study_form">
				<div id = "form_top">
			
				</div>
				<div id = "form_cont">
					<h3><a href = "${path }/study_manage_main.do"><img src="${path }/resources/img/back.png"></a> 스터디 정보 관리</h3>
					<div id = "study_info_form">
						<form method = "post" action = "${path }/study_info_update.do" enctype="multipart/form-data" onsubmit="return info_update_check()">
						<c:set var = "info" value = "${dto }"/>
						<input type = "hidden" value = "${info.getStudy_num() }" name = "study_num">
							<table>
								<tr>
									<th>스터디모임 이름<span>*</span></th>
								</tr>
								<tr>
									<td>
									<input type = "text" name = "study_name" placeholder="스터디 그룹 이름을 입력해주세요" maxlength="20" value = "${info.getStudy_name() }"><br>
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
												<option value = "${cate.getStudy_cate_num() }" <c:if test = "${cate.getStudy_cate_num() == info.getStudy_category() }">selected</c:if>>${cate.getStudy_cate_name() }</option>
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
										<input type = "radio" name = "study_type" value = "Y" <c:if test = "${info.getStudy_type() == 'Y' }">checked</c:if>>유
										<input type = "radio" name = "study_type" value = "N" <c:if test = "${info.getStudy_type() == 'N' }">checked</c:if>>무
									</td>
								</tr>
								<tr>
									<th>한 줄 소개<span>*</span></th>
								</tr>
								<tr>
									<td>
										<input type = "text" placeholder="한 줄 소개를 입력해주세요" maxlength="45" name = "study_short_intro" value = "${info.getStudy_short_intro() }"><br>
										<span id = "short_limit">0/45</span>
									</td>
								</tr>
								<tr>
									<th>상세설명<span>*</span></th>
								</tr>
								<tr>
									<td>
										<textarea placeholder="소개를 입력해주세요" name = "study_long_intro">${info.getStudy_long_intro() }</textarea>
										<p>스터디 모임의 주제와 규칙 등 자세한 설명을 입력해주세요</p>
									</td>
								</tr>
								<tr>
									<th>해시태그</th>
								</tr>
								<tr>
									<td>
										<input type = "text" placeholder="#스터디그룹 #공무원" maxlength="60" name = "study_hashtag" value = "${info.getStudy_hashtag() }"><br>
										<span id = "hash_limit">0/60</span>
									</td>
								</tr>
								<tr>
									<th>대표 썸네일</th>
								</tr>
								<tr>
									<td>
										<input type = "file" name = "file_img">
										<input type = "hidden" name = "study_img" value = "${info.getStudy_img() }">
									</td>
								</tr>
								<tr>
									<th>가입 가능 인원<span>*</span></th>
								</tr>
								<tr>
									<td><input type = "number" name = "study_people" min="1" value = "${info.getStudy_people() }"> 명</td>
								</tr>
								<tr>
									<th>가입 기간<span>*</span></th>
								</tr>
								<tr>
									<td><input type = "date" name = "study_sdate" value = "${info.getStudy_sdate().substring(0,10) }"> ~ <input type = "date" name = "study_edate" value = "${info.getStudy_edate().substring(0,10) }"></td>
								</tr>
							</table>
							<div id = "study_frm_btn">
								<input type = "submit" class = "btn_red" value = "저장하기"><br>
								<c:if test="${info.getStudy_mem_cnt() > 1 }">
									<input type = "button" class = "btn_white" onclick = "javascript:alert('스터디 멤버가 존재합니다. 스터디 리더만 남았을 때 삭제 가능합니다.')" value = "스터디 모임 삭제">
								</c:if>
								<c:if test="${info.getStudy_mem_cnt() == 1 }">
									<input type = "button" class = "btn_white" onclick = "javascript:if(confirm('삭제하시겠습니까?')){
										location = '${path}/study_delete.do?study_num=${info.getStudy_num() }';
										}else{return;}" value = "스터디 모임 삭제">
								</c:if>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>