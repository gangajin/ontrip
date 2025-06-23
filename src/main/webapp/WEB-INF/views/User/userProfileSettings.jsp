<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로필 설정</title>
<link rel="stylesheet" href="/CSS/profileSettings.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
	<%@ include file="../header.jsp" %>

	<!-- 프로필 정보 영역 -->
	<div class="profile-info">
	    <div class="profile-avatar d-inline-flex justify-content-center align-items-center">
	        <i class="bi bi-person-fill"></i>
	    </div>
<%-- 	    <div>${sessionScope.loginUser.userNickname}님</div> --%>
	</div>
	
	<div>
		<h3>프로필 설정</h3>
		<form name="changeNickname" method="post" action="/user/changeNickname">
			닉네임<br>
			<input type="text" name="userNickname" value="${user.userNickname}"><p>
			이메일<br>
			<input type="text" name="userId" value="${user.userId}" readonly><p>
			
			<!-- <input type="button" value="회원탈퇴"><p>-->
			<div class="button-group">
				<input type="button" value="돌아가기" onclick="history.back()">
				<input type="submit" value="저장">
			</div>
		</form>
	</div>
	
	<c:if test="${param.success eq 'nickname'}">
	    <script>
	        alert("닉네임이 변경되었습니다.");
	    </script>
	</c:if>
	
	<c:if test="${param.error eq 'nickname'}">
	    <script>
	        alert("이미 존재하는 닉네임입니다.");
	    </script>
	</c:if>
	
</body>
</html>