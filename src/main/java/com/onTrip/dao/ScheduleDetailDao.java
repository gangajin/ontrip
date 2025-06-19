package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.ScheduleDetailDto;

@Mapper
public interface ScheduleDetailDao {
    void insert(ScheduleDetailDto detail);
    List<ScheduleDetailDto> getScheduleDetailsWithPlace(@Param("scheduleNum") int scheduleNum);

}
