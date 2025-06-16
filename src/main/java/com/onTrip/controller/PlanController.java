package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.onTrip.dto.PlaceDto;
import com.onTrip.service.PlanService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/plan")  // prefix /plan 으로 통일 (가독성 ↑)
public class PlanController {

    @Autowired
    private PlanService planService;

    // Plan 추가 (AJAX 전용)
    @PostMapping("/add")
    @ResponseBody
    public String addPlan(@RequestParam("placeNum") int placeNum, HttpSession session) {

        Integer userNum = (Integer) session.getAttribute("userNum");
        Integer scheduleNum = (Integer) session.getAttribute("scheduleNum");

        if (userNum == null || scheduleNum == null) {
            return "login";
        }

        planService.addPlan(userNum, scheduleNum, placeNum);
        return "success";
    }

    // Plan 삭제 (AJAX 전용)
    @PostMapping("/remove")
    @ResponseBody
    public String removePlan(@RequestParam("placeNum") int placeNum, HttpSession session) {

        Integer userNum = (Integer) session.getAttribute("userNum");
        Integer scheduleNum = (Integer) session.getAttribute("scheduleNum");

        if (userNum == null || scheduleNum == null) {
            return "login";
        }

        planService.removePlan(userNum, scheduleNum, placeNum);
        return "success";
    }

    @GetMapping("/list")
    public String getPlanList(HttpSession session, Model model) {

        Integer userNum = (Integer) session.getAttribute("userNum");
        Integer scheduleNum = (Integer) session.getAttribute("scheduleNum");

        if (userNum == null || scheduleNum == null) {
            return "redirect:/login";
        }

        List<PlaceDto> selectedPlaceDtoList = planService.selectPlacesInPlan(userNum, scheduleNum);
        model.addAttribute("selectedPlaceDtoList", selectedPlaceDtoList);

        return "Schedule/selectedPlaceList";
    }
}
