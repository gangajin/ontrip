package com.onTrip.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.onTrip.dao.UserDao;
import com.onTrip.dao.PasswordTokenDao;
import com.onTrip.dto.UserDto;
import com.onTrip.service.MailService;
import com.onTrip.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	
	@Autowired
	private UserDao userDao;
	
	@Autowired
	private UserService userService;
	
	//회원가입 form
    @RequestMapping("/register")
    public String register() {
        return "User/register";
    }
    
    //회원가입 처리메소드
    @RequestMapping("/registerProcess")
    public String registerProcess(UserDto userDto) {
    	userService.registerUser(userDto);
    	return "redirect:/login";
    }
    
    //이메일(userId) 중복검사
    @RequestMapping("/checkEmail")
    @ResponseBody
    public boolean checkEmail(@RequestParam String userId) {
    	return userDao.countByUserId(userId)==0;
    }
    
    //닉네임 중복검사
    @RequestMapping("/checkNickname")
    @ResponseBody
    public boolean checkNickname(@RequestParam String nickname) {
        return userDao.countByUserNickname(nickname) == 0;
    }

    
    //로그인 폼으로 가기
    @RequestMapping("/login")
    public String loginForm() {
    	return "User/login";
    }
    
    //로그인 -> 메인페이지
    @RequestMapping("/loginSuccess")
    public String loginSuccess(@RequestParam("userId") String userId,
                               @RequestParam("userPasswd") String userPasswd,
                               HttpSession session,
                               Model model) {
        UserDto loginUser = userService.login(userId, userPasswd);

        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            session.setAttribute("role", loginUser.getRole()); // role 안 쓰면 이 줄 생략 가능

            // 로그인 전 요청 저장되어 있을 경우 처리
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                return "redirect:" + redirectUrl;
            }

            return "redirect:/"; // 메인 페이지
        } else {
            model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "User/login";
        }
    }
    
    //로그아웃 -> main
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 종료
        return "redirect:/?logout=true";  // 메인 페이지
    }
    //비밀번호 찾기 form
    @RequestMapping("/findPassword")
    public String findPasswordPage() {
        return "User/findPassword";  // JSP 위치에 맞게 경로 조정
    }

}
