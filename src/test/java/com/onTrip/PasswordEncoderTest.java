package com.onTrip;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoderTest {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String rawPassword = "admin1234";
        String encodedPassword = encoder.encode(rawPassword);
        System.out.println("암호화된 비밀번호: " + encodedPassword);
    }
}
