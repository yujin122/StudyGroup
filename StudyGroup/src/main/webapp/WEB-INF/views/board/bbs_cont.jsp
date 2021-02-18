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
<script type="text/javascript">
	<%--글 삭제 확인--%>
	function conf(no) {
		var conf = confirm("정말 삭제 하시겠습니까?");
		if(conf){
			location.href= '<%=request.getContextPath() %>/bbs_delete.do?no='+no+'&page=${page}&str=${str }&opt=${opt }&text=${text }';
		} else {
			return;
		}
	};
	
	<%-- 댓글 삭제 확인--%>
	function conf_2(no,count) {
		var conf_2 = confirm("댓글을 삭제 하시겠습니까?");
		if(conf_2){
			deleteReply(no,count);
		} else {
			return;
		}
	};

	<%--댓글 목록--%>
	function replyList(count) {
		$(function() {

			$.ajax({
				type: "get",
				contentType: "application/json; charset=UTF-8",
				dataType: "json",
				url: "bcomm_list.do?no=${no}&count="+count,
				success: function(data) {
					// index : data 객체 내의 인덱스를 말함.
					// item : data 객체 내의 이름과 값을 가지는 객체를 말함.
					var txt ="";
					
					if(data !=""){
						$.each(data, function(index, item) {
							if(item.bcomm_indent !=0) { //대댓글
									txt += "<li class='list-group-item'>" +
									"<div class='reply1'>" +
									"<div class='repInfo'>" +
									"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
							        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
							        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no+',"rrep",' +count+ ");'>답글</a></span>" ;
							        if(item.bcomm_writer=="${mem_id}"){
							        txt +=
							        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no+',"edit",' +count+");'>수정</a></span>" +
									"&nbsp;<span class='badge'><a onclick='conf_2("+ item.bcomm_no+',' +count+");'>삭제</a></span>";
							        };
									txt += "</div>" +
							        "<div class='repCont'>" + item.bcomm_cont + "</div>" +
							        "</div>" +
							        "</li>";
							
							} else { //기본댓글
								txt += "<li class='list-group-item'>" +
								"<div class='repInfo'>" +
								"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
						        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
						        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no+',"rrep",' +count+");'>답글</a></span>";
						        if(item.bcomm_writer=="${mem_id}"){
							     txt +=
						        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no+',"edit",' +count+");'>수정</a></span>" +
						        "&nbsp;<span class='badge'><a onclick='conf_2("+ item.bcomm_no +"," +count+");'>삭제</a></span>";
						        };
						        txt += "</div>" +
						        "<div class='repCont'>" + item.bcomm_cont + "</div>" +
						        "</li>";
							}; // 기본/대댓 if절
							
							$("#replyList").html(txt);
						});
						
						var btn="";
							if( (${rep_count} -(count*10) ) > 0) {
							
							btn += "<a onclick='replyList("+(count+1)+")'>더 많은 댓글</a>";
							$("#more").html(btn);
						} else {
							$("#more").html(btn);
						};
					} else {
						$("#replyList").html(txt);
					}
					
				},
				error: function() {
					alert("댓글을 불러오지 못했습니다.");
				}
			});
		});
	};
	
	<%--댓글 저장--%>
	function replyWrite(board_no) {
	
		var bcomm_cont = $('#bcomm_cont').val();
		//var bcomm_writer = sessionStorage.getItem("");
		var data = {"bcomm_cont" : bcomm_cont,
					"board_no" : board_no
					};
		
		$.ajax({
			type: "post",
			data: data,
			url: "bcomm_write.do",
			success: function(data) {
				replyList(1);
				$('#bcomm_cont').val('');
			},
			error: function() {
				alert("댓글을 저장하지 못했습니다.");
			}
		});
	};
	
	<%--댓글 삭제--%>
	function deleteReply(bcomm_no, count) {
		
		var data = {"bcomm_no" : bcomm_no};
		
		$.ajax({
			type: "post",
			data: data,
			url: "bcomm_delete.do",
			success: function(data) {
				replyList(count);
			},
			error: function() {
				alert("댓글을 삭제하지 못했습니다.");
			}
		});
	};
	
	<%--댓글 리스트 변화--%>
	function editReply(num,str,count) {

		$.ajax({
			type: "get",
			contentType: "application/json; charset=UTF-8",
			dataType: "json",
			url: "bcomm_list.do?no=${no}&count="+count,
			success: function(data) {
				// index : data 객체 내의 인덱스를 말함.
				// item : data 객체 내의 이름과 값을 가지는 객체를 말함.
				var txt ="";
				
				$.each(data, function(index, item) {
					if(item.bcomm_indent !=0) { // 대댓글
						if(item.bcomm_no == num && str =="edit"){
							// 댓글 수정
							txt += "<li class='list-group-item'>" +
							"<div class='reply1'>" +
							"<div class='repInfo'>" +
							"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
					        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
					        "&nbsp;<span class='badge'><a onclick='editWrite("+num+','+count+");'>저장</a></span>" +
					       	"&nbsp;<span class='badge'><a onclick='replyList("+count+")'>취소</a></span>" +
					        "</div>" +
					        	"<div class='repCont'>" +
						        "<input type='text' id='editCont' value='" +item.bcomm_cont + "'>" +
						        "</div>" +
						    "</div>"+
					        "</li>"
						} else if(item.bcomm_no == num && str =="rrep") {
							//대댓달기
							txt += "<li class='list-group-item'>" +
							"<div class='reply1'>" +
							"<div class='repInfo'>" +
							"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
					        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
					        "</div>" +
					        "<div class='repCont'>" +
						     item.bcomm_cont +
						     "</div>"+
						     "<div>"+
						     "<span id='L'>┗</span>&nbsp;&nbsp;<input type='text' id='rrepCont'>"+
						     "<span class='badge'><a onclick='rrepWrite("+num+','+count+");'>저장</a></span>" +
					       	 "<span class='badge'><a onclick='replyList("+count+")'>취소</a></span>" +
					       	 "</div>"+
					       	 "</div>"+
					       	 "</li>"
						} else {
							txt += "<li class='list-group-item'>" +
							"<div class='reply1'>" +
							"<div class='repInfo'>" +
							"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
					        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
					        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no+',"rrep",'+count+");'>답글</a></span>";
					        if(item.bcomm_writer=="${mem_id}"){
							     txt +=
					        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no + ',"edit",' +count+");'>수정</a></span>" +
					        "&nbsp;<span class='badge'><a onclick='conf_2("+ item.bcomm_no +","+count+");'>삭제</a></span>";
					        };
					        txt += "</div>" +
					        "<div class='repCont'>" +
						     item.bcomm_cont +
						     "</div>"+
						     "</div>" +
					        "</li>"
						}
					
					} else { //기본 댓글
						if(item.bcomm_no == num && str =="edit"){
							// 댓글 수정
							txt += "<li class='list-group-item'>" +
							"<div class='repInfo'>" +
							"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
					        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
					        "&nbsp;<span class='badge'><a onclick='editWrite("+num+","+count+");'>저장</a></span>" +
					       	"&nbsp;<span class='badge'><a onclick='replyList("+count+")'>취소</a></span>" +
					        "</div>" +
					        	"<div class='repCont'>" +
						        "<input type='text' id='editCont' value='" +item.bcomm_cont + "'>" +
						        "</div>" +
					        "</li>"
						} else if(item.bcomm_no == num && str =="rrep") {
							//대댓달기
							txt += "<li class='list-group-item'>" +
							"<div class='repInfo'>" +
							"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
					        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
					        "</div>" +
					        "<div class='repCont'>" +
						     item.bcomm_cont +
						     "</div>"+
						     "<div>"+
						     "<span id='L'>┗</span>&nbsp;&nbsp;<input type='text' id='rrepCont'>"+
						     "<span class='badge'><a onclick='rrepWrite("+num+","+count+");'>저장</a></span>" +
					       	 "<span class='badge'><a onclick='replyList("+count+")'>취소</a></span>" +
					       	 "</div>"+
					       	 "</li>"
						} else {
							txt += "<li class='list-group-item'>" +
							"<div class='repInfo'>" +
							"<span id='repWriter'>"+ item.bcomm_nickname + "</span>" +
					        "<span id='repRegdate'>" + item.bcomm_regdate + "</span>" +
					        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no+',"rrep",' +count+");'>답글</a></span>";
					        if(item.bcomm_writer=="${mem_id}"){
							     txt +=
					        "&nbsp;<span class='badge'><a onclick='editReply("+ item.bcomm_no + ',"edit",' +count+");'>수정</a></span>" +
					        "&nbsp;<span class='badge'><a onclick='conf_2("+ item.bcomm_no +","+count+");'>삭제</a></span>";
					        };
					        txt += "</div>" +
					        "<div class='repCont'>" +
						     item.bcomm_cont +
						     "</div>"+
					        "</li>";
						};
						
					}; // 기본/대댓 if절
					
					$("#replyList").html(txt);
				});
			},
			error: function() {
				alert("댓글을 불러오지 못했습니다.");
			}
		});
	};
	
	<%--댓글 수정 저장 --%>
	function editWrite(num,count) {
		var editCont = $('#editCont').val();
		var bcomm_no = num
		
		var data = {"edit_cont" : editCont,
				"bcomm_no" : bcomm_no
				};
	
		$.ajax({
			type: "post",
			data: data,
			url: "bcomm_edit.do",
			success: function(data) {
				replyList(count);
			},
			error: function() {
				alert("댓글을 수정하지 못했습니다.");
			}
		});
		
	};
	
	<%--대댓 저장--%>
	function rrepWrite(num,count) {
		var rrepCont = $('#rrepCont').val();
		var bcomm_no = num
		var board_no = ${no}
		
		var data = {"rrep_cont" : rrepCont,
				"bcomm_no" : bcomm_no,
				"board_no" : board_no
				};
		
		$.ajax({
			type: "post",
			data: data,
			url: "bcomm_rrep.do",
			success: function(data) {
				replyList(count);
			},
			error: function() {
				alert("댓글을 저장하지 못했습니다.");
			}
		});
		
	};
	
	<%-- 전체 목록 버튼--%>
	function backList(page) {
		switch("${str}") {
			case "bbs" :
				location.href='bbs_list.do?page='+page;
				break;
			case "search" : 
				location.href='search_list.do?page='+page+'&opt=${opt}&text=${text}';
				break;
			default : 
				location.href='bbs_catg.do?page='+page+'&catg=${str}';
				break;
		}
	}
	
