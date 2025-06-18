package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.PlaceDto;

@Mapper
public interface PlanDao {

    void insertPlan(@Param("userNum") int userNum,
                    @Param("scheduleNum") int scheduleNum,
                    @Param("placeNum") int placeNum);

    void deletePlan(@Param("userNum") int userNum,
                    @Param("scheduleNum") int scheduleNum,
                    @Param("placeNum") int placeNum);

    int checkPlanExists(@Param("userNum") int userNum,
                        @Param("scheduleNum") int scheduleNum,
                        @Param("placeNum") int placeNum);

    //장바구니 리스트(내가 선택한 장소)
    List<PlaceDto> selectPlacesInPlan(@Param("userNum") int userNum,
                                      @Param("scheduleNum") int scheduleNum);
    //지도 마커찍기
    List<PlaceDto> selectPlanMarker(@Param("userNum") int userNum, @Param("scheduleNum") int scheduleNum);
    
}
