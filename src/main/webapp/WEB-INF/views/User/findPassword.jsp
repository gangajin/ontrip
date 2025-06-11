<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>비밀번호 찾기</h2>
	<p>가입 시 등록한 이메일 주소로 비밀번호 변경 링크 보내드립니다. </p>
	
	<form name="findPassword" method="post" action="/findPasswordProcess">
		이메일
		<input type="text" name="userId" placeholder="이메일 주소 입력"><br><br>
        <input type="submit" value="인증 메일 보내기">
	</form>
	<p><a href="/login">로그인 화면가기</a></p>
</body>
</html>