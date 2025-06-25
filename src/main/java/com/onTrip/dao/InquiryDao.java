package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.InquiryDto;

@Mapper
public interface InquiryDao {
	void insertInquiry(InquiryDto inquirydto);
	
	InquiryDto selectInquiryNum(int inquiryNum);
	
	List<InquiryDto> selectInquiryUser(int userNum);
	
	List<InquiryDto> selectAllInquiries();
	
	void updateInquiryStatus(@Param("inquiryNum") int inquiryNum, @Param("inquiryStatus") String status);

	int countAllInquiries();
	List<InquiryDto> selectPagedInquiries(@Param("start") int start, @Param("size") int size);
	
	void insertPublicInquiry(InquiryDto inquiry);

}
