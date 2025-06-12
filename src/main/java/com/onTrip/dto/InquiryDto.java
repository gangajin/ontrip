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
	private int userNum;
	private List<ReplyDto> replies;
	private String userNickname;
}
