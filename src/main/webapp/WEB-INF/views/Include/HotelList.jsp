<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 숙소 리스트 출력 -->
<c:if test="${not empty hotelList}">
<c:out value="리스트 개수: ${fn:length(hotelList)}" /><br/>
  <table class="table table-bordered bg-white">
  <c:forEach var="hotel" items="${hotelList}">
  <tr>
    <td rowspan="3" style="width: 120px;">
      <c:choose>
        <c:when test="${not empty hotel.placeImage}">
          <img src="${pageContext.request.contextPath}${hotel.placeImage}" width="100%" height="100px" />
        </c:when>
        <c:otherwise>
          <img src="${pageContext.request.contextPath}/Image/default.png" width="100%" height="100px" />
        </c:otherwise>
      </c:choose>
    </td>

    <!-- 이름 + 버튼 같이 넣은 셀 -->
    <td colspan="2">
      <div style="display: flex; justify-content: space-between; align-items: center;">
        <b>${fn:escapeXml(hotel.placeName)}</b>
        <button type="button"
          class="btn btn-outline-primary"
          onclick="openModal('${hotel.placeNum}', '${fn:escapeXml(hotel.placeName)}', '${hotel.placeLat}', '${hotel.placeLong}')">
          +
        </button>
      </div>
    </td>
  </tr>

  <!-- 주소 -->
  <tr>
    <td colspan="2">${fn:escapeXml(hotel.placeRoadAddr)}</td>
  </tr>

  <!-- 평점 + 좋아요 -->

<tr>
  <td colspan="2">
    <i class="fa-solid fa-star text-warning"></i>
    <c:choose>
      <c:when test="${not empty hotel.placeScore}">
        <fmt:formatNumber value="${hotel.placeScore}" type="number" maxFractionDigits="1"/>
      </c:when>
      <c:otherwise>0.0</c:otherwise>
    </c:choose>
    &nbsp;&nbsp;
    <i class="fa-solid fa-heart text-danger"></i> ${hotel.placelike}
  </td>
</tr>

</c:forEach>
  </table>
</c:if>

	<c:if test="${not empty travelDates}">
	  <script>
	    travelDates = [
	      <c:forEach var="d" items="${travelDates}" varStatus="loop">
	        '${d}'<c:if test="${!loop.last}">,</c:if>
	      </c:forEach>
	    ];
	  </script>
	</c:if>
<c:if test="${empty travelDates}">
  <script>travelDates = [];</script>
</c:if>
<c:if test="${empty hotelList}">
  <p>검색 결과가 없습니다.</p>
</c:if>