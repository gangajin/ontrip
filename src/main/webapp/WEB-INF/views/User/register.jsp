<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 페이지</title>
<script src="/JS/register.js"></script>
</head>
<body>
	<h2>회원 가입</h2>
	<h3>회원 가입을 위한 정보를 입력해주세요.</h3>
	<form name="register" method="post" action="/registerProcess" onsubmit="return check()">
		이메일<br>
		<input type="text" name="userId" id="userId" placeholder="이메일 주소">
		<button type="button" onclick="validateEmail()">확인</button><br>
		<div id="emailStatus" style="color:red; font-size: 0.9em;"></div><p>
		
		닉네임<br>
		<input type="text" name="userNickname" id="userNickname">
		<button type="button" onclick="validateNickname()">확인</button><br>
		<div id="nicknameStatus" style="color:red; font-size: 0.9em;"></div><p>
		
		비밀번호<br>
		<input type="password" name="userPasswd" id="userPasswd" placeholder="영문, 숫자, 특수문자 포함 8자리 이상"><p>
		
		비밀번호 확인<br>
		<input type="password" name="userPasswd2" id="userPasswd2" placeholder="영문, 숫자, 특수문자 포함 8자리 이상"><p>
		
		<input type="submit" value="회원가입"><br>
		<a href="/login">로그인 화면으로</a>
	</form>
</body>
</html>