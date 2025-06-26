package com.onTrip.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
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
import com.onTrip.dto.ScheduleDto;
import com.onTrip.dto.StayHotelDto;
import com.onTrip.service.DestinationService;
import com.onTrip.service.PlaceService;
import com.onTrip.service.PlanService;
import com.onTrip.service.ScheduleService;
import com.onTrip.service.StayHotelService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ScheduleController {

    
    @Autowired
    private DestinationService destinationService;

    @Autowired
    private PlaceService placeService;
    
    @Autowired
    private ScheduleService scheduleService;
    
    @Autowired
    private PlanService planService;

    @Autowired
    private StayHotelService stayHotelService;
    // STEP1
    @RequestMapping("/step1")
    public String step1(
    		@RequestParam(value = "destinationNum", required = false) Integer destinationNum,
    	    @RequestParam(value = "destinationName", required = false) String destinationName,
    	    @RequestParam(value = "scheduleStart", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
    	    @RequestParam(value = "scheduleEnd", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
            Model model,
            HttpSession session) {

        DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("yyyy.MM.dd(E)", Locale.KOREAN);
        DateTimeFormatter urlFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        DestinationDto destination = destinationService.getDestinationByNum(destinationNum);

        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("destinationName", destinationName);
        model.addAttribute("scheduleStart", scheduleStart.format(displayFormatter));
        model.addAttribute("scheduleEnd", scheduleEnd.format(displayFormatter));
        model.addAttribute("scheduleStartParam", scheduleStart.format(urlFormatter));
        model.addAttribute("scheduleEndParam", scheduleEnd.format(urlFormatter)); 
        model.addAttribute("destinationLat", destination.getDestinationLat());
        model.addAttribute("destinationLong", destination.getDestinationLong());

        model.addAttribute("scheduleStartParam", scheduleStart.toString());
        model.addAttribute("scheduleEndParam", scheduleEnd.toString());

        session.setAttribute("destinationNum", destinationNum);
        session.setAttribute("destinationName", destinationName);
        session.setAttribute("scheduleStart", scheduleStart.toString());
        session.setAttribute("scheduleEnd", scheduleEnd.toString());

        return "Schedule/selectDate";
    }

    // STEP2 
    @RequestMapping("/step2")
    public String step2(
            @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
            @RequestParam(value="category", required=false, defaultValue="") String category,
            @RequestParam("destinationLat") double destinationLat,
            @RequestParam("destinationLong") double destinationLong,
            Model model,
            HttpSession session) {
    	
    	 Integer userNum = (Integer) session.getAttribute("userNum");
    	    if (userNum == null) {
    	        model.addAttribute("loginMessage", "로그인 이후 사용 가능합니다.");
    	        return "User/forceLogin";  // ✳️ alert 띄우는 전용 JSP로 이동
    	    }

        Integer destinationNum = (Integer) session.getAttribute("destinationNum");
        String destinationName = (String) session.getAttribute("destinationName");
        String scheduleStart = (String) session.getAttribute("scheduleStart");
        String scheduleEnd = (String) session.getAttribute("scheduleEnd");

        List<PlaceDto> placeList;
        if (!keyword.isEmpty()) {
            placeList = placeService.searchPlaceByKeyword(destinationNum, keyword);
        } else if (!category.isEmpty()) {
            if (category.equals("recommend")) {
                placeList = placeService.recommendPlace(destinationNum, List.of("attraction", "restaurant", "cafe"));
            } else {
                placeList = placeService.recommendPlace(destinationNum, List.of(category));
            }
        } else {
            placeList = placeService.recommendPlace(destinationNum, List.of("attraction", "restaurant", "cafe"));
        }

        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("destinationName", destinationName);
        model.addAttribute("scheduleStart", scheduleStart);
        model.addAttribute("scheduleEnd", scheduleEnd);
        model.addAttribute("placeList", placeList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);
        model.addAttribute("destinationLat", destinationLat);
        model.addAttribute("destinationLong", destinationLong);

        // ✅ 장바구니 리스트 추가
        Integer scheduleNum = (Integer) session.getAttribute("scheduleNum");

        if (userNum != null && scheduleNum != null) {
            List<PlaceDto> selectedPlaceDtoList = planService.selectPlacesInPlan(userNum, scheduleNum);
            model.addAttribute("selectedPlaceDtoList", selectedPlaceDtoList);
        } else {
            model.addAttribute("selectedPlaceDtoList", List.of());
        }
        
        // ✅ 마커 찍기용 리스트: Kakao 지도 출력용
        if (userNum != null && scheduleNum != null) {
            List<PlaceDto> planMarkerList = planService.selectPlanMarker(userNum, scheduleNum);  // 새 메서드
            model.addAttribute("planMarkerList", planMarkerList);
        } else {
            model.addAttribute("planMarkerList", List.of());
        }

        return "Schedule/selectPlace";
    }

    // AJAX - insertSchedule
    @PostMapping("/insertSchedule")
    @ResponseBody
    public int insertScheduleAjax(
        @RequestParam("destinationNum") int destinationNum,
        @RequestParam("scheduleStart") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
        @RequestParam("scheduleEnd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
        @RequestParam("userNum") int userNum,
        HttpSession session) {
        int scheduleNum = scheduleService.insertSchedule(destinationNum, scheduleStart, scheduleEnd, userNum);
        // ✅ scheduleNum 세션에 저장 → 장바구니에서 사용
        session.setAttribute("scheduleNum", scheduleNum);
        return scheduleNum;
    }

    // STEP3
    @PostMapping("/saveScheduleToSession")
    @ResponseBody
    public void saveScheduleToSession(
            @RequestParam("scheduleStart") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleStart,
            @RequestParam("scheduleEnd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate scheduleEnd,
            HttpSession session) {

        session.setAttribute("scheduleStart", scheduleStart.toString());
        session.setAttribute("scheduleEnd", scheduleEnd.toString());
    }
    
    @RequestMapping("/schedulePreview")
    public String previewSchedule(@RequestParam("scheduleNum") int scheduleNum, Model model) {
        ScheduleDto schedule = scheduleService.selectOneByScheduleNum(scheduleNum);
        List<PlaceDto> placeList = placeService.getPlacesByScheduleNum(scheduleNum);
        List<StayHotelDto> stayList = stayHotelService.getStayListByScheduleNum(scheduleNum);

        // 날짜 기준으로 숙소 정렬
        stayList.sort(Comparator.comparing(StayHotelDto::getStayHotelDate));

        // 날짜별 빈 일정 리스트 생성
        List<ScheduleDto> scheduleList = new ArrayList<>();
        LocalDate start = schedule.getScheduleStart();
        LocalDate end = schedule.getScheduleEnd();

        for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
            ScheduleDto daily = new ScheduleDto();
            daily.setScheduleStart(date);
            scheduleList.add(daily);
        }

        model.addAttribute("schedule", schedule);
        model.addAttribute("scheduleList", scheduleList);
        model.addAttribute("placeList", placeList);
        model.addAttribute("stayList", stayList); // 👈 List로 전달

        return "Schedule/preview";
    }
}
