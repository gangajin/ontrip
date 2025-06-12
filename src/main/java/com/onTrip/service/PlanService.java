package com.onTrip.service;

import java.util.List;
import com.onTrip.dao.PlanDao;
import com.onTrip.dto.PlanDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

// Plan 관련 Service
@Service
public class PlanService {

    @Autowired
    private PlanDao planDao;

    // Plan 저장
    public void insertPlan(PlanDto dto) {
        planDao.insertPlan(dto);
    }

    // Plan 리스트 조회 (장바구니 표시용)
    public List<PlanDto> selectPlanList(int scheduleNum, int userNum) {
        return planDao.selectPlanList(scheduleNum, userNum);
    }

    // Plan 삭제 (장바구니에서 빼기)
    public void deletePlan(int planNum) {
        planDao.deletePlan(planNum);
    }
}

