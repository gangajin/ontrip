package com.onTrip.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PasswordTokenDao {
		// 사용자의 비밀번호 재설정을 위한 토큰을 DB에 저장
		void save(@Param("userId") String userId, @Param("token") String token);

		// 저장된 토큰을 기반으로 어떤 사용자인지 찾기
		String findUserIdByToken(@Param("token") String token);

		// 토큰 삭제 (1회용으로 사용 후 무효화)
		void delete(@Param("token") String token);

}
