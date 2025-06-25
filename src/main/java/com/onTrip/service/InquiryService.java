package com.onTrip.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.onTrip.dao.InquiryDao;
import com.onTrip.dao.ReplyDao;
import com.onTrip.dto.InquiryDto;
import com.onTrip.dto.ReplyDto;
@Service
public class InquiryService {
	@Autowired
	private InquiryDao inquirydao;
	
	@Autowired
	private ReplyDao replydao;
	//내용저장(문의내용의 일부를 문의 제목으로 설정)
	  public void saveNewInquiry(int userNum, String content) {
	        InquiryDto inquiry = new InquiryDto();

	        inquiry.setUserNum(userNum);
	        inquiry.setInquiryContent(content);
	        inquiry.setInquiryStatus("대기");

	        String title = content; 
	        int maxLength = 50;

	        if (StringUtils.isEmpty(content) || content.trim().isEmpty()) {
	             title = "내용 없음"; 
	        } else {
	            
	            title = title.replace("\n", " ");

	            
	            title = title.trim();

	            
	            if (title.isEmpty()) {
	                 title = "내용 없음";
	            } else if (title.length() > maxLength) {
	              
	                title = title.substring(0, maxLength) + "...";
	            }
	        }

	        
	        inquiry.setInquiryTitle(title);

	        // 4. 데이터베이스에 저장!
	        // JPA 예시:
	        // inquiryRepository.save(inquiry);

	        inquirydao.insertInquiry(inquiry);

	    }

	  public InquiryDto InquiryReplies(int inquiryNum) {
		  InquiryDto inquirydto = inquirydao.selectInquiryNum(inquiryNum);
		  List<ReplyDto> replies = replydao.selectReplyNum(inquiryNum);
		  inquirydto.setReplies(replies);
		  return inquirydto;
	  }
	  
	  public List<InquiryDto> InquiryListUser(int userNum) {
		    return inquirydao.selectInquiryUser(userNum);
		}
	  
	  public List<InquiryDto> getAllInquiries() {
		    return inquirydao.selectAllInquiries();
		}
	  
	   public void updateInquiryStatus(int inquiryNum, String status) {
	    	inquirydao.updateInquiryStatus(inquiryNum, status);
	    }
	   
	   //비회원 전용 문의
	   public void savePublicInquiry(String userIdText, String title,String content) {
		    InquiryDto inquiry = new InquiryDto();
		    inquiry.setUserNum(null);  // 로그인 사용자 아님
		    inquiry.setUserIdText(userIdText);  // 새 필드 필요
		    inquiry.setInquiryTitle(title);
		    inquiry.setInquiryContent(content);
		    inquiry.setInquiryStatus("대기");
		    inquiry.setInquiryTime(LocalDateTime.now());

		    inquirydao.insertPublicInquiry(inquiry);
		}
	   
	   public int getTotalInquiryCount() {
		    return inquirydao.countAllInquiries();
		}

		public List<InquiryDto> getPagedInquiries(int startIndex, int pageSize) {
		    return inquirydao.selectPagedInquiries(startIndex, pageSize);
		}
	   
	}

