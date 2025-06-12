package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.PlaceDto;

@Mapper
public interface PlaceDao {

    // 기존 메소드 그대로 유지

    List<PlaceDto> placeHotelList(@Param("destinationNum") int destinationNum);

    List<PlaceDto> searchHotel(@Param("destinationNum") int destinationNum, @Param("keyword") String keyword);

    List<PlaceDto> searchPlace(@Param("destinationNum") int destinationNum, @Param("keyword") String keyword);

    List<PlaceDto> recommendPlace(@Param("destinationNum") int destinationNum, @Param("categoryList") List<String> categoryList);

    void insertPlace(PlaceDto placeDto);

    // ✅ 추가 - step2용 전체 장소 조회
    List<PlaceDto> selectPlaceByDestination(@Param("destinationNum") int destinationNum);
}
