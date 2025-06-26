<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>On:trip</title>
	<link rel="icon" href="/Image/header/logo2.png" type="image/png" />    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="/CSS/header.css">
  	<script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <h2>비회원 문의하기</h2>
    
     <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>
    
    <c:if test="${not empty successMessage}">
	    <div class="alert alert-success">${successMessage}</div>
	</c:if>
    
    <form action="/publicInquirySubmit" method="post">
        <div class="mb-3">
            <label for="userId" class="form-label">이메일 또는 아이디</label>
            <input type="text" class="form-control" id="userId" name="userId" required>
        </div>
        
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">문의 내용</label>
            <textarea class="form-control" id="content" name="content" rows="5" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">문의 제출</button>
    </form>
</div>
</body>
</html>