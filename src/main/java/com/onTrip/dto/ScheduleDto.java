package com.onTrip.dto;

import java.time.LocalDate;
import java.util.Date;

import lombok.Data;

@Data
public class ScheduleDto {
	private int scheduleNum;
	private LocalDate scheduleStart;
	private LocalDate scheduleEnd;
	private Date scheduleCreated;
	private int userNum;
	private int destinationNum;
	private String destinationName;
	private double destinationLat;
	private double destinationLong;

	
}
