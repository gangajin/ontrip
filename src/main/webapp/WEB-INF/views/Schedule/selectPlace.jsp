<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장소 선택</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { overflow-x: hidden; background-color: #f8f9fa; }
        .sidebar {
            min-height: 100vh;
            background-color: #ffffff;
            padding-top: 20px;
            border-right: 1px solid #ddd;
        }
        .map-container {
            width: 100%;
            height: 500px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .selected-card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
        }
        .btn-category {
            margin-right: 5px;
            margin-bottom: 5px;
        }
        .btn-category:hover {
            opacity: 0.85;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- 사이드바 -->
        <div class="col-2 sidebar d-flex flex-column align-items-center">
            <h4 class="mb-4 mt-2">On:trip</h4>
            <div class="mb-3">STEP 1<br>날짜 확인</div>
            <div class="mb-3 text-primary fw-bold">STEP 2<br>장소 선택</div>
            <div class="mb-3">STEP 3<br>숙소 선택</div>
            <div class="d-grid mt-4">
                <button class="btn btn-dark" onclick="goToStep3()">다음</button>
            </div>
        </div>

        <!-- 좌측 리스트 -->
        <div class="col-4 p-4">
            <h4 class="mb-2">${destinationName}</h4>
            <p class="text-muted">${scheduleStart} ~ ${scheduleEnd}</p>

            <ul class="nav nav-tabs mb-3">
                <li class="nav-item">
                    <a class="nav-link active" href="#">장소 선택</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/insertArea?destinationNum=${destinationNum}" target="_blank">신규 장소 등록</a>
                </li>
            </ul>

            <!-- 검색창 -->
            <div class="input-group mb-3">
                <input type="text" id="searchKeyword" class="form-control" placeholder="장소명을 입력하세요">
                <button class="btn btn-outline-secondary" type="button" onclick="searchPlace()">검색</button>
            </div>

            <!-- 카테고리 버튼 -->
            <div class="mb-3">
                <button class="btn btn-primary btn-sm btn-category" onclick="filterByCategory('recommend')">추천 장소</button>
                <button class="btn btn-outline-primary btn-sm btn-category" onclick="filterByCategory('attraction')">명소</button>
                <button class="btn btn-outline-primary btn-sm btn-category" onclick="filterByCategory('restaurant')">식당</button>
                <button class="btn btn-outline-primary btn-sm btn-category" onclick="filterByCategory('cafe')">카페</button>
            </div>

            <!-- 추천 장소 리스트 -->
            <!-- 추천 장소 리스트 -->
			<div id="placeList" class="overflow-auto" style="max-height: 500px;">
			    <c:forEach var="place" items="${placeList}" varStatus="status">
			        <div class="card mb-2 shadow-sm">
			            <div class="card-body d-flex justify-content-between align-items-center">
			                <div>
			                    <h6 class="card-title mb-1">${place.placeName}</h6>
			                    <p class="card-text small text-muted mb-0">${place.placeRoadAddr}</p>
			                </div>
			                <button class="btn btn-outline-success btn-sm"
			                        onclick='addToSelectedFromList(${status.index})'>+</button>
			            </div>
			        </div>
			    </c:forEach>
			</div>
        </div>

        <!-- 우측 선택 리스트 + 지도 -->
        <div class="col-6 p-4">
            <h5 class="mb-3">선택한 장소</h5>
            <div id="selectedList" class="mb-4"></div>
            <div id="map" class="map-container"></div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Kakao Map API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439"></script>
<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    window.currentPlaceList = [
        <c:forEach var="place" items="${placeList}" varStatus="status">
            {
                placeNum: ${place.placeNum},
                placeName: "${place.placeName}",
                placeRoadAddr: "${place.placeRoadAddr}",
                placeLat: ${place.placeLat},
                placeLong: ${place.placeLong}
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    var selectedPlaceList = [];
    var map;
    var markers = [];

    window.onload = function() {
        initMap();
    };

    function initMap() {
        var mapContainer = document.getElementById('map');
        var mapOption = {
            center: new kakao.maps.LatLng(35.1796, 129.0756),
            level: 5
        };
        map = new kakao.maps.Map(mapContainer, mapOption);
    }

    function addToSelectedFromList(index) {
        var place = window.currentPlaceList[index];
        if (selectedPlaceList.some(p => p.placeNum === place.placeNum)) {
            alert("이미 선택한 장소입니다!");
            return;
        }
        selectedPlaceList.push(place);
        renderSelectedList();
        addMarker(place);
    }

    function renderSelectedList() {
        var selectedContainer = document.getElementById('selectedList');
        selectedContainer.innerHTML = '';
        selectedPlaceList.forEach(function(place, index) {
            var item = document.createElement('div');
            item.className = 'selected-card d-flex justify-content-between align-items-center';
            item.innerHTML = `
                <div><strong>${index + 1}. ${place.placeName}</strong></div>
                <button class="btn btn-sm btn-outline-danger" onclick='removeSelected(${index})'>삭제</button>
            `;
            selectedContainer.appendChild(item);
        });
    }

    function removeSelected(index) {
        var place = selectedPlaceList[index];
        selectedPlaceList.splice(index, 1);
        renderSelectedList();
        removeMarker(place);
    }

    function addMarker(place) {
        var markerPosition = new kakao.maps.LatLng(place.placeLat, place.placeLong);
        var marker = new kakao.maps.Marker({
            position: markerPosition,
            map: map
        });
        markers.push({ place: place, marker: marker });
    }

    function removeMarker(place) {
        for (var i = 0; i < markers.length; i++) {
            if (markers[i].place.placeNum === place.placeNum) {
                markers[i].marker.setMap(null);
                markers.splice(i, 1);
                break;
            }
        }
    }
    
    function goToStep3() {
        const destinationNum = "${destinationNum}";

        $.post("/saveScheduleToSession", {
            scheduleStart: "${scheduleStart}",
            scheduleEnd: "${scheduleEnd}"
        }, function() {
            location.href = `/selectStayHotel?destinationNum=${destinationNum}`;
        });
    }
</script>
</body>
</html>
