kakao.maps.load(function () {
    const container = document.getElementById('map');
    const options = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 9
    };

    const map = new kakao.maps.Map(container, options);
});

// "다음" 버튼 클릭 시 호출
function goToStep2() {
    if (!userNum || userNum === "null") {
        alert("로그인 이후 사용 가능합니다.");
        location.href = "/login";
        return;
    }

    $.post("/insertSchedule", {
        destinationNum: destinationNum,
        scheduleStart: scheduleStartParam,
        scheduleEnd: scheduleEndParam,
        userNum: userNum
    }, function(scheduleNum) {
        console.log("✅ 생성된 scheduleNum =", scheduleNum);

        const url = `/step2?destinationNum=${destinationNum}`
            + `&destinationName=${destinationName}`
            + `&scheduleStart=${scheduleStartParam}`
            + `&scheduleEnd=${scheduleEndParam}`
            + `&destinationLat=${destinationLat}`
            + `&destinationLong=${destinationLong}`;

        location.href = url;
    });
}
