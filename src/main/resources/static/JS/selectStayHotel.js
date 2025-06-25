let stayHotelData = [];
let selectedLat = null;
let selectedLng = null;
let hotelMarkers = [];
let map;
let mapReady = false;
let tempStayHotelData = [];
let tempPlaceNum = null;

document.addEventListener("DOMContentLoaded", function () {
  const rawJson = document.getElementById("hotelListData").textContent.trim();
  try {
    const hotelData = JSON.parse(rawJson);
    renderHotelList(hotelData);
  } catch (e) {
    console.error("🚨 숙소 데이터 파싱 오류:", e);
  }

  // 지도 로드
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

function renderHotelList(hotels) {
  const hotelListContainer = document.getElementById("hotelList");
  hotelListContainer.innerHTML = "";

  if (!hotels || hotels.length === 0) {
    hotelListContainer.innerHTML = "<p>검색 결과가 없습니다.</p>";
    return;
  }

  hotels.forEach(hotel => {
    const item = document.createElement("div");
    item.className = "card mb-2";
    item.innerHTML = `
      <div class="row g-0">
        <div class="col-4">
          <img src="${hotel.placeImage}" class="img-fluid rounded-start hotel-img" alt="숙소 이미지">
        </div>
        <div class="col-8 d-flex flex-column justify-content-between">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <h5 class="card-title mb-1 mb-0">${hotel.placeName}</h5>
              <button class="btn btn-outline-primary btn-sm"
                onclick="openModal('${hotel.placeNum}', '${hotel.placeName}', '${hotel.placeLat}', '${hotel.placeLong}')">+
              </button>
            </div>
            <p class="card-text mb-1">${hotel.placeRoadAddr}</p>
            <div class="d-flex align-items-center gap-2">
              <div class="rating">
                <i class="fa-solid fa-star text-warning"></i>
                ${Number(hotel.placeScore || 0).toFixed(1)}
              </div>
              <div class="likes">
                <i class="fa-solid fa-heart text-danger"></i> ${hotel.placelike || 0}
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
    hotelListContainer.appendChild(item);
  });
}

function openModal(placeNum, placeName, lat, lng) {
  document.getElementById("selectedPlaceNum").value = placeNum;
  selectedLat = lat;
  selectedLng = lng;
  tempPlaceNum = placeNum;

  tempStayHotelData = [...stayHotelData];

  let html = `<div class='modal-header'>
                <span class='modal-title'>${placeName}</span>
                <button class='modal-close' onclick='closeModal()'>×</button>
              </div><div class='date-card-container'>`;

  travelDates.forEach(date => {
    const matched = tempStayHotelData.find(item => item.stayHotelDate === date);
    const isSelected = matched && matched.placeNum == placeNum;

    html += `<div class="date-card ${isSelected ? 'selected' : ''}" data-date="${date}">${date.split("-")[2]}</div>`;
  });

  html += `</div><div class='modal-btn-group'>
             <button class='btn btn-primary btn-sm' onclick='selectAllDates()'>전체 선택</button>
             <button class='btn btn-primary btn-sm' onclick='addStayHotel()'>완료</button>
           </div>`;

  document.getElementById("dateSelection").innerHTML = html;
  document.getElementById("modal").style.display = "block";

  document.querySelectorAll(".date-card").forEach(card => {
    card.addEventListener("click", () => {
      const date = card.getAttribute("data-date");
      const isSelected = card.classList.contains("selected");

      tempStayHotelData = tempStayHotelData.filter(item => item.stayHotelDate !== date);

      if (!isSelected) {
        tempStayHotelData.push({
          stayHotelDate: date,
          placeNum,
          placeName,
          lat: selectedLat,
          lng: selectedLng
        });
      }
      card.classList.toggle("selected");
    });
  });
}

function selectAllDates() {
  document.querySelectorAll(".date-card").forEach(card => {
    const date = card.getAttribute("data-date");
    card.classList.add("selected");

    tempStayHotelData = tempStayHotelData.filter(item => item.stayHotelDate !== date);
    tempStayHotelData.push({
      stayHotelDate: date,
      placeNum: tempPlaceNum,
      placeName: document.querySelector(".modal-title").innerText,
      lat: selectedLat,
      lng: selectedLng
    });
  });
}

function addStayHotel() {
  const uniqueDates = new Map();
  tempStayHotelData.forEach(item => {
    uniqueDates.set(item.stayHotelDate, item);
  });

  stayHotelData = Array.from(uniqueDates.values());
  stayHotelData.sort((a, b) => a.stayHotelDate.localeCompare(b.stayHotelDate));

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

  const dateListDiv = document.getElementById("hotelReservationTextList");
  if (dateListDiv) dateListDiv.innerHTML = "";

  travelDates.forEach(date => {
    const matched = stayHotelData.find(item => item.stayHotelDate === date);

    const card = document.createElement("div");
    card.className = "status-card";
    let html = `<div class='status-info'><div class='status-date'>${date}</div>`;

    html += matched
      ? `<div class='status-hotel'>${matched.placeName}</div></div><div><button class='btn btn-sm btn-outline-primary'>예약하기</button></div>`
      : `<div class='status-hotel text-muted'>선택 안함</div></div>`;

    card.innerHTML = html;
    statusDiv.appendChild(card);

    if (dateListDiv && matched) {
      const line = document.createElement("div");
      line.innerHTML = `
        <div class="border p-2 mb-2">
          <strong>${date}</strong><br/>
          ${matched.placeName}
          <button class='btn btn-sm btn-outline-primary'>예약하기</button>
        </div>
      `;
      dateListDiv.appendChild(line);
    }
  });
}

function renderStayHotelMarkers() {
  if (!mapReady) return;

  hotelMarkers.forEach(marker => marker.setMap(null));
  hotelMarkers = [];

  stayHotelData.forEach(item => {
    if (!item.lat || !item.lng) return;

    const pos = new kakao.maps.LatLng(parseFloat(item.lat), parseFloat(item.lng));
    const marker = new kakao.maps.Marker({
      map: map,
      position: pos,
      title: item.placeName,
      image: new kakao.maps.MarkerImage(
        "/image/marker_hotel_selected.png",
        new kakao.maps.Size(40, 42),
        { offset: new kakao.maps.Point(20, 42) }
      )
    });

    hotelMarkers.push(marker);
  });
}

function submitStayHotel() {
  const form = document.getElementById("saveForm");
  form.querySelectorAll("input[name='stayHotelDate'], input[name='placeNum']").forEach(el => el.remove());

  stayHotelData.forEach(item => {
    ["stayHotelDate", "placeNum"].forEach(field => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = field;
      input.value = item[field];
      form.appendChild(input);
    });
  });

  form.submit();
}
