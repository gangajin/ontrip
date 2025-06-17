package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.DestinationDto;
import com.onTrip.service.DestinationService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {
	@Autowired
	private DestinationService destinationService;

    @GetMapping("/adminMain")
    public String adminMainPage(HttpSession session, Model model) {
        // 관리자 권한 확인 (예: userRole이 "ADMIN"인지 검사)
        String role = (String) session.getAttribute("userRole");
        if (role == null || !role.equals("admin")) {
            return "RoleErrorPage";  // 또는 "User/forceLogin.jsp"
        }

        return "Admin/adminMain";  // 실제 JSP 경로
    }

}

