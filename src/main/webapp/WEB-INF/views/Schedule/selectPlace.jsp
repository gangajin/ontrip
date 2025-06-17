<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장소 선택</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
            <h4 class="mb-4 mt-2"><a href="/">
	    		<img src="/Image/header/logo.png" alt="로고" style="height: 60px;"></a>
	    	</h4>
            <div class="mb-3">STEP 1<br>날짜 확인</div>
            <div class="mb-3 text-primary fw-bold">STEP 2<br>장소 선택</div>
            <div class="mb-3">STEP 3<br>숙소 선택</div>
            <div class="d-grid mt-4">
                <button class="btn btn-dark" onclick="goToStep3()">다음</button>
            </div>
        </div>

        <!-- 본문 3등분 레이아웃 -->
        <div class="col-10">
            <div class="row">
                <!-- 좌측: 검색/카테고리/추천 리스트 -->
                <div class="col-4 p-4 border-end">
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

                    <!-- 검색 form -->
                    <form id="searchForm" action="/step2" method="get" class="input-group mb-3">
                        <input type="hidden" name="destinationNum" value="${destinationNum}">
                        <input type="hidden" name="destinationName" value="${destinationName}">
                        <input type="hidden" name="scheduleStart" value="${scheduleStart}">
                        <input type="hidden" name="scheduleEnd" value="${scheduleEnd}">
                        <input type="hidden" name="destinationLat" value="${destinationLat}">
    					<input type="hidden" name="destinationLong" value="${destinationLong}">
                        <input type="hidden" id="categoryInput" name="category" value="${category}">
                        
                        <input type="text" name="keyword" class="form-control" placeholder="장소명을 입력하세요" value="${keyword}">
                        <button class="btn btn-outline-secondary" type="submit">검색</button>
                    </form>

                    <!-- 카테고리 버튼 -->
                    <div class="mb-3">
                        <button class="btn btn-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('recommend')">추천 장소</button>
                        <button class="btn btn-outline-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('attraction')">명소</button>
                        <button class="btn btn-outline-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('restaurant')">식당</button>
                        <button class="btn btn-outline-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('cafe')">카페</button>
                    </div>

                    <!-- 추천 장소 리스트 -->
                    <div id="placeList" class="overflow-auto" style="max-height: 500px;">
					    <c:forEach var="place" items="${placeList}" varStatus="status">
					        <div class="card mb-2 shadow-sm">
					            <div class="card-body d-flex justify-content-between align-items-center">
					                <div class="d-flex">
					                    <!-- 장소 이미지 -->
					                    <img src="${pageContext.request.contextPath}${place.placeImage}" 
					                         alt="이미지" 
					                         width="80" height="80" class="me-3 rounded">
					
					                    <!-- 장소 정보 -->
					                    <div>
					                        <h6 class="card-title mb-1">${place.placeName}</h6>
					                        <p class="card-text small text-muted mb-1">${place.placeRoadAddr}</p>
					                        <p class="mb-0">
					                            <i class="fa-solid fa-heart" style="color: red;"></i> ${place.placelike}
					                            &nbsp;&nbsp;
					                            <i class="fa-solid fa-star" style="color: gold;"></i> ${place.placeScore}
					                        </p>
					                    </div>
					                </div>
					
					                <!-- 추가 버튼 -->
					                <button type="button" class="btn btn-outline-success btn-sm" onclick="addSelectedPlace(${place.placeNum})">+</button>
					            </div>
					        </div>
					    </c:forEach>
					</div>
                </div>

                <!-- 중앙: 장바구니 리스트 -->
                <div class="col-4 p-4 border-end">
                    <h5 class="mb-3">선택한 장소</h5>
                    <div id="selectedList">
                        <c:forEach var="place" items="${selectedPlaceDtoList}" varStatus="status">
                            <div class="selected-card d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>${status.index + 1}. ${place.placeName}</strong>
                                    <div class="small text-muted">${place.placeRoadAddr}</div>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeSelectedPlace(${place.placeNum})">삭제</button>
                            </div>
                        </c:forEach>
                    </div>
                </div>             

                <!-- 우측: 지도 -->
                <div class="col-4 p-4">
                    <h5 class="mb-3">지도</h5>
                    <div id="map" class="map-container"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Kakao Map API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
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
	
	var map;
	var markers = [];
	
	kakao.maps.load(function () {
	    initMap();
	});
	
	function initMap() {
	    var mapContainer = document.getElementById('map');
	    var mapOption = {
	        center: new kakao.maps.LatLng(${destinationLat}, ${destinationLong}),
	        level: 5
	    };
	    map = new kakao.maps.Map(mapContainer, mapOption);
	
	    // ✅ planMarkerList 기준 마커 찍기
	    <c:forEach var="marker" items="${planMarkerList}">
		    var markerPosition = new kakao.maps.LatLng(${marker.placeLat}, ${marker.placeLong});
		    var marker = new kakao.maps.Marker({
		        position: markerPosition,
		        map: map,
		        title: "<c:out value='${marker.placeName}'/>"
		    });
		    markers.push(marker);
		</c:forEach>

	}

 	// ✅ 장소 추가
    function addSelectedPlace(placeNum) {
    $.post("/plan/add", { placeNum: placeNum }, function(response) {
        if (response === "success") {
            refreshSelectedList();

            // ✅ 마커 추가
            const addedPlace = window.currentPlaceList.find(p => p.placeNum === Number(placeNum));
            if (addedPlace) {
                const markerPosition = new kakao.maps.LatLng(addedPlace.placeLat, addedPlace.placeLong);
                const marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map,
                    title: addedPlace.placeName
                });
                marker.placeNum = addedPlace.placeNum;
                markers.push(marker);
                map.setCenter(markerPosition);
            } else {
                console.warn("❗ 추가할 장소를 찾을 수 없습니다. placeNum:", placeNum);
            }
        } else {
            alert("로그인 후 이용 가능합니다.");
        }
    });
}


    // ✅ 장소 삭제
    function removeSelectedPlace(placeNum) {
        $.post("/plan/remove", { placeNum: placeNum }, function(response) {
            if (response === "success") {
                refreshSelectedList();
                // 마커 삭제
                // markers 배열에서 해당 placeNum 마커 찾아서 제거
                for (let i = 0; i < markers.length; i++) {
                    if (markers[i].placeNum === placeNum) {
                        markers[i].setMap(null);      // 지도에서 제거
                        markers.splice(i, 1);         // 배열에서도 제거
                        break;
                    }
                }
            } else {
                alert("로그인 후 이용 가능합니다.");
            }
        });
    }

    // ✅ 장바구니 영역 새로고침
    function refreshSelectedList() {
        $("#selectedList").load("/plan/list");
    }


    function goToStep3() {
        const destinationNum = "${destinationNum}";
        const scheduleStart = "${scheduleStartParam}";
        const scheduleEnd = "${scheduleEndParam}";

        fetch("/saveScheduleToSession", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: `scheduleStart=${scheduleStart}&scheduleEnd=${scheduleEnd}`
        }).then(() => {
            location.href = `/selectStayHotel?destinationNum=${destinationNum}`;
        }).catch(err => {
            alert("세션 저장 실패");
        });
    }
    function setCategoryAndSubmit(category) {
        document.getElementById("categoryInput").value = category;
        document.getElementById("searchForm").submit();
    }
</script>
</body>
</html>
