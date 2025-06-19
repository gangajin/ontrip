package com.onTrip.controller;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.PlaceDto;
import com.onTrip.dto.ScheduleDetailDto;
import com.onTrip.dto.ScheduleDto;
import com.onTrip.dto.StayHotelDto;
import com.onTrip.service.OpenAiService;
import com.onTrip.service.PlaceService;
import com.onTrip.service.ScheduleDetailService;
import com.onTrip.service.ScheduleService;
import com.onTrip.service.StayHotelService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AiScheduleController {

    @Autowired
    private PlaceService placeService;

    @Autowired
    private StayHotelService stayHotelService;

    @Autowired
    private ScheduleService scheduleService;

    @Autowired
    private ScheduleDetailService scheduleDetailService;

    @Autowired
    private OpenAiService openAiService;

    @PostMapping("/generateAiSchedule")
    public String generateAiSchedule(@RequestParam("scheduleNum") int scheduleNum,
                                     @RequestParam("transportType") String transportType,
                                     HttpSession session) {

        List<PlaceDto> placeList = placeService.getPlacesByScheduleNum(scheduleNum);

        List<PlaceDto> hotelPlaceList = new ArrayList<>();
        List<StayHotelDto> hotelList = stayHotelService.getStayListByScheduleNum(scheduleNum);

        for (StayHotelDto hotel : hotelList) {
            PlaceDto hotelPlace = new PlaceDto();
            hotelPlace.setPlaceNum(hotel.getPlaceNum());
            hotelPlace.setPlaceName(hotel.getPlaceName());
            hotelPlace.setPlaceLat(hotel.getPlaceLat());
            hotelPlace.setPlaceLong(hotel.getPlaceLong());
            hotelPlace.setPlaceRoadAddr("호텔 주소 미정");
            hotelPlace.setPlaceCategory("hotel");
            hotelPlaceList.add(hotelPlace);
        }

        List<PlaceDto> fullPlaceList = new ArrayList<>();
        fullPlaceList.addAll(placeList);
        fullPlaceList.addAll(hotelPlaceList);

        ScheduleDto schedule = scheduleService.selectOneByScheduleNum(scheduleNum);
        LocalDate startDate = schedule.getScheduleStart();
        LocalDate endDate = schedule.getScheduleEnd();

        String prompt = openAiService.buildAiPrompt(
                fullPlaceList,
                transportType,
                startDate.toString(),
                endDate.toString()
        );

        List<String> orderedNames = openAiService.getOrderedPlaceNames(prompt);
        List<PlaceDto> orderedList = openAiService.matchOrderedPlaces(orderedNames, fullPlaceList);

        System.out.println("✅ GPT 응답: " + orderedNames);
        for (PlaceDto place : orderedList) {
            System.out.println("✅ 정렬된 장소명: " + place.getPlaceName());
        }

        LocalDateTime startTime = startDate.atTime(9, 0);
        for (int i = 0; i < orderedList.size(); i++) {
            ScheduleDetailDto detail = new ScheduleDetailDto();
            detail.setScheduleNum(scheduleNum);
            detail.setPlaceNum(orderedList.get(i).getPlaceNum());
            detail.setScheduleDetailDay(Timestamp.valueOf(startTime.plusHours(i * 2)));
            detail.setScheduleDetailMemo("");
            scheduleDetailService.insert(detail);
        }

        return "redirect:/aiPreview?scheduleNum=" + scheduleNum;
    }

    @GetMapping("/aiPreview")
    public String previewSchedule(@RequestParam("scheduleNum") int scheduleNum, Model model) {
        List<ScheduleDetailDto> detailList = scheduleDetailService.getScheduleDetailsWithPlace(scheduleNum);

        Map<String, List<ScheduleDetailDto>> groupedByDate = new LinkedHashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (ScheduleDetailDto detail : detailList) {
            String dateKey = detail.getScheduleDetailDay().toLocalDateTime().toLocalDate().format(formatter);
            groupedByDate.computeIfAbsent(dateKey, k -> new ArrayList<>()).add(detail);
        }

        model.addAttribute("groupedDetailMap", groupedByDate);
        model.addAttribute("detailList", detailList);
        return "Schedule/AiPreview";
    }
}
