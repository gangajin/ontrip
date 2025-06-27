package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.UserDto;
import com.onTrip.service.DestinationService;
import com.onTrip.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class MainController {
	
	@Autowired
	private DestinationService destinationService;
	
	@Autowired
	private UserService userService;
	
	@RequestMapping("/")
	public String mainPage(@RequestParam(value = "keyword", required = false) String keyword,
	                       Model model, HttpSession session) {
	    UserDto loginUser = (UserDto) session.getAttribute("loginUser");
	    Boolean introShown = (Boolean) session.getAttribute("introShown");

	    // 처음 들어온 경우 introShown==null → 인트로 뜨고 introShown=true로 전환
	    if (introShown == null) {
	        session.setAttribute("introShown", false); // 인트로 띄우기 위해 false 설정
	    }

	    List<DestinationDto> destinationList =
	        (keyword == null || keyword.isEmpty())
	        ? destinationService.getAllDestinations()
	        : destinationService.searchDestination(keyword);

	    model.addAttribute("destinationList", destinationList);
	    return "main";
	}

	@RequestMapping("/loginProcess")
	public String loginProcess(UserDto userDto, HttpSession session) {
	    UserDto loginUser = userService.login(userDto.getUserId(), userDto.getUserPasswd());

	    if (loginUser != null) {
	        session.setAttribute("loginUser", loginUser);
	        session.setAttribute("introShown", false); // 로그인 후 인트로 다시 띄우기
	        return "redirect:/";
	    } else {
	        return "redirect:/login?error=true";
	    }
	}

	@GetMapping("/introComplete")
	@ResponseBody
	public void introComplete(HttpSession session) {
	    session.setAttribute("introShown", true); // 인트로 끝난 뒤엔 true로 유지
	}
}
