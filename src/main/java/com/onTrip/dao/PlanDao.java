package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.onTrip.dto.PlanDto;
@Mapper
public interface PlanDao {
	// Plan 저장
    void insertPlan(PlanDto dto);

    // Plan 리스트 조회 (장바구니 표시용)
    List<PlanDto> selectPlanList(int scheduleNum, int userNum);

    // Plan 삭제 (장바구니에서 빼기)
    void deletePlan(int planNum);
}
