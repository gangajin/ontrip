package com.onTrip.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ScheduleDetailDto {
    private int scheduleDetailNum;        // 기본키 (PK)
    private Timestamp scheduleDetailDay;  // 방문 시간
    private String scheduleDetailMemo;    // 메모
    private int placeNum;                 // 장소 번호 (FK → place)
    private int scheduleNum;              // 일정 번호 (FK → schedule)
    
    private PlaceDto place;
}
