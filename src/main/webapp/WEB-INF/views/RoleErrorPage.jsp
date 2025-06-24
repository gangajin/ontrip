<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>권한 없음</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Bootstrap Icons (선택사항) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/CSS/RoleErrorPage.css"/>
</head>
<body>
<div class="container d-flex justify-content-center align-items-center vh-100">
    <div class="error-box text-center">
        <div class="error-icon mb-3">
            <i class="bi bi-shield-exclamation"></i>
        </div>
        <h1 class="text-danger fw-bold mb-3">403 Forbidden</h1>
        <p class="lead mb-4">⚠️ 이 페이지에 접근할 권한이 없습니다.</p>
        <a href="/user/myPage" class="btn btn-danger me-2">마이페이지로 이동</a>
        <a href="/login" class="btn btn-outline-danger">로그인 페이지로 이동</a>
    </div>
</div>
</body>
</html>