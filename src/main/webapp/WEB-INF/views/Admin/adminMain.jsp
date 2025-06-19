<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 메인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 부트스트랩 아이콘 CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .admin-card {
            border-radius: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease-in-out;
        }
        .admin-card:hover {
            transform: scale(1.03);
        }
        .bi {
            font-size: 2rem;
            margin-bottom: 10px;
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-5">
    <h2 class="text-center mb-5">관리자 페이지</h2>
    <div class="row g-4 justify-content-center">

        <!-- 1: 문의 관리 -->
        <div class="col-md-3">
            <div class="card text-center admin-card p-4">
                <i class="bi bi-chat-dots-fill"></i>
                <h5 class="card-title">문의 관리</h5>
                <a href="admininquiry" class="btn btn-outline-primary mt-3">바로가기</a>
            </div>
        </div>

        <!-- 2: 지역 등록 -->
        <div class="col-md-3">
            <div class="card text-center admin-card p-4">
                <i class="bi bi-geo-alt-fill"></i>
                <h5 class="card-title">지역 등록</h5>
                <button onclick="alertAndRedirect()" class="btn btn-outline-info mt-3">바로가기</button>
            </div>
        </div>

        <!-- 3: 장소 등록 -->
        <div class="col-md-3">
            <div class="card text-center admin-card p-4">
                <i class="bi bi-map-fill"></i>
                <h5 class="card-title">장소 등록</h5>
                <a href="insertplaceform" class="btn btn-outline-warning mt-3">바로가기</a>
            </div>
        </div>

        <!-- 4: 장소 목록 -->
        <div class="col-md-3">
            <div class="card text-center admin-card p-4">
                <i class="bi bi-list-ul"></i>
                <h5 class="card-title">장소 목록</h5>
                <a href="/admin/place/list" class="btn btn-outline-info mt-3">바로가기</a>
            </div>
        </div>

        <!-- 5: 회원 관리 -->
        <div class="col-md-3">
            <div class="card text-center admin-card p-4">
                <i class="bi bi-people-fill"></i>
                <h5 class="card-title">회원 관리</h5>
                <a href="admin/userList" class="btn btn-outline-danger mt-3">바로가기</a>
            </div>
        </div>

    </div>
</div>
</body>
<script>
	function alertAndRedirect() {
	    alert('메인페이지에서 STEP1부터 진행해 주세요.');
	    window.location.href = '/';
	}
</script>
</html>