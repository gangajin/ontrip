package com.onTrip.dao;

import java.time.LocalDate;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.ScheduleDto;
@Mapper
public interface ScheduleDao {
	// Schedule insert
    void insertSchedule(@Param("destinationNum") int destinationNum,
                        @Param("scheduleStart") LocalDate scheduleStart,
                        @Param("scheduleEnd") LocalDate scheduleEnd,
                        @Param("userNum") int userNum);

    // 방금 insert된 Schedule PK 값 가져오기
    int getLastInsertId();
    
    ScheduleDto getScheduleByNum(int scheduleNum);
}
