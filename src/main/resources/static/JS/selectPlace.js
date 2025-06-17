let stayHotelData = [];
let selectedLat = null;
let selectedLng = null;
let hotelMarkers = [];
let map;
let mapReady = false;

function openModal(placeNum, placeName, lat, lng) {
  document.getElementById("selectedPlaceNum").value = placeNum;
  document.getElementById("hotelName").innerText = placeName;
  selectedLat = lat;
  selectedLng = lng;

  let html = "";
  travelDates.forEach(date => {
    const isSelected = stayHotelData.some(item => item.stayHotelDate === date && item.placeNum == placeNum);
    const isAlreadySelected = stayHotelData.some(item => item.stayHotelDate === date && item.placeNum != placeNum);

    html += `<label>
      <input type="checkbox" name="dates" value="${date}" ${isSelected ? 'checked' : ''} ${isAlreadySelected && !isSelected ? 'disabled' : ''}>
      ${date} ${isAlreadySelected && !isSelected ? '(다른 숙소 선택됨)' : ''}
    </label><br>`;
  });

  document.getElementById("dateSelection").innerHTML = html;
  document.getElementById("modal").style.display = "block";
}

function closeModal() {
  document.getElementById("modal").style.display = "none";
}

function addStayHotel() {
  const placeNum = document.getElementById("selectedPlaceNum").value;
  const placeName = document.getElementById("hotelName").innerText;
  const selectedDates = document.querySelectorAll("input[name='dates']:checked");

  if (selectedDates.length === 0) {
    alert("날짜를 선택해주세요.");
    return;
  }

  selectedDates.forEach(d => {
    stayHotelData = stayHotelData.filter(item => item.stayHotelDate !== d.value);
    stayHotelData.push({
      stayHotelDate: d.value,
      placeNum: placeNum,
      placeName: placeName,
      lat: selectedLat,
      lng: selectedLng
    });
  });

  updateHotelStatus();
  renderStayHotelMarkers();
  closeModal();
}

function updateHotelStatus() {
  const statusDiv = document.getElementById("selectedHotelStatus");
  let html = "";
  travelDates.forEach(date => {
    const matched = stayHotelData.find(item => item.stayHotelDate === date);
    html += `<div>${date} : ${matched ? matched.placeName : '선택안함'}</div>`;
  });
  statusDiv.innerHTML = html;
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
    const like = hotel.placeLike || "0";
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