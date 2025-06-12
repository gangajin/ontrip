<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<style>
    
    .inquiry-form-container {
        width: 500px; 
        margin: 20px auto;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 8px;
        box-shadow: 2px 2px 5px #eee;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .form-group label {
        display: block; 
        margin-bottom: 5px;
        font-weight: bold;
    }
    .form-group textarea {
        width: calc(100% - 22px); 
        height: 150px; 
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        resize: vertical; 
        font-size: 1em;
    }
    .form-actions {
        text-align: right; 
    }
    .form-actions button {
        padding: 10px 20px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 1em;
    }
    .form-actions button:hover {
        background-color: #0056b3;
    }
    .error-message {
        color: red;
        margin-bottom: 15px;
    }
</style>
</head>
<body>

    <div class="inquiry-form-container">
        <h2>새 문의 작성</h2>

    
        <c:if test="${not empty errorMessage}">
            <p class="error-message">${errorMessage}</p>
        </c:if>

  
        <form action="/inquiryinsert" method="post">
            <div class="form-group">
                <label for="content">문의 내용</label>
                <textarea id="content" name="content" placeholder="문의 내용을 입력해주세요." required></textarea>
            </div>

            <div class="form-actions">
                <button type="submit">문의 제출</button>
            </div>
        </form>
    </div>

</body>
</html>