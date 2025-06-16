<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 장소 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; padding: 20px; }
        .table th, .table td { vertical-align: middle; }
    </style>
</head>
<body>

    <h2 class="mb-4">장소 관리 (관리자)</h2>

	<form action="/admin/place/search" method="get" class="mb-4 row gx-2 align-items-center">
	    <!-- 지역 필터 -->
	    <div class="col-auto">
	        <label for="destinationNum" class="form-label mb-0">지역 필터:</label>
	    </div>
	    <div class="col-auto" style="min-width: 160px;">
	        <select name="destinationNum" id="destinationNum" class="form-select form-select-sm">
	            <option value="">전체</option>
	            <c:forEach var="destination" items="${destinationList}">
	                <option value="${destination.destinationNum}"
	                    <c:if test="${destination.destinationNum == selectedDestinationNum}">selected</c:if>>
	                    ${destination.nameKo}
	                </option>
	            </c:forEach>
	        </select>
	    </div>
	
	    <!-- 검색어 입력 -->
	    <div class="col" style="max-width: 400px;">
	        <input type="text" name="keyword" class="form-control form-control-sm"
	               placeholder="장소명 또는 도로명 주소 입력" value="${keyword}">
	    </div>
	
	    <!-- 검색 버튼 -->
	    <div class="col-auto">
	        <button type="submit" class="btn btn-primary btn-sm">검색</button>
	    </div>
	</form>


    <!-- 장소 리스트 -->
    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>장소명</th>
                <th>카테고리</th>
                <th>주소</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="place" items="${placeList}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${place.placeName}</td>
                    <td>${place.placeCategory}</td>
                    <td>${place.placeRoadAddr}</td>
                    <td>
                        <form action="/admin/place/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="placeNum" value="${place.placeNum}">
                            <!-- 현재 destinationNum 유지 -->
                            <input type="hidden" name="destinationNum" value="${selectedDestinationNum}">
                            <button type="submit" class="btn btn-sm btn-danger">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <!-- 장소 없을 경우 -->
    <c:if test="${empty placeList}">
        <div class="alert alert-info mt-3">장소가 없습니다.</div>
    </c:if>
    
    <!-- 페이징 영역 -->
	<div class="d-flex justify-content-center mt-4">
	    <nav>
	        <ul class="pagination">
	            <c:forEach var="i" begin="1" end="${totalPages}">
	                <c:choose>
	                    <c:when test="${i == currentPage}">
	                        <li class="page-item active">
	                            <a class="page-link" href="/admin/place/list?page=${i}<c:if test='${not empty selectedDestinationNum}'>&destinationNum=${selectedDestinationNum}</c:if>">${i}</a>
	                        </li>
	                    </c:when>
	                    <c:otherwise>
	                        <li class="page-item">
	                            <a class="page-link" href="/admin/place/list?page=${i}<c:if test='${not empty selectedDestinationNum}'>&destinationNum=${selectedDestinationNum}</c:if>">${i}</a>
	                        </li>
	                    </c:otherwise>
	                </c:choose>
	            </c:forEach>
	        </ul>
	    </nav>
	</div>

</body>
</html>