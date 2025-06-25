kakao.maps.load(() => {
    const map = new kakao.maps.Map(document.getElementById('map'), {
      center: new kakao.maps.LatLng(placeList[0].lat, placeList[0].lng),
      level: 9
    });

    // 명소 마커 + 오버레이
    placeList.forEach(place => {
      const pos = new kakao.maps.LatLng(place.lat, place.lng);
      new kakao.maps.Marker({ map, position: pos, title: place.name });
      new kakao.maps.CustomOverlay({
        map, position: pos,
        content: `<div style="background:#4faeff;color:white;padding:4px 8px;border-radius:16px;font-size:12px;">${place.order}</div>`,
        yAnchor: 1
      });
    });

    // 숙소 마커
    const hotelImg = new kakao.maps.MarkerImage("/image/marker_hotel_selected.png", new kakao.maps.Size(40, 42), { offset: new kakao.maps.Point(20, 42) });
    stayList.forEach(hotel => {
      const pos = new kakao.maps.LatLng(hotel.lat, hotel.lng);
      new kakao.maps.Marker({ map, position: pos, title: "[숙소] " + hotel.name, image: hotelImg }); // ✅ 고침
    });
  });

  function openTransportModal() {
    document.getElementById("transportModal").style.display = "flex";
  }

  function closeTransportModal() {
    document.getElementById("transportModal").style.display = "none";
  }

  function selectTransport(type, element) {
    document.getElementById("transportType").value = type;
    document.querySelectorAll(".transport-card").forEach(card => card.classList.remove("selected"));
    element.classList.add("selected");
  }