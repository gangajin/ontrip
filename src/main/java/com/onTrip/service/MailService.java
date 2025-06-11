package com.onTrip.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@Service
public class MailService {
	@Autowired
    private JavaMailSender mailSender;
	
	public void sendResetPasswordMail(String toEmail, String token) {
        String resetLink = "http://localhost:8080/resetPassword?token=" + token;

        String subject = "비밀번호 재설정 링크입니다";
        String htmlContent = "<p>다음 링크를 클릭하여 비밀번호를 재설정하세요:</p>" +
                             "<a href=\"" + resetLink + "\">비밀번호 재설정하기</a>";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(new InternetAddress("jhlyu0606@gmail.com", "on : Trip"));
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(htmlContent, true); // HTML 형식(링크띄우기)

            mailSender.send(message);
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            e.printStackTrace(); 
        }
    }
}