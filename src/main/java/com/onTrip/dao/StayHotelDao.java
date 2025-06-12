package com.onTrip.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface StayHotelDao {
	
	public void insertStayHotel(@Param("scheduleNum") int scheduleNum, 
            @Param("stayHotelDate") String stayHotelDate, 
            @Param("placeNum") int placeNum);
}
