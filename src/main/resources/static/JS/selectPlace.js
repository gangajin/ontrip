let stayHotelData = [];
let selectedLat = null;
let selectedLng = null;
let hotelMarkers = [];
let map;
let mapReady = false;
let tempStayHotelData = [];
let tempPlaceNum = null;

function openModal(placeNum, placeName, lat, lng) {
  document.getElementById("selectedPlaceNum").value = placeNum;
  selectedLat = lat;
  selectedLng = lng;
  tempPlaceNum = placeNum;

  tempStayHotelData = [...stayHotelData]; // 복사

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
  // 날짜 기준으로 하나만 남도록 정제
  const uniqueDates = new Map();
  tempStayHotelData.forEach(item => {
    uniqueDates.set(item.stayHotelDate, item); // 같은 날짜면 마지막 걸로 덮어씀
  });

  // 갱신
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
document.addEventListener("DOMContentLoaded", function () {
  const rawJson = document.getElementById("hotelListData").textContent.trim();
  try {
    const hotelData = JSON.parse(rawJson);
    renderHotelList(hotelData);
  } catch (e) {
    console.error("🚨 숙소 JSON 파싱 오류:", e);
  }

  // ✅ 지도 로드
  kakao.maps.load(function () {
    const container = document.getElementById("map");
    const lat = parseFloat(container.dataset.lat);
    const lng = parseFloat(container.dataset.lng);
    const name = container.dataset.name;

    map = new kakao.maps.Map(container, {
      center: new kakao.maps.LatLng(lat, lng),
      level: 9
    });

    // 중심 마커
    new kakao.maps.Marker({
      map: map,
      position: new kakao.maps.LatLng(lat, lng),
      title: name
    });

    mapReady = true;
    setTimeout(() => map.relayout(), 300);
    renderStayHotelMarkers(); // ✅ 숙소 마커 그려주기
  });

  updateHotelStatus(); // 상태도 반영
});