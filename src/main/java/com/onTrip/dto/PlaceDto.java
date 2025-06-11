package com.onTrip.dto;

import lombok.Data;

@Data
public class PlaceDto {
    private int placeNum;
    private String placeName ;
    private String placeCategory; 
    private String placeRoadAddr ;
    private String placeDetailAddr;
    private double placeLat;
    private double placeLong;
    private String placeImage;
    private String kakaoPlaceId;
    private String placeContent;
    private int destinationNum;
    private String placeExternalApiId;
    private int placelike;
    private double placeScore; 
}
