<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<link rel="stylesheet" href="/CSS/login.css">
</head>
<body>
	<div class="login-container">
		<div class="login-box">
			<a href="/">
				<img src="/Image/header/logo.png" alt="로고" style="height: 100px;">
			</a>

	        <form name="login" method="post" action="loginSuccess">
	            <input type="text" name="userId" placeholder="이메일" value="${userIdValue}">
	            <div class="error-message">
	                <c:if test="${not empty userIdError}">
	                    ${userIdError}
	                </c:if>
	            </div>
	
	            <input type="password" name="userPasswd" id="userPasswd" placeholder="비밀번호">
	            <div class="show-password">
	                <input type="checkbox" id="showPw" onclick="togglePassword()">
	                <label for="showPw">비밀번호 보기</label>
	            </div>
	            
	            <div class="error-message">
	                <c:if test="${not empty passwordError}">
	                    ${passwordError}
	                </c:if>
	            </div>
	
	            <div class="forgot-password">
	                <a href="/findPassword">비밀번호를 잊으셨나요?</a>
	            </div>
	
	            <button type="submit">로그인</button>
	
	            <div class="register-link">
	                아직 회원이 아니세요? <a href="/register">회원가입</a>
	            </div>
	        </form>
			
			<div class="divider">
			    <span>or</span>
			</div>
			
			<div>SNS 간편 로그인</div>
			
	        <div class="social-login">
	            <div class="social-icons">
	                <a href="/oauth2/authorization/kakao">
	                    <img src="/Image/OAuth/kakao.png" alt="카카오 로그인">
	                </a>
	                <a href="/oauth2/authorization/naver">
	                    <img src="/Image/OAuth/naver.png" alt="네이버 로그인">
	                </a>
	                <a href="/oauth2/authorization/google">
	                    <img src="/Image/OAuth/google.png" alt="구글 로그인">
	                </a>
	            </div>
	        </div>
	    </div>
	</div>
	
	<script>
		function togglePassword() {
		    const pwInput = document.getElementById("userPasswd");
		    pwInput.type = pwInput.type === "password" ? "text" : "password";
		}
	</script>
</body>
</html>