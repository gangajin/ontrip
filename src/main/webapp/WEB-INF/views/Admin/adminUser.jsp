<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>On:trip</title>
	<link rel="icon" href="/Image/header/logo2.png" type="image/png" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="/CSS/header.css">
  	<script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>
<div class="container mt-4">
    <h2>회원 관리</h2>

    <form action="/admin/userList" method="get" class="row mb-3">
        <div class="col-md-3">
            <input type="text" name="keyword" class="form-control" placeholder="닉네임, 이메일, 상태">
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary">검색</button>
        </div>
    </form>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>번호</th>
            <th>ID</th>
            <th>이름</th>
            <th>닉네임</th>
            <th>가입일</th>
            <th>역할</th>
            <th>상태</th>
            <th>변경</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${userList}">
            <tr>
                <td>${user.userNum}</td>
                <td>${user.userId}</td>
                <td>${user.userName}</td>
                <td>${user.userNickname}</td>
                <td>${user.userDate}</td>
                <td>${user.userRole}</td>
                <td>${user.userStatus}</td>
                <td>
                    <a href="/admin/updateStatus?userNum=${user.userNum}&status=잠금" class="btn btn-warning btn-sm">잠금</a>
                    <a href="/admin/updateStatus?userNum=${user.userNum}&status=휴면" class="btn btn-secondary btn-sm">휴면</a>
                    <a href="/admin/deleteUser?userNum=${user.userNum}"class="btn btn-sm btn-danger"onclick="return confirm('강제탈퇴 시키겠습니까?');">강제 탈퇴</a>
                    <a href="/admin/updateStatus?userNum=${user.userNum}&status=정상" class="btn btn-success btn-sm">정상</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- 페이징 영역 -->
<div class="d-flex justify-content-center mt-4">
    <nav>
        <ul class="pagination">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <li class="page-item active">
                            <a class="page-link" href="#">${i}</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link"
                               href="/admin/userList?page=${i}
                               <c:if test='${not empty keyword}'>&keyword=${keyword}</c:if>">${i}</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </ul>
    </nav>
</div>

</body>
</html>
