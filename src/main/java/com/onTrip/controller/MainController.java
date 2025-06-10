package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dao.DestinationDao;
import com.onTrip.dto.DestinationDto;
import com.onTrip.service.DestinationService;

@Controller
public class MainController {
	
	@Autowired
	private DestinationService destinationService;
	
	
	//Main페이지에서 지역명 뜨게하기(부산,서울,제주도)
	@RequestMapping("/")
	public String mainPage(@RequestParam(value = "keyword", required = false) String keyword,
		    Model model) {
		  List<DestinationDto> destinationList;

	        if (keyword == null || keyword.isEmpty()) {
	            destinationList = destinationService.getAllDestinations();
	        } else {
	            destinationList = destinationService.searchDestination(keyword);
	        }

	        model.addAttribute("destinationList", destinationList);
	        return "main";
	    }
	}
