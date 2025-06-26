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
    <link rel="stylesheet" href="/CSS/header.css">
	<script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>
<div class="container-fluid">
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
            <button class="btn btn-outline-primary" onclick="openWithNotice('https://www.skyscanner.co.kr', '항공권 예매는 스카이스캐너 공식 사이트에서\n출발지, 도착지, 날짜를 직접 입력해 주세요.')">✈️ 항공</button>
            <button class="btn btn-outline-primary" onclick="openWithNotice('https://www.letskorail.com', '기차 예매는 레츠코레일 공식 사이트에서\n출발역, 도착역, 날짜를 직접 입력해 주세요.')">🚝 기차</button>
            <button class="btn btn-outline-primary" onclick="openWithNotice('https://www.bustago.or.kr/newweb/kr/index.do', '버스 예매는 버스타고 공식 사이트에서\n출발지, 도착지, 날짜를 직접 입력해 주세요.')">🚌 버스</button> | 
            <a class="btn btn-outline-secondary"  href="https://www.yeogi.com/domestic-accommodations?keyword=${destinationName}&checkIn=${scheduleStartParam}&checkOut=${scheduleEndParam}&personal=2&freeForm=false" target="_blank">🏠 숙소</a>

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
	const lat = parseFloat("${destinationLat}");
	const lng = parseFloat("${destinationLong}");
	const destinationNum = "${destinationNum}";
	const destinationName = encodeURIComponent("${destinationName}");
	const scheduleStartParam = "${scheduleStartParam}";
	const scheduleEndParam = "${scheduleEndParam}";
	const userNum = "${sessionScope.userNum}";
	const destinationLat = "${destinationLat}";
	const destinationLong = "${destinationLong}";
	
	function openWithNotice(url, message) {
		  alert(message);
		  window.open(url, "_blank");
		}

</script>

<script src="/JS/selectDate.js"></script>
</body>
</html>
