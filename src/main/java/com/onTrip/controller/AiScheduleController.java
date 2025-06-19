package com.onTrip.controller;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.PlaceDto;
import com.onTrip.dto.ScheduleDetailDto;
import com.onTrip.dto.ScheduleDto;
import com.onTrip.service.OpenAiService;
import com.onTrip.service.PlaceService;
import com.onTrip.service.ScheduleDetailService;
import com.onTrip.service.ScheduleService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AiScheduleController {

    @Autowired
    private PlaceService placeService;

    @Autowired
    private ScheduleService scheduleService;

    @Autowired
    private ScheduleDetailService scheduleDetailService;

    @Autowired
    private OpenAiService openAiService;

    @PostMapping("/generateAiSchedule")
    public String generateAiSchedule(@RequestParam("planId") int planId,
                                     @RequestParam("transportType") String transportType,
                                     HttpSession session) {

        // 1. 현재 일정에 포함된 장소 목록 가져오기
        List<PlaceDto> placeList = placeService.getPlacesByScheduleNum(planId);

        // 2. 일정 정보 가져오기 (시작일, 종료일 포함)
        ScheduleDto schedule = scheduleService.selectOneByScheduleNum(planId);
        LocalDate startDate = schedule.getScheduleStart();
        LocalDate endDate = schedule.getScheduleEnd();

        // 3. GPT 프롬프트 생성
        String prompt = openAiService.buildAiPrompt(
                placeList,
                transportType,
                startDate.toString(),
                endDate.toString()
        );

        // 4. GPT에게 장소 방문 순서 요청
        List<String> orderedNames = openAiService.getOrderedPlaceNames(prompt);

        // 5. GPT 결과 기반으로 PlaceDto 정렬
        List<PlaceDto> orderedList = new ArrayList<>();
        for (String name : orderedNames) {
            placeList.stream()
                .filter(p -> p.getPlaceName().equalsIgnoreCase(name.trim()))
                .findFirst()
                .ifPresent(orderedList::add);
        }

        // 6. 시간대별로 일정 세부 정보 저장 (09:00부터 2시간 간격)
        LocalDateTime startTime = startDate.atTime(9, 0);

        for (int i = 0; i < orderedList.size(); i++) {
            ScheduleDetailDto detail = new ScheduleDetailDto();
            detail.setScheduleNum(planId);
            detail.setPlaceNum(orderedList.get(i).getPlaceNum());
            detail.setScheduleDetailDay(Timestamp.valueOf(startTime.plusHours(i * 2)));
            detail.setScheduleDetailMemo(""); // 필요 시 GPT 설명 저장 가능

            scheduleDetailService.insert(detail);
        }

        // 7. 일정 미리보기 페이지로 이동
        return "redirect:/aiPreview?scheduleNum=" + planId;
    }
    
    @GetMapping("/aiPreview")
    public String previewSchedule(@RequestParam("scheduleNum") int scheduleNum, Model model) {
        List<ScheduleDetailDto> detailList = scheduleDetailService.getScheduleDetailsWithPlace(scheduleNum);
        model.addAttribute("detailList", detailList);
        return "Schedule/AiPreview";  // JSP 파일명
    }
}
