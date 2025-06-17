package com.onTrip.controller;

import com.onTrip.dto.UserDto;
import com.onTrip.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @GetMapping("/userList")
    public String userList(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<UserDto> userList = (keyword == null || keyword.isEmpty())
                ? userService.getAllUsers()
                : userService.searchUsers(keyword);
        model.addAttribute("userList", userList);
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
