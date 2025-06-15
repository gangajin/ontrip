package com.onTrip.service;

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
       if (user != null && passwordEncoder.matches(userPasswd, user.getUserPasswd())) {
           return user;
       }
       return null;
   }
   
   //로그인창에서 아이디 맞는지
   public UserDto findByUserId(String userId) {
       return userDao.findByUserId(userId);
   }
   
   //OAuth카카오
//   public void registerKakaoUser(UserDto userDto) {
//	    userDao.insertKakaoUser(userDto);
//	}
   
   //OAuth구글
//   public void registerGoogleUser(UserDto userDto) {
//	   userDao.insertGoogleUser(userDto);
//   }
   
   //OAuth네이버
//   public void registerNaverUser(UserDto userDto) {
//	   userDao.insertNaverUser(userDto);
//   }
   
   //OAuth 통합(카카오, 구글, 네이버)
   public void registerSocialUser(UserDto userDto) {
	    userDao.insertSocialUser(userDto);
   }

}
