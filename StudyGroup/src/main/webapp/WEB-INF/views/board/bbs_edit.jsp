<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link href="${pageContext.request.contextPath}/resources/summernote/summernote-lite.css"  rel="stylesheet">
<script type="text/javascript">
	//summernote
	$(document).ready(function() {
	  $('#cont').summernote({
	  		minHeight: 400
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
	
	function conf2(no) {
		
		var yn = confirm('수정을 취소 하시겠습니까?');
		
		if(yn) {
			location.href="<%=request.getContextPath()%>/bbs_cont.do?no="+no+"&page=${page}&str=${str}&opt=${opt}&text=${text}";
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
		<form id="frm" method="post" action="<%=request.getContextPath()%>/bbs_edit_ok.do">
			<c:set var="dto" value="${cont }"/>
			<input type="hidden" name="board_no" value="${dto.getBoard_no() }">
			<input type="hidden" name="page" value="${page }">
			<input type="hidden" name="str" value="${str }">
			<input type="hidden" name="opt" value="${opt }">
			<input type="hidden" name="text" value="${text }">
			<table>
				<tr>
					<td>
						<c:if test="${dto.getBoard_catg() eq 'rev'}">
							<select name="board_catg" id="catg">
								<option value="none">카테고리 선택</option>
								<option disabled>::::::::</option>
								<option value="rev" selected>합격 후기·성공 사례</option>
								<option value="unb">자유</option>
								<option value="qna">질문</option>
							</select>
						</c:if>
						<c:if test="${dto.getBoard_catg() eq 'unb'}">
							<select name="board_catg" id="catg">
								<option value="none">카테고리 선택</option>
								<option disabled>::::::::</option>
								<option value="rev">합격 후기·성공 사례</option>
								<option value="unb" selected>자유</option>
								<option value="qna">질문</option>
							</select>
						</c:if>
						<c:if test="${dto.getBoard_catg() eq 'qna'}">
							<select name="board_catg" id="catg">
								<option value="none">카테고리 선택</option>
								<option disabled>::::::::</option>
								<option value="rev">합격 후기·성공 사례</option>
								<option value="unb">자유</option>
								<option value="qna" selected>질문</option>
							</select>
						</c:if>
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" name="board_title" id="title" size="45" value=${dto.getBoard_title() }>
					</td>
				</tr>
				<tr>
					<td>
						<textarea name="board_cont" id="cont" cols="50" rows="20">${dto.getBoard_cont() }</textarea>
					</td>
				</tr>
			</table>
			<div id="repWrite_btn">
				<input type="button" class="btn_red" value="수정" onclick="conf(); return false;">
				<input type="button" class="btn_white" value="취소" onclick="conf2(${dto.getBoard_no()})">
			</div>
		</form>
	</div>
	
	</div><!--id="content"-->
	
	<jsp:include page="../include/bottom.jsp" />
	
</body>
</html>