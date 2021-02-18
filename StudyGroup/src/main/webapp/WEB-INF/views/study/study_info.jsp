<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study/study_manage.css">
</head>
<body>
	<%@include file="../include/study_board_top.jsp" %>
	
		<div id = "content">
			<jsp:include page="../include/study_board_side.jsp" />
			<div class = "study_form">
				<div id = "form_top">
				</div>
				<c:set var = "info" value = "${dto }"/>
				<div id = "form_cont">
					<h3><a href = "${path }/study_manage_main.do"><img src="${path }/resources/img/back.png"></a> 스터디 정보</h3>
					<div id = "study_info">
						<c:if test="${!empty info.getStudy_img() }">
							<img src="${path }/resources/upload/study/${info.getStudy_img() }" alt="스터디 아이콘">
						</c:if>	
						<c:if test="${empty info.getStudy_img() }">
							<img src="${path }/resources/img/study_main_default.png" alt="스터디 아이콘">
						</c:if>
						<table>
							<tr>
								<th>스터디명</th>
								<td>${info.getStudy_name() }</td>
							</tr>
							<tr>
								<th>리더</th>
								<td>${info.getMem_nickname() }</td>
							</tr>
							<tr>
								<th>총인원</th>
								<td>${info.getStudy_people() }명</td>
							</tr>
							<tr>
								<th>한 줄 소개</th>
								<td>
									${info.getStudy_short_intro() }
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>