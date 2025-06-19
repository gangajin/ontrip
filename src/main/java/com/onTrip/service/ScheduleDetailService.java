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

}
