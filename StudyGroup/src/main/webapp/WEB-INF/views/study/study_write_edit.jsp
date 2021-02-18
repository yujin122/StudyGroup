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
		
		getFile();
		
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
	
	function getFile(){
		var sboard_num = $("#sboard_num").val();
		
		$.ajax({
			url: "${path}/getFile.do",
			dataType: "json",
			data: {
				"num": sboard_num
			},
			success: function(data){
				var span = "";
				
				for(i in data){
					
					span += "<br>" + data[i].board_img_original + "&nbsp;&nbsp;";
					span += "<a href = 'javascript:file_delete(\""+data[i].board_img_new+"\")'>[삭제]</a>";
				}
				
				$("#pre_file_name").empty();
				$("#pre_file_name").append(span);
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	function file_delete(fileName) {
		$.ajax({
			url: "${path}/file_delete.do",
			data: {
				"fileName": fileName
			},
			dataType: "text",
			success: function(data){
				if(data > 0){
					getFile();
				}else{
					alert("파일 삭제 실패");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		})
	}
	
	function file_cancle(num) {
		$.ajax({
			url: "${path}/file_delete_cancle.do",
			data: {
				"num": num
			},
			dataType: "text",
			success: function(data){
				if(!data > 0){
					alert("파일 복구 실패");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		})
	}
	
	// '게시글 수정'
	function click1() {
	
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
	
	function click2(num) {
		
		var i = confirm('수정을 취소 하시겠습니까?');
		
		if(i) {
			file_cancle(num);
			location.href='sboard_cont.do?num='+num+'&category=${category}';
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
					<form method="post" id="frm" action="<%=request.getContextPath() %>/sboard_edit_ok.do" enctype="multipart/form-data">
						<c:set var="dto" value="${sboard_cont }"/>
						<input type="hidden" name="sboard_num" id = "sboard_num" value="${dto.getSboard_num() }">
						<input type="hidden" name="category" value="${category }">
						<table>
							<tr></tr>
							<tr>
								<td>
									<select id="sboard_menu" name="sboard_menu">
										<option value="none">게시판 선택</option>
										<option value="공지" <c:if test = "${dto.getSboard_menu() == '공지'}">selected</c:if>>공지</option>
										<option value="질문" <c:if test = "${dto.getSboard_menu() == '질문'}">selected</c:if>>질문</option>
										<option value="TIP" <c:if test = "${dto.getSboard_menu() == 'TIP'}">selected</c:if>>TIP</option>
										<option value="자료" <c:if test = "${dto.getSboard_menu() == '자료'}">selected</c:if>>자료</option>
									</select>
								</td>
							</tr>    
							<tr>
								<td><input type="text" id="sboard_title" name="sboard_title" placeholder="제목을 입력해주세요" value=${dto.getSboard_title() }></td>
							</tr> 
							<tr>
								<td><textarea rows="17" cols="30" id="sboard_cont" name="sboard_cont"
										placeholder="내용을 입력해주세요" >${dto.getSboard_cont() }</textarea></td>
							</tr>
							<tr>
								<td>
									<label for="sboard_file">업로드</label> 
									<input type="file" name="sboard_file" id = "sboard_file" multiple="multiple">
									<span id = "pre_file_name"></span>
									<span id = "file_name"></span>
								</td>
							</tr>
						</table>
				
					<div id="study_write_btn" align="center">
						<input type="submit" class="sboard_btn" value="등록" onclick="click1(); return false;"> 
						<input type="button" class="sboard_cbtn" value="취소" onclick="click2(${dto.getSboard_num()});">
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>

</body>
</html>