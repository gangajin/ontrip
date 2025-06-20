let stayHotelData = [];
let selectedLat = null;
let selectedLng = null;
let hotelMarkers = [];
let map;
let mapReady = false;

function openModal(placeNum, placeName, lat, lng) {
  document.getElementById("selectedPlaceNum").value = placeNum;
  selectedLat = lat;
  selectedLng = lng;

  let html = "<div class='modal-header'>"
           + "<span class='modal-title'>" + placeName + "</span>"
           + "<button class='modal-close' onclick='closeModal()'>×</button>"
           + "</div>";

  html += "<div class='date-card-container'>";
  travelDates.forEach(date => {
    const matched = stayHotelData.find(item => item.stayHotelDate === date);
    const isSelected = matched && matched.placeNum == placeNum;

    html += `
      <div class="date-card ${isSelected ? 'selected' : ''}" data-date="${date}">
        ${date.split("-")[2]}
      </div>
    `;
  });
  html += "</div><div class='modal-btn-group'>"
        + "<button class='btn btn-primary btn-sm' onclick='selectAllDates()'>전체 선택</button>"
        + "<button class='btn btn-primary btn-sm' onclick='addStayHotel()'>완료</button>"
        + "</div>";

  document.getElementById("dateSelection").innerHTML = html;
  document.getElementById("modal").style.display = "block";

  document.querySelectorAll(".date-card").forEach(card => {
    card.addEventListener("click", () => {
      card.classList.toggle("selected");
    });
  });
}

function selectAllDates() {
  document.querySelectorAll(".date-card").forEach(card => {
    card.classList.add("selected");
  });
}

function addStayHotel() {
  const placeNum = document.getElementById("selectedPlaceNum").value;
  const placeName = document.querySelector(".modal-title").innerText;

  // 기존 선택 제거 (같은 날짜에 이미 선택된 숙소가 있으면 삭제)
  document.querySelectorAll(".date-card").forEach(card => {
    const date = card.getAttribute("data-date");
    stayHotelData = stayHotelData.filter(item => item.stayHotelDate !== date);
  });

  document.querySelectorAll(".date-card.selected").forEach(card => {
    const date = card.getAttribute("data-date");
    stayHotelData.push({
      stayHotelDate: date,
      placeNum,
      placeName,
      lat: selectedLat,
      lng: selectedLng
    });
  });

  updateHotelStatus();
  renderStayHotelMarkers();
  closeModal();
}

function closeModal() {
  document.getElementById("modal").style.display = "none";
}




function updateHotelStatus() {
  const statusDiv = document.getElementById("selectedHotelStatus");
  statusDiv.innerHTML = "";

  travelDates.forEach(date => {
    const matched = stayHotelData.find(item => item.stayHotelDate === date);
    
    const card = document.createElement("div");
    card.className = "status-card";

    if (matched) {
		card.innerHTML = `
		  <div class="status-info">
		    <div class="status-date">${date}</div>
		    <div class="status-hotel">${matched.placeName}</div>
		  </div>
		  <div>
		    <button class="btn btn-sm btn-outline-primary">예약하기</button>
		  </div>
		`;
    } else {
      card.innerHTML = `
        <div class="status-date">${date}</div>
        <div class="status-hotel text-muted">선택 안함</div>
      `;
    }

    statusDiv.appendChild(card);
  });
}

function renderStayHotelMarkers() {
  if (!mapReady) return;

  hotelMarkers.forEach(marker => marker.setMap(null));
  hotelMarkers = [];

  stayHotelData.forEach(item => {
    if (!item.lat || !item.lng) return;

    const pos = new kakao.maps.LatLng(parseFloat(item.lat), parseFloat(item.lng));
    const markerImage = new kakao.maps.MarkerImage(
      "/image/marker_hotel_selected.png",
      new kakao.maps.Size(40, 42),
      { offset: new kakao.maps.Point(20, 42) }
    );

    const marker = new kakao.maps.Marker({
      map: map,
      position: pos,
      title: item.placeName,
      image: markerImage
    });

    hotelMarkers.push(marker);
  });
}

function submitStayHotel() {
  const form = document.getElementById("saveForm");

  Array.from(form.querySelectorAll("input[name='stayHotelDate'], input[name='placeNum']")).forEach(el => el.remove());

  stayHotelData.forEach(item => {
    [
      { name: "stayHotelDate", value: item.stayHotelDate },
      { name: "placeNum", value: item.placeNum }
    ].forEach(field => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = field.name;
      input.value = field.value;
      form.appendChild(input);
    });
  });

  form.submit();
}

function searchHotels() {
  const destinationNum = document.getElementById("destinationNum").value;
  const keyword = document.getElementById("searchKeyword").value;

  fetch(`/ajax/searchHotel?destinationNum=${destinationNum}&keyword=` + encodeURIComponent(keyword))
    .then(response => response.json())
    .then(data => renderHotelList(data))
    .catch(error => {
      console.error("검색 실패", error);
      alert("검색 중 문제가 발생했습니다.");
    });
}

function renderHotelList(hotels) {
  const hotelListContainer = document.getElementById("hotelList");
  hotelListContainer.innerHTML = "";

  if (!hotels || hotels.length === 0) {
    hotelListContainer.innerHTML = "<p>검색 결과가 없습니다.</p>";
    return;
  }

  hotels.forEach(hotel => {
    const placeName = hotel.placeName;
    const address = hotel.placeRoadAddr || hotel.placeAddr || "";
    const score = hotel.placeScore || "0.0";
    const like = hotel.placelike || "0"; // ✅ 여기가 핵심 수정 부분!
    const image = hotel.placeImage ? hotel.placeImage : "/image/default_hotel.jpg";

    const item = document.createElement("div");
    item.className = "hotel-card mb-2 p-2 border d-flex";
    item.innerHTML = `
      <img src="${image}" class="me-2" style="width: 90px; height: 90px; object-fit: cover;" alt="숙소 이미지"/>
      <div class="flex-grow-1">
        <div><strong>${placeName}</strong></div>
        <div>${address}</div>
        <div>
          <i class="fas fa-star text-warning"></i> ${score}
          <i class="fas fa-heart text-danger ms-2"></i> ${like}
        </div>
        <button class="btn btn-sm btn-outline-primary mt-1"
          onclick="openModal('${hotel.placeNum}', \`${placeName}\`, '${hotel.placeLat}', '${hotel.placeLong}')">+
        </button>
      </div>
    `;
    hotelListContainer.appendChild(item);
  });
}
window.renderHotelList = renderHotelList;

// 초기 지도 렌더링
document.addEventListener("DOMContentLoaded", function () {
  const rawJson = document.getElementById("hotelListData").textContent.trim();
  try {
    const hotelData = JSON.parse(rawJson);
    renderHotelList(hotelData);
  } catch (e) {
    console.error("🚨 숙소 JSON 파싱 오류:", e);
  }

  kakao.maps.load(function () {
    const container = document.getElementById("map");
    const lat = parseFloat(container.dataset.lat);
    const lng = parseFloat(container.dataset.lng);
    const name = container.dataset.name;

    map = new kakao.maps.Map(container, {
      center: new kakao.maps.LatLng(lat, lng),
      level: 9
    });

    new kakao.maps.Marker({
      map: map,
      position: new kakao.maps.LatLng(lat, lng),
      title: name
    });

    mapReady = true;
    setTimeout(() => map.relayout(), 300);
    renderStayHotelMarkers();
  });

  updateHotelStatus();
});

window.openModal = openModal;