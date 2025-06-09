package com.onTrip.service;

import java.util.List;

import com.onTrip.dto.DestinationDto;

public interface DestinationService {
	List<DestinationDto> getAllDestinations();  // 전체 지역 목록 조회
	
	DestinationDto getDestinationByNum(int destinationNum);  //지도 쓰기위함

}
