<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>On:trip</title>
	<link rel="icon" href="/Image/header/logo2.png" type="image/png" />
    <link rel="stylesheet" href="/CSS/adminInquiry.css">
	<link rel="stylesheet" href="/CSS/header.css">
  	<script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>

<div class="table-wrapper">
    <h2 class="table-title">회원 문의 관리</h2>

    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>상태</th>
                <th>작성일</th>
                <th>상세보기</th>
                <th>상태 수정</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="inquiry" items="${inquiryList}" varStatus="status">
                <tr>
                    <!-- 역순 번호 계산 -->
                    <td>${totalCount - ((currentPage - 1) * 10 + status.index)}</td>
                    <td>${inquiry.inquiryTitle}</td>
                    <td>
                        <c:choose>
                            <c:when test="${inquiry.userNum == null}">
                                <span class="guest-user">비회원 (${inquiry.userIdText})</span>
                            </c:when>
                            <c:otherwise>
                                ${inquiry.userNickname}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${inquiry.inquiryStatus == '완료'}">
                                <span class="status-badge status-complete">${inquiry.inquiryStatus}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-pending">${inquiry.inquiryStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${fn:substring(inquiry.inquiryTime, 0, 16)}</td>
                    <td><a href="/inquiryDetail?inquiryNum=${inquiry.inquiryNum}">보기</a></td>
                    <td>
                        <form action="/inquiryStatusUpdate" method="get" class="status-form">
                            <input type="hidden" name="inquiryNum" value="${inquiry.inquiryNum}" />
                            <select class="status-select" name="inquiryStatus">
                                <option value="대기" ${inquiry.inquiryStatus == '대기' ? 'selected' : ''}>대기</option>
                                <option value="완료" ${inquiry.inquiryStatus == '완료' ? 'selected' : ''}>완료</option>
                            </select>
                            <button class="status-button" type="submit">변경</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="pagination">
        <c:forEach begin="1" end="${totalPages}" var="p">
            <a href="/admininquiry?page=${p}" class="${p == currentPage ? 'active' : ''}">${p}</a>
        </c:forEach>
    </div>
</div>

</body>
</html>