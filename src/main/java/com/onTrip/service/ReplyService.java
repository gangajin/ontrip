package com.onTrip.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.onTrip.dao.ReplyDao;
import com.onTrip.dto.ReplyDto;

@Service
public class ReplyService {

    @Autowired
    private ReplyDao replyDao;

    
    public void insertReply(ReplyDto replyDto) {
        replyDao.insertReply(replyDto);
    }
}
