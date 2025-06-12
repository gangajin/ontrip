package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.onTrip.dto.PlanDto;
import com.onTrip.service.PlanService;

@RestController
@RequestMapping("/plan")
public class PlanController {

    @Autowired
    private PlanService planService;

    // Plan 저장 (장소 등록 버튼)
    @PostMapping("/insert")
    public void insertPlan(@RequestBody PlanDto dto) {
        planService.insertPlan(dto);
    }

    // Plan 리스트 조회 (장바구니 표시)
    @GetMapping("/list")
    public List<PlanDto> selectPlanList(@RequestParam("scheduleNum") int scheduleNum, @RequestParam("userNum") int userNum) {
        return planService.selectPlanList(scheduleNum, userNum);
    }

    // Plan 삭제 (장바구니에서 빼기)
    @DeleteMapping("/delete")
    public void deletePlan(@RequestParam("planNum") int planNum) {
        planService.deletePlan(planNum);
    }
}
