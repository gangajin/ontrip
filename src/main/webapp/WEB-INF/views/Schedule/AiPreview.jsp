<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>On:trip</title>
    <link rel="icon" href="/Image/header/logo2.png" type="image/png" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/CSS/AiPreview.css">
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services"></script>
</head>
<body>
<div class="container-flex">
    <!-- 사이드바 -->
    <div class="col-2 sidebar d-flex flex-column align-items-center">
        <h4 class="mb-4 mt-2">
            <a href="/"><img src="/Image/header/logo.png" alt="로고" style="height: 60px;"></a>
        </h4>
        <div class="d-flex flex-column align-items-center w-100 px-2">
            <button class="btn btn-outline-primary btn-sm mb-3 w-100 schedule-button active" onclick="filterSchedule('all')">전체일정</button>
            <c:forEach var="entry" items="${groupedDetailMap}" varStatus="status">
                <button class="btn btn-outline-primary btn-sm mb-3 w-100 schedule-button" onclick="filterSchedule('day${status.index + 1}')">
                    ${status.index + 1}일차
                </button>
            </c:forEach>
        </div>
        <div class="d-grid mt-4" style="gap: 8px;">
		  <button class="btn" style="background-color: #333; color: white;" onclick="saveScheduleTimes()">저장</button>
		  <a href="/user/myPage" class="btn" style="background-color: #00c6be; color: white;">마이페이지로 이동</a>
		</div>
    </div>

    <!-- 일정 카드 -->
    <div class="schedule-panel">
        <h4 class="mb-4">🗓 AI 자동 생성된 일정 미리보기</h4>
        <div class="schedule-container d-flex gap-3 overflow-auto" style="padding-bottom: 10px;">
            <c:forEach var="entry" items="${groupedDetailMap}" varStatus="dayStatus">
                <div class="day-card" id="day${dayStatus.index + 1}">
                    <h5 class="mb-3 text-center">🗓 ${dayStatus.index + 1}일차<br>(${entry.key})</h5>
                    <div class="timeline position-relative ms-4">
                        <c:forEach var="detail" items="${entry.value}" varStatus="placeStatus">
                            <div class="timeline-item d-flex mb-4">
                                <div class="timeline-icon me-3">
                                    <span class="badge rounded-circle text-white fs-6 px-3 py-2
                                        <c:choose>
                                            <c:when test="${dayStatus.index == 0}"> bg-danger</c:when>
                                            <c:when test="${dayStatus.index == 1}"> bg-primary</c:when>
                                            <c:otherwise> bg-secondary</c:otherwise>
                                        </c:choose>">
                                        ${placeStatus.index + 1}
                                    </span>
                                </div>
                                <div class="timeline-content card flex-fill shadow-sm border-0">
                                    <div class="card-body">
                                        <h6 class="card-title mb-1">${detail.place.placeName}</h6>
                                        <p class="mb-1">
										  <strong>날짜:</strong>
										  <span class="date-span">
										    <fmt:formatDate value="${detail.scheduleDetailDay}" pattern="yyyy-MM-dd"/>
										  </span>
										</p>
										
										<div class="mb-1 d-flex align-items-center gap-2">
										  <label><strong>시간:</strong></label>
										  <input
										    type="time"
										    class="form-control"
										    data-id="${detail.scheduleDetailNum}"
										    value="<fmt:formatDate value='${detail.scheduleDetailDay}' pattern='HH:mm' />"
										    style="width: 150px;"
										  />
										</div>

                                        <p class="mb-1"><strong>주소:</strong> ${detail.place.placeRoadAddr}</p>
                                        <p class="mb-0">
                                            <c:choose>
                                                <c:when test="${detail.place.placeCategory == 'attraction'}">
                                                    <span class="badge bg-primary">명소</span>
                                                </c:when>
                                                <c:when test="${detail.place.placeCategory == 'cafe'}">
                                                    <span class="badge bg-warning text-dark">카페</span>
                                                </c:when>
                                                <c:when test="${detail.place.placeCategory == 'restaurant'}">
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
            </c:forEach>
        </div>
    </div>

    <!-- 지도 -->
    <div class="map-panel">
        <div id="map"></div>
    </div>
</div>

<script>
var groupedPlaceList = {
    <c:forEach var="entry" items="${groupedDetailMap}" varStatus="dayStatus">
        "day${dayStatus.index + 1}": [
            <c:forEach var="detail" items="${entry.value}" varStatus="loop">
                <c:if test="${not empty detail.place.placeLat and not empty detail.place.placeLong}">
                {
                    name: "${detail.place.placeName}",
                    lat: ${detail.place.placeLat},
                    lng: ${detail.place.placeLong}
                }<c:if test="${!loop.last}">,</c:if>
                </c:if>
            </c:forEach>
        ]<c:if test="${!dayStatus.last}">,</c:if>
    </c:forEach>
};
<!--여기-->
document.querySelectorAll('input[type="time"]').forEach(input => {
	  console.log("ID:", input.dataset.id);
	  console.log("Time:", input.value);
	  const date = input.closest(".card-body").querySelector(".date-span").textContent.trim();
	  console.log("Date:", date);
	});
	
function collectScheduleUpdates() {
	  const updates = [];
	  document.querySelectorAll('input[type="time"]').forEach(input => {
	    const id = input.dataset.id;
	    const time = input.value;
	    const date = input.closest(".card-body").querySelector(".date-span").textContent.trim();
	    const dateTime = date + " " + time + ":00";
	    updates.push({
	      scheduleDetailNum: id,
	      newDateTime: dateTime
	    });
	  });
	  console.log("🟢 수집된 데이터:", updates);
	  return updates;
	}

	function saveScheduleTimes() {
	  const updates = collectScheduleUpdates();
	  if (!confirm("저장하시겠습니까?")) return;

	  fetch("/schedule/updateTimes", {
	    method: "POST",
	    headers: {"Content-Type": "application/json"},
	    body: JSON.stringify(updates)
	  })
	  .then(res => {
	    if (res.ok) {
	      alert("저장 완료!");
	      location.reload();
	    } else {
	      alert("저장 실패");
	    }
	  })
	  .catch(err => {
	    console.error(err);
	    alert("오류 발생");
	  });
	}


</script>

<script src="/JS/aiPreview.js"></script>
    
</body>
</html>