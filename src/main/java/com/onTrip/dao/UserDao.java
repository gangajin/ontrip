package com.onTrip.dao;

import java.util.List;

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
   UserDto findByUserId(String userId); 
   
   //비밀번호 변경
   void updatePassword(@Param("userId") String userId, @Param("userPasswd") String userPasswd);

   //OAuth 통합
   void insertSocialUser(UserDto userDto);
   
   //어드민 페이지 유저관리
   List<UserDto> selectAllUsers();
   List<UserDto> searchUsers(@Param("keyword") String keyword); //검색
   void updateUserStatus(@Param("userNum") int userNum, @Param("status") String status);//상태 업데이트
   void deleteUser(@Param("userNum") int userNum);//강제탈퇴 (삭제)


}
