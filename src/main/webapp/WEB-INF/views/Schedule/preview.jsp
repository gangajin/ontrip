<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>일정 미리보기</title>
  <link rel="stylesheet" href="/CSS/preview.css">
</head>
<body>

<div class="container">
  <!-- 왼쪽 일정 요약 -->
  <div class="sidebar">
    <h2>나의 여행 일정</h2>
    <p>${schedule.scheduleStart} ~ ${schedule.scheduleEnd}</p>

    <div class="section-title">선택한 장소</div>
    <div class="card-list">
      <c:forEach var="place" items="${placeList}">
        <div class="card">
          <img src="${place.placeImage}" alt="${place.placeName}">
          <div>${place.placeName}</div>
        </div>
      </c:forEach>
    </div>

    <div class="section-title">설정한 숙소</div>
    <div class="card-list">
      <c:forEach var="stay" items="${stayList}" varStatus="vs">
        <div class="card">
          <img src="${stay.placeImage}" alt="${stay.placeName}">
          <div>DAY ${vs.index + 1}</div>
          <div>${stay.placeName}</div>
        </div>
      </c:forEach>
    </div>

    <button type="button" class="ai-button" onclick="openTransportModal()">🤖 AI 일정 생성하기</button>
  </div>

  <!-- 오른쪽 지도 -->
  <div class="map-container">
    <div id="map" style="width: 100%; height: 100%;"></div>
  </div>
</div>

<!-- 모달 창 -->
<div id="transportModal" style="display:none;" class="modal-backdrop">
  <div class="modal-box">
    <h3 style="margin-bottom: 8px;">이동수단 선택</h3>
    <p style="color: #888; font-size: 14px; margin-bottom: 20px;">
      여행 시 이용하실 이동수단을 선택해주세요.
    </p>

    <div class="button-group">
      <div class="transport-card selected" onclick="selectTransport('대중교통', this)">
        <div class="icon">🚍</div>
        <div class="label">대중교통</div>
      </div>
      <div class="transport-card" onclick="selectTransport('승용차', this)">
        <div class="icon">🚗</div>
        <div class="label">승용차</div>
      </div>
    </div>

    <form id="transportForm" action="/generateAiSchedule" method="post">
      <input type="hidden" name="scheduleNum" value="${schedule.scheduleNum}" />
      <input type="hidden" name="transportType" id="transportType" value="대중교통" />
      <div class="modal-footer">
        <button type="button" class="close-btn" onclick="closeTransportModal()">닫기</button>
        <button type="submit" class="submit-btn">일정생성</button>
      </div>
    </form>
  </div>
</div>

<!-- 지도 로딩 -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
<script>
  const placeList = [
    <c:forEach var="place" items="${placeList}" varStatus="vs">
      {
        name: "${place.placeName}",
        lat: ${place.placeLat},
        lng: ${place.placeLong},
        order: ${vs.index + 1}
      }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
  ];

  const stayList = [
    <c:forEach var="stay" items="${stayList}" varStatus="vs">
      {
        name: "${stay.placeName}",
        lat: ${stay.placeLat},
        lng: ${stay.placeLong}
      }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
  ];
</script>

<script src="/JS/preview.js"></script>
</body>
</html>