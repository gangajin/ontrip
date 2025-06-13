package com.onTrip.service;

import java.util.Map;

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

        System.out.println("카카오 ID: " + kakaoId);
        System.out.println("이메일: " + email);
        System.out.println("닉네임: " + nickname);

        //DB에 이미 있는지 확인 (가입 여부 체크)
        UserDto existingUser = userService.findByUserId(email);

        UserDto loginUser;
        
        if (existingUser == null) {
            String uniqueNickname = nickname + "_" + kakaoId;

            UserDto newUser = new UserDto();
            newUser.setUserId(email);
            newUser.setUserNickname(uniqueNickname);
            newUser.setSocialId(String.valueOf(kakaoId));
            newUser.setSocialType("kakao");
            newUser.setUserRole("user");

            userService.registerKakaoUser(newUser);
            System.out.println("신규 회원 가입 완료");

            loginUser = newUser;
        } else {
            System.out.println("기존 회원 로그인");
            loginUser = existingUser;
        }

        session.setAttribute("loginUser", loginUser);

        return oAuth2User;
    }
}
