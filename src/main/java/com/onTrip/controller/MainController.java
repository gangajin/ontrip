package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.onTrip.dto.DestinationDto;
import com.onTrip.service.DestinationService;

@Controller
public class MainController {
	
	@Autowired
	private DestinationService destinationService;
	
	//Main페이지에서 지역명 뜨게하기(부산,서울,제주도)
	@RequestMapping("/")
	public String mainPage(Model model) {
        List<DestinationDto> destinationList = destinationService.getAllDestinations();
        model.addAttribute("destinationList", destinationList);
		return "main";
	}
}
