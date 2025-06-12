package com.onTrip.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.onTrip.dto.ReplyDto;

@Mapper
public interface ReplyDao {
	List<ReplyDto> selectReplyNum(int inquiryNum);
	
	void insertReply(ReplyDto replyDto);
}
