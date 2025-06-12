<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>회원 문의 관리</title>
    <style>
        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #f3f3f3;
        }
    </style>
</head>
<body>
    <h2 style="text-align:center;">회원 문의 관리</h2>
    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>상태</th>
                <th>작성일</th>
                <th>상세보기</th>
                <th>상태 수정</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="inquiry" items="${inquiryList}">
                <tr>
                    <td>${inquiry.inquiryNum}</td>
                    <td>${inquiry.inquiryTitle}</td>
                    <td>${inquiry.userNickname}</td>
                    <td>
                        <c:choose>
                            <c:when test="${inquiry.inquiryStatus == '완료'}">
                                <span style="color: green; font-weight: bold;">${inquiry.inquiryStatus}</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: red;">${inquiry.inquiryStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                   <td>${fn:substring(inquiry.inquiryTime, 0, 16)}</td>
                    <td>
                        <a href="/inquiryDetail?inquiryNum=${inquiry.inquiryNum}">보기</a>
                    </td>
                    <td>
                        <form action="/inquiryStatusUpdate" method="get">
                            <input type="hidden" name="inquiryNum" value="${inquiry.inquiryNum}" />
                            <select name="inquiryStatus">
                                <option value="대기" ${inquiry.inquiryStatus == '대기' ? 'selected' : ''}>대기</option>
                                <option value="완료" ${inquiry.inquiryStatus == '완료' ? 'selected' : ''}>완료</option>
                            </select>
                            <button type="submit">변경</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>