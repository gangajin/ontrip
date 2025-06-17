package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.PlaceDto;

@Mapper
public interface DestinationDao {
	List<DestinationDto> selectAll(); // 전체 지역 목록 조회

	DestinationDto selectByNum(int destinationNum); //지도 쓰기위함
	
    List<DestinationDto> searchDestination(@Param("keyword") String keyword);
    
    // 관리자용 전체 지역 조회
    List<DestinationDto> adminSelectAll();
}
