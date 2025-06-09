<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>    
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>여행 일정 확인</title>
</head>
<body>
	<h2>여행 일정 확인(STEP1)</h2>
  	<h2>${destinationName}</h2>
  	<p>${scheduleStart} ~ ${scheduleEnd}</p>

  	<a href="https://www.skyscanner.co.kr/" target="_blank"><button>항공</button></a>
  	<a href="https://kr.trip.com/?locale=ko-KR&curr=KRW" target="_blank"><button>숙소</button></a>

 	<div id="map" style="width:100%; height:400px; margin-top:20px;"></div>

  	<script type="text/javascript" 
    	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=51c4a2ab2dc8447ff9c8ce7270d89439&autoload=false&libraries=services">
  	</script>
  	<script>
	    kakao.maps.load(function () {
	      const lat = parseFloat("${destinationLat}");
	      const lng = parseFloat("${destinationLong}");
	
	      const container = document.getElementById('map');
	      const options = {
	        center: new kakao.maps.LatLng(lat, lng),
	        level: 9
	      };
	
	      const map = new kakao.maps.Map(container, options);
	    });
	  </script>

</body>
</html>
