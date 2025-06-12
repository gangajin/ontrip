<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>문의 상세</title>
    <style>
        .chat-container {
            width: 600px;
            margin: 20px auto;
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 10px;
            background: #f9f9f9;
        }

        .message {
            margin: 10px 0;
            padding: 10px;
            border-radius: 10px;
            max-width: 70%;
            clear: both;
        }

        .user-message {
            background: #d4eaf7;
            float: left;
            text-align: left;
        }

        .admin-message {
            background: #f1d6d6;
            float: right;
            text-align: right;
        }

        .time {
            font-size: 0.8em;
            color: gray;
            margin-top: 5px;
        }

        .reply-form {
            clear: both;
            margin-top: 30px;
        }

        .reply-form textarea {
            width: 100%;
            height: 60px;
            resize: none;
            padding: 10px;
            font-size: 1em;
        }

        .reply-form button {
            margin-top: 5px;
            padding: 8px 20px;
        }

        .clear {
            clear: both;
        }
    </style>
</head>
<body>
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

    <!-- 입력창은 하나만 -->
    <form action="/replyInsert" method="post" class="reply-form">
        <input type="hidden" name="inquiryNum" value="${inquiry.inquiryNum}" />
        <textarea name="replyContent" placeholder="메시지를 입력하세요" required></textarea>
        <button type="submit">전송</button>
    </form>
</div>
</body>
</html>