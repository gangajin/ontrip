package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dao.UserDao;
import com.onTrip.dto.UserDto;
import com.onTrip.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserDao userDao; // ✅ Service 안 쓰고 Dao 직접 사용

    @GetMapping("/userList")
    public String userList(@RequestParam(value = "keyword", required = false) String keyword,
                           @RequestParam(value = "page", defaultValue = "1") int page,
                           Model model) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<UserDto> userList;
        int totalUsers;

        if (keyword != null && !keyword.isEmpty()) {
            userList = userDao.searchUsers(keyword); // 기존 검색
            totalUsers = userList.size();
        } else {
            totalUsers = userDao.countAllUsers(); // 페이징 전체
            userList = userDao.selectPagedUsers(offset, pageSize);
        }

        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        model.addAttribute("userList", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);

        return "Admin/adminUser";
    }



    @GetMapping("/updateStatus")
    public String updateUserStatus(@RequestParam("userNum") int userNum, @RequestParam("status") String status) {
        userService.updateUserStatus(userNum, status);
        return "redirect:/admin/userList";
    }
    
    @GetMapping("/deleteUser")
    public String deleteUser(@RequestParam("userNum") int userNum) {
        userService.deleteUser(userNum);
        return "redirect:/admin/userList";
    }

}
