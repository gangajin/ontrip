<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
</head>
<body>
   <h2>로그인</h2>
   <form name="login" method="post" action="loginSuccess">
       이메일<br>
       <input type="text" name="userId" value="${userIdValue}">
       <div id="emailStatus" style="color:red; font-size: 0.9em;">
           <c:if test="${not empty userIdError}">
               ${userIdError}
           </c:if>
       </div>
   
       비밀번호<br>
       <input type="password" name="userPasswd">
       <div id="passwordStatus" style="color:red; font-size: 0.9em;">
           <c:if test="${not empty passwordError}">
               ${passwordError}
           </c:if>
       </div>
       <a href="/findPassword">비밀번호를 잊으셨나요?</a><p>
   
       <input type="submit" value="로그인"><br>
       아직 회원이 아니세요? <a href="/register">회원가입</a>
   </form>
   
	<div style="display: flex; gap: 20px; margin-top: 20px;">
	    <a href="/oauth2/authorization/kakao">
	        <img src="/Image/OAuth/kakao.png" alt="카카오 로그인" width="60" height="60" style="border-radius: 15px;">
	    </a>
	    <a href="/oauth2/authorization/naver">
	        <img src="/Image/OAuth/naver.png" alt="네이버 로그인" width="60" height="60" style="border-radius: 15px;">
	    </a>
	    <a href="/oauth2/authorization/google">
	        <img src="/Image/OAuth/google.png" alt="구글 로그인" width="60" height="60" style="border-radius: 15px;">
	    </a>
	</div>

</body>
</html>