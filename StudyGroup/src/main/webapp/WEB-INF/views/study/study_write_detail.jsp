<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TOGETER</title>
<link rel="stylesheet"
	href="${path }/resources/css/study/study_board.css">
<script type="text/javascript"
	src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
	$(function(){
		$("#dropdown_bar").click(function(){
			if(!$("#dropdown").is(":visible")){
				$("#dropdown").show();	
			}else{
				$("#dropdown").hide();
			}
			
		});
		
		if($("#menu").val() == 'TIP'){
			var sboard_num = $("#num").val();
			tip_check(sboard_num);
		}
		
	});
	
	// '글 삭제'
    function delck(num) {
		var delck = confirm("정말 삭제 하시겠습니까?");
		if(delck){
			location.href='sboard_delete.do?num='+num+'&category=${category}';
		} else {
			return;
		}
	};	

	function tip_check(sboard_num){
		$.ajax({
			url: "${path}/tip_check.do",
			dataType: "text",
			data: {
				"num": sboard_num
			},
			success: function(data){
				var img = "";
				img += "<img src = '${path}/resources/img/"+data+"' onclick = 'tip("+sboard_num+")'>";
				
				$("#tip_question").empty();
				$("#tip_question").append(img);
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	function tip(sboard_num){
		$.ajax({
			url: "${path}/tip_add.do",
			dataType: "text",
			data: {
				"num": sboard_num
			},
			success: function(data){
				if(data > 0){
					tip_check(sboard_num);
				}else{
					alert("도움됐어요 실패");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	function question(sboard_num){
		$.ajax({
			url: "${path}/question.do",
			dataType: "text",
			data: {
				"num": sboard_num
			},
			success: function(data){
				if(data > 0){
					question_check(sboard_num);
				}else{
					alert("실패");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	function question_check(sboard_num){
		$.ajax({
			url: "${path}/question_check.do",
			dataType: "text",
			data: {
				"num": sboard_num
			},
			success: function(data){
				if(data == "unsolved"){
					$("#tip_question img").attr("src", "${path }/resources/img/question_empty.png");
					$(".detail_box tr:nth-child(2) td:nth-child(2) span").empty();
					$(".detail_box tr:nth-child(2) td:nth-child(2) span").append("미해결");
					$(".detail_box tr:nth-child(2) td:nth-child(2) span").css("color", "red");
				}else{
					$("#tip_question img").attr("src", "${path }/resources/img/question.png");
					$(".detail_box tr:nth-child(2) td:nth-child(2) span").empty();
					$(".detail_box tr:nth-child(2) td:nth-child(2) span").append("해결");
					$(".detail_box tr:nth-child(2) td:nth-child(2) span").css("color", "green");
				}

			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
	
	function dels(commNum, boardNum) {
		var dels = confirm("삭제 하시겠습니까?");
		console.log(commNum);
		console.log(boardNum);
		
		if(delck){
			location.href='scomm_delete.do?commnum='+commNum+'&boardnum='+boardNum+'&category=${category}';
		} else {
			return;
		}
	};
	
	function update_form(num){
		if($("#text_"+num).css("display") == "none"){
		    $("#text_"+num).show();
		    $("#text_box_"+num).hide();
		} else {
		    $("#text_"+num).hide();
		    $("#text_box_"+num).show();
		}
	}
	
</script>
</head>
<body>

	<jsp:include page="../include/study_board_top.jsp" />
	<div id="content">
		<jsp:include page="../include/study_board_side.jsp" />

		<div class="study_form">
			<div id="form_top"></div>

			<div id="form_cont">
				<div id="detail_form">
					<table class="detail_box">
						<c:set var="dto" value="${sboard_cont }" />
						<c:if test="${!empty dto }">
							<tr>
								<td colspan="3"><h3><a href = "${path }/sboard_main.do?category=${category}"><img id = "back_btn" src="${path }/resources/img/back.png"></a></h3></td>
							</tr>
							<tr>
								<td><span>#</span>${dto.getSboard_num() }</td>
								<td>
									<c:if test="${dto.getSboard_menu() == '질문' }">
										<c:if test="${dto.getSboard_help() == 'unsolved' }">
											<span class = "unsolved">미해결</span>
										</c:if>
										<c:if test="${dto.getSboard_help() == 'solved' }">
											<span class = "solved">해결</span>
										</c:if>
									</c:if>
									${dto.getSboard_menu() } ${dto.getSboard_title() }
								</td>
								<td>
									<c:if test="${session_mem_id eq dto.getSboard_writer() }">	
										<img src="${path }/resources/img/menubar.png" alt="메뉴"
											id="dropdown_bar">
										<div id="dropdown">
											<a href="${path }/sboard_edit.do?num=${dto.getSboard_num() }&category=${category}">수정</a>
											<br>
											<a href="javascript:delck(${dto.getSboard_num() })">삭제</a>	
										</div>
									</c:if>	
								</td>
							</tr>
							<tr>
								<td colspan="3">
								<span>${dto.getMem_name() }
								<c:if test="${dto.getStudy_mem_position() == 'L' }">
									리더</span>
								</c:if>
								<c:if test="${dto.getStudy_mem_position() == 'M' }">
									멤버</span>
								</c:if>
								<span>${dto.getSboard_regdate().substring(0, 10) }</span>
								<span>${dto.getSboard_hit() }</span></td>
							</tr>
							<tr>
								<td colspan="3"><textarea rows="15" cols="30"
										id="sboard_cont" readonly>${dto.getSboard_cont() }</textarea>
							</tr>
							<c:set var = "file_list" value = "${file_list }" />
							<c:if test="${!empty file_list }">
								<tr id = "file_down">
								<td colspan = "3"><span id = "file_list">[첨부파일]</span>
									<c:forEach items="${file_list }" var = "file">
										<br><a href = "${path }/fileDownload.do?newFile=${file.getBoard_img_new() }&originalFile=${file.getBoard_img_original() }">${file.getBoard_img_original() }</a>
									</c:forEach>
								</td>
								</tr>
							</c:if>
							<tr>
								<td id = "tip_question" colspan="3">
								<input type = "hidden" value = "${dto.getSboard_menu() }" id = "menu">
								<input type = "hidden" value = "${dto.getSboard_num() }" id = "num">
									<c:if test="${dto.getSboard_menu() == '질문' }">
										<c:if test="${dto.getSboard_help() == 'unsolved' }">
											<img src="${path }/resources/img/question_empty.png" <c:if test = "${dto.getSboard_writer() == session_mem_id }">onclick = "question(${dto.getSboard_num() })"</c:if>>
										</c:if>
										<c:if test="${dto.getSboard_help() == 'solved' }">
											<img src="${path }/resources/img/question.png" <c:if test = "${dto.getSboard_writer() == session_mem_id }">onclick = "question(${dto.getSboard_num() })"</c:if>>
										</c:if>
									</c:if>
								</td>
							</tr>
						</c:if>
					</table>
					
					<form method="post" action="<%=request.getContextPath() %>/scomm_write.do?num=${dto.getSboard_num() }">
						<input type="hidden" name="sboard_num" value="${dto.getSboard_num() }">
						<input type="hidden" name="scomm_writer" value="${session_mem_id }">
						<input type="hidden" name="category" value="${category }">
						<h4>댓글</h4>
	
						<input type="text" id="comm" name="scomm_cont" placeholder="댓글을 입력해주세요"> 
						<input type="submit" id="comm_btn" value="작성">
					</form>
				</div>
				<div class="board_comm" id="scomm_list">
					<c:set var="dto1" value="${scomm_list }" />
					<c:if test="${!empty dto1 }">
						<c:forEach items="${dto1 }" var="dto">
							<table class="comm_box">
								
								<tr>
									<td>${dto.getMem_name() }</td>
									<td>
									<c:if test="${session_mem_id eq dto.getScomm_writer() }">
										<input type="button" value="수정 |" id="edit_btn" onclick = "javascript:update_form(${dto.getScomm_num() })"> 
										<input type="button" value="삭제" onclick="javascript:dels(${dto.getScomm_num() }, ${dto.getSboard_num() })" ></c:if>
									</td>
								</tr>
								<tr>
									<td colspan="2" id="text_box_${dto.getScomm_num() }">${dto.getScomm_cont() }</td>
									<td colspan="2" id="text_${dto.getScomm_num() }" class = "comm_update" style="display: none;">
										<form method="post" id="frm" action="<%=request.getContextPath() %>/scomm_update.do?num=${dto.getScomm_num() }&snum=${dto.getSboard_num() }&category=${category}">
											<input type="hidden" name="scomm_num" value="${dto.getScomm_num() }">
											<textarea name="scomm_cont">${dto.getScomm_cont() }</textarea>
											<button type="submit" class = "btn_red">수정</button>
										</form>
									</td>
								</tr>
								
								<tr>
									<td colspan="2"><span>${dto.getScomm_regdate().substring(0, 10) }</span>
								</tr>
								
							</table>
						</c:forEach>
					</c:if>
				</div>
			</div>
		</div>
	</div>

</body>
</html>