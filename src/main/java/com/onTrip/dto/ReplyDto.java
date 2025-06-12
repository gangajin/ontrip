package com.onTrip.dto;

import java.time.LocalDateTime;

import lombok.Data;
@Data
public class ReplyDto {
    private int replyNum;
    private String replyContent;
    private LocalDateTime replyTime;
    private int inquiryNum; 
    private int userNum; 
    private Integer parentReplyNum;
    private String userRole;
}
