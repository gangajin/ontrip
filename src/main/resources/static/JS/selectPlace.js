let map;
let markers = [];

kakao.maps.load(function () {
  initMap();
});

function initMap() {
  const mapContainer = document.getElementById('map');
  const mapOption = {
    center: new kakao.maps.LatLng(destinationLat, destinationLong),
    level: 5
  };
  map = new kakao.maps.Map(mapContainer, mapOption);

  // 마커 초기 로드 (planMarkerList는 서버 렌더링 → JSP에서 처리됨)
  const existingMarkers = document.querySelectorAll(".existing-marker");
  existingMarkers.forEach(markerData => {
    const lat = parseFloat(markerData.dataset.lat);
    const lng = parseFloat(markerData.dataset.lng);
    const name = markerData.dataset.name;

    const position = new kakao.maps.LatLng(lat, lng);
    const marker = new kakao.maps.Marker({
      position: position,
      map: map,
      title: name
    });
    markers.push(marker);
  });
}

// 장소 추가
function addSelectedPlace(placeNum) {
  $.post("/plan/add", { placeNum: placeNum }, function (response) {
    if (response === "success") {
      refreshSelectedList();

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
      alert("세션 오류입니다., STEP1에서 다음 버튼을 누르시고 이용해주세요.");
    }
  });
}

// 장소 삭제
function removeSelectedPlace(placeNum) {
  $.post("/plan/remove", { placeNum: placeNum }, function (response) {
    if (response === "success") {
      refreshSelectedList();

      for (let i = 0; i < markers.length; i++) {
        if (markers[i].placeNum === placeNum) {
          markers[i].setMap(null);
          markers.splice(i, 1);
          break;
        }
      }
    } else {
      alert("로그인 후 이용 가능합니다.");
    }
  });
}

// 선택한 장소 목록 새로고침
function refreshSelectedList() {
  $("#selectedList").load("/plan/list");
}

// 다음 단계로 이동
function goToStep3() {
  fetch("/saveScheduleToSession", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: `scheduleStart=${scheduleStart}&scheduleEnd=${scheduleEnd}`
  }).then(() => {
    location.href = `/selectStayHotel?destinationNum=${destinationNum}`;
  }).catch(() => {
    alert("세션 저장 실패");
  });
}

// 카테고리 선택 후 form 제출
let currentCategory = document.getElementById("categoryInput").value || "recommend";

  window.addEventListener("DOMContentLoaded", () => {
    updateButtonStyles(currentCategory);
  });

  function setCategoryAndSubmit(category) {
    const prevCategory = currentCategory;
    currentCategory = (prevCategory === category) ? "" : category;

    document.getElementById("categoryInput").value = currentCategory;
    updateButtonStyles(currentCategory);
    document.getElementById("searchForm").submit();
  }

  function updateButtonStyles(selectedCategory) {
    const categories = ["recommend", "attraction", "restaurant", "cafe"];
    categories.forEach(cat => {
      const btn = document.getElementById("btn-" + cat);
      if (btn) {
        if (selectedCategory === cat) {
          btn.classList.remove("btn-outline-primary");
          btn.classList.add("btn-primary");
        } else {
          btn.classList.remove("btn-primary");
          btn.classList.add("btn-outline-primary");
        }
      }
    });
  }
  
  //insertSchedule 호출 (사이드바 STEP2 클릭 시 세션에 scheduleNum이 없으면 호출)
  window.addEventListener("DOMContentLoaded", () => {
    updateButtonStyles(currentCategory); // 기존 실행 로직 유지

    const userNum = document.body.dataset.usernum;
    const scheduleNum = document.body.dataset.schedulenum;
    const destinationNum = document.body.dataset.destinationnum;
    const scheduleStart = document.body.dataset.schedulestart;
    const scheduleEnd = document.body.dataset.scheduleend;

    if (!scheduleNum || scheduleNum === "null") {
      fetch("/insertSchedule", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `destinationNum=${destinationNum}&scheduleStart=${scheduleStart}&scheduleEnd=${scheduleEnd}&userNum=${userNum}`
      })
      .then(res => res.text())
      .then(data => {
        console.log("✅ scheduleNum 세션 저장 완료:", data);
        location.reload(); // 세션 반영을 위해 한 번 새로고침
      })
      .catch(err => {
        alert("⚠️ 세션 초기화 실패 - STEP1에서 다시 시도해주세요.");
        console.error(err);
      });
    }
  });

