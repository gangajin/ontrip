<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI 자동 일정 미리보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .schedule-card {
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        #map {
            width: 100%;
            height: 500px;
            border-radius: 8px;
            margin-top: 30px;
        }
    </style>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4">🗓 AI 자동 생성된 일정 미리보기</h3>

    <c:forEach var="detail" items="${detailList}" varStatus="status">
        <div class="card schedule-card p-3">
            <h5><strong>${status.index + 1}번 장소</strong></h5>
            <p><strong>방문 시간:</strong> 
                <fmt:formatDate value="${detail.scheduleDetailDay}" pattern="yyyy-MM-dd HH:mm" />
            </p>
            <p><strong>장소명:</strong> ${detail.place.placeName}</p>
            <p><strong>주소:</strong> ${detail.place.placeRoadAddr}</p>
            <p><strong>설명:</strong> ${detail.scheduleDetailMemo}</p>
        </div>
    </c:forEach>

    <!-- Kakao Map -->
    <div id="map"></div>
</div>

<script>
    // ✅ 장소 목록을 자바스크립트 객체로 변환
    var placeList = [
        <c:forEach var="detail" items="${detailList}" varStatus="loop">
            {
                name: "${detail.place.placeName}",
                lat: ${detail.place.placeLat},
                lng: ${detail.place.placeLong}
            }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    var map;
    kakao.maps.load(function () {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(placeList[0].lat, placeList[0].lng),
            level: 5
        };
        map = new kakao.maps.Map(container, options);

        // ✅ 마커 표시
        placeList.forEach(function (place, index) {
            var marker = new kakao.maps.Marker({
                map: map,
                position: new kakao.maps.LatLng(place.lat, place.lng)
            });

            var infoWindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;">${index + 1}. ${place.name}</div>`
            });

            kakao.maps.event.addListener(marker, 'mouseover', function () {
                infoWindow.open(map, marker);
            });
            kakao.maps.event.addListener(marker, 'mouseout', function () {
                infoWindow.close();
            });
        });
    });
</script>
</body>
</html>
