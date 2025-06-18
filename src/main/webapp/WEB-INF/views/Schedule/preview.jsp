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

    <form action="/generateAiSchedule" method="post">
      <input type="hidden" name="planId" value="${schedule.scheduleNum}" />
      <button type="submit" class="ai-button">🤖 AI 일정 생성하기</button>
    </form>
  </div>

  <!-- 오른쪽 지도 -->
  <div class="map-container">
    <div id="map" style="width: 100%; height: 100%;"></div>
  </div>

</div>


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
</script>
<script>
  kakao.maps.load(() => {
    const mapContainer = document.getElementById('map');
    const mapOption = {
      center: new kakao.maps.LatLng(placeList[0].lat, placeList[0].lng),
      level: 9
    };
    const map = new kakao.maps.Map(mapContainer, mapOption);

    // 📍 장소 마커
    placeList.forEach(place => {
      const pos = new kakao.maps.LatLng(place.lat, place.lng);

      new kakao.maps.Marker({
        map: map,
        position: pos,
        title: place.name
      });

      new kakao.maps.CustomOverlay({
        map: map,
        position: pos,
        content: `<div style="background:#4faeff;color:white;padding:4px 8px;border-radius:16px;font-size:12px;">${place.order}</div>`,
        yAnchor: 1
      });
    });

    // 🏨 숙소 마커
    const hotelImg = new kakao.maps.MarkerImage(
      "/image/marker_hotel_selected.png",
      new kakao.maps.Size(40, 42),
      { offset: new kakao.maps.Point(20, 42) }
    );

    stayList.forEach(hotel => {
      const pos = new kakao.maps.LatLng(hotel.lat, hotel.lng);

      new kakao.maps.Marker({
        map: map,
        position: pos,
        title: "[숙소] " + hotel.name,
        image: hotelImg
      });
    });
  });
</script>
</body>
</html>