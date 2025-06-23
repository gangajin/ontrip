<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>신규 장소 등록</title>
  <link rel="stylesheet" href="/CSS/insertPlace.css">
  <script type="text/javascript" src="/js/placeCheck.js"></script>
</head>
<body>
<%@ include file="../header.jsp" %>
<div class="container">
  <div class="form-box">
    <h2>📍 신규 장소 등록</h2>

    <form action="/admin/includeinsertArea" method="post" enctype="multipart/form-data">
      <table class="form-table">
        <tr>
          <td>장소명:</td>
          <td><input type="text" name="placeName" required></td>
        </tr>

        <tr>
          <td>카테고리:</td>
          <td>
            <select name="placeCategory">
              <option value="attraction">명소</option>
              <option value="restaurant">식당</option>
              <option value="cafe">카페</option>
            </select>
          </td>
        </tr>

        <tr>
          <td>기본주소:</td>
          <td>
            <div class="addr-group">
              <input type="text" id="placeRoadAddr" name="placeRoadAddr" required>
              <button type="button" class="addr-btn" onclick="goPopup();">주소검색</button>
            </div>
          </td>
        </tr>

        <tr>
          <td>상세 주소:</td>
          <td><input type="text" id="placeDetailAddr" name="placeDetailAddr" required></td>
        </tr>

        <tr>
          <td>위도:</td>
          <td><input type="text" id="latitude" name="placeLat" readonly></td>
        </tr>

        <tr>
          <td>경도:</td>
          <td><input type="text" id="longitude" name="placeLong" readonly></td>
        </tr>

        <tr>
          <td>이미지:</td>
          <td><input type="file" name="placeImageFile"></td>
        </tr>

        <tr>
          <td>설명:</td>
          <td><textarea name="placeContent" rows="3"></textarea></td>
        </tr>

        <tr>
          <td>지역번호:</td>
          <td>
            <input type="number" value="${destinationNum}" disabled>
            <input type="hidden" name="destinationNum" value="${destinationNum}">
          </td>
        </tr>

        <tr>
          <td>좋아요수:</td>
          <td><input type="number" name="placelike" value="0"></td>
        </tr>

        <tr>
          <td>별점:</td>
          <td><input type="number" name="placeScore" value="0" step="0.1" min="0" max="5"></td>
        </tr>
      </table>

      <div class="button-group">
        <button type="button" onclick="getCoordinates()">좌표 자동입력</button>
        <button type="submit">등록</button>
      </div>
    </form>
  </div>
</div>

</body>
</html>