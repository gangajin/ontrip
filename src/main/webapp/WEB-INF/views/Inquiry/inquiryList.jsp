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
    .write-button {
	    padding: 8px 14px;
	    background-color: #007bff;
	    color: white;
	    border-radius: 6px;
	    font-size: 14px;
	    text-decoration: none;
	}

	.write-button:hover {
   	 background-color: #0056b3;
	}
</style>
</head>
<body>
<c:if test="${sessionScope.loginUser.userRole ne 'admin'}">
<div class="inquiry-list-container">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <h2>나의 문의 내역</h2>
        <a href="/inquiryWrite" class="write-button">문의 작성하기</a>
    </div>

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
                    <td>${inquiry.inquiryTime.toString().substring(0,10)} ${inquiry.inquiryTime.toString().substring(11,16)}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</c:if>
</body>
</html>