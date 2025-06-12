package com.onTrip.dto;

import java.util.Date;

import lombok.Data;

@Data
public class PlanDto {
	private int planNum;
    private Date planDate;
    private int userNum;
    private int scheduleNum;
    private int placeNum;

    // Place 정보 포함해서 장바구니 표시
    private String placeName;
    private String placeImage;
    private String placeRoadAddr;
    private String placeCategory;
}
