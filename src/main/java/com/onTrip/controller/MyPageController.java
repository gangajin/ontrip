package com.onTrip.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.ScheduleDto;
import com.onTrip.service.ScheduleService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class MyPageController {

    @Autowired
    private ScheduleService scheduleService;

    @GetMapping("/myPage")
    public String myPage(HttpSession session, Model model) {
        Integer userNum = (Integer) session.getAttribute("userNum");
        if (userNum == null) return "redirect:/login";

        List<ScheduleDto> draftList = scheduleService.getDraftSchedules(userNum);
        List<ScheduleDto> completedList = scheduleService.getCompletedSchedules(userNum);

        model.addAttribute("draftList", draftList);
        model.addAttribute("completedList", completedList);
        return "User/mypage";
    }

    @GetMapping("/continueSchedule")
    public String continueSchedule(@RequestParam("scheduleNum") int scheduleNum,@RequestParam("destinationNum") int destinationNum, HttpSession session) {
        Integer userNum = (Integer) session.getAttribute("userNum");
        if (userNum == null) {
            return "redirect:/user/login";
        }

        // scheduleNum으로 스케줄 조회 (userNum 포함)
        ScheduleDto schedule = scheduleService.getScheduleWithUserNum(scheduleNum, userNum, destinationNum);
        if (schedule == null) return "redirect:/user/myPage";
        
        session.setAttribute("userNum", schedule.getUserNum());
        session.setAttribute("scheduleNum", schedule.getScheduleNum());
        session.setAttribute("destinationNum", schedule.getDestinationNum());
        session.setAttribute("destinationName", schedule.getDestinationName());
        session.setAttribute("scheduleStart", schedule.getScheduleStart().toString());
        session.setAttribute("scheduleEnd", schedule.getScheduleEnd().toString());
        session.setAttribute("destinationLat", schedule.getDestinationLat());
        session.setAttribute("destinationLong", schedule.getDestinationLong());

        String encodedName = URLEncoder.encode(schedule.getDestinationName(), StandardCharsets.UTF_8);

        return "redirect:/step2?destinationNum=" + schedule.getDestinationNum()
             + "&destinationName=" + encodedName
             + "&scheduleStart=" + schedule.getScheduleStart()
             + "&scheduleEnd=" + schedule.getScheduleEnd()
             + "&destinationLat=" + schedule.getDestinationLat()
             + "&destinationLong=" + schedule.getDestinationLong();
    }

    @PostMapping("/deleteSchedule")
    public String deleteSchedule(@RequestParam("scheduleNum") int scheduleNum) {
        scheduleService.deleteSchedule(scheduleNum);
        return "redirect:/user/myPage";
    }
}
