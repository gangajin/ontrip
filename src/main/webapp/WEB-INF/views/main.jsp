<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>On:trip</title>
  <meta name="description" content="">
  <meta name="keywords" content="">

  <!-- Favicons -->
  <link href="Image/header/logo2.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Fonts -->
  <link href="https://fonts.googleapis.com" rel="preconnect">
  <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Raleway:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
  <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

  <!-- Main CSS File -->
  <link href="assets/css/main.css" rel="stylesheet">
  <link href="CSS/header.css" rel="stylesheet">
  <link href="/CSS/Main-destination.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"  rel="stylesheet" >

  <!-- =======================================================
  * Template Name: Moderna
  * Template URL: https://bootstrapmade.com/free-bootstrap-template-corporate-moderna/
  * Updated: Aug 07 2024 with Bootstrap v5.3.3
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->
</head>
<body class="index-page">
<c:if test="${not empty sessionScope.loginUser and sessionScope.introShown eq false}">
  <jsp:include page="/WEB-INF/views/intro.jsp" />  
</c:if>

<header id="header" class="header d-flex align-items-center fixed-top">
  <div class="container-fluid container-xl position-relative d-flex align-items-center justify-content-between">

    <!-- 로고 -->
    <a href="/" class="logo d-flex align-items-center">
      <h1 class="sitename">On:trip</h1>
    </a>

    <!-- 좌측 메뉴 -->
    <nav id="navmenu" class="navmenu d-flex align-items-center">
      <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
    </nav>

    <!-- 로그인/마이페이지 UI -->
    <div class="header-right d-flex align-items-center ms-3 position-relative">
      <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
          <div class="user-menu-container d-flex align-items-center gap-3">
            <div class="welcome-message">
              ${sessionScope.loginUser.userNickname}님 환영합니다
            </div>
            <div class="user-icon" onclick="toggleUserMenu()" style="cursor: pointer;">
              <img src="/Image/header/icon.png" alt="유저 아이콘" style="width: 30px; height: 30px;" />
            </div>
            <div id="userDropdown" class="user-dropdown position-absolute bg-white border rounded shadow p-2" style="top: 40px; right: 0; display: none; min-width: 150px;">
             <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#guideModal">이용방법 보기</a>
              <a href="/user/myPage" class="dropdown-item">마이페이지</a>
              <c:if test="${sessionScope.loginUser.userRole eq 'admin'}">
                <a href="/adminMain" class="dropdown-item">관리자 페이지</a>
              </c:if>
              <c:if test="${sessionScope.loginUser.userRole ne 'admin'}">
                <a href="/inquiryList" class="dropdown-item">1:1 문의</a>
              </c:if>
              <a href="/logout" class="dropdown-item">로그아웃</a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <button type="button" class="btn btn-outline-primary ms-2" data-bs-toggle="modal" data-bs-target="#guideModal">이용방법 보기</button>
          <a href="/login" class="btn btn-outline-primary ms-2">로그인</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

	<!-- 모달 -->
<div class="modal fade" id="guideModal" tabindex="-1" aria-labelledby="guideModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="guideModalLabel">이용 가이드</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <!-- Carousel -->
        <div id="guideCarousel" class="carousel slide" data-bs-ride="carousel">
          <div class="carousel-inner">
            <div class="carousel-item active">
              <img src="/Image/capture/guide1.png" class="d-block w-100" alt="가이드1">
            </div>
            <div class="carousel-item">
              <img src="/Image/capture/guide2.png" class="d-block w-100" alt="가이드2">
            </div>
            <div class="carousel-item">
              <img src="/Image/capture/guide3.png" class="d-block w-100" alt="가이드3">
            </div>
            <div class="carousel-item">
              <img src="/Image/capture/guide4.png" class="d-block w-100" alt="가이드4">
            </div>
            <div class="carousel-item">
              <img src="/Image/capture/guide6.png" class="d-block w-100" alt="가이드5">
            </div>
            <div class="carousel-item">
              <img src="/Image/capture/guide7.png" class="d-block w-100" alt="가이드6">
            </div>
            <div class="carousel-item">
              <img src="/Image/capture/guide8.png" class="d-block w-100" alt="가이드7">
            </div>
          </div>
          <!-- 슬라이드 컨트롤 -->
          <button class="carousel-control-prev" type="button" data-bs-target="#guideCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">이전</span>
          </button>
          <button class="carousel-control-next" type="button" data-bs-target="#guideCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">다음</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

  <main class="main">

    <!-- Hero Section -->
    <section id="hero" class="hero section dark-background">

