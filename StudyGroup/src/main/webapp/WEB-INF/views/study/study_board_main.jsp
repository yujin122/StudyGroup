<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TOGETER</title>
<link rel="stylesheet"
	href="${path }/resources/css/study/study_list.css">
</head>
<body>

	<jsp:include page="../include/study_board_top.jsp" />
	<div id="content">
		<jsp:include page="../include/study_board_side.jsp" />

		<div class="study_form">
			<div id="form_top">
				<img src="${path }/resources/img/pen.png" alt="글쓰기"
					onclick="location.href='sboard_write.do?category=${category}'">
			</div>

			<div id="form_cont">
				<div id="main_form">
					<c:set var="list" value="${SboardList }" />
					<c:if test="${!empty list }">
						<c:forEach items="${list }" var="dto">
							<table class="top_box"
								onclick="location.href='sboard_cont.do?num=${dto.getSboard_num() }&category=${category }'">
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
								</tr>
								<tr>
									<td colspan="2">
										<c:if test="${dto.getSboard_cont().length() > 110 }">
											${dto.getSboard_cont().substring(0,110) } ...
										</c:if>
										<c:if test="${dto.getSboard_cont().length() <= 110 }">
											${dto.getSboard_cont() }
										</c:if>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<span>${dto.getSboard_regdate().substring(0, 10) }</span>
										<span>${dto.getMem_name() } 
										<c:if test="${dto.getStudy_mem_position() == 'L' }">
											리더</span>
										</c:if>
										<c:if test="${dto.getStudy_mem_position() == 'M' }">
											멤버</span>
										</c:if>
										<span><img src="${path }/resources/img/chat.png"> ${dto.getComm_cnt() }</span>
										<c:if test="${dto.getSboard_menu() == 'TIP' }">
											<span><img src="${path }/resources/img/tip_icon.png"> ${dto.getTip_cnt() }</span>
										</c:if>
									</td>
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