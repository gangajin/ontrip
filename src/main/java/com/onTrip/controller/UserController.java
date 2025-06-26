package com.onTrip.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.onTrip.dao.UserDao;
import com.onTrip.dto.UserDto;
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
    public boolean checkEmail(@RequestParam("userId") String userId) {
       return userDao.countByUserId(userId)==0;
    }
    
    //닉네임 중복검사
    @RequestMapping("/checkNickname")
    @ResponseBody
    public boolean checkNickname(@RequestParam("nickname") String nickname) {
        return userDao.countByUserNickname(nickname) == 0;
    }

    
    //로그인 폼으로 가기
    @RequestMapping("/login")
    public String loginForm() {
       return "User/login";
    }
    
    //로그인 -> 메인페이지
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @RequestMapping("/loginSuccess")
    public String loginSuccess(@RequestParam("userId") String userId,
                               @RequestParam("userPasswd") String userPasswd,
                               HttpSession session,
                               Model model) {

        UserDto user = userService.findByUserId(userId);

        if (user == null) {
            model.addAttribute("userIdError", "존재하지 않는 아이디입니다.");
            return "User/login";
        }

        if (!passwordEncoder.matches(userPasswd, user.getUserPasswd())) {
            model.addAttribute("passwordError", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("userIdValue", userId);  // 아이디 유지시켜주기 (UX)
            return "User/login";
        }

        session.setAttribute("loginUser", user);
        session.setAttribute("userNum", user.getUserNum());
        session.setAttribute("userRole", user.getUserRole());

        String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
        if (redirectUrl != null) {
            session.removeAttribute("redirectAfterLogin");
            return "redirect:" + redirectUrl;
        }

        return "redirect:/";
    }



    
    //로그아웃 -> main
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 종료
        return "redirect:/?logout=true";  // 메인 페이지
    }
    //비밀번호 찾기 form (매핑 -> PasswordToken컨트롤러)
    @RequestMapping("/findPassword")
    public String findPasswordPage() {
        return "User/findPassword";  // JSP 위치에 맞게 경로 조정
    }

}
