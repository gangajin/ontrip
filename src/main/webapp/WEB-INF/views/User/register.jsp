<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>On:trip</title>
<link rel="icon" href="/Image/header/logo2.png" type="image/png" />
<script src="/JS/register.js"></script>
<link rel="stylesheet" href="/CSS/register.css">
</head>
<body>
	<div class="register-container">
	    <div class="register-box">
			<a href="/">
				<img src="/Image/header/logo.png" alt="로고" style="height: 100px;">
			</a>
			
	        <h4>회원 가입을 위한 정보를 입력해주세요.</h4>
	
	        <form name="register" method="post" action="/registerProcess" onsubmit="return check()">
	
	        	<div class="form-group">
				    <div class="input-group">
				    	<input type="text" name="userId" id="userId" placeholder="이메일 주소">
				        <button type="button" onclick="validateEmail()">중복확인</button>
				    </div>
				    <div class="error-message" id="emailStatus"></div>
				</div>
				
				<div class="form-group">
				    <div class="input-group">
				        <input type="text" name="userNickname" id="userNickname" placeholder="닉네임">
				        <button type="button" onclick="validateNickname()">중복확인</button>
				    </div>
				    <div class="error-message" id="nicknameStatus"></div>
				</div>
	
	            <div class="form-group">
	                <input type="password" name="userPasswd" id="userPasswd" placeholder="비밀번호 (영문, 숫자, 특수문자 포함 8자리 이상)">
	                <div class="show-password">
		                <input type="checkbox" id="showPw" onclick="togglePassword()">
		                <label for="showPw">비밀번호 보기</label>
		            </div>
	            </div>
	            
	
	            <div class="form-group">
	                <input type="password" name="userPasswd2" id="userPasswd2" placeholder="비밀번호 확인">
	                <div class="show-password">
		                <input type="checkbox" id="showPw2" onclick="togglePassword2()">
		                <label for="showPw">비밀번호 보기</label>
		            </div>
	            </div>
	
	            <button type="submit">회원가입</button>
	
	            <div class="login-link">
	                이미 계정이 있으신가요? <a href="/login">로그인 하기</a>
	            </div>
	        </form>
	    </div>
	</div>
	
	<script src="/JS/RegisterToggle.js"></script>
</body>
</html>