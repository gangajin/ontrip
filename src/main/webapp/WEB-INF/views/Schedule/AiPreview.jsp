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
            flex-direction: column;
            gap: 40px;
        }

        .timeline {
            border-left: 2px dotted #ccc;
            padding-left: 20px;
        }

        .timeline-item {
            position: relative;
        }

        .timeline-icon {
            position: absolute;
            left: -40px;
            top: 5px;
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
        <!-- 일정 영역 -->
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <c:forEach var="entry" items="${groupedDetailMap}" varStatus="dayStatus">
                <div class="col">
                    <div class="border rounded p-3 h-100 bg-light">
                        <!-- 일차 헤더 -->
                        <h5 class="mb-3 text-center">📅 ${dayStatus.index + 1}일차<br>(${entry.key})</h5>

                        <!-- 타임라인 시작 -->
                        <div class="timeline position-relative ms-4">
                            <c:forEach var="detail" items="${entry.value}" varStatus="placeStatus">
                                <div class="timeline-item d-flex mb-4">
                                    <!-- 순서 원형 번호 + 색상 -->
                                    <div class="timeline-icon me-3">
                                        <span class="badge rounded-circle text-white fs-6 px-3 py-2
                                            <c:choose>
                                                <c:when test="${dayStatus.index == 0}"> bg-danger</c:when>
                                                <c:when test="${dayStatus.index == 1}"> bg-primary</c:when>
                                                <c:when test="${dayStatus.index == 2}"> bg-success</c:when>
                                                <c:when test="${dayStatus.index == 3}"> bg-warning text-dark</c:when>
                                                <c:otherwise> bg-secondary</c:otherwise>
                                            </c:choose>">
                                            ${placeStatus.index + 1}
                                        </span>
                                    </div>

                                    <!-- 카드 정보 -->
                                    <div class="timeline-content card flex-fill shadow-sm border-0">
                                        <div class="card-body">
                                            <h6 class="card-title mb-1">${detail.place.placeName}</h6>
                                            <p class="mb-1"><strong>시간:</strong>
                                                <fmt:formatDate value="${detail.scheduleDetailDay}" pattern="yyyy-MM-dd HH:mm" />
                                            </p>
                                            <p class="mb-1"><strong>주소:</strong> ${detail.place.placeRoadAddr}</p>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${detail.place.placeCategory == 'attraction'}">
                                                        <span class="badge bg-primary">명소</span>
                                                    </c:when>
                                                    <c:when test="${detail.place.placeCategory == 'cafe'}">
                                                        <span class="badge bg-warning text-dark">카페</span>
                                                    </c:when>
                                                    <c:when test="${detail.place.placeCategory == 'food'}">
                                                        <span class="badge bg-danger">식당</span>
                                                    </c:when>
                                                    <c:when test="${detail.place.placeCategory == 'hotel'}">
                                                        <span class="badge bg-success">호텔</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">기타</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 지도 영역 -->
        <div class="mt-5">
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
        if (!placeList.length) return;

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
