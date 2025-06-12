<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>여행 일정 확인</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { overflow-x: hidden; background-color: #f8f9fa; }
        .sidebar {
            min-height: 100vh;
            background-color: #ffffff;
            padding-top: 20px;
            border-right: 1px solid #ddd;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- 사이드바 (selectPlace.jsp와 동일) -->
        <div class="col-2 sidebar d-flex flex-column align-items-center">
            <h4 class="mb-4 mt-2">On:trip</h4>
            <div class="mb-3 text-primary fw-bold">STEP 1<br>날짜 확인</div>
            <div class="mb-3">STEP 2<br>장소 선택</div>
            <div class="mb-3">STEP 3<br>숙소 선택</div>
            <div class="d-grid mt-4">
                <button class="btn btn-dark" onclick="goToStep2()">다음</button>
            </div>
        </div>
        <!-- 본문 영역 -->
        <div class="col-10 p-5">
            <h2>여행 일정 확인(STEP1)</h2>
            <h2>${destinationName}</h2>
            <p>${scheduleStart} ~ ${scheduleEnd}</p>
            <a href="https://www.skyscanner.co.kr/" target="_blank"><button class="btn btn-outline-primary">항공</button></a>
            <a href="https://kr.trip.com/?locale=ko-KR&curr=KRW" target="_blank"><button class="btn btn-outline-secondary">숙소</button></a>
            <div id="map" style="width:100%; height:400px; margin-top:20px;"></div>
        </div>
    </div>
</div>

<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Kakao Map API -->
<script type="text/javascript"
    src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services">
</script>
<script>
		kakao.maps.load(function () {
		    const lat = parseFloat("${destinationLat}");
		    const lng = parseFloat("${destinationLong}");
		
		    const container = document.getElementById('map');
		    const options = {
		        center: new kakao.maps.LatLng(lat, lng),
		        level: 9
		    };
		
		    const map = new kakao.maps.Map(container, options);
		});
		
		// "다음" 버튼 클릭 시 호출
		function goToStep2() {
		    var destinationNum = "${destinationNum}";
		    var destinationName = encodeURIComponent("${destinationName}");
		    var scheduleStartParam = "${scheduleStartParam}";
		    var scheduleEndParam = "${scheduleEndParam}";
		    var userNum = 1; // 테스트용 → 나중에 세션에서 가져와도 됨
		
		    $.post("/insertSchedule", {
		        destinationNum: destinationNum,
		        scheduleStart: scheduleStartParam,
		        scheduleEnd: scheduleEndParam,
		        userNum: userNum
		    }, function(scheduleNum) {
		        console.log("✅ 생성된 scheduleNum =", scheduleNum);
		
		        var url = `/step2?destinationNum=${destinationNum}`
		                + `&destinationName=${destinationName}`
		                + `&scheduleStart=${scheduleStartParam}`
		                + `&scheduleEnd=${scheduleEndParam}`;
		
		        location.href = url;
		    });
		}
</script>
</body>
</html>
