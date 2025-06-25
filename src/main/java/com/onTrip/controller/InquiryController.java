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
	    public String adminInquiryList(@RequestParam(value = "page", defaultValue = "1") int page,
	                                   Model model) {
	        int pageSize = 10;
	        int totalCount = inquiryService.getTotalInquiryCount();
	        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
	        int startIndex = (page - 1) * pageSize;

	        List<InquiryDto> inquiryList = inquiryService.getPagedInquiries(startIndex, pageSize);

	        model.addAttribute("inquiryList", inquiryList);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        model.addAttribute("totalCount", totalCount);

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
	    
	    //비회원 문의
	    @RequestMapping("/publicInquiryWrite")
	    public String publicInquiryWriteForm() {
	        return "Inquiry/publicInquiryWrite";
	    }

	    @RequestMapping("/publicInquirySubmit")
	    public String publicInquirySubmit(@RequestParam("userId") String userId,
	                                      @RequestParam("title") String title,
	                                      @RequestParam("content") String content,
	                                      Model model) {
	        if (userId == null || userId.trim().isEmpty() ||
	            title == null || title.trim().isEmpty() ||
	            content == null || content.trim().isEmpty()) {
	            
	            model.addAttribute("errorMessage", "이메일, 제목, 내용을 모두 입력해주세요.");
	            return "Inquiry/publicInquiryWrite";
	        }

	        // 수정된 서비스 호출 (title 인자 포함)
	        inquiryService.savePublicInquiry(userId, title, content);
	        model.addAttribute("successMessage", "문의가 정상적으로 접수되었습니다!");
	        return "Inquiry/publicInquiryWrite";
	    }
	    
}
