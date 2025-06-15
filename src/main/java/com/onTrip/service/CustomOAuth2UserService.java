package com.onTrip.service;

import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.onTrip.dto.UserDto;

import jakarta.servlet.http.HttpSession;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private UserService userService;  
    
    @Autowired
    private HttpSession session;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attributes = oAuth2User.getAttributes();

        String registrationId = userRequest.getClientRegistration().getRegistrationId();  // google / kakao / naver
        
        UserDto loginUser = null;

        if ("kakao".equals(registrationId)) {
            loginUser = processKakao(attributes);
        } else if ("google".equals(registrationId)) {
            loginUser = processGoogle(attributes);
        } else if ("naver".equals(registrationId)) {
        	loginUser = processNaver(attributes);
        }

        session.setAttribute("loginUser", loginUser);

        return oAuth2User;
    }
    
    //Kakao
    private UserDto processKakao(Map<String, Object> attributes) {
        Long kakaoId = ((Number) attributes.get("id")).longValue();

        Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
        String email = null;
        String nickname = null;

        if (kakaoAccount != null) {
            email = (String) kakaoAccount.get("email");

            Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
            if (profile != null) {
                nickname = (String) profile.get("nickname");
            }
        }

        UserDto existingUser = userService.findByUserId(email);

        if (existingUser == null) {
        	String uuid = UUID.randomUUID().toString().substring(0, 6);
            String uniqueNickname = nickname + "_kakao_" + uuid;

            UserDto newUser = new UserDto();
            newUser.setUserId(email);
            newUser.setUserNickname(uniqueNickname);
            newUser.setSocialId(String.valueOf(kakaoId));
            newUser.setSocialType("kakao");
            newUser.setUserRole("user");

            userService.registerSocialUser(newUser);
            return newUser;
        } else {
            return existingUser;
        }
    }
    
    //Google
    private UserDto processGoogle(Map<String, Object> attributes) {
        String email = (String) attributes.get("email");
        String name = (String) attributes.get("name");

        UserDto existingUser = userService.findByUserId(email);

        if (existingUser == null) {
        	String uuid = UUID.randomUUID().toString().substring(0, 6);
            String uniqueNickname = name + "_google_" + uuid;

            UserDto newUser = new UserDto();
            newUser.setUserId(email);
            newUser.setUserNickname(uniqueNickname);
            newUser.setSocialId(email);  // 구글은 id보다는 email이 주키처럼 사용 가능
            newUser.setSocialType("google");
            newUser.setUserRole("user");

            userService.registerSocialUser(newUser);
            return newUser;
        } else {
            return existingUser;
        }
    }
    
    //Naver
    private UserDto processNaver(Map<String, Object> attributes) {
    	Map<String, Object> response = (Map<String, Object>) attributes.get("response");
    	
    	String email = (String) response.get("email");
    	String name = (String) response.get("name");
    	String naverId = (String) response.get("id");
    	
        UserDto existingUser = userService.findByUserId(email);
        
       if (existingUser == null) {
    	   String uuid = UUID.randomUUID().toString().substring(0, 6);
    	   String uniqueNickname = name + "_naver_" + uuid;
    	   
    	   UserDto newUser = new UserDto();
    	   newUser.setUserId(email);
    	   newUser.setUserName(name);
    	   newUser.setUserNickname(uniqueNickname);
    	   newUser.setSocialId(naverId);
    	   newUser.setSocialType("naver");
    	   newUser.setUserRole("user");
    	   
    	   userService.registerSocialUser(newUser);
           return newUser;
       } else {
           return existingUser;
       }
    	   
    }
}
