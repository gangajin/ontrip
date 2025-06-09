package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.PlaceDto;
@Mapper
public interface PlaceDao {
	
	public List<PlaceDto> placeHotelList(int destinationNum);
	
    List<PlaceDto> searchHotel(@Param("destinationNum") int destinationNum,
    							@Param("keyword") String keyword);
	
	public int insertPlace(PlaceDto Placedto);
}
