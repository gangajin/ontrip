package com.onTrip.dto;

import java.time.LocalDateTime;

import lombok.Data;
@Data
public class UserDto {
	private int userNum;
	private String userId;
	private String userPasswd;
	private String userName;
	private String userNickname;
	private LocalDateTime userDate;
	private String userRole;
	private String socialType;
	private String socialId;
}
