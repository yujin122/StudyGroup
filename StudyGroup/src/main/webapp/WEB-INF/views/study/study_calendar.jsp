<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study/study_calendar.css">
<style type="text/css">
	#menu_bar li:nth-child(6) a {color: #ED6560}
</style>
<script type="text/javascript" src="${path }/resources/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
$(function(){
	getCalendar();
});

var today = new Date();
var date = new Date();

// 이전달
function prevCalendar(){
	today = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
	getCalendar();
}

// 다음달
function nextCalendar(){
	today = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
	getCalendar();
}

function getCalendar(){
	var setDate = new Date(today.getFullYear(), today.getMonth(), 1);
	// 현재 달의 첫째날
	var firstDate = setDate.getDate();
	// 현재 달의 마지막날
	var lastDate = new Date(today.getFullYear(), today.getMonth()+1, 0).getDate();
	// 현재 달의 처음 요일
	var firstDay = setDate.getDay();
	
	$("#ym").text(today.getFullYear() + "." + (today.getMonth() + 1));

	drawing();
	
	var tr_cnt = 2;
	for(var i = 1; i <= lastDate; i++){
		$("#calendar tr:nth-child("+tr_cnt+") td:nth-child("+(firstDay+1)+")").text(i);
		
		if(today.getFullYear() == date.getFullYear() && today.getMonth() == date.getMonth() && i == date.getDate()){
			$("#calendar tr:nth-child("+tr_cnt+") td:nth-child("+(firstDay+1)+")").css("color", "orange");
		}
		
		firstDay += 1;
		if(firstDay % 7 == 0){
			tr_cnt += 2;
			firstDay = 0;
		}			
	}
	
	study_cal(today);
	
}

// 달력 출력
function drawing(){
	$("#calendar").find("tr:gt(0)").remove();
	
	var cal = "";
	
	for(var i = 0; i < 12; i++){
		cal += "<tr>";
		for(var j = 0; j < 7; j++){
			cal += "<td></td>";
		}
		cal += "</tr>";
	}
	
	 $("#calendar").append(cal); 
}

// 일정 출력
function day_drawing(index, tr_index, td_index, currentDays, monthDays, data){
	
	if(monthDays <= currentDays){
		// 첫번째 줄
		$("#calendar tr:nth-child("+tr_index+") td:nth-child("+td_index+")").append("<span id = 'span_"+ tr_index +"_" +data.scal_num+"' onclick = 'detail("+data.scal_num+")'>"+data.scal_title+"</span>");
			
		$("#span_"+ tr_index +"_" +data.scal_num).css("width", (100 + (102.5 * monthDays))+"%");
		
		for(var k = 0; k < monthDays; k++){
			$("#calendar tr:nth-child("+tr_index+") td:nth-child("+(td_index+(k+1))+")").append("<span></span>");	
		}
	}else{
		nextWeek = monthDays - currentDays;
		fullWeek = parseInt(nextWeek / 7);
		restOfDay = nextWeek % 7;
		
		// 첫번째 줄
		$("#calendar tr:nth-child("+tr_index+") td:nth-child("+td_index+")").append("<span id = 'span_"+ tr_index +"_" +data.scal_num+"' onclick = 'detail("+data.scal_num+")'>"+data.scal_title+"</span>");
			
		$("#span_"+ tr_index +"_" +data.scal_num).css("width", (100 + (102.5 * currentDays))+"%");
		
		for(var k = 0; k < currentDays; k++){
			$("#calendar tr:nth-child("+tr_index+") td:nth-child("+(td_index+(k+1))+")").append("<span></span>");	
		}
		
		// 여러 주에 걸쳐 있을 경우 일주일이 꽉찬 줄
		for(var j = 0; j < fullWeek; j++){
			tr_index += 2;
			$("#calendar tr:nth-child("+tr_index+") td:nth-child(1)").append("<span id = 'span_"+ tr_index +"_" +data.scal_num+"' onclick = 'detail("+data.scal_num+")'>"+data.scal_title+"</span>");
			$("#span_"+ tr_index +"_" +data.scal_num).css("width", (100 + (102.5 * 6))+"%");	
			
			for(var s = 2; s <= 7; s++){
				$("#calendar tr:nth-child("+tr_index+") td:nth-child("+s+")").append("<span></span>");	
			}
		}
		// 남은 날
		if(restOfDay != 0){
			tr_index += 2;
			$("#calendar tr:nth-child("+tr_index+") td:nth-child(1)").append("<span id = 'span_"+ tr_index +"_" +data.scal_num+"' onclick = 'detail("+data.scal_num+")'>"+data.scal_title+"</span>");
			
			$("#span_"+ tr_index +"_" +data.scal_num).css("width", (100 + (102.5 * (restOfDay-1)))+"%");
			
			for(var k = 2; k <= restOfDay; k++){
				$("#calendar tr:nth-child("+tr_index+") td:nth-child("+k+")").append("<span></span>");	
			}		
		}
			
	}	
}

