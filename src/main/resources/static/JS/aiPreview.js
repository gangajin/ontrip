let map;
let polylines = {};
let markers = {};
let allBounds;

kakao.maps.load(function () {
    allBounds = new kakao.maps.LatLngBounds();
    map = new kakao.maps.Map(document.getElementById("map"), {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 7
    });

    Object.keys(groupedPlaceList).forEach(day => {
        const places = groupedPlaceList[day];
        const linePath = [];
        const markerList = [];

        places.forEach((place, idx) => {
            const latlng = new kakao.maps.LatLng(place.lat, place.lng);
            linePath.push(latlng);
            allBounds.extend(latlng);

            const marker = new kakao.maps.Marker({
                position: latlng,
                title: `${idx + 1}. ${place.name}`
            });
            marker.setMap(map);

            const infoWindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;">${idx + 1}. ${place.name}</div>`
            });

            kakao.maps.event.addListener(marker, 'mouseover', () => infoWindow.open(map, marker));
            kakao.maps.event.addListener(marker, 'mouseout', () => infoWindow.close());

            markerList.push(marker);
        });

        const polyline = new kakao.maps.Polyline({
            path: linePath,
            strokeWeight: 4,
            strokeColor: '#FF6F61',
            strokeOpacity: 0.9,
            strokeStyle: 'solid'
        });
        polyline.setMap(map);

        polylines[day] = polyline;
        markers[day] = markerList;
    });

    map.setBounds(allBounds);
});

function showPolylineForDay(dayId) {
    Object.values(polylines).forEach(p => p.setMap(null));
    Object.values(markers).flat().forEach(m => m.setMap(null));

    if (dayId === 'all') {
        Object.values(polylines).forEach(p => p.setMap(map));
        Object.values(markers).flat().forEach(m => m.setMap(map));
        map.setBounds(allBounds);
    } else if (polylines[dayId]) {
        polylines[dayId].setMap(map);
        markers[dayId].forEach(m => m.setMap(map));

        const bounds = new kakao.maps.LatLngBounds();
        groupedPlaceList[dayId].forEach(p => {
            bounds.extend(new kakao.maps.LatLng(p.lat, p.lng));
        });
        map.setBounds(bounds);
    }
}

function filterSchedule(dayId) {
    const allCards = document.querySelectorAll(".day-card");
    allCards.forEach(card => {
        card.style.display = (dayId === 'all' || card.id === dayId) ? 'block' : 'none';
    });

    document.querySelectorAll('.schedule-button').forEach(btn => btn.classList.remove('active'));
    const targetBtn = Array.from(document.querySelectorAll('.schedule-button'))
        .find(btn => btn.getAttribute("onclick").includes(dayId));
    if (targetBtn) targetBtn.classList.add('active');

    const container = document.querySelector('.schedule-container');
    if (dayId === 'all') {
        container.classList.add('d-flex', 'overflow-auto');
    } else {
        container.classList.remove('d-flex', 'overflow-auto');
    }

    showPolylineForDay(dayId);
}

function confirmAndRedirect() {
    const result = confirm("저장되었습니다. 마이페이지로 이동하시겠습니까?");
    if (result) window.location.href = "/user/myPage";
}