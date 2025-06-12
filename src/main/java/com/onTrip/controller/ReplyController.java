package com.onTrip.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dto.ReplyDto;
import com.onTrip.service.ReplyService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReplyController {

    @Autowired
    private ReplyService replyService;

    @RequestMapping("/replyInsert")
    public String insertReply(@RequestParam("inquiryNum") int inquiryNum,
                              @RequestParam(value = "parentReplyNum", required = false) Integer parentReplyNum,
                              @RequestParam("replyContent") String replyContent,
                              HttpSession session) {

        Integer userNumObj = (Integer) session.getAttribute("userNum");

        // 세션에 사용자 정보가 없으면 로그인 페이지로 리다이렉트
        if (userNumObj == null) {
            return "redirect:/login"; // 로그인 경로에 맞게 수정
        }

        int userNum = userNumObj.intValue();

        ReplyDto reply = new ReplyDto();
        reply.setInquiryNum(inquiryNum);
        reply.setReplyContent(replyContent);
        reply.setUserNum(userNum);

        if (parentReplyNum != null) {
            reply.setParentReplyNum(parentReplyNum);
        }

        replyService.insertReply(reply);
        return "redirect:/inquiryDetail?inquiryNum=" + inquiryNum;
    }
}