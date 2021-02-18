<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="http://code.jquery.com/jquery-1.6.4.min.js"></script>
<script type="text/javascript">
// layer popup
function wrapPopupByMask() {
	var maskHeight = $(document).height();
	var maskWidth = $(document).width();
	
	$("#mask").css({"width":maskWidth,"height":maskHeight});
	
	//$("#mask").fadeIn(1);      
  	$("#mask").fadeTo(0,0.6);    
	
	$("#popup").show();
	
}

$(document).ready(function(){
	$(".openMask").click(function(e){
		e.preventDefault();
		wrapPopupByMask();
	});
	
	$("#popup .close").click(function(e){
		e.preventDefault();
		$("#mask, #popup").hide();
	});
	
	$("#mask").click(function(){
		$(this).hide();
		$("#popup").hide();
	});
}); 
// layer popup 끝

//전체선택&해제
$("#popup").ready(function(){
		$("#allCheck").click(function(){
			if($("#allCheck").is(":checked")){
				$(".todo_chx").prop("checked", true);
			}else{
				$(".todo_chx").prop("checked", false);
			}
		});
});
// todo detail list
function list_detail() {
	 $.ajax({
		  url:"todo_listDetail.do",
		  type:"POST",
		  dataType:"json",
		  success:function(data){
			  var table = document.querySelector("#todo_table");
			  var html = "";
			  for(var i = 0; i < data.length; i++){
				var f = "F";
					if(data[i].todo_state == f){
						html += "<tr><td><input type='checkbox' name='todo_chx' class='todo_chx' value="+data[i].todo_num+"><DEL>"+data[i].todo_text+"</DEL></td></tr>";
					}else {
						html += "<tr><td><input type='checkbox' name='todo_chx' class='todo_chx' value="+data[i].todo_num+">"+data[i].todo_text+"</td></tr>";
					}
				}
			 table.innerHTML = html;
		  }
	  });
}

// todo 완료
function todo_finish(){
	   var checkArr = new Array();
	   var list = $("input[name='todo_chx']");
	   for(var i=0; i<list.length; i++){
	      if(list[i].checked){
	         checkArr.push(list[i].value);
	      }
	   }
	   if(checkArr.length == 0){
	      alert("선택된 글이 없습니다.");
	   }
	   else {
		  
		  var chk = confirm("완료하셨습니까?");

		  if(chk == true) {
			  $.ajax({
				  url:"todo_finish.do",
				  type:"POST",
				  traditional : true,
				  data : {checkArr: checkArr},
				  success:function(result){
					  if(result == 0){
						  alert("완료실패.");
						  history.back();
					  }
					 else {
						  list_detail();
					  }
				  }
			  });
		  } else {
			  alert("취소되었습니다.");
		  }
		}
	  }

// todo 삭제
function todo_del(){
	   var checkArr = new Array();
	   var list = $("input[name='todo_chx']");
	   for(var i=0; i<list.length; i++){
	      if(list[i].checked){
	         checkArr.push(list[i].value);
	      }
	   }
	   if(checkArr.length == 0){
	      alert("선택된 글이 없습니다.");
	   }
	   else {
		  
		  var chk = confirm("삭제하시겠습니까?");

		  if(chk == true) {
			  $.ajax({
				  url:"todo_delete.do",
				  type:"POST",
				  traditional : true,
				  data : {checkArr: checkArr},
				  success:function(result){
					  if(result == 0){
						  alert("삭제실패.");
						  history.back();
					  }
					 else {
						  alert("삭제되었습니다.");
						  list_detail();
					  }
				  }
			  });
		  } else {
			  alert("삭제를 취소하였습니다.");
		  }
		}
	  } 

// todo 추가
function todo_insert(){
	 if(!document.todo_form.todo_text.value) {
		 alert("내용을 입력하세요.");
	 }else {
		 var todo_text = $("#todo_text").val();
		 
			$.ajax({
				url:"todo_insert.do",
				type:"POST",
				data : {todo_text:todo_text},
				success:function(result){
					if(result > 0){
						alert("TO DO 목록에 추가되었습니다.");
						$("#todo_text").val("");
						list_detail();
					}else {
						alert("추가 실패");
						history.back();
					}
				}
			});
	 }
}

