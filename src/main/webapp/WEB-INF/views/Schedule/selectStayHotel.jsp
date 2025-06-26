<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>숙소 선택</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="/CSS/selectStayHotel.css">
  <link rel="stylesheet" href="/CSS/StayHotel.css">
  <link rel="stylesheet" href="/CSS/header.css">
  <script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>

<div class="d-flex">
  <!-- STEP 사이드바 -->
  <div class="col-2 sidebar d-flex flex-column align-items-center bg-white border-end" style="min-height: 100vh;">
    <div class="mb-3"><a href="/step1?destinationNum=${destinationNum}&destinationName=${destinationName}&scheduleStart=${scheduleStart}&scheduleEnd=${scheduleEnd}"class="text-decoration-none text-dark">STEP 1<br>날짜 확인</a></div>
    <div class="mb-3"><a href="/step2?destinationNum=${destinationNum}&destinationName=${destinationName}&scheduleStart=${scheduleStartParam}&scheduleEnd=${scheduleEndParam}&destinationLat=${destinationLat}&destinationLong=${destinationLong}"class="text-decoration-none text-dark">STEP 2<br>장소 선택</a></div>
    <div class="mb-3"><a href="/selectStayHotel?destinationNum=${destinationNum}"class="text-decoration-none text-primary fw-bold">STEP 3<br>숙소 선택</a></div>
    <div class="d-grid mt-4 w-100 px-4">
      <button class="btn btn-dark" type="button" onclick="submitStayHotel()">저장하기</button>
    </div>
  </div>

  <!-- 오른쪽 콘텐츠 영역 -->
  <div class="flex-grow-1 p-4">
    <h2 class="mb-4">숙소 선택</h2>
    <div class="row g-3 align-items-start">
      <!-- 숙소 리스트 -->
      <div class="col-3-6">
        <div class="input-group mb-3">
          <input type="text" id="searchKeyword" class="form-control" placeholder="숙소명을 입력하세요"
            onkeypress="if(event.key === 'Enter') { event.preventDefault(); searchHotels(); }">
          <button type="button" class="btn btn-outline-secondary" onclick="searchHotels()">검색</button>
        </div>
        <div id="hotelList"></div>
      </div>

      <!-- 날짜별 숙소 현황 -->
      <div class="col-3-6">
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">날짜별 숙소 선택 현황</h5>
            <div id="selectedHotelStatus"></div>
          </div>
        </div>
      </div>

      <!-- 지도 -->
     <div class="col-4-8">
	  <div id="map"
	       data-lat="${destinationLat}"
	       data-lng="${destinationLong}"
	       data-name="${destinationName}"
	       style="width: 100%; height: 600px; border: 1px solid #ccc; border-radius: 8px; background: #fff;">
	  </div>
	</div>
    </div>
  </div>
</div>

<div id="modal" style="display:none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
  border:1px solid #000; padding: 20px; background: white; width: 400px; box-shadow: 0 0 10px rgba(0,0,0,0.3); border-radius: 8px;">
  <h3 id="hotelName" style="font-size: 20px; margin-bottom: 15px;"></h3>
  <input type="hidden" id="selectedPlaceNum">
  <div id="dateSelection" style="margin-bottom: 15px;"></div>

</div>
<form id="saveForm" action="saveStayHotel" method="post">
  <input type="hidden" name="scheduleNum" value="${scheduleNum}">
</form>

<script>
  let travelDates = [
    <c:forEach var="date" items="${travelDates}" varStatus="loop">
      '${date}'<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];
</script>
<script id="hotelListData" type="application/json">
  <c:out value="${hotelListJson}" escapeXml="false"/>
</script>

<script src="/JS/selectStayHotel.js"></script>

<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>