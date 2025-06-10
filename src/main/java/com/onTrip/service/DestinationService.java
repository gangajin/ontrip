package com.onTrip.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.PlaceDto;

public interface DestinationService {
	List<DestinationDto> getAllDestinations();  // 전체 지역 목록 조회
	
	DestinationDto getDestinationByNum(int destinationNum);  //지도 쓰기위함

	 List<DestinationDto> searchDestination(@Param("keyword") String keyword);
}
