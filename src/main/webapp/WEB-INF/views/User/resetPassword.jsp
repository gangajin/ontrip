<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 재설정</title>
</head>
<body>
	<h2>비밀번호 재설정</h2>

    <form action="/resetPasswordProcess" method="post" onsubmit="return pwCheck()">
        <input type="hidden" name="token" value="${token}" />

        <label>새 비밀번호:</label><br>
        <input type="password" name="userPasswd" id="userPasswd" placeholder="새 비밀번호 입력"><br><br>

        <label>비밀번호 확인:</label><br>
        <input type="password" name="userPasswd2" id="userPasswd2" placeholder="비밀번호 재입력"><br><br>

        <button type="submit">비밀번호 변경</button>
    </form>

    <p><a href="/login">로그인으로 돌아가기</a></p>
    
    <script src="${pageContext.request.contextPath}/JS/resetPassword.js"></script>
</body>
</html>