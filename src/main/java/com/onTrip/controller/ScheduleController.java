package com.onTrip.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.DestinationDto;
import com.onTrip.service.DestinationService;

@Controller
public class ScheduleController {
	@Autowired
	private DestinationService destinationService;
	
	//달력 + 지역 넘기는 페이지
	@RequestMapping("/step1")
	public String step1(
			@RequestParam("destinationNum") int destinationNum,
			@RequestParam("destinationName") String destinationName,
			@RequestParam("scheduleStart") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
			@RequestParam("scheduleEnd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
			Model model
			) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd(E)", Locale.KOREAN);
		DestinationDto destination = destinationService.getDestinationByNum(destinationNum);
		
		model.addAttribute("destinationNum", destinationNum);
		model.addAttribute("destinationName", destinationName);
		model.addAttribute("scheduleStart", scheduleStart.format(formatter));
		model.addAttribute("scheduleEnd", scheduleEnd.format(formatter));
		model.addAttribute("destinationLat", destination.getDestinationLat());
		model.addAttribute("destinationLong", destination.getDestinationLong());
		
		return "Schedule/selectDate";
	}
	
	//STEP1

	
	//STEP2

	
	//STEP3
	
}
