<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - 작성 중인 스케줄</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h3>📝 작성 중인 여행 일정</h3>
    <table class="table table-hover mt-3">
        <thead>
        <tr>
            <th>일정 번호</th>
            <th>여행 시작</th>
            <th>여행 종료</th>
            <th>작성일</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="schedule" items="${draftList}">
            <tr>
                <td>${schedule.scheduleNum}</td>
                <td>${schedule.scheduleStart}</td>
                <td>${schedule.scheduleEnd}</td>
                <td><fmt:formatDate value="${schedule.scheduleCreated}" pattern="yyyy.MM.dd HH:mm"/></td>
                <td>
                    <a href="/user/continueSchedule?scheduleNum=${schedule.scheduleNum}&userNum=${schedule.userNum}&destinationNum=${schedule.destinationNum}" class="btn btn-primary btn-sm">이어쓰기</a>
                    <form action="/user/deleteSchedule" method="post" style="display:inline;" onsubmit="return confirm('삭제하시겠습니까?');">
                        <input type="hidden" name="scheduleNum" value="${schedule.scheduleNum}">
                        <button class="btn btn-danger btn-sm" type="submit">삭제</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
