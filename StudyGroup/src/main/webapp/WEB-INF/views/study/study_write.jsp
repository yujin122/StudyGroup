<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TOGETER</title>
<link rel="stylesheet" href="${path }/resources/css/study/study_board.css">
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
	$(function(){
		$("input[type=file]").on("change", function(){
			var files = $("input[type='file']")[0].files;
			
			var span = "";
			for(var i = 0; i < files.length; i++){
				span += "<br>"+files[i].name;
			}
			$("#file_name").empty();
			$("#file_name").append(span);	
		});		
	});
	function conf() {
	
		if($("#sboard_menu").val()=="none") {
			alert('카테고리를 선택해주세요.');
			return;
			
		} else if($("#sboard_title").val()=="") {
			alert('제목을 입력해주세요.');
			return;
				
		} else if($("#sboard_cont").val()=="") {
			alert('내용을 입력해주세요.');
			return;
			
		} else {
			$("#frm").submit();
		}
	};
	
	function conf2() {
		
		var yn = confirm('작성을 취소 하시겠습니까?');
		
		if(yn) {
			history.go(-1);	
		} else return;
	};
</script>
</head>
<body>

	<jsp:include page="../include/study_board_top.jsp" />
	<div id="content">
		<jsp:include page="../include/study_board_side.jsp" />

		<div class="study_form">
			<div id="form_top"></div>

			<div id="form_cont">
				<div id="write_form">
					<form method="post" id="frm" action="<%=request.getContextPath() %>/sboard_write_ok.do" enctype="multipart/form-data">
						<input type="hidden" name="sboard_writer" value="${mem_id }">
						<input type="hidden" name="category" value="${category }">
						<table>
							<tr>
								<td><h3><a href = "javascript:history.back();"><img src="${path }/resources/img/back.png"></a></h3></td>
							</tr>
							<tr>
								<td><select id="sboard_menu" name="sboard_menu">
										<option value="none">게시판 선택</option>
										<option value="공지" <c:if test = "${category == '공지'}">selected</c:if>>공지</option>
										<option value="질문" <c:if test = "${category == '질문'}">selected</c:if>>질문</option>
										<option value="TIP" <c:if test = "${category == 'TIP'}">selected</c:if>>TIP</option>
										<option value="자료" <c:if test = "${category == '자료'}">selected</c:if>>자료</option>
									</select>
								</td>
							</tr>
							<tr>
								<td><input type="text" id="sboard_title" name="sboard_title" placeholder="제목을 입력해주세요"></td>
							</tr> 
							<tr>
								<td><textarea rows="17" cols="30" id="sboard_cont" name="sboard_cont"
										placeholder="내용을 입력해주세요"></textarea></td>
							</tr>
							<tr>
								<td>
									<label for="sboard_file">업로드</label> 
									<input type="file" name="sboard_file" id = "sboard_file" multiple="multiple">
									<span id = "file_name"></span>
								</td>
							</tr>
						</table>
				
					<div id="study_write_btn" align="center">
						<input type="submit" class="sboard_btn" value="등록" onclick="conf(); return false;"> 
						<input type="button" class="sboard_cbtn" value="취소" onclick="conf2(); return false;">
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>

</body>
</html>