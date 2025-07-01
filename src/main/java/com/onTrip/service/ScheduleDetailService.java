package com.onTrip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.ScheduleDetailDao;
import com.onTrip.dto.ScheduleDetailDto;

@Service
public class ScheduleDetailService {

    @Autowired
    private ScheduleDetailDao scheduleDetailDao;

    public void insert(ScheduleDetailDto detail) {
        scheduleDetailDao.insert(detail);
    }

    public List<ScheduleDetailDto> getScheduleDetailsWithPlace(int scheduleNum) {
        return scheduleDetailDao.getScheduleDetailsWithPlace(scheduleNum);
    }
    
    // 상태를 '완성'으로 변경하는 메서드
    public void updateScheduleStatusToComplete(int scheduleNum) {
        scheduleDetailDao.updateScheduleStatusToComplete(scheduleNum);
    }
    
    // 일정 삭제 (이어쓰기 시 기존 일정 제거용)
    public void deleteDetailsByScheduleNum(int scheduleNum) {
        scheduleDetailDao.deleteByScheduleNum(scheduleNum);
    }

    public void updateTime(int scheduleDetailNum, String newDateTime) {
    	scheduleDetailDao.updateTime(scheduleDetailNum, newDateTime);
    }
}
