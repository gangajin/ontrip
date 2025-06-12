package com.onTrip.service;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.ScheduleDao;
import com.onTrip.dto.ScheduleDto;

@Service
public class ScheduleService {

    @Autowired
    private ScheduleDao scheduleDao;

    public int insertSchedule(int destinationNum, LocalDate scheduleStart, LocalDate scheduleEnd, int userNum) {
        System.out.println("📌 insertSchedule 호출됨!");
        
        scheduleDao.insertSchedule(destinationNum, scheduleStart, scheduleEnd, userNum);
        
        int scheduleNum = scheduleDao.getLastInsertId();
        System.out.println("✅ 생성된 scheduleNum = " + scheduleNum);
        return scheduleNum;
    }
	    // ScheduleService.java
	    public ScheduleDto getScheduleByNum(int scheduleNum) {
        return scheduleDao.getScheduleByNum(scheduleNum);
    }

}
