package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.InquiryDto;
import com.onTrip.service.InquiryService;

import jakarta.servlet.http.HttpSession;

@Controller
public class InquiryController {
	 @Autowired 
	    private InquiryService inquiryService;

	    @RequestMapping("/inquiryWrite")
	    public String inquiryinsertform() {
	        return "Inquiry/inquiryWrite";
	    }


	    @RequestMapping("/inquiryinsert")
	    public String saveInquiry(@RequestParam("content") String content,HttpSession session, Model model) {
	    		
	            Integer userNum = (Integer) session.getAttribute("userNum"); 

	            if (userNum == null) {
	                return "redirect:/login"; 
	            }
	            inquiryService.saveNewInquiry(userNum, content);

	            return "redirect:/inquiryList"; 
	    
	    }
	    
	    @RequestMapping("/inquiryList")
	    public String inquiryList(HttpSession session, Model model) {
	        Integer userNum = (Integer) session.getAttribute("userNum");

	        if (userNum == null) {
	            return "redirect:/login";
	        }

	        List<InquiryDto> inquiryList = inquiryService.InquiryListUser(userNum);
	        model.addAttribute("inquiryList", inquiryList);

	        return "Inquiry/inquiryList";
	    }
	    
	    @RequestMapping("/admininquiry")
	    public String adminInquiryList(Model model) {
	        List<InquiryDto> inquiryList = inquiryService.getAllInquiries();
	        model.addAttribute("inquiryList", inquiryList);
	        return "Admin/adminInquiry";
	    }
	    
	    @RequestMapping("/inquiryStatusUpdate")
	    public String updateInquiryStatus(@RequestParam("inquiryNum") int inquiryNum,
	                                      @RequestParam("inquiryStatus") String status) {
	        inquiryService.updateInquiryStatus(inquiryNum, status);
	        return "redirect:/admininquiry";
	    }
	    
	    @RequestMapping("/inquiryDetail")
	    public String inquiryDetail(@RequestParam("inquiryNum") int inquiryNum, Model model) {
	        InquiryDto inquiry = inquiryService.InquiryReplies(inquiryNum);
	        model.addAttribute("inquiry", inquiry);
	        model.addAttribute("replies", inquiry.getReplies());
	        return "Inquiry/inquiryDetail"; 
	    }
	    
}
