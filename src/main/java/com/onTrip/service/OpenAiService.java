package com.onTrip.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.onTrip.dto.PlaceDto;

@Service
public class OpenAiService {

    @Value("${openai.api.key}")
    private String apiKey;

    private final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

    /**
     * ✅ GPT에 프롬프트를 보내고 응답을 받아 장소 이름 리스트로 반환
     */
    public List<String> getOrderedPlaceNames(String prompt) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            // 요청 바디 구성 - gpt-4 모델을 사용, 사용자 프롬프트 포함
            String requestBody = """
                {
                    "model": "gpt-3.5-turbo",
                    "messages": [
                        { "role": "system", "content": "너는 여행 전문가이자 동선 설계자야. 사용자의 장소 리스트를 가장 효율적인 순서로 재배열해줘." },
                        { "role": "user", "content": "%s" }
                    ],
                    "temperature": 0.7
                }
                """.formatted(prompt.replace("\"", "\\\"").replace("\n", "\\n")); // 따옴표/개행 이스케이프

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey); // API 키 인증

            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

            // GPT API 호출
            ResponseEntity<String> response = restTemplate.exchange(
                    OPENAI_API_URL, HttpMethod.POST, entity, String.class);

            // 응답이 정상이라면 파싱
            if (response.getStatusCode() == HttpStatus.OK) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(response.getBody());

                // ✅ 예외 처리: 응답이 비어있거나 잘못된 경우
                if (!root.has("choices") || !root.path("choices").isArray() || root.path("choices").isEmpty()) {
                    throw new RuntimeException("GPT 응답이 비어 있거나 유효하지 않습니다.");
                }

                String content = root.path("choices").get(0).path("message").path("content").asText();

                // 응답에서 장소명 추출
                List<String> result = new ArrayList<>();
                for (String line : content.split("\n")) {
                    line = line.replaceAll("^[0-9]+[.)]?\\s*", "").trim(); // 번호 제거
                    if (!line.isEmpty()) result.add(line);
                }
                return result;
            } else {
                throw new RuntimeException("GPT 호출 실패: " + response.getStatusCode());
            }

        } catch (Exception e) {
            throw new RuntimeException("GPT 처리 오류", e);
        }
    }

    /**
     * ✅ 프롬프트 생성 메서드
     * 사용자의 장소 리스트, 이동수단, 일정 날짜를 바탕으로 GPT에 보낼 자연어 프롬프트 문자열 생성
     */
    public String buildAiPrompt(List<PlaceDto> placeList, String transportType, String scheduleStart, String scheduleEnd) {
        StringBuilder prompt = new StringBuilder();

        // 기본 정보 입력
        prompt.append("당신은 여행 전문가입니다. 사용자가 여행지를 선택했고, 일정은 다음과 같습니다.\n");
        prompt.append("이동수단: ").append(transportType).append("\n");
        prompt.append("여행 기간: ").append(scheduleStart).append(" ~ ").append(scheduleEnd).append("\n\n");

        // 장소 리스트 출력
        prompt.append("사용자가 선택한 장소 목록은 다음과 같습니다.\n");
        for (PlaceDto place : placeList) {
            prompt.append("- 장소명: ").append(place.getPlaceName())
                  .append(", 카테고리: ").append(place.getPlaceCategory())
                  .append(", 주소: ").append(place.getPlaceRoadAddr()).append("\n");
        }

        // 요청 조건 명시
        prompt.append("\n아래 조건에 따라 1일차, 2일차 등으로 나눠 일정을 짜주세요:\n");
        prompt.append("- 하루 기준: 아침, 점심, 저녁 식사 장소 1곳씩 포함\n");
        prompt.append("- 하루 최소 1곳 ~ 최대 3곳의 명소 포함\n");
        prompt.append("- 숙소에서 가까운 곳 위주로 효율적인 동선을 구성\n");
        prompt.append("- 반환 형식: '1일차\\n아침: 장소명\\n명소1: 장소명\\n점심: 장소명...' 와 같이 요일별로\n");
        prompt.append("- 날짜는 자동 분배, 사용자가 카카오 지도로 시각화할 수 있도록 장소명을 명확히 출력");

        return prompt.toString();
    }
}
