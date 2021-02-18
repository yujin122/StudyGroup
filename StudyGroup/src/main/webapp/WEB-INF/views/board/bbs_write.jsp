<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/bbs.css"/>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<!-- editor:summernote -->
<script src="${pageContext.request.contextPath}/resources/summernote/summernote-lite.js"></script>
<script src="${pageContext.request.contextPath}/resources/summernote/lang/summernote-ko-KR.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/summernote/summernote-lite.css">
<script type="text/javascript">
	//summernote
	$(document).ready(function() {
	  $('#cont').summernote({
	  		minHeight: 400,
			placeholder:"내용을 입력하세요."
	  });
	});
	
	function conf() {
	
		if($("#catg").val()=="none") {
			alert('카테고리를 선택해주세요.');
			return;
			
		} else if($("#title").val()=="") {
			alert('제목을 입력해주세요.');
			return;
				
		} else if($("#cont").val()=="") {
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
	
	<jsp:include page="../include/top.jsp" />
	
	<div id="content">
	
	<div>
		<h1><a href="bbs_list.do?page=1">자유게시판</a></h1>
	</div>
	
	<div id="repWrite">
		<form method="post" id="frm" action="<%=request.getContextPath()%>/bbs_write_ok.do">
			<input type="hidden" name="board_writer" value="${mem_id }">
			<input type="hidden" name="board_nickname" value="${mem_nickname }">
			<table>
				<tr>
					<td>
						<select name="board_catg" id="catg">
							<option value="none">카테고리 선택</option>
							<option disabled>::::::::</option>
							<option value="rev">합격 후기·성공 사례</option>
							<option value="unb">자유</option>
							<option value="qna">질문</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" name="board_title" id="title" size="45" placeholder="제목을 입력하세요.">
					</td>
				</tr>
				<tr>
					<td>
						<textarea name="board_cont" id="cont" cols="50" rows="20"></textarea>
					</td>
				</tr>
			</table>
			<div id="repWrite_btn">
					<input type="button" class = "btn_red" value="등록" onclick="conf(); return false;">
					<input type="button" class = "btn_white" value="취소" onclick="conf2(); return false;">
			</div>
		</form>
	</div><!-- id="repWrite" -->
	
	</div><!--id="content"-->
	
	<jsp:include page="../include/bottom.jsp" />
	
</body>
</html>