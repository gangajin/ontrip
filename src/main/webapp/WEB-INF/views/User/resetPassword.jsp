<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>On:trip</title>
<link rel="icon" href="/Image/header/logo2.png" type="image/png" />
<link rel="stylesheet" href="/CSS/resetPassword.css">
</head>
<body>
	<div class="reset-container">
	    <div class="reset-box">
	    	<a href="/">
				<img src="/Image/header/logo.png" alt="로고" style="height: 100px;">
			</a>

	        <form action="/resetPasswordProcess" method="post" onsubmit="return pwCheck()">
	            <input type="hidden" name="token" value="${token}" />

	            <label>새 비밀번호:</label>
	            <input type="password" name="userPasswd" id="userPasswd" placeholder="새 비밀번호 입력">

	            <label>비밀번호 확인:</label>
	            <input type="password" name="userPasswd2" id="userPasswd2" placeholder="비밀번호 재입력">

	            <button type="submit">비밀번호 변경</button>
	        </form>

	        <a href="/login">로그인으로 돌아가기</a>
	    </div>
	</div>
    
    <script src="${pageContext.request.contextPath}/JS/resetPassword.js"></script>
</body>
</html>