<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>잠금 계정 안내</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-danger">
        ${loginMessage}
    </div>
    <p>계정이 잠금 상태입니다. 관리자에게 문의해주세요.</p>
    <a href="/publicInquiryWrite" class="btn btn-outline-primary">관리자에게 문의하기</a>
    <a href="/login" class="btn btn-secondary">로그인 페이지로 돌아가기</a>
</div>
</body>
</html>