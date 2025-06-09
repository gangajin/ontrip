package com.onTrip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.DestinationDao;
import com.onTrip.dto.DestinationDto;

@Service
public class DestinationServiceImpl implements DestinationService{
	
	@Autowired
    private DestinationDao destinationDao;
	
	//지역명 카드(Main)
	@Override
    public List<DestinationDto> getAllDestinations() {
        return destinationDao.selectAll();
    }
	
	//지도
	@Override
	public DestinationDto getDestinationByNum(int destinationNum) {
	    return destinationDao.selectByNum(destinationNum);
	}

}
