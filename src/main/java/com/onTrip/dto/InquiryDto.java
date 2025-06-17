package com.onTrip.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;
@Data
public class InquiryDto {
	private int inquiryNum;
	private String inquiryTitle ;
	private String inquiryStatus;
	private String inquiryContent;
	private LocalDateTime inquiryTime;
	private Integer userNum;
	private List<ReplyDto> replies;
	private String userNickname;
	
	// 비회원 식별용 사용자 입력 ID
	private String userIdText;

}
