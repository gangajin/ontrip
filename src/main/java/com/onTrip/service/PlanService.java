package com.onTrip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.PlanDao;
import com.onTrip.dto.PlaceDto;

@Service
public class PlanService {

    @Autowired
    private PlanDao planDao;

    // Plan 추가
    public void addPlan(int userNum, int scheduleNum, int placeNum) {
        if (planDao.checkPlanExists(userNum, scheduleNum, placeNum) == 0) {
            planDao.insertPlan(userNum, scheduleNum, placeNum);
        }
    }

    // Plan 삭제
    public void removePlan(int userNum, int scheduleNum, int placeNum) {
        planDao.deletePlan(userNum, scheduleNum, placeNum);
    }

    // Plan 목록 조회
    public List<PlaceDto> selectPlacesInPlan(int userNum, int scheduleNum) {
        return planDao.selectPlacesInPlan(userNum, scheduleNum);
    }
    //지도 마커 찍기
    public List<PlaceDto> selectPlanMarker(int userNum, int scheduleNum) {
        return planDao.selectPlanMarker(userNum, scheduleNum);
    }

}
