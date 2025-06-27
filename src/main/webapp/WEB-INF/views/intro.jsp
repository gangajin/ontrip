<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main</title>
<style>
  #intro-wrapper {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background-color: #00d2d3;
    z-index: 9999;
    overflow: hidden;
  }

  #plane {
    width: 240px;
    position: absolute;
    bottom: 40px;
    left: -200px;
    z-index: 10;
    opacity: 1;
  }

  #logo-text {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.8);
    font-size: 5rem;
    font-weight: bold;
    color: white;
    font-family: 'Poppins', sans-serif;
    opacity: 0;
    z-index: 20;
    white-space: nowrap;
  }
</style>
</head>
<body>

<!-- ✅ 로그인되어 있고 introShown이 false일 때만 인트로 표시 -->
<c:if test="${sessionScope.introShown == false}">
  <div id="intro-wrapper">
    <img src="/Image/plane.png" id="plane" />
    <div id="logo-text">On:trip</div>
  </div>

  <script>
    const plane = document.getElementById('plane');
    const logo = document.getElementById('logo-text');

    setTimeout(() => {
      plane.animate([{transform:'translate(0,0)',opacity:1},{transform:'translate(150vw,-80vh)',opacity:0}],{duration:2200,easing:'ease-in-out',fill:'forwards'});
    }, 300);

    setTimeout(() => {
      logo.animate([{opacity:0,transform:'translate(-50%,-50%) scale(0.8)'},{opacity:1,transform:'translate(-50%,-50%) scale(1)'}],{duration:1500,easing:'ease-out',fill:'forwards'});
    }, 1000);

    setTimeout(() => {
      fetch('/introComplete').then(() => {
        document.getElementById("intro-wrapper").style.display = "none";
      });
    }, 3500);
  </script>
</c:if>


</body>
</html>