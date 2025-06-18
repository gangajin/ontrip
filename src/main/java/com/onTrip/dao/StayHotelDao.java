package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.StayHotelDto;

@Mapper
public interface StayHotelDao {
	
	public void insertStayHotel(@Param("scheduleNum") int scheduleNum, 
            @Param("stayHotelDate") String stayHotelDate, 
            @Param("placeNum") int placeNum);
	
	List<StayHotelDto> selectByScheduleNum(@Param("scheduleNum") int scheduleNum);
}
