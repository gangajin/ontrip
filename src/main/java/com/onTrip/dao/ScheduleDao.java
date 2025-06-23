package com.onTrip.dao;

import java.time.LocalDate;
import java.util.List;

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
    
    // 작성중인 일정 목록 조회
    List<ScheduleDto> selectDraftSchedules(@Param("userNum") int userNum);

    // 일정 삭제
    void deleteSchedule(@Param("scheduleNum") int scheduleNum);
    
    ScheduleDto selectScheduleWithUserNum(@Param("scheduleNum") int scheduleNum, @Param("userNum") int userNum, @Param("destinationNum") int destinationNum);

    List<ScheduleDto> selectByScheduleNum(@Param("scheduleNum") int scheduleNum);
    
    int getPlanIdByScheduleNum(int scheduleNum);
    
    ScheduleDto selectOneByScheduleNum(int scheduleNum);
    
    //작성 완료된 일정 목록 조회
    List<ScheduleDto> selectCompletedSchedules(@Param("userNum") int userNum);
    

}
