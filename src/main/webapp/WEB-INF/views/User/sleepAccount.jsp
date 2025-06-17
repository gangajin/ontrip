<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>휴면 계정 안내</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="alert alert-warning">
        ${loginMessage}
    </div>
    <p>비밀번호를 변경하면 계정이 다시 활성화됩니다.</p>
    <a href="/findPassword" class="btn btn-primary">비밀번호 변경하기</a>
</div>
</body>
</html>