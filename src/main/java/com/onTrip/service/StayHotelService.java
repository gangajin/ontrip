package com.onTrip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.StayHotelDao;
import com.onTrip.dto.StayHotelDto;

@Service
public class StayHotelService {
	
@Autowired
private StayHotelDao stayHotelDao;
	public List<StayHotelDto> getStayListByScheduleNum(int scheduleNum) {
	    return stayHotelDao.selectByScheduleNum(scheduleNum);
	}
}
