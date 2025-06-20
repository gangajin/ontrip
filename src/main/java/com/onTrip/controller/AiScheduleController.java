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

    /**
     * GPT 기반 자동 일정 생성 엔드포인트
     * 일정 규칙: 
     * - 첫날: 기차역 → 카페 → 식당 → 명소들 → 호텔
     * - 마지막날: 호텔 → 카페 → 식당 → 명소들 → 기차역
     * - 중간날: 호텔 → 카페 → 식당 → 명소들 → 호텔
     * - 10시 시작, 22시 종료
     */
    @PostMapping("/generateAiSchedule")
    public String generateAiSchedule(@RequestParam("scheduleNum") int scheduleNum,
                                     @RequestParam("transportType") String transportType,
                                     HttpSession session) {

        // 1. 유저가 선택한 장소 및 호텔 리스트 조회
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

        // 2. 일정 정보 및 날짜 계산
        ScheduleDto schedule = scheduleService.selectOneByScheduleNum(scheduleNum);
        LocalDate startDate = schedule.getScheduleStart();
        LocalDate endDate = schedule.getScheduleEnd();
        int totalDays = (int) (endDate.toEpochDay() - startDate.toEpochDay() + 1);

        // 3. 기차역 정보 조회 (도시 기준)
        int destinationNum = schedule.getDestinationNum();
        PlaceDto station = placeService.getStationByDestination(destinationNum);

        // 4. GPT로 정렬된 장소 순서 받아오기
        List<PlaceDto> fullList = new ArrayList<>(placeList);
        fullList.addAll(hotelList);
        String prompt = openAiService.buildAiPrompt(fullList, transportType, startDate.toString(), endDate.toString());
        List<String> orderedNames = openAiService.getOrderedPlaceNames(prompt);
        List<PlaceDto> orderedList = openAiService.matchOrderedPlaces(orderedNames, fullList);

        // 5. 카테고리별 분류
        List<PlaceDto> cafes = new ArrayList<>();
        List<PlaceDto> restaurants = new ArrayList<>();
        List<PlaceDto> attractions = new ArrayList<>();
        List<PlaceDto> hotels = new ArrayList<>();

        for (PlaceDto p : orderedList) {
            switch (p.getPlaceCategory()) {
                case "cafe": cafes.add(p); break;
                case "restaurant": restaurants.add(p); break;
                case "attraction": attractions.add(p); break;
                case "hotel": hotels.add(p); break;
            }
        }

        Set<Integer> visited = new HashSet<>();

        // 6. 날짜별 자동 일정 생성
        for (int d = 0; d < totalDays; d++) {
            LocalDate date = startDate.plusDays(d);
            LocalDateTime time = date.atTime(10, 0); // 오전 10시 시작

            // 시작 장소
            if (d == 0) {
                // 첫날은 기차역
                insert(scheduleNum, station, time);
                time = time.plusHours(2);
            } else {
                // 나머지는 호텔
                PlaceDto hotel = hotels.get(d % hotels.size());
                insert(scheduleNum, hotel, time);
                time = time.plusHours(2);
            }

            // 카페
            time = insertCategory(scheduleNum, cafes, visited, time);
            // 식당
            time = insertCategory(scheduleNum, restaurants, visited, time);
            // 명소들 (최대 18시까지)
            while (time.getHour() <= 18 && !attractions.isEmpty()) {
                for (Iterator<PlaceDto> it = attractions.iterator(); it.hasNext();) {
                    PlaceDto p = it.next();
                    if (!visited.contains(p.getPlaceNum())) {
                        insert(scheduleNum, p, time);
                        visited.add(p.getPlaceNum());
                        time = time.plusHours(2);
                        it.remove();
                        break;
                    }
                }
                if (time.getHour() > 18) break;
            }

            // 종료 장소
            if (d == totalDays - 1) {
                // 마지막 날은 기차역
                insert(scheduleNum, station, time);
            } else {
                // 나머지는 호텔 (20~22시)
                PlaceDto hotel = hotels.get(d % hotels.size());
                insert(scheduleNum, hotel, time.withHour(20));
            }
        }

        return "redirect:/aiPreview?scheduleNum=" + scheduleNum;
    }

    /**
     * 특정 카테고리에서 미방문 장소 1개를 추가하고 2시간 증가
     */
    private LocalDateTime insertCategory(int scheduleNum, List<PlaceDto> list, Set<Integer> visited, LocalDateTime time) {
        for (Iterator<PlaceDto> it = list.iterator(); it.hasNext();) {
            PlaceDto p = it.next();
            if (!visited.contains(p.getPlaceNum())) {
                insert(scheduleNum, p, time);
                visited.add(p.getPlaceNum());
                time = time.plusHours(2);
                it.remove();
                break;
            }
        }
        return time;
    }

    /**
     * 일정 상세 저장
     */
    private void insert(int scheduleNum, PlaceDto place, LocalDateTime time) {
        ScheduleDetailDto detail = new ScheduleDetailDto();
        detail.setScheduleNum(scheduleNum);
        detail.setPlaceNum(place.getPlaceNum());
        detail.setScheduleDetailDay(Timestamp.valueOf(time));
        detail.setScheduleDetailMemo("");
        scheduleDetailService.insert(detail);
    }

    /**
     * 일정 미리보기 페이지
     */
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
