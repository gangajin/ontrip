<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
<link rel="stylesheet" href="/CSS/Main-destination.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
</head>
<body>
	<%@ include file="header.jsp" %>

	<form id="calendarForm" action="/step1" method="get">
	  <input type="hidden" name="destinationNum" id="destinationNum">
	  <input type="hidden" name="destinationName" id="destinationName">
	  <input type="hidden" name="scheduleStart" id="scheduleStart">
	  <input type="hidden" name="scheduleEnd" id="scheduleEnd">
	</form>
	
	<input type="text" id="datePicker" style="opacity:0; pointer-events:none; position:absolute;" />
	
	<h2>국내 어디로 여행을 떠나시나요?</h2>
	<form action="/" method="get" style="text-align:center; margin-top:20px;">
		<input type="text" name="keyword" placeholder="지역명 검색" style="width:200px; height:30px; font-size:16px;">
		<button type="submit" style="height:34px; font-size:16px;">검색</button>
	</form>
	<div class="destination-container">
	  <c:forEach var="destination" items="${destinationList}">
	    <div class="destination-card" onclick="openCalendarWithForm(${destination.destinationNum}, '${destination.nameKo}')">
	      <img src="${destination.destinationImage}" alt="${destination.nameKo}" class="destination-img">
	      <div class="destination-name-en">${destination.nameEn}</div>
	      <div class="destination-name-ko">${destination.nameKo}</div>
	    </div>
	  </c:forEach>
	</div>


	<script src="/JS/Main-selectDate.js"></script>	
</body>
</html>