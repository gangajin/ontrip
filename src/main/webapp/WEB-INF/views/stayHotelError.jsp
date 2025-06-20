<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>숙소 선택 안내</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .error-card {
      max-width: 500px;
      margin: 100px auto;
      padding: 30px;
      border-radius: 20px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
      background-color: #ffffff;
    }
    .error-emoji {
      font-size: 48px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="error-card text-center">
      <div class="error-emoji mb-3">😕</div>
      <h4 class="mb-3 text-danger">${errorMessage}</h4>
      <p class="mb-4">숙소를 선택하지 않으면 일정을 저장할 수 없어요.</p>
      <a href="/" class="btn btn-outline-primary px-4">메인페이지로 돌아가기</a>
    </div>
  </div>
</body>
</html>