package com.onTrip.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.onTrip.dao.UserDao;
import com.onTrip.dto.UserDto;

@Service
public class UserService {
   @Autowired
    private UserDao userDao;
   
   @Autowired
    private BCryptPasswordEncoder passwordEncoder;
   
   //비밀번호 암호화
   public void registerUser(UserDto userDto) {
        String rawPwd = userDto.getUserPasswd();
        String encPwd = passwordEncoder.encode(rawPwd);
        userDto.setUserPasswd(encPwd); // 암호화된 비번으로 덮어쓰기

        // DB 저장
        userDao.insertUser(userDto);
    }
   
   //DB의 userId랑 암호화된 비밀번호 비교
   public UserDto login(String userId, String userPasswd) {
	    UserDto user = userDao.findByUserId(userId);
	    
	    if (user != null) {
	        // ✅ [1] 계정 상태 확인
	        String status = user.getUserStatus();
	        if ("잠금".equals(status)) {
	            throw new IllegalStateException("해당 계정은 잠금 상태입니다.");
	        } else if ("휴면".equals(status)) {
	            throw new IllegalStateException("휴면 계정입니다. 비밀번호를 변경해주세요.");
	        } else if ("탈퇴".equals(status)) {
	            throw new IllegalStateException("이미 탈퇴된 계정입니다.");
	        }

	        // ✅ [2] 비밀번호 비교
	        if (passwordEncoder.matches(userPasswd, user.getUserPasswd())) {
	            return user;
	        }
	    }
	    
	    return null;
	}
   
   //로그인창에서 아이디 맞는지
   public UserDto findByUserId(String userId) {
       return userDao.findByUserId(userId);
   }
   
   //OAuth 통합(카카오, 구글, 네이버)
   public void registerSocialUser(UserDto userDto) {
	    userDao.insertSocialUser(userDto);
   }
   
   //어드민 페이지 유저관리
   public List<UserDto> getAllUsers() {
       return userDao.selectAllUsers();
   }

   public List<UserDto> searchUsers(String keyword) {
       return userDao.searchUsers(keyword);
   }

   public void updateUserStatus(int userNum, String status) {
       userDao.updateUserStatus(userNum, status);
   }
   
   public void deleteUser(int userNum) {
	    userDao.deleteUser(userNum);
	}
}
