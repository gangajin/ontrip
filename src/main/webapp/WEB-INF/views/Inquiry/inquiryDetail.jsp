<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>문의 상세</title>
	<link rel="stylesheet" href="/CSS/inquiryDetail.css">
	<link rel="stylesheet" href="/CSS/header.css">
  	<script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>lude file="../header.jsp" %>

<div class="chat-container">
    <h3>문의 내역</h3>

    <div class="message user-message">
        ${inquiry.inquiryContent}
        <div class="time">${inquiry.inquiryTime.toString().substring(0, 16)}</div>
    </div>

    <c:forEach var="reply" items="${inquiry.replies}">
        <c:choose>
            <c:when test="${reply.userRole eq 'user'}">
                <div class="message user-message">
                    ${reply.replyContent}
                    <div class="time">${reply.replyTime.toString().substring(0, 16)}</div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="message admin-message">
                    ${reply.replyContent}
                    <div class="time">${reply.replyTime.toString().substring(0, 16)}</div>
                </div>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <div class="clear"></div>

    <c:choose>
        <c:when test="${inquiry.inquiryStatus == '완료'}">
            <div class="complete-notice">
                ※ 이 문의는 완료 처리되어 더 이상 메시지를 작성할 수 없습니다.
            </div>
        </c:when>
        <c:otherwise>
            <form action="/replyInsert" method="post" class="reply-form">
                <input type="hidden" name="inquiryNum" value="${inquiry.inquiryNum}" />
                <textarea name="replyContent" placeholder="메시지를 입력하세요" required></textarea>
                <button type="submit">전송</button>
            </form>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>