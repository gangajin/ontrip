<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI 자동 일정 미리보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container-flex {
            display: flex;
            gap: 30px;
        }

        .left {
            flex: 1;
        }

        .right {
            flex: 1;
            position: sticky;
            top: 20px;
        }

        .day-box {
            background: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .schedule-card {
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
            padding: 15px;
            margin-top: 10px;
        }

        #map {
            width: 100%;
            height: 600px;
            border-radius: 10px;
        }
    </style>

    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4">🗓 AI 자동 생성된 일정 미리보기</h3>

    <div class="container-flex">
        <!-- 왼쪽: 일정 -->
        <div class="left">
            <c:forEach var="entry" items="${groupedDetailMap}" varStatus="dayStatus">
                <div class="day-box">
                    <h4>📅 ${dayStatus.index + 1}일차 (${entry.key})</h4>

                    <c:forEach var="detail" items="${entry.value}" varStatus="placeStatus">
                        <div class="schedule-card">
                            <p><strong>${placeStatus.index + 1}번 장소</strong></p>
                            <p><strong>시간:</strong> <fmt:formatDate value="${detail.scheduleDetailDay}" pattern="yyyy-MM-dd HH:mm" /></p>
                            <p><strong>장소명:</strong> ${detail.place.placeName}</p>
                            <p><strong>주소:</strong> ${detail.place.placeRoadAddr}</p>
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>
        </div>

        <!-- 오른쪽: 지도 -->
        <div class="right">
            <div id="map"></div>
        </div>
    </div>
</div>

<!-- 지도 스크립트 -->
<script>
    var placeList = [
        <c:forEach var="detail" items="${detailList}" varStatus="loop">
            <c:if test="${not empty detail.place.placeLat and not empty detail.place.placeLong}">
            {
                name: "${detail.place.placeName}",
                lat: ${detail.place.placeLat},
                lng: ${detail.place.placeLong}
            }<c:if test="${!loop.last}">,</c:if>
            </c:if>
        </c:forEach>
    ];

    var map;
    kakao.maps.load(function () {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(placeList[0].lat, placeList[0].lng),
            level: 6
        };
        map = new kakao.maps.Map(container, options);

        var bounds = new kakao.maps.LatLngBounds();
        var linePath = [];

        const markerSet = new Set();

        placeList.forEach(function (place, index) {
            const key = place.lat + "," + place.lng;
            if (markerSet.has(key)) return;
            markerSet.add(key);

            const position = new kakao.maps.LatLng(place.lat, place.lng);
            bounds.extend(position);
            linePath.push(position);

            const marker = new kakao.maps.Marker({
                map: map,
                position: position,
                title: (index + 1) + ". " + place.name
            });

            const infoWindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;">${index + 1}. ${place.name}</div>`
            });

            kakao.maps.event.addListener(marker, 'mouseover', function () {
                infoWindow.open(map, marker);
            });
            kakao.maps.event.addListener(marker, 'mouseout', function () {
                infoWindow.close();
            });
        });
        
        var polyline = new kakao.maps.Polyline({
            map: map,
            path: linePath,
            strokeWeight: 4,
            strokeColor: '#FF6F61',
            strokeOpacity: 0.9,
            strokeStyle: 'solid'
        });

        map.setBounds(bounds);
    });
</script>
</body>
</html>