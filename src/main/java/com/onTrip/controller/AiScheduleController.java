package com.onTrip.controller;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.onTrip.dto.*;
import com.onTrip.service.*;

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
    private DestinationService destinationService;

    @Autowired
    private OpenAiService openAiService;

    @PostMapping("/generateAiSchedule")
    public String generateAiSchedule(@RequestParam("scheduleNum") int scheduleNum,
                                     @RequestParam("transportType") String transportType,
                                     HttpSession session) {

        // 장소 조회
        List<PlaceDto> placeList = placeService.getPlacesByScheduleNum(scheduleNum);
        List<StayHotelDto> hotelDtoList = stayHotelService.getStayListByScheduleNum(scheduleNum);
        List<PlaceDto> hotelList = new ArrayList<>();

        for (StayHotelDto hotel : hotelDtoList) {
            PlaceDto dto = new PlaceDto();
            dto.setPlaceNum(hotel.getPlaceNum());
            dto.setPlaceName(hotel.getPlaceName());
            dto.setPlaceLat(hotel.getPlaceLat());
            dto.setPlaceLong(hotel.getPlaceLong());
            dto.setPlaceRoadAddr("호텔 주소 미정");
            dto.setPlaceCategory("hotel");
            hotelList.add(dto);
        }

        // 일정 조회
        ScheduleDto schedule = scheduleService.selectOneByScheduleNum(scheduleNum);
        LocalDate startDate = schedule.getScheduleStart();
        LocalDate endDate = schedule.getScheduleEnd();
        int totalDays = (int) (endDate.toEpochDay() - startDate.toEpochDay() + 1);

        // 도시 기반 역 정보
        int destinationNum = schedule.getDestinationNum();
        PlaceDto station = placeService.getStationByDestination(destinationNum);
        PlaceDto startStation = new PlaceDto(station);
        PlaceDto endStation = new PlaceDto(station);

        // GPT 응답
        List<PlaceDto> fullList = new ArrayList<>(placeList);
        fullList.addAll(hotelList);
        String prompt = openAiService.buildAiPrompt(fullList, transportType, startDate.toString(), endDate.toString());
        List<String> orderedNames = openAiService.getOrderedPlaceNames(prompt);
        List<PlaceDto> orderedList = openAiService.matchOrderedPlaces(orderedNames, fullList);

        // 분류
        List<PlaceDto> filteredHotels = new ArrayList<>();
        List<PlaceDto> nonHotels = new ArrayList<>();
        for (PlaceDto place : orderedList) {
            if ("hotel".equalsIgnoreCase(place.getPlaceCategory())) {
                filteredHotels.add(place);
            } else if (!"station".equalsIgnoreCase(place.getPlaceCategory())) {
                nonHotels.add(place);
            }
        }

        Set<Integer> visited = new HashSet<>();
        PlaceDto prevHotel = null;
        int idx = 0;

        // 일정 생성
        for (int d = 0; d < totalDays; d++) {
            LocalDate currentDate = startDate.plusDays(d);
            LocalDateTime currentTime = currentDate.atTime(9, 0);

            // 첫날: 역에서 출발
            if (d == 0) {
                insert(scheduleNum, startStation, currentTime);
                visited.add(startStation.getPlaceNum());
                currentTime = currentTime.plusHours(2);
            }

            // 2일차 이상: 전날 숙소에서 출발
            if (d > 0 && prevHotel != null) {
                insert(scheduleNum, prevHotel, currentTime);
                currentTime = currentTime.plusHours(2);
            }

            // 명소 분배
            int placeCountPerDay = (int) Math.ceil((double) nonHotels.size() / totalDays);
            int added = 0;
            while (added < placeCountPerDay && idx < nonHotels.size()) {
                PlaceDto place = nonHotels.get(idx++);
                if (!visited.contains(place.getPlaceNum())) {
                    insert(scheduleNum, place, currentTime);
                    visited.add(place.getPlaceNum());
                    currentTime = currentTime.plusHours(2);
                    added++;
                }
            }

            // 마지막 날은 역으로 끝냄 (숙소에서 출발한 건 위에서 처리함)
            if (d == totalDays - 1) {
                insert(scheduleNum, endStation, currentTime);
            } else {
                // 그 외 날은 숙소로 끝냄
                if (d < filteredHotels.size()) {
                    PlaceDto hotel = filteredHotels.get(d);
                    if (!visited.contains(hotel.getPlaceNum())) {
                        insert(scheduleNum, hotel, currentTime);
                        visited.add(hotel.getPlaceNum());
                        prevHotel = hotel;
                    }
                }
            }
        }

        return "redirect:/aiPreview?scheduleNum=" + scheduleNum;
    }





    private void insert(int scheduleNum, PlaceDto place, LocalDateTime time) {
        ScheduleDetailDto detail = new ScheduleDetailDto();
        detail.setScheduleNum(scheduleNum);
        detail.setPlaceNum(place.getPlaceNum());
        detail.setScheduleDetailDay(Timestamp.valueOf(time));
        detail.setScheduleDetailMemo("");
        scheduleDetailService.insert(detail);
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
