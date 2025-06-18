package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.PlaceDto;

@Mapper
public interface PlaceDao {

    List<PlaceDto> placeHotelList(@Param("destinationNum") int destinationNum);

    List<PlaceDto> searchHotel(@Param("destinationNum") int destinationNum, @Param("keyword") String keyword);

    List<PlaceDto> searchPlaceByKeyword(@Param("destinationNum") int destinationNum, @Param("keyword") String keyword);

    List<PlaceDto> recommendPlace(@Param("destinationNum") int destinationNum, @Param("categoryList") List<String> categoryList);

    void insertPlace(PlaceDto placeDto);

    // ✅ 추가 - step2용 전체 장소 조회
    List<PlaceDto> selectPlaceByDestination(@Param("destinationNum") int destinationNum);
    
    // 전체 장소 조회
    List<PlaceDto> adminAllPlaces();

    // 특정 destination의 장소 조회
    List<PlaceDto> adminPlaceByDestination(@Param("destinationNum") int destinationNum);

    // 장소 삭제
    void admindeletePlace(@Param("placeNum") int placeNum);
    
    // 장소 목록 페이징 처리
    List<PlaceDto> adminPagedPlaces(@Param("start") int start, @Param("pageSize") int pageSize);

    // 전체 장소 수 조회 (페이징용)
    int adminPlaceCount();

    // 관리자용 키워드 검색
    List<PlaceDto> adminSearchPlace(@Param("keyword") String keyword);

    List<PlaceDto> selectByScheduleNum(@Param("scheduleNum") int scheduleNum);
}
