package com.onTrip.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.onTrip.dao.PasswordTokenDao;
import com.onTrip.dao.UserDao;
import com.onTrip.dto.UserDto;
import com.onTrip.service.MailService;

@Controller
public class PasswordTokenController {
   @Autowired
   private UserDao userDao;
   
   @Autowired
   private MailService mailService;
   
   @Autowired
   private PasswordTokenDao tokenDao;
   
   @Autowired
   private PasswordEncoder passwordEncoder;
   
   // 이메일 존재 확인 (Ajax)
   @RequestMapping("/checkEmailExists")
   @ResponseBody
   public boolean checkEmailExists(@RequestParam("userId") String userId) {
       return userDao.countByUserId(userId) > 0;
   }
   
   //이메일 입력 받기(비밀번호 재설정 관련)
    @RequestMapping("/findPasswordProcess")
    public String findPassword(@RequestParam("userId") String userId) {
        // 이메일 존재 확인
        UserDto user = userDao.findByUserId(userId);
        if (user != null) {
            String token = UUID.randomUUID().toString();  // 토큰 생성
            tokenDao.save(user.getUserId(), token);          // DB에 저장
            mailService.sendResetPasswordMail(userId, token); // 메일 전송
        }
        return "redirect:/login?sent=true";
    }
    
    //비밀번호 재설정 폼 (토큰 포함 링크)- 이메일로 오는거
    @RequestMapping("/resetPassword")
    public String resetPasswordForm(@RequestParam("token") String token, Model model) {
        model.addAttribute("token", token);
        return "User/resetPassword"; // JSP
    }
    
    //비밀번호 변경 처리
    @RequestMapping("/resetPasswordProcess")
    public String resetPasswordProcess(@RequestParam("token") String token,
                                        @RequestParam("userPasswd") String userPasswd,
                                        @RequestParam("userPasswd2") String userPasswd2) {
        if (!userPasswd.equals(userPasswd2)) {
            return "User/resetPassword?token=" + token + "&error=notMatch";
        }

        String userId = tokenDao.findUserIdByToken(token); // 토큰으로 사용자 찾기
        if (userId != null) {
            String encodedPw = passwordEncoder.encode(userPasswd);
            userDao.updatePassword(userId, encodedPw);
            tokenDao.delete(token);
        }

        return "redirect:/login?reset=success";
    }
    
    

}
