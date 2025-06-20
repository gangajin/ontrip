package com.onTrip.dto;

import lombok.Data;
@Data
public class PlaceDto {
    private int placeNum;
    private String placeName ;
    private String placeCategory; 
    private String placeRoadAddr;
    private String placeDetailAddr;
    private double placeLat;
    private double placeLong;
    private String placeImage;
    private String kakaoPlaceId;
    private String placeContent;
    private int destinationNum;
    private String placeExternalApiId;
    private Integer placelike;
    private double placeScore; 
    
    // ✅ 복사 생성자 추가
    public PlaceDto(PlaceDto other) {
    	
        this.placeNum = other.placeNum;
        this.placeName = other.placeName;
        this.placeCategory = other.placeCategory;
        this.placeRoadAddr = other.placeRoadAddr;
        this.placeLat = other.placeLat;
        this.placeLong = other.placeLong;
    }
    
    public PlaceDto() {}
}