</script>
<link rel ="stylesheet" href = "${path }/resources/css/main_manage.css">
</head>
<body>
	<jsp:include page="../include/top.jsp" />
	<!-- todo:layer popup -->
	<div id="mask"></div>
	<div id="popup">
		<div class="head">
			<button class="close" type="button"><img src="${path }/resources/img/close.png"></button>
		</div>
		<span>#TO DO</span>
		<form name="todo_form">
			<div id="popup_btn">
				<input type="button" class="btn_red" value="삭제" onclick="todo_del()">
				<input type="button" class="btn_red" value="완료" onclick="todo_finish()">
			</div>
			<div id="popup_todo">
				<table>
					<thead>
						<tr>
							<th><input type="checkbox" id="allCheck" name="allCheck"></th>
						</tr>
					</thead>
					<tbody id="todo_table">
					</tbody>
				</table>
			</div>
			<input type="text" name="todo_text" id="todo_text">
			<input type="button" class="btn_red" value="추가" onclick="todo_insert()">
		</form>
	</div>
	<!-- todo:layer popup end -->
	<div id="content">
	<h1>스터디 관리</h1>
	<table id="mTable">
		<tr class = "subtitle">
			<td>
				<div id = "todo_td">
					#TO DO
					<button class="openMask" type="button" onclick="list_detail();"><img src="${path }/resources/img/todo_detail.png" title="To DO 상세보기"></button>
				</div>
			</td>
			<td>#이번 주 일정</td>
		</tr>
		<!-- 1  -->
		<tr>
			<!-- to do -->
			<td>
				<div id="todo">
				<form>
					<table>
						<c:set var="tList" value="${todoList }" />
						<c:if test="${!empty tList }"> 
						<c:forEach items="${tList }" var="t">
							<c:if test="${t.todo_state == 'N' }">
								<tr>
									<td> ✔ ${t.getTodo_text() }</td>
								</tr>
							</c:if>
						</c:forEach>
						</c:if>
						<c:if test="${empty tList }">
							<tr><td>입력된 TO DO 리스트가 없습니다.</td></tr>
						</c:if>
					</table>
				</form>
				</div>
			</td>
			<!--  -->

			<td>
			<div id="weekly">
				<table>
					<tr>
						<th>날짜</th><th>스터디</th><th>장소</th><th>일정</th>
					</tr>
				<c:set var="weekly" value="${weekly }"/>
				<c:if test="${!empty weekly }">
				<c:forEach items="${weekly }" var="w">
					<tr>
						<c:if test="${w.getScal_sdate() == w.getScal_edate() }">
							<td>${w.getScal_sdate().substring(5,7) }/${w.getScal_sdate().substring(8,10) }</td>
						</c:if>
						<c:if test="${w.getScal_sdate() != w.getScal_edate() }">
							<td>${w.getScal_sdate().substring(5,7) }/${w.getScal_sdate().substring(8,10) } - 
							${w.getScal_edate().substring(5,7) }/${w.getScal_edate().substring(8,10) }</td>
						</c:if>
						<td>${w.getStudy_name() }</td>
						<td>${w.getScal_place() }</td>
						<td>${w.getScal_title() }</td>
					</tr>
				</c:forEach>
				</c:if>
				<c:if test="${empty weekly }">
					<tr><td colspan = "4"><h4>등록된 일정이 없습니다.</h4></td></tr>
				</c:if>
				</table>
			</div>
			</td>
		</tr>
		</table>
		
		<span class = "subtitle subtitle_span">#스터디 모임</span>
		<div class = "item_list">
			<c:set value="${MyStudy }" var = "study_list" />
				<c:if test="${!empty study_list }">
					<c:forEach items="${study_list }" var = "study">
						<c:set var = "cnt" value = "${cnt+1}" />
						<table onclick = "location = '${path }/sboard_main.do?num=${study.getStudy_num() }'">
							<tr>
								<td rowspan = "3">
									<c:if test="${!empty study.getStudy_img() }">
										<img src="${path }/resources/upload/study/${study.getStudy_img() }">
									</c:if>
									<c:if test="${empty study.getStudy_img() }">
										<img src="${path }/resources/img/study_main_default.png">
									</c:if>
								</td>
								<td>
									<c:if test="${study.getStudy_type() == 'Y' }">
										<img src="${path }/resources/img/icon.png">	
									</c:if>
								</td>
							</tr>
							<tr>
								<td rowspan = "2">${study.getStudy_name() }</td>
							</tr>
							<tr></tr>
							<tr>
								<td colspan = "2">${study.getStudy_short_intro() }</td>
							</tr>
							<tr>
								<td colspan = "2">${study.getStudy_hashtag() }</td>
							</tr>
							<tr>
								<td colspan = "2">${study.getStudy_mem_cnt() }/${study.getStudy_people() }명 <c:if test="${study.getStudy_mem_cnt() == study.getStudy_people() }"></c:if>모집중
							</tr>
						</table>
						
						<c:if test="${cnt%4 == 0 }">
						<br>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${empty study_list }">
					<h2>가입한 스터디 모임이 존재하지 않습니다.</h2>
					<p>스터디에 참여해보세요!</p>
				</c:if>
		</div>
		<!-- 스터디 모임 끝 -->
		
		<span class = "subtitle subtitle_span">#승인 대기</span>
		<div class = "item_list">
			<c:set value="${WaitStudy }" var = "w_study_list" />
				<c:if test="${!empty w_study_list }">
					<c:forEach items="${w_study_list }" var = "w_study">
						<c:set var = "cnt" value = "${cnt+1}" />
						<table onclick = "location = '${path }/study_cont.do?num=${w_study.getStudy_num() }&menu=manage'">
							<tr>
								<td rowspan = "3">
									<c:if test="${!empty w_study.getStudy_img() }">
										<img src="${path }/resources/upload/study/${w_study.getStudy_img() }">
									</c:if>
									<c:if test="${empty w_study.getStudy_img() }">
										<img src="${path }/resources/img/study_main_default.png">
									</c:if>
								</td>
								<td>
									<c:if test="${w_study.getStudy_type() == 'Y' }">
										<img src="${path }/resources/img/icon.png">	
									</c:if>
								</td>
							</tr>
							<tr>
								<td rowspan = "2">${w_study.getStudy_name() }</td>
							</tr>
							<tr></tr>
							<tr>
								<td colspan = "2">${w_study.getStudy_short_intro() }</td>
							</tr>
							<tr>
								<td colspan = "2">${w_study.getStudy_hashtag() }</td>
							</tr>
							<tr>
								<td colspan = "2">${w_study.getStudy_mem_cnt() }/${w_study.getStudy_people() }명 <c:if test="${study.getStudy_mem_cnt() == study.getStudy_people() }"></c:if>모집중
							</tr>
						</table>
						
						<c:if test="${cnt%4 == 0 }">
						<br>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${empty w_study_list }">
					<h2>승인 대기 중인 스터디 모임이 없습니다.</h2>
				</c:if>
		</div>
		<!-- 승인 대기 끝 -->
	</div><!-- content div end -->

	
	<jsp:include page="../include/bottom.jsp" />
</body>
</html>