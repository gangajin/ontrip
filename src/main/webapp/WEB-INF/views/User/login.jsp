<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<script src="/JS/login.js"></script>
</head>
<body>
	<form name="login" method="post" action="loginSuccess" onsubmit="return checkLogin()">
		이메일<br>
		<input type="text" name="userId"><p>
		
		비밀번호<br>
		<input type="password" name="userPasswd"><br>
		<a href="/findPassword">비밀번호를 잊으셨나요?</a><p>
		
		<input type="submit" value="로그인"><br>
		아직 회원이 아니세요? <a href="/register">회원가입</a>
		<hr>
		Auth
	</form>
</body>
</html>