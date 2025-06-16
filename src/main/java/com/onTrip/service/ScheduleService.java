package com.onTrip.service;

import java.time.LocalDate;
import java.util.List;

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
    
	    public ScheduleDto getScheduleByNum(int scheduleNum) {
	    	return scheduleDao.getScheduleByNum(scheduleNum);
	    }

	    // 작성 중인 스케줄 목록 조회
	    public List<ScheduleDto> getDraftSchedules(int userNum) {
	        return scheduleDao.selectDraftSchedules(userNum);
	    }

	    // 스케줄 삭제
	    public void deleteSchedule(int scheduleNum) {
	        scheduleDao.deleteSchedule(scheduleNum);
	    }
	    
	    //이어쓰기용 스케줄 + 목적지 이름
	    public ScheduleDto getScheduleWithUserNum(int scheduleNum, int userNum, int destinationNum) {
	        return scheduleDao.selectScheduleWithUserNum(scheduleNum, userNum, destinationNum);
	    }

}
