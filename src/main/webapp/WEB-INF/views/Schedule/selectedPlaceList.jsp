<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:forEach var="place" items="${selectedPlaceDtoList}" varStatus="status">
    <div class="selected-card d-flex justify-content-between align-items-center">
        <div>
            <strong>${status.index + 1}. ${place.placeName}</strong>
            <p class="card-text small text-muted mb-0">${place.placeRoadAddr}</p>
        </div>
        <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeSelectedPlace(${place.placeNum})">삭제</button>
    </div>
</c:forEach>
