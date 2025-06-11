package com.onTrip.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.onTrip.dto.UserDto;

@Mapper
public interface UserDao {
	//회원 가입
	void insertUser(UserDto userDto);
	
	//이메일(userId) 중복 검사
	int countByUserId(String userId);
	
	//닉네임 중복 검사
	int countByUserNickname(String userNickname);
	
	//DB에서 userID찾기
	public UserDto findByUserId(String userId); 
	
	//비밀번호 변경
	void updatePassword(@Param("userId") String userId, @Param("userPasswd") String userPasswd);

}
