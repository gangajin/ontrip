<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>숙소 선택</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    body { background-color: #f8f9fa; }
    .sidebar {
      min-height: 100vh;
      background-color: #fff;
      padding-top: 20px;
      border-right: 1px solid #ddd;
    }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-2 sidebar d-flex flex-column align-items-center">
      <h4 class="mb-4 mt-2">On:trip</h4>
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
          <ul class="nav nav-tabs mb-2">
            <li class="nav-item">
              <a class="nav-link active" aria-current="page" href="#">장소 선택</a>
            </li>
          </ul>
          <form action="selectStayHotel" method="get" class="input-group mb-3">
            <input type="hidden" name="destinationNum" value="${destinationNum}">
            <input type="text" name="keyword" value="${param.keyword}" class="form-control" placeholder="숙소명을 입력하세요">
            <button type="submit" class="btn btn-outline-secondary">검색</button>
          </form>
          <table border="1" style="width: 100%; margin-bottom: 20px; background: #fff;">
            <c:forEach var="hotel" items="${hotelList}">
              <tr>
                <td rowspan="3">
                  <img src="${pageContext.request.contextPath}${hotel.placeImage}" width="100%" height="150px" />
                </td>
                <td><b>${hotel.placeName}</b></td>
                <td rowspan="3">
                  <button type="button"
                    onclick="openModal('${hotel.placeNum}', '${hotel.placeName}', '${hotel.placeLat}', '${hotel.placeLong}')">+</button>
                </td>
              </tr>
              <tr><td>${hotel.placeRoadAddr}</td></tr>
              <tr>
                <td>
                  <i class="fa-solid fa-heart" style="color: red;"></i> ${hotel.placelike}
                  &nbsp;&nbsp;<i class="fa-solid fa-star" style="color: gold;"></i> ${hotel.placeScore}
                </td>
              </tr>
            </c:forEach>
          </table>
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

<div id="modal"
  style="display:none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
         border:1px solid #000; padding: 20px; background: white; width: 400px; box-shadow: 0 0 10px rgba(0,0,0,0.3); border-radius: 8px;">
  <h3 id="hotelName" style="font-size: 20px; margin-bottom: 15px;"></h3>
  <input type="hidden" id="selectedPlaceNum">
  <div id="dateSelection" style="margin-bottom: 15px;"></div>
  <div style="text-align: center;">
    <button onclick="addStayHotel()">추가</button>
    <button onclick="closeModal()">닫기</button>
  </div>
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

  let map;
  let hotelMarker;
  let mapReady = false;

  const hotelData = [
    <c:forEach var="hotel" items="${hotelList}" varStatus="loop">
      {
        name: "${hotel.placeName}",
        lat: ${hotel.placeLat},
        lng: ${hotel.placeLong}
      }<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];
</script>

<script type="text/javascript"
  src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services">
</script>
<script type="text/javascript" src="/JS/selectPlace.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>