</script>
</head>
<body>
	
	<jsp:include page="../include/top.jsp" />
	
	<div id="content">
		<div>
			<h1><a href="bbs_list.do?page=1">자유게시판</a></h1>
		</div>
	
		<div id="bbsCont">
			<table id = "bbsCont_tb">
				<c:set var="dto" value="${cont }" />
				<c:if test="${dto.getBoard_catg() eq 'rev'}" >
					<c:set var="catg" value="합격 후기·성공 사례" />
				</c:if>
				<c:if test="${dto.getBoard_catg() eq 'unb'}" >
					<c:set var="catg" value="자유" />
				</c:if>
				<c:if test="${dto.getBoard_catg() eq 'qna'}" >
					<c:set var="catg" value="질문" />
				</c:if>
				<tr>
					<th>
						[${catg }] ${dto.getBoard_title() }
					</th>
				</tr>
				<tr>
					<td>
						${dto.getBoard_nickname() }
						&nbsp;
						${dto.getBoard_regdate().substring(0,16) }
						&nbsp;
						${dto.getBoard_hit() }
					</td>
				</tr>
				<tr>
					<td>
						<pre>${dto.getBoard_cont() }</pre>
					</td>
				</tr>
			</table>
			<hr/>
			
			<table id = "bbsComm_tb">
				<tr>
					<th> 댓글</th>
				</tr>
				<tr>
					<td>
						<input type="text" id="bcomm_cont" placeholder="댓글을 작성해주세요.">
						<input type="button" value="작성" class="btn_red" onclick="replyWrite(${dto.getBoard_no()});">
					</td>
				</tr>
			</table>
			
			<div id="repList"> <!-- 댓글 리스트 -->
				<script>replyList(1);</script>
				<ul id="replyList" class="list-group">
				</ul>
				<p id="more" align="center">
				</p>
			</div>
			
			<div id = "bbs_cont_btn">
				<c:if test="${mem_id eq dto.getBoard_writer() }">
				<input type="button" value="수정" class="btn_red" onclick="location.href='<%=request.getContextPath()%>/bbs_edit.do?no=${dto.getBoard_no()}&page=${page}&str=${str }&opt=${opt }&text=${text }'">
				<input type="button" value="삭제" class="btn_red" onclick="conf(${dto.getBoard_no()}); return false;">
				</c:if>
				<input type="button" value="전체목록" class="btn_white" onclick="backList(${page});">
			</div>
		</div> <!-- repCont -->
	
	</div> <!-- id="content" -->
	
	<jsp:include page="../include/bottom.jsp" />
	
	
</body>
</html>