<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>나의 문의 내역</title>
<style>
    .inquiry-list-container {
        width: 700px;
        margin: 30px auto;
    }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        border-bottom: 1px solid #ddd;
        padding: 12px;
        text-align: left;
    }
    th {
        background-color: #f4f4f4;
    }
    a {
        text-decoration: none;
        color: #007bff;
    }
    a:hover {
        text-decoration: underline;
    }
    .status {
        font-weight: bold;
    }
</style>
</head>
<body>
<div class="inquiry-list-container">
    <h2>나의 문의 내역</h2>
    <table>
        <thead>
            <tr>
                <th>제목</th>
                <th>상태</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="inquiry" items="${inquiryList}">
                <tr>
                    <td>
                        <a href="/inquiryDetail?inquiryNum=${inquiry.inquiryNum}">
                            ${inquiry.inquiryTitle}
                        </a>
                    </td>
                    <td class="status">${inquiry.inquiryStatus}</td>
                    <td>${inquiry.inquiryTime}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>