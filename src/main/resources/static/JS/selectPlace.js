let stayHotelData = [];

function openModal(placeNum, placeName, lat, lng) {
  document.getElementById("selectedPlaceNum").value = placeNum;
  document.getElementById("hotelName").innerText = placeName;

  let html = "";
  travelDates.forEach(date => {
    const isSelected = stayHotelData.some(item => item.stayHotelDate === date && item.placeNum === placeNum);

    html += `<label>
      <input type="checkbox" name="dates" value="${date}" ${isSelected ? 'checked' : ''}> ${date}
    </label><br>`;
  });

  document.getElementById("dateSelection").innerHTML = html;
  document.getElementById("modal").style.display = "block";

  if (mapReady) {
    addStayHotelMarker(parseFloat(lat), parseFloat(lng), placeName);
  }
}

function closeModal() {
  document.getElementById("modal").style.display = "none";
}

function addStayHotelMarker(lat, lng, name) {
  if (!map) return;
  if (hotelMarker) hotelMarker.setMap(null);
  const pos = new kakao.maps.LatLng(lat, lng);
  hotelMarker = new kakao.maps.Marker({
    map: map,
    position: pos,
    title: name
  });
  map.setCenter(pos);
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
      placeName: placeName
    });
  });

  updateHotelStatus();
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

function submitStayHotel() {
  const form = document.getElementById("saveForm");
  stayHotelData.forEach(item => {
    let inputDate = document.createElement("input");
    inputDate.type = "hidden";
    inputDate.name = "stayHotelDate";
    inputDate.value = item.stayHotelDate;
    form.appendChild(inputDate);

    let inputPlace = document.createElement("input");
    inputPlace.type = "hidden";
    inputPlace.name = "placeNum";
    inputPlace.value = item.placeNum;
    form.appendChild(inputPlace);
  });
  form.submit();
}
document.addEventListener("DOMContentLoaded", function () {
  kakao.maps.load(function () {
    const container = document.getElementById("map");
    const lat = parseFloat(container.dataset.lat);
    const lng = parseFloat(container.dataset.lng);
    const name = container.dataset.name;

    map = new kakao.maps.Map(container, {
      center: new kakao.maps.LatLng(lat, lng),
      level: 9
    });

    // ✅ 목적지 마커
    new kakao.maps.Marker({
      map: map,
      position: new kakao.maps.LatLng(lat, lng),
      title: name
    });

    // ✅ 호텔 목록 전체 마커 표시
    hotelData.forEach(hotel => {
      const marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(hotel.lat, hotel.lng),
        title: hotel.name
      });
    });

    mapReady = true;
    setTimeout(() => map.relayout(), 300);
  });

  updateHotelStatus();
});