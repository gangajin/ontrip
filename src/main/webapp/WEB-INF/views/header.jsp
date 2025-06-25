<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="header">
  <div class="header-content">
    <a href="/">
      <img src="/Image/header/logo.png" alt="로고" style="height: 60px;">
    </a>
  </div>

  <div class="header-right">
    <c:choose>
      <c:when test="${not empty sessionScope.loginUser}">
        <div class="user-menu-container" style="display: flex; align-items: center; gap: 10px;">
          <div class="welcome-message">
            ${sessionScope.loginUser.userNickname}님 환영합니다
          </div>
          <div class="user-icon" onclick="toggleUserMenu()">
            <img src="/Image/header/icon.png" alt="유저 아이콘" />
          </div>
          <div id="userDropdown" class="user-dropdown">
            <a href="/user/myPage">마이페이지</a>
            <c:if test="${sessionScope.loginUser.userRole eq 'admin'}">
              <a href="/adminMain">관리자 페이지</a>
            </c:if>
            <c:if test="${sessionScope.loginUser.userRole ne 'admin'}">
              <a href="/inquiryList">1:1 문의</a>
            </c:if>
            <a href="/logout">로그아웃</a>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <a href="/login" class="login-button">로그인</a>
      </c:otherwise>
    </c:choose>
  </div>
</div>