// 일정 추가 메서드
function study_cal(today){
	$.ajax({
		url: "${path}/getStudyCalendar.do",
		dataType: "json",
		success: function(data){
			for(i in data){
				var syear = data[i].scal_sdate.substring(0,4); var eyear = data[i].scal_edate.substring(0,4);
				var smonth = data[i].scal_sdate.substring(5,7); var emonth = data[i].scal_edate.substring(5,7);
				var sday = data[i].scal_sdate.substring(8,10); var eday = data[i].scal_edate.substring(8,10);
				
				if(data[i].scal_sdate.substring(8,9) == '0'){
					sday = data[i].scal_sdate.substring(9,10); 
				}
				
				if(data[i].scal_edate.substring(8,9) == '0'){
					eday = data[i].scal_edate.substring(9,10); 
				}
				
				var days, currentDays, index, tr_index, td_index, nextWeek, fullWeek, restOfDay, monthLastDay, monthDays;
			
				if(syear == today.getFullYear() && smonth == (today.getMonth() + 1) || today.getFullYear() == eyear && (today.getMonth() + 1) == emonth){
					console.log(data[i]);
					if(smonth != emonth){	// 첫날과 마지막날 달이 다를때
						monthLastDay = new Date(syear, smonth, 0).getDate();	// 첫째 달의 마지막 날짜
						monthDays = monthLastDay - sday;						// 마지막 날짜 - 일정첫날
						
						if((today.getMonth() + 1) == smonth){
							index = $("#calendar tr td").index($("#calendar tr td:contains('"+sday+"')"));	// 일정 첫날 날짜 인덱스	
							tr_index = parseInt(index/7)+3;														// tr 인덱스
							td_index = (index % 7)+1;																// td 인덱스
							currentDays = 7 - td_index;															// 현재 주의 남은 날짜
							
							day_drawing(index, tr_index, td_index, currentDays, monthDays, data[i]);
							
						}else if((today.getMonth() + 1) > smonth && (today.getMonth() + 1) < emonth){	// 첫날 달 ~ 마지막날 달 사이에 있는 월
							monthLastDay = new Date(syear, (today.getMonth() + 1), 0).getDate();
							monthDays = monthLastDay - 1;
							
							index = $("#calendar tr td").index($("#calendar tr td:contains('"+1+"')"));
							tr_index = parseInt(index/7)+3;
							td_index = (index % 7)+1;
							currentDays = 7 - td_index;
							
							nextWeek = monthDays - currentDays;
							fullWeek = parseInt(nextWeek / 7);
							restOfDay = nextWeek % 7;
							
							day_drawing(index, tr_index, td_index, currentDays, monthDays, data[i]);
							
						}else{	// 마지막 달
							monthDays = eday-1;
							console.log(monthDays);
							
							index = $("#calendar tr td").index($("#calendar tr td:contains('"+1+"')"));
							tr_index = parseInt(index/7)+3;
							td_index = (index % 7)+1;
							currentDays = 7 - td_index;
							
							day_drawing(index, tr_index, td_index, currentDays, monthDays, data[i]);
							
						}		
					}else{		// 같은 달일때
						index = $("#calendar tr td").index($("#calendar tr td:contains('"+sday+"')"));
						tr_index = parseInt(index / 7)+3;
						td_index = (index % 7)+1;
						days = eday - sday;
						currentDays = 7 - td_index;
						
						day_drawing(index, tr_index, td_index, currentDays, days, data[i]);
						
					}  	
				}
			}				
		},
		error : function(request, status, error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}	
	});
}

// 일정 상세내역
function detail(scal_num){
	$.ajax({
		url: "${path}/study_calendar_cont.do",
		data: {
			"scal_num" : scal_num
		},
		dataType: "json",
		success: function(data){
			
			$("#popupCont h3").text("📆 " + data.scal_title);
			if(data.scal_sdate.substring(0,10) == data.scal_edate.substring(0,10)){
				$("#popupCont table tr:nth-child(1) td:nth-child(2)").text(data.scal_sdate.substring(0,10));
				$("#popupCont table tr:nth-child(2) td:nth-child(2)").text(data.scal_sdate.substring(11,16) + " ~ " + data.scal_edate.substring(11,16));
			}else{
				$("#popupCont table tr:nth-child(1) td:nth-child(2)").text(data.scal_sdate.substring(0,10) + " ~ " + data.scal_edate.substring(0,10));
				$("#popupCont table tr:nth-child(2) td:nth-child(2)").text(data.scal_sdate.substring(11,16) + " / " + data.scal_edate.substring(11,16));
			}
			if(data.scal_place == '' || data.scal_place == null){
				$("#popupCont table tr:nth-child(3) td:nth-child(2)").text("");
			}else{
				$("#popupCont table tr:nth-child(3) td:nth-child(2)").text(data.scal_place);
			}
			$("#popupCont table tr:nth-child(5) td textarea").val(data.scal_cont);
		},
		error : function(request, status, error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
	$(".popup").fadeIn(400);
	
}

function popup_close(){
	$(".popup").fadeOut();
}
</script>
</head>
<body>
<body>
	
	<jsp:include page="../include/study_board_top.jsp" />
	
	<div id="content">
		<jsp:include page="../include/study_board_side.jsp" />
		<div class="study_form">
			<div id="form_top">
			</div>
			<div id="form_cont">
				<div id = "study_cal">
					<div id = "cal_title">
						<a href = "javascript:prevCalendar()"><</a><span id = "ym"></span><a href = "javascript:nextCalendar()">></a>
					</div>
					<table id = "calendar">
						<tr>
							<th>일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th>
						</tr>
					</table>
				</div>
				
				<div class = "popup">
					<div id = "popupBg"></div>
					<div id = "popupCont">
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
							<button class = "btn_white" onclick = "popup_close()">닫기</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</body>
</html>