package com.onTrip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.PlaceDao;
import com.onTrip.dto.PlaceDto;

@Service
public class PlaceService {

    @Autowired
    private PlaceDao placeDao;

    public List<PlaceDto> placeHotelList(int destinationNum) {
        return placeDao.placeHotelList(destinationNum);
    }

    public List<PlaceDto> searchHotel(int destinationNum, String keyword) {
        return placeDao.searchHotel(destinationNum, keyword);
    }

    public List<PlaceDto> searchPlaceByKeyword(int destinationNum, String keyword) {
        return placeDao.searchPlaceByKeyword(destinationNum, keyword);
    }

    public List<PlaceDto> recommendPlace(int destinationNum, List<String> categoryList) {
        return placeDao.recommendPlace(destinationNum, categoryList);
    }

    public void insertPlace(PlaceDto placeDto) {
        placeDao.insertPlace(placeDto);
    }

    // ✅ 추가 - step2용 전체 장소 조회
    public List<PlaceDto> getPlaceByDestination(int destinationNum) {
        return placeDao.selectPlaceByDestination(destinationNum);
    }
    
    // 장소 페이징 조회
    public List<PlaceDto> adminPagedPlaces(int start, int pageSize) {
        return placeDao.adminPagedPlaces(start, pageSize);
    }

    // 전체 장소 수 조회
    public int adminPlaceCount() {
        return placeDao.adminPlaceCount();
    }
    
    public List<PlaceDto> adminSearchPlace(String keyword) {
        return placeDao.adminSearchPlace(keyword);
    }


}
