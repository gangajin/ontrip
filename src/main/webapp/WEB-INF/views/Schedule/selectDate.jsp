<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>여행 일정 확인</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/CSS/selectDate.css">
</head>
<body>
<div class="container-fluid">
<%@ include file="../header.jsp" %>
    <div class="row">
        <!-- 사이드바 (selectPlace.jsp와 동일) -->
        <div class="col-2 sidebar d-flex flex-column align-items-center">
            <div class="mb-3"><a href="/step1?destinationNum=${destinationNum}&destinationName=${destinationName}&scheduleStart=${scheduleStartParam}&scheduleEnd=${scheduleEndParam}"class="text-decoration-none text-primary fw-bold">STEP 1<br>날짜 확인</a></div>
          	<div class="mb-3"><a href="/step2?destinationNum=${destinationNum}&destinationName=${destinationName}&scheduleStart=${scheduleStartParam}&scheduleEnd=${scheduleEndParam}&destinationLat=${destinationLat}&destinationLong=${destinationLong}"class="text-decoration-none text-dark">STEP 2<br>장소 선택</a></div>
            <div class="mb-3"><a href="/selectStayHotel?destinationNum=${destinationNum}"class="text-decoration-none text-dark">STEP 3<br>숙소 선택</a></div>
            <div class="d-grid mt-4">
                <button class="btn btn-dark" onclick="goToStep2()">다음</button>
            </div>
        </div>
        <!-- 본문 영역 -->
        <div class="col-10 p-5">
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
			var userNum = "${sessionScope.userNum}";

		    // ✅ 로그인 안 된 경우 알림 후 로그인 페이지로 이동
		    if (!userNum || userNum === "null") {
		        alert("로그인 이후 사용 가능합니다.");
		        location.href = "/login";
		        return; // 더 이상 진행하지 않음
		    }
		    var destinationNum = "${destinationNum}";
		    var destinationName = encodeURIComponent("${destinationName}");
		    var scheduleStartParam = "${scheduleStartParam}";
		    var scheduleEndParam = "${scheduleEndParam}";
		    var destinationLat = "${destinationLat}";
		    var destinationLong = "${destinationLong}";
		    var userNum = "${sessionScope.userNum}";; 
		
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
		                + `&scheduleEnd=${scheduleEndParam}`
		                + `&destinationLat=${destinationLat}`
		                + `&destinationLong=${destinationLong}`;
		
		        location.href = url;
		    });
		}
</script>
</body>
</html>
