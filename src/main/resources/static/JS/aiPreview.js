    var map;
    kakao.maps.load(function () {
        if (!placeList.length) return;

        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(placeList[0].lat, placeList[0].lng),
            level: 6
        };
        map = new kakao.maps.Map(container, options);

        var bounds = new kakao.maps.LatLngBounds();
        var linePath = [];
        const markerSet = new Set();

        placeList.forEach(function (place, index) {
            const key = place.lat + "," + place.lng;
            if (markerSet.has(key)) return;
            markerSet.add(key);

            const position = new kakao.maps.LatLng(place.lat, place.lng);
            bounds.extend(position);
            linePath.push(position);

            const marker = new kakao.maps.Marker({
                map: map,
                position: position,
                title: (index + 1) + ". " + place.name
            });

            const infoWindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;">${index + 1}. ${place.name}</div>`
            });

            kakao.maps.event.addListener(marker, 'mouseover', function () {
                infoWindow.open(map, marker);
            });
            kakao.maps.event.addListener(marker, 'mouseout', function () {
                infoWindow.close();
            });
        });

        new kakao.maps.Polyline({
            map: map,
            path: linePath,
            strokeWeight: 4,
            strokeColor: '#FF6F61',
            strokeOpacity: 0.9,
            strokeStyle: 'solid'
        });

        map.setBounds(bounds);
    });
    
    function filterSchedule(dayId) {
    	// 1. 일정 카드 표시/숨김 처리
        const allCards = document.querySelectorAll(".day-card");
        allCards.forEach(card => {
            card.style.display = (dayId === 'all' || card.id === dayId) ? 'block' : 'none';
        });
        
     	// 2. 모든 버튼에서 active 제거
        document.querySelectorAll('.schedule-button').forEach(btn => {
            btn.classList.remove('active');
        });

        // 3. 클릭된 버튼만 active 추가
        const targetBtn = Array.from(document.querySelectorAll('.schedule-button'))
            .find(btn => btn.getAttribute("onclick").includes(dayId));
        if (targetBtn) {
            targetBtn.classList.add('active');
        }
    }
    
    function confirmAndRedirect() {
        const result = confirm("저장되었습니다. 마이페이지로 이동하시겠습니까?");
        if (result) {
            window.location.href = "/user/myPage";
        }
    }