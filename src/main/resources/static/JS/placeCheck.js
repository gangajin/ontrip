function goPopup() {
    window.open("/admin/Popup", "pop", "width=570,height=420, scrollbars=yes, resizable=yes");
}

// 하나만 남겨!
function jusoCallBack(roadAddr, detailAddr) {
    document.getElementById("placeRoadAddr").value = roadAddr;
    document.getElementById("placeDetailAddr").value = detailAddr;
}

function getCoordinates() {
    const address = document.getElementById("placeRoadAddr").value;

    fetch("https://dapi.kakao.com/v2/local/search/address.json?query=" + encodeURIComponent(address), {
        headers: { "Authorization": "KakaoAK a00ede6619d31ceec6d8c6c353395bde" }
    })
    .then(response => response.json())
    .then(data => {
        if (data.documents.length > 0) {
            document.getElementById("latitude").value = data.documents[0].y;
            document.getElementById("longitude").value = data.documents[0].x;
        } else {
            alert("좌표를 찾을 수 없습니다.");
        }
    });
}