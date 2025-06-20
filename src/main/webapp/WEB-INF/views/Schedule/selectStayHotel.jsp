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
	<link rel="stylesheet" href="/CSS/stayHotel.css">
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-2 sidebar d-flex flex-column align-items-center">
      <h4 class="mb-4 mt-2">
        <a href="/"><img src="Image/header/logo.png" alt="로고" style="height:60px"></a>
      </h4>
      <div class="mb-3">STEP 1<br>날짜 확인</div>
      <div class="mb-3">STEP 2<br>장소 선택</div>
      <div class="mb-3 text-primary fw-bold">STEP 3<br>숙소 선택</div>
      <div class="d-grid mt-4 w-100 px-4">
        <button class="btn btn-dark" type="button" onclick="submitStayHotel()">저장하기</button>
      </div>
    </div>
    <div class="col-10 p-4">
      <h2 class="mb-4">숙소 선택</h2>
      <div class="row g-3 align-items-start">
        <div class="col-4">
          <div class="input-group mb-3">
            <input type="hidden" id="destinationNum" value="${destinationNum}">
            <input type="text" id="searchKeyword" class="form-control" placeholder="숙소명을 입력하세요"
              onkeypress="if(event.key === 'Enter') { event.preventDefault(); searchHotels(); }">
            <button type="button" class="btn btn-outline-secondary" onclick="searchHotels()">검색</button>
          </div>
          <div id="hotelList"></div>
        </div>
        <div class="col-4">
          <div class="card" style="min-height:200px;">
            <div class="card-body">
              <h5 class="card-title">날짜별 숙소 선택 현황</h5>
              <div id="selectedHotelStatus"></div>
            </div>
          </div>
        </div>
        <div class="col-4">
          <div id="map"
               data-lat="${destinationLat}"
               data-lng="${destinationLong}"
               data-name="${destinationName}"
               style="width: 100%; height: 400px; border: 1px solid #ccc; border-radius: 8px; background: #fff;">
          </div>
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
<script>
document.addEventListener("DOMContentLoaded", function () {
	  const rawJson = document.getElementById("hotelListData").textContent.trim();
	  try {
	    const hotelData = JSON.parse(rawJson);
	    renderHotelList(hotelData);  // hotel은 여기서 쓰면 안 됨
	  } catch (e) {
	    console.error("🚨 숙소 데이터 파싱 오류:", e);
	  }
	});

	function renderHotelList(hotels) {
	  const hotelListContainer = document.getElementById("hotelList");
	  hotelListContainer.innerHTML = "";

	  if (!hotels || hotels.length === 0) {
	    hotelListContainer.innerHTML = "<p>검색 결과가 없습니다.</p>";
	    return;
	  }

	  hotels.forEach(hotel => {
	    console.log("✅ hotel object:", hotel); // 여기서만 hotel 변수가 유효함

	    const placeImage = hotel.placeImage || "/images/default.png";
	    const placeName = hotel.placeName || "이름 없음";
	    const placeRoadAddr = hotel.placeRoadAddr || "";
	    const placeScore = (hotel.placeScore !== undefined && !isNaN(hotel.placeScore))
	      ? Number(hotel.placeScore).toFixed(1)
	      : "0.0";
	    const placelike = (hotel.placelike !== undefined && !isNaN(hotel.placelike))
	      ? hotel.placelike
	      : 0;

	    const item = document.createElement("div");
	    item.className = "card mb-2";
	    item.innerHTML = `
	      <div class="row g-0">
	        <div class="col-4">
	          <img src="${placeImage}" class="img-fluid rounded-start hotel-img" alt="숙소 이미지">
	        </div>
	        <div class="col-8 d-flex flex-column justify-content-between">
	          <div class="card-body">
	            <div class="d-flex justify-content-between align-items-center">
	              <h5 class="card-title mb-1 mb-0">${placeName}</h5>
	              <button class="btn btn-outline-primary btn-sm"
	                onclick="openModal('${hotel.placeNum}', '${placeName}', '${hotel.placeLat}', '${hotel.placeLong}')">+
	              </button>
	            </div>
	            <p class="card-text mb-1">${placeRoadAddr}</p>
	            <div class="d-flex align-items-center gap-2">
	              <div class="rating">
	                <i class="fa-solid fa-star text-warning"></i> ${placeScore}
	              </div>
	              <i class="fa-solid fa-heart text-danger"></i> ${placelike}
	            </div>
	          </div>
	        </div>
	      </div>
	    `;
	    hotelListContainer.appendChild(item);
	  });
	}
</script>
<script src="/JS/selectPlace.js"></script>
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>