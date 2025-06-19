<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>일정 미리보기</title>
<style>
  body {
    font-family: sans-serif;
    margin: 0;
    padding: 0;
  }

  .container {
    display: flex;
    height: 100vh;
  }

  .sidebar {
    width: 400px;
    padding: 20px;
    border-right: 1px solid #ddd;
    overflow-y: auto;
  }

  .map-container {
    flex-grow: 1;
    height: 100%;
  }

  .section-title {
    font-size: 18px;
    margin-top: 30px;
    margin-bottom: 10px;
    font-weight: bold;
  }

  .card-list {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
  }

  .card {
    text-align: center;
    width: 100px;
  }

  .card img {
    width: 100%;
    height: 70px;
    object-fit: cover;
    border-radius: 8px;
  }

  .ai-button {
    margin-top: 20px;
    width: 100%;
    padding: 10px;
    background-color: #4faeff;
    border: none;
    border-radius: 8px;
    color: white;
    font-size: 16px;
    cursor: pointer;
  }

  .ai-button:hover {
    background-color: #3c94d6;
  }

  .modal-backdrop {
    position: fixed;
    top: 0; left: 0;
    width: 100vw; height: 100vh;
    background: rgba(0, 0, 0, 0.5);
    display: flex; justify-content: center; align-items: center;
    z-index: 1000;
  }

  .modal-box {
    background: #fff;
    padding: 30px 25px;
    border-radius: 16px;
    width: 380px;
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
    text-align: center;
  }

  .button-group {
    display: flex;
    justify-content: center;
    gap: 16px;
  }

  .transport-card {
    width: 130px;
    height: 130px;
    border-radius: 12px;
    border: 1px solid #ccc;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    transition: 0.2s;
    background-color: #f9f9f9;
  }

  .transport-card .icon {
    font-size: 32px;
    margin-bottom: 10px;
  }

  .transport-card .label {
    font-size: 15px;
  }

  .transport-card.selected {
    background-color: black;
    color: white;
    border-color: black;
  }

  .modal-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20px;
  }

  .submit-btn {
    padding: 10px 16px;
    background-color: #4faeff;
    color: white;
    font-size: 15px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
  }

  .submit-btn:hover {
    background-color: #3c94d6;
  }

  .close-btn {
    font-size: 14px;
    background: none;
    border: none;
    color: #777;
    cursor: pointer;
  }

  .close-btn:hover {
    text-decoration: underline;
  }
</style>
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
      <c:forEach var="entry" items="${stayMap}" varStatus="vs">
        <div class="card">
          <img src="${entry.value.placeImage}" alt="${entry.value.placeName}">
          <div>DAY ${vs.index + 1}</div>
          <div>${entry.value.placeName}</div>
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
    <c:forEach var="entry" items="${stayMap}" varStatus="vs">
      {
        name: "${entry.value.placeName}",
        lat: ${entry.value.placeLat},
        lng: ${entry.value.placeLong}
      }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
  ];

  kakao.maps.load(() => {
    const map = new kakao.maps.Map(document.getElementById('map'), {
      center: new kakao.maps.LatLng(placeList[0].lat, placeList[0].lng),
      level: 9
    });

    placeList.forEach(place => {
      const pos = new kakao.maps.LatLng(place.lat, place.lng);
      new kakao.maps.Marker({ map, position: pos, title: place.name });
      new kakao.maps.CustomOverlay({
        map, position: pos,
        content: `<div style="background:#4faeff;color:white;padding:4px 8px;border-radius:16px;font-size:12px;">${place.order}</div>`,
        yAnchor: 1
      });
    });

    const hotelImg = new kakao.maps.MarkerImage("/image/marker_hotel_selected.png", new kakao.maps.Size(40, 42), { offset: new kakao.maps.Point(20, 42) });
    stayList.forEach(hotel => {
      const pos = new kakao.maps.LatLng(hotel.lat, hotel.lng);
      new kakao.maps.Marker({ map, position: pos, title: "[숙소] " + hotel.name, image: hotelImg });
    });
  });
</script>

<!-- 모달 동작 -->
<script>
  function openTransportModal() {
    document.getElementById("transportModal").style.display = "flex";
  }

  function closeTransportModal() {
    document.getElementById("transportModal").style.display = "none";
  }

  function selectTransport(type, element) {
    document.getElementById("transportType").value = type;
    document.querySelectorAll(".transport-card").forEach(card => card.classList.remove("selected"));
    element.classList.add("selected");
  }
</script>

</body>
</html>