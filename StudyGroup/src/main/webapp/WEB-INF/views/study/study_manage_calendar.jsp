<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${path }/resources/css/study/study_manage.css">
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
	$(function(){
		$("#allCheck").click(function(){
			if($("#allCheck").is(":checked")){
				$(".delCheck").prop("checked", true);
			}else{
				$(".delCheck").prop("checked", false);
			}
		});
		
		if('${msg}' != ''){
			alert('${msg}');
		}
	});
	
	function cal_del_check(){
		if(!$(".delCheck").is(":checked")){
			alert("삭제할 일정을 선택해주세요");
			return false;
		}else {
			if(confirm('일정을 삭제하시겠습니까?')){
				return true;	
			}else{
				return false;
			}
		}
	}
	
	function calendar_cont(scal_num){
		$.ajax({
			url: "${pageContext.request.contextPath}/study_calendar_cont.do",
			data: {
				"scal_num" : scal_num
			},
			dataType: "json",
			success: function(data){
				
				$("#popup_cal_cont h3").text("📆 " + data.scal_title);
				if(data.scal_sdate.substring(0,10) == data.scal_edate.substring(0,10)){
					$("#popup_cal_cont table tr:nth-child(1) td:nth-child(2)").text(data.scal_sdate.substring(0,10));
					$("#popup_cal_cont table tr:nth-child(2) td:nth-child(2)").text(data.scal_sdate.substring(11,16) + " ~ " + data.scal_edate.substring(11,16));
				}else{
					$("#popup_cal_cont table tr:nth-child(1) td:nth-child(2)").text(data.scal_sdate.substring(0,10) + " ~ " + data.scal_edate.substring(0,10));
					$("#popup_cal_cont table tr:nth-child(2) td:nth-child(2)").text(data.scal_sdate.substring(11,16) + " / " + data.scal_edate.substring(11,16));
				}
				
				if(data.scal_place == '' || data.scal_place == null){
					$("#popup_cal_cont table tr:nth-child(3) td:nth-child(2)").text("");
				}else{
					$("#popup_cal_cont table tr:nth-child(3) td:nth-child(2)").text(data.scal_place);
				}
				$("#popup_cal_cont table tr:nth-child(5) td textarea").val(data.scal_cont);
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
		
		$("#cal_cont").fadeIn(400);
	}
	
	function popup_close(up){
		$("#cal_"+up).fadeOut();
	}
	
	function calendar_check(){
		if($("input[name='scal_title']").val() == ''){
			alert('일정 이름을 입력해주세요');
			$("input[name='scal_title']").focus();
			return false;
		}
		
		if($("input[name='scal_sdate']").val() == '' || $("input[name='scal_edate']").val() == ''){
			alert('날짜를 입력해주세요.');
			$("input[name='scal_sdate']").focus();
			return false;
		}
	}
	
	function calendar_input(){
		$("input[name='scal_title']").val("");
		$("input[name='scal_sdate']").val("");
		$("input[name='scal_edate']").val("");
		$("input[name='scal_place']").val("");
		$("textarea").val("");
		
		$("#cal_insert").fadeIn(400);
	}
	
</script>
</head>
<body>

	<jsp:include page="../include/study_board_top.jsp" />
	<div id="content">
		<jsp:include page="../include/study_board_side.jsp" />
		<div class="study_form">
		<div id = "form_top">
		</div>
		<div id = "form_cont">
			<h3><a href = "${path }/study_manage_main.do"><img src="${path }/resources/img/back.png"></a> 스터디 모임 일정 관리</h3>
			<div id = "manage_cal">
				<form method = "post" action = "${path }/calendar_delete.do" onsubmit = "return cal_del_check()">
				<c:set var = "list" value = "${list }"/>
					<table>
						<tr>
							<td colspan = "4">
								<input type = "button" onclick = "calendar_input()" value = "">
								<input type = "submit" value = "">
							</td>
						</tr>
						<tr>
							<th><input type = "checkbox" name = "allCheck" id = "allCheck"></th><th>일정 이름</th><th>날짜/시간</th><th>장소</th>
						</tr>
						<c:if test="${!empty list }">
							<c:forEach items="${list }" var = "cal">
								<tr>
									<td><input type = "checkbox" name = "delCheck" class = "delCheck" value = "${cal.getScal_num() }"></td>
									<td><a href = "javascript:calendar_cont(${cal.getScal_num() })">${cal.getScal_title() }</a></td>
									<td>${cal.getScal_sdate().substring(0,16) } ~ ${cal.getScal_edate().substring(0,16) }</td>
									<td>${cal.getScal_place() }</td>
								</tr>
							</c:forEach>
						</c:if>
					</table>
				</form>
			</div>
			<div class = "popup" id = "cal_cont">
				<div class = "popupBg"></div>
				<div id = "popup_cal_cont">
					<h2>일정</h2>
					<h3></h3>
					<table>
						<tr>
							<th>날짜</th>
							<td></td>
						</tr>
						<tr>
							<th>시간</th>
							<td></td>
						</tr>
						<tr>
							<th>장소</th>
							<td></td>
						</tr>
						<tr>
							<th colspan = "2">상세내용</th>
						</tr>
						<tr>
							<td colspan = "2"><textarea readonly></textarea></td>
						</tr>
					</table>
					<div id = "popupBtn">
						<button class = "btn_white" onclick = "popup_close('cont')">닫기</button>
					</div>
				</div>
			</div>
			<div class = "popup" id = "cal_insert">
				<div class = "popupBg"></div>
				<div id = "popup_cal_insert">
					<h2>일정 추가</h2>
					<form method = "post" action = "${path }/calendar_insert.do" onsubmit="return calendar_check()">
						<table>
							<tr>
								<th>일정 이름</th>
							</tr>
							<tr>
								<td><input type = "text" name = "scal_title" placeholder="일정 이름을 입력해주세요"></td>
							</tr>
							<tr>
								<th>날짜 / 시간</th>
							</tr>
							<tr>
								<td><input type = "datetime-local" name = "scal_sdate"> ~ <input type = "datetime-local" name = "scal_edate"></td>
							</tr>
							<tr>
								<th>장소</th>
							</tr>
							<tr>
								<td><input type = "text" name = "scal_place" placeholder="장소를 입력해주세요"></td>
							</tr>
							<tr>
								<th>상세내용</th>
							</tr>
							<tr>
								<td><textarea placeholder="상세내용을 입력해주세요" name = "scal_cont"></textarea></td>
							</tr>
						</table>
						<div id = "insert_Btn">
							<input type = "submit" class = "btn_red" value = "추가">
							<input type = "button" class = "btn_white" onclick = "popup_close('insert')" value = "닫기">
						</div>
					</form>
				</div>
			</div>
		</div>
		</div>
	</div>
</body>
</html>