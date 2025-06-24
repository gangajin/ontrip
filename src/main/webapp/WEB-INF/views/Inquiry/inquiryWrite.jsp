<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<link rel="stylesheet" href="/CSS/inquiryWrite.css">
</head>
<body>
<%@ include file="../header.jsp" %>
    <div class="inquiry-form-container">
        <h2>새 문의 작성</h2>

    
        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

  
        <form action="/inquiryinsert" method="post">
            <div class="form-group">
                <label for="content">문의 내용</label>
                <textarea id="content" name="content" placeholder="문의 내용을 입력해주세요." required></textarea>
            </div>

            <div class="form-actions">
                <button type="submit">문의 제출</button>
            </div>
        </form>
    </div>

</body>
</html>