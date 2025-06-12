<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>숙소 선택</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<h2>숙소 선택</h2>

<form action="selectStayHotel" method="get">
  <input type="hidden" name="destinationNum" value="${destinationNum}">
  <input type="text" name="keyword" value="${param.keyword}" placeholder="숙소명을 입력하세요">
  <button type="submit">검색</button>
</form>

<div style="display: flex; width: 100%; gap: 10px; box-sizing: border-box;">
  
  <div style="width: 25%;">
    <table border="1" style="width: 100%; margin-bottom: 20px;">
      <c:forEach var="hotel" items="${hotelList}">
        <tr>
          <td rowspan="3">
            <img src="${pageContext.request.contextPath}${hotel.placeImage}" width="100%" height="150px" />
          </td>
          <td><b>${hotel.placeName}</b></td>
          <td rowspan="3">
            <button type="button"
              onclick="openModal('${hotel.placeNum}', '${hotel.placeName}', '${hotel.placeLat}', '${hotel.placeLong}')">+</button>
          </td>
        </tr>
        <tr><td>${hotel.placeRoadAddr}</td></tr>
        <tr>
          <td><i class="fa-solid fa-heart" style="color: red;"></i> ${hotel.placelike}
              &nbsp;&nbsp;<i class="fa-solid fa-star" style="color: gold;"></i> ${hotel.placeScore}</td>
        </tr>
      </c:forEach>
    </table>
  </div>

  <div style="width: 25%; border: 1px solid #ccc; padding: 10px;">
    <h3>날짜별 숙소 선택 현황</h3>
    <div id="selectedHotelStatus"></div>
  </div>

  <div style="width: 50%;">
    <div id="map"
      data-lat="${destinationLat}"
      data-lng="${destinationLong}"
      data-name="${destinationName}"
      style="width: 100%; height: 400px; border: 1px solid #ccc;">
    </div>
  </div>
</div>

<div id="modal"
  style="display:none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
         border:1px solid #000; padding: 20px; background: white; width: 400px; box-shadow: 0 0 10px rgba(0,0,0,0.3); border-radius: 8px;">
  <h3 id="hotelName" style="font-size: 20px; margin-bottom: 15px;"></h3>
  <input type="hidden" id="selectedPlaceNum">
  <div id="dateSelection" style="margin-bottom: 15px;"></div>
  <div style="text-align: center;">
    <button onclick="addStayHotel()">추가</button>
    <button onclick="closeModal()">닫기</button>
  </div>
</div>

<form id="saveForm" action="saveStayHotel" method="post">
  <input type="hidden" name="scheduleNum" value="${scheduleNum}">
  <button type="button" onclick="submitStayHotel()">저장하기</button>
</form>

<script>
  let travelDates = [
    <c:forEach var="date" items="${travelDates}" varStatus="loop">
      '${date}'<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];

  // 전역변수 선언 (중복 방지)
  let map;
  let hotelMarker;
  let mapReady = false;

  const hotelData = [
	    <c:forEach var="hotel" items="${hotelList}" varStatus="loop">
	      {
	        name: "${hotel.placeName}",
	        lat: ${hotel.placeLat},
	        lng: ${hotel.placeLong}
	      }<c:if test="${!loop.last}">,</c:if>
	    </c:forEach>
	  ];
</script>

<script type="text/javascript"
  src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services">
</script>

<script type="text/javascript" src="/JS/selectPlace.js"></script>

</body>
</html>