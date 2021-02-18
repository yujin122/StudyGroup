<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${path }/resources/css/study/study_manage.css">
</head>
<body>

	<jsp:include page="../include/study_board_top.jsp" />
	<div id="content">
	<jsp:include page="../include/study_board_side.jsp" />
		<div class="study_form">
		<div id = "form_top">
		</div>
		<div id = "form_cont">
			<div id="memberFrame">
				<h3><a href = "${path }/study_manage_main.do"><img src="${path }/resources/img/back.png"></a> 구성원 관리</h3>
				<table id = "leader_tb">
					<c:set var="m" value="${countMember }" />
						<tr>
							<td colspan="2"><b>총 ${m.getCountMember()+1 }명</b> (관리자 1명, 참여자 ${m.getCountMember() }명)</td>
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
					<span>참여자</span>
				</div>
				<c:set var="list" value="${SMemList }" />
				<c:if test="${!empty list }">
					<c:forEach items="${list }" var="mdto">
						<table>
							<!-- 멤버입력 -->
							<tr>
								<td rowspan="2" class = "cancle_td"><input type="button" onclick="location.href='<%=request.getContextPath()%>/study_member_delete.do?id=${mdto.getStudy_mem_id() }'"></td>
								<td rowspan="2" class = "img_td">
								<c:if test="${!empty mdto.getMem_img() }">
									<img src="${path }/resources/upload/user/${mdto.getMem_img() }" alt="프로필 이미지">
								</c:if>	
								<c:if test="${empty mdto.getMem_img() }">
									<img src="${path }/resources/img/user.png" alt="프로필 이미지">
								</c:if>
								</td>
								<td>${mdto.getMem_name() }</td>
							</tr>
							<tr>
								<td>${mdto.getMem_email() }</td>
							</tr>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty list }">
					<h3>현재 승인된 스터디 멤버가 없습니다.</h3>
				</c:if>
			</div>
		</div>
		</div>
	</div>
</body>
</html>