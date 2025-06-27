<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>On:trip</title>
  	<link rel="icon" href="/Image/header/logo2.png" type="image/png" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="/CSS/selectPlace.css">
    <link rel="stylesheet" href="/CSS/header.css">
	<script src="/JS/header.js"></script>
</head>
<body style="margin: 0; padding: 0;">
<%@ include file="../header.jsp" %>
<div class="container-fluid">
    <div class="row">
        <!-- 사이드바 -->
        <div class="col-2 sidebar d-flex flex-column align-items-center">
            <div class="mb-3"><a href="/step1?destinationNum=${destinationNum}&destinationName=${destinationName}&scheduleStart=${scheduleStart}&scheduleEnd=${scheduleEnd}"class="text-decoration-none text-dark">STEP 1<br>날짜 확인</a></div>
          	<div class="mb-3"><a href="/step2?destinationNum=${destinationNum}&destinationName=${destinationName}&scheduleStart=${scheduleStartParam}&scheduleEnd=${scheduleEndParam}&destinationLat=${destinationLat}&destinationLong=${destinationLong}"class="text-decoration-none text-primary fw-bold">STEP 2<br>장소 선택</a></div>
            <div class="mb-3"><a href="/selectStayHotel?destinationNum=${destinationNum}"class="text-decoration-none text-dark">STEP 3<br>숙소 선택</a></div>
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
                        <input type="hidden" id="categoryInput" name="category" value="${param.category != null ? param.category : 'recommend'}">
                        <input type="text" name="keyword" class="form-control" placeholder="장소명을 입력하세요" value="${keyword}">
                        <button class="btn btn-outline-secondary" type="submit">검색</button>
                    </form>

                    <!-- 카테고리 버튼 -->
                    <div class="mb-3">
					  <button id="btn-recommend" class="btn btn-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('recommend')">추천 장소</button>
					  <button id="btn-attraction" class="btn btn-outline-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('attraction')">명소</button>
					  <button id="btn-restaurant" class="btn btn-outline-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('restaurant')">식당</button>
					  <button id="btn-cafe" class="btn btn-outline-primary btn-sm btn-category" type="button" onclick="setCategoryAndSubmit('cafe')">카페</button>
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
  const destinationLat = ${destinationLat};
  const destinationLong = ${destinationLong};
  const destinationNum = "${destinationNum}";
  const scheduleStart = "${scheduleStartParam}";
  const scheduleEnd = "${scheduleEndParam}";
</script>
<script src="/JS/selectPlace.js"></script>

</body>
</html>