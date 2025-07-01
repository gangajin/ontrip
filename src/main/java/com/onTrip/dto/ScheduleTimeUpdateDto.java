package com.onTrip.dto;

import lombok.Data;

@Data
public class ScheduleTimeUpdateDto {
	private int scheduleDetailNum;
    private String newDateTime;
}