<!--       <img src="assets/img/hero-bg.jpg" alt="" data-aos="fade-in"> -->

      <div id="hero-carousel" class="carousel carousel-fade" data-bs-ride="carousel" data-bs-interval="5000">

        <div class="container position-relative">

          <div class="carousel-item active">
            <div class="carousel-container">
              <h2>Welcome to On:trip</h2>
              <p>여행, 어렵게 계획하지 마세요. AI가 여러분의 취향과 장소에 맞춰 하루 일정을 자동으로 만들어드립니다. 숙소부터 맛집, 명소까지—알아서 착착! 이제는 여행도 스마트하게 즐겨보세요. </p>
              <a href="#dest" class="btn-get-started">여행지 선택</a>
            </div>
          </div><!-- End Carousel Item -->

          <div class="carousel-item">
            <div class="carousel-container">
              <h2>함께 만들어가는 우리 팀을 소개합니다.</h2>
              <p>기획부터 개발, 디자인까지! 각자의 자리에서 열정을 다해 여행을 더 즐겁고 편리하게 만들고 있는 든든한 팀원들입니다.</p>
              <a href="#team" class="btn-get-started">함께한 팀원들</a>
            </div>
          </div><!-- End Carousel Item -->

          <a class="carousel-control-prev" href="#hero-carousel" role="button" data-bs-slide="prev">
            <span class="carousel-control-prev-icon bi bi-chevron-left" aria-hidden="true"></span>
          </a>

          <a class="carousel-control-next" href="#hero-carousel" role="button" data-bs-slide="next">
            <span class="carousel-control-next-icon bi bi-chevron-right" aria-hidden="true"></span>
          </a>

          <ol class="carousel-indicators"></ol>

        </div>

      </div>

    </section><!-- /Hero Section -->

    <!-- Featured Services Section -->
    
    <!-- 여행지 검색 및 달력 선택 섹션 -->
	<section class="destination-search-section py-5" id="dest">
	  <form id="calendarForm" action="/step1" method="get">
	    <input type="hidden" name="destinationNum" id="destinationNum">
	    <input type="hidden" name="destinationName" id="destinationName">
	    <input type="hidden" name="scheduleStart" id="scheduleStart">
	    <input type="hidden" name="scheduleEnd" id="scheduleEnd">
	  </form>
	
	  <div class="container">
	    <div class="search-box mb-4">
	      <form action="/" method="get">
	        <div class="search-input-wrapper">
	          <input type="text" name="keyword" placeholder="여행하고 싶은 도시명을 검색해보세요." />
	          <button type="submit"><i class="fas fa-search"></i></button>
	        </div>
	      </form>
	    </div>
	
	    <div class="destination-container row gy-4">
	      <c:forEach var="destination" items="${destinationList}">
	        <div class="col-lg-3 col-md-4">
	          <div class="destination-card" onclick="openCalendarWithForm(${destination.destinationNum}, '${destination.nameKo}')">
	            <img src="${destination.destinationImage}" alt="${destination.nameKo}" class="destination-img">
	            <div class="destination-name-en">${destination.nameEn}</div>
	            <div class="destination-name-ko">${destination.nameKo}</div>
	          </div>
	        </div>
	      </c:forEach>
	    </div>
	  </div>
	</section>
	
	<!-- ✨ 달력 모달 -->
	<div id="calendarOverlay" class="calendar-overlay" style="display: none;"></div>
	<div id="calendarModal" class="calendar-modal" style="display: none;">
	  <div class="calendar-box">
	    <h4 class="calendar-title">여행 기간이 어떻게 되시나요?</h4>
	    <p class="calendar-subtitle">
	      * 여행 일자는 최대 <strong style="color:#000">10일</strong>까지 설정 가능합니다.<br>
	      현재 여행 기간(<span style="font-weight:600">여행지 도착 날짜, 여행지 출발 날짜</span>)으로 입력해 주세요.
	    </p>
	    <input type="text" id="datePicker" />
	    <div class="calendar-btn-group">
	      <button id="cancelBtn" class="calendar-btn cancel">닫기</button>
	      <button id="confirmBtn" class="calendar-btn confirm" disabled>선택</button>
	    </div>
	  </div>
	</div>
  </main>
  
  <!-- Section Title -->
  <section id="team" class="team section">
      <div class="container section-title" data-aos="fade-up">
        <h2>함께한 팀원들</h2>
      </div><!-- End Section Title -->

      <div class="container" style="margin-left: 330px;">

        <div class="row">

          <div class="col-md-4 d-flex" data-aos="fade-up" data-aos-delay="100">
            <div class="member">
              <img src="/assets/img/team/jiho.jpg" class="img-fluid" alt="" style="width: 170px; height: auto;">
              <div class="member-content">
                <h4>류지호</h4>
                <span>팀원</span>
                <div class="social">
                  <a href="https://www.instagram.com/_g_.h0/" target="_blank"><i class="bi bi-instagram"></i></a>
                  <a href="#"><i class="bi bi-facebook"></i></a>
                  <a href="#"><i class="bi bi-twitter-x"></i></a>
                  <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
              </div>
            </div>
          </div><!-- End Team Member -->

          <div class="col-lg-4 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="200">
            <div class="member">
              <img src="/assets/img/team/gangjin.jpg" class="img-fluid" alt="" style="width: 160px; height: auto;">
              <div class="member-content">
                <h4>이강진</h4>
                <span>팀장</span>
                <div class="social">
                  <a href="https://www.instagram.com/gang_a_jin_/" target="_blank"><i class="bi bi-instagram"></i></a>
                  <a href="#"><i class="bi bi-facebook"></i></a>
                  <a href="#"><i class="bi bi-twitter-x"></i></a>
                  <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
              </div>
            </div>
          </div><!-- End Team Member -->

          <div class="col-lg-4 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="300">
            <div class="member">
              <img src="/assets/img/team/Sangjun.jpg" class="img-fluid" alt="" style="width: 180px; height: auto;">
              <div class="member-content">
                <h4>박상준</h4>
                <span>팀원</span>
                <div class="social">
                  <a href="https://www.instagram.com/ps.j0_0n/" target="_blank"><i class="bi bi-instagram"></i></a>
                  <a href="#"><i class="bi bi-facebook"></i></a>
                  <a href="#"><i class="bi bi-twitter-x"></i></a>
                  <a href="#"><i class="bi bi-linkedin"></i></a>
                </div>
              </div>
            </div>
          </div><!-- End Team Member -->

        </div>

      </div>

    </section><!-- /Team Section -->

  <footer id="footer" class="footer dark-background">

    <div class="container footer-top">
      <div class="row gy-4">
        <div class="col-lg-4 col-md-6 footer-about">
          <a href="index.html" class="d-flex align-items-center">
            <span class="sitename">On:trip</span>
          </a>
          <div class="footer-contact pt-3">
            <p>부산광역시</p>
            <p>부산진구 중앙대로627 2,12층</p>
            <p><strong>Git:</strong> <span>https://github.com/on-Trip/onTrip.git</span></p>
          </div>
        </div>

        <div class="col-lg-2 col-md-3 footer-links">
          <h4>Useful Links</h4>
          <ul>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Home</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="#">About us</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Services</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Terms of service</a></li>
          </ul>
        </div>

        <div class="col-lg-2 col-md-3 footer-links">
          <h4>Our Services</h4>
          <ul>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Web Design</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Web Development</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Product Management</a></li>
            <li><i class="bi bi-chevron-right"></i> <a href="#">Marketing</a></li>
          </ul>
        </div>

        <div class="col-lg-4 col-md-12">
          <h4>Follow Us</h4>
          <p>Cras fermentum odio eu feugiat lide par naso tierra videa magna derita valies</p>
          <div class="social-links d-flex">
            <a href=""><i class="bi bi-twitter-x"></i></a>
            <a href=""><i class="bi bi-facebook"></i></a>
            <a href=""><i class="bi bi-instagram"></i></a>
            <a href=""><i class="bi bi-linkedin"></i></a>
          </div>
        </div>

      </div>
    </div>

  </footer>

  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Preloader -->
  <div id="preloader"></div>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>
  <script src="assets/vendor/aos/aos.js"></script>
  <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
  <script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>
  <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>
  <script src="assets/vendor/waypoints/noframework.waypoints.js"></script>
  <script src="assets/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
  <script src="assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>

  <!-- Main JS File -->
  <script src="assets/js/main.js"></script>
  <script src="/JS/header.js"></script>
  <script src="/JS/Main-selectDate.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

</body>
</html>