package com.onTrip.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.PlaceDto;
import com.onTrip.service.DestinationService;
import com.onTrip.service.PlaceService;
import com.onTrip.service.ScheduleService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ScheduleController {

    @Autowired
    private DestinationService destinationService;

    @Autowired
    private PlaceService placeService;
    
    @Autowired
    private ScheduleService scheduleService;

    // STEP1
    @RequestMapping("/step1")
    public String step1(
            @RequestParam("destinationNum") int destinationNum,
            @RequestParam("destinationName") String destinationName,
            @RequestParam("scheduleStart") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
            @RequestParam("scheduleEnd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
            Model model) {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd(E)", Locale.KOREAN);
        DestinationDto destination = destinationService.getDestinationByNum(destinationNum);

        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("destinationName", destinationName);
        model.addAttribute("scheduleStart", scheduleStart.format(formatter));
        model.addAttribute("scheduleEnd", scheduleEnd.format(formatter));
        model.addAttribute("destinationLat", destination.getDestinationLat());
        model.addAttribute("destinationLong", destination.getDestinationLong());

        model.addAttribute("scheduleStartParam", scheduleStart.toString());
        model.addAttribute("scheduleEndParam", scheduleEnd.toString());

        return "Schedule/selectDate";
    }

    // STEP2
    @RequestMapping("/step2")
    public String step2(
            @RequestParam("destinationNum") int destinationNum,
            @RequestParam("destinationName") String destinationName,
            @RequestParam("scheduleStart") String scheduleStart,
            @RequestParam("scheduleEnd") String scheduleEnd,
            Model model) {

        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("destinationName", destinationName);
        model.addAttribute("scheduleStart", scheduleStart);
        model.addAttribute("scheduleEnd", scheduleEnd);

        // ✅ 장소 리스트 조회 후 model 에 추가
        List<PlaceDto> placeList = placeService.getPlaceByDestination(destinationNum);
        model.addAttribute("placeList", placeList);

        return "Schedule/selectPlace";
    }
    
    @PostMapping("/insertSchedule")
    @ResponseBody
    public int insertScheduleAjax(
        @RequestParam("destinationNum") int destinationNum,
        @RequestParam("scheduleStart") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
        @RequestParam("scheduleEnd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
        @RequestParam("userNum") int userNum
    ) {
        int scheduleNum = scheduleService.insertSchedule(destinationNum, scheduleStart, scheduleEnd, userNum);
        return scheduleNum;
    }
    
    //step3
    @PostMapping("/saveScheduleToSession")
    @ResponseBody
    public void saveScheduleToSession(
            @RequestParam("scheduleStart") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
            @RequestParam("scheduleEnd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
            HttpSession session) {

        session.setAttribute("scheduleStart", scheduleStart);
        session.setAttribute("scheduleEnd", scheduleEnd);
    }
}
