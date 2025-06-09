package com.onTrip.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ScheduleDto {
	private int scheduleNum;
	private LocalDate scheduleStart;
	private LocalDate scheduleEnd;
	private LocalDateTime scheduleCreated;
	private int userNum;
	private int destinationNum;

}
