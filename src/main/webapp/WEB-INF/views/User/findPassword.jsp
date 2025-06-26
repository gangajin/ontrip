<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>On:trip</title>
<link rel="icon" href="/Image/header/logo2.png" type="image/png" />
<link rel="stylesheet" href="/CSS/findPassword.css">
</head>
<body>
	<div class="find-container">
	    <div class="find-box">
	    	<a href="/">
				<img src="/Image/header/logo.png" alt="로고" style="height: 100px;">
			</a>
			
	        <h5>가입 시 등록한 이메일 주소로 비밀번호 변경 링크 보내드립니다.</h5>

	        <form name="findPassword" method="post" action="/findPasswordProcess" onsubmit="return emailCheck()">
	            <label>이메일</label>
	            <input type="text" name="userId" id="userId" placeholder="이메일 주소 입력">
	            <button type="submit">인증 메일 보내기</button>
	        </form>

	        <a href="/login">로그인 화면가기</a>
	    </div>
	</div>
	
	<script src="${pageContext.request.contextPath}/JS/findPw-emailSubmit.js"></script>
</body>
</html>