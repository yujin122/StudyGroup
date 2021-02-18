<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet" href = "${path }/resources/css/study/study_manage.css">
</head>
<body>
<body>
	
	<jsp:include page="../include/study_board_top.jsp" />
	
	<div id="content">
	<jsp:include page="../include/study_board_side.jsp" />
		<div class="study_form">
		<div id = "form_top">
		</div>
		<div id = "form_cont">
			<div id="memberFrame">
			<!-- 가입 승인 -->
			<h3><a href = "${path }/study_manage_main.do"><img src="${path }/resources/img/back.png"></a> 가입 승인</h3>
			<table>
				<c:set var="p" value="${studyPeople }" />
				<c:set var="m" value="${countMember }" />
					<tr>
						<td colspan="2"><b> ${m.getCountMember() + 1}</b><b> / ${p.getStudy_people() }명</b> (남은 인원 : ${p.getStudy_people() - m.getCountMember() - 1 }명)</td>
					</tr>
					
					<!-- 리더 입력 -->
					<c:set var="dto" value="${leaderInfo }" />
					<c:if test="${!empty dto }">
						<tr>
							<td rowspan="2" class = "img_td">
								<c:if test="${!empty dto.getMem_img() }">
									<img src="${path }/resources/upload/user/${dto.getMem_img() }" alt="프로필 이미지">
								</c:if>	
								<c:if test="${empty dto.getMem_img() }">
									<img src="${path }/resources/img/user.png" alt="프로필 이미지">
								</c:if>
							</td>
							<td>${dto.getMem_name() }</td>
						</tr>
						<tr>
							<td>${dto.getMem_email() }</td>
						</tr>
					</c:if>
					<c:if test="${empty dto }">
						<h3>검색된 레코드가 없습니다.</h3>
					</c:if>
			</table>
			
			<div id="division">
				<span>대기자</span>
			</div>
			<table id="memberTable">
				<c:set var="wlist" value="${WMemList }"/>
				<c:if test="${!empty wlist }" >
				<c:forEach items="${wlist }" var="wdto">
				<tr>
					<td rowspan="2" class = "cancle_td"><input type="button" onclick="location.href='<%=request.getContextPath() %>/study_reject_join.do?id=${wdto.getStudy_mem_id() }'"></td>
					<td rowspan="2" class = "img_td">
						<c:if test="${!empty wdto.getMem_img() }">
								<img src="${path }/resources/upload/user/${wdto.getMem_img() }" alt="프로필 이미지">
							</c:if>	
							<c:if test="${empty wdto.getMem_img() }">
								<img src="${path }/resources/img/user.png" alt="프로필 이미지">
							</c:if>
					</td>
					<td>${wdto.getMem_name() }</td>
					<td rowspan="2" class = "ok_btn"><input type="button" class = "btn_red" value="승인" onclick="location.href='<%=request.getContextPath() %>/study_member_insert.do?id=${wdto.getStudy_mem_id() }'"></td>
				</tr>
				<tr>
					<td>${wdto.getMem_email() }</td>
				</tr>
				</c:forEach>
				</c:if>
				<c:if test="${empty wlist }">
					<h3>가입을 요청한 사람이 없습니다.</h3>
				</c:if>
			</table>
			</div>
		</div>
		
		</div><!-- study form -->
	</div><!-- content -->
</body>
</body>
</html>