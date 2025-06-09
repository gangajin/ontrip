package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.onTrip.dto.DestinationDto;

@Mapper
public interface DestinationDao {
	List<DestinationDto> selectAll(); // 전체 지역 목록 조회

	DestinationDto selectByNum(int destinationNum); //지도 쓰기위함
}
