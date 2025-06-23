package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.ScheduleDetailDto;

@Mapper
public interface ScheduleDetailDao {
    void insert(ScheduleDetailDto detail);
    List<ScheduleDetailDto> getScheduleDetailsWithPlace(@Param("scheduleNum") int scheduleNum);
    // 상태 업데이트
    void updateScheduleStatusToComplete(@Param("scheduleNum") int scheduleNum);
    // 이어쓰기 시 기존 스케줄 삭제
    void deleteByScheduleNum(@Param("scheduleNum") int scheduleNum);
}
