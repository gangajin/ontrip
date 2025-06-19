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

            String requestBody = """
                {
                    "model": "gpt-4",
                    "messages": [
                        { "role": "system", "content": "너는 여행 전문가이자 동선 설계자야. 사용자의 장소 리스트를 가장 효율적인 순서로 재배열해줘." },
                        { "role": "user", "content": "%s" }
                    ],
                    "temperature": 0.7
                }
                """.formatted(prompt.replace("\"", "\\\"").replace("\n", "\\n"));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    OPENAI_API_URL, HttpMethod.POST, entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(response.getBody());

                if (!root.has("choices") || !root.path("choices").isArray() || root.path("choices").isEmpty()) {
                    throw new RuntimeException("GPT 응답이 비어 있거나 유효하지 않습니다.");
                }

                String content = root.path("choices").get(0).path("message").path("content").asText();

                List<String> result = new ArrayList<>();
                for (String line : content.split("\n")) {
                    line = line.replaceAll("^[0-9]+[.)]?\\s*", "")
                               .replaceAll("^(아침|점심|저녁|숙소|명소\\d*):\\s*", "")
                               .replaceAll("[^가-힣a-zA-Z0-9\\s]", "")
                               .trim();
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
	
	    // GPT 역할 설명
	    prompt.append("당신은 여행 동선을 최적화하는 여행 전문가입니다.\n\n");
	
	    // 여행 정보
	    prompt.append("사용자는 다음과 같은 여행 계획을 가지고 있습니다:\n");
	    prompt.append("- 이동 수단: ").append(transportType).append("\n");
	    prompt.append("- 여행 기간: ").append(scheduleStart).append(" ~ ").append(scheduleEnd).append("\n\n");
	
	    // 선택한 장소 목록 출력
	    prompt.append("여행자가 선택한 장소 목록은 다음과 같습니다:\n");
	    for (PlaceDto place : placeList) {
	        prompt.append("- ").append(place.getPlaceName())
	              .append(" (").append(place.getPlaceCategory()).append(", ")
	              .append(place.getPlaceRoadAddr()).append(")\n");
	    }
	
	    // 일정 구성 조건 설명
	    prompt.append("\n아래 조건에 따라 요일별 일정을 구성해주세요:\n");
	    prompt.append("1. 하루 기준:\n");
	    prompt.append("   - 아침, 점심, 저녁 식사 장소 각 1곳 포함\n");
	    prompt.append("   - 명소는 하루 1~3곳 포함\n");
	    prompt.append("   - 숙소 1곳 포함\n");
	    prompt.append("2. 장소 간 이동 동선을 고려하여 효율적으로 구성해주세요.\n");
	    prompt.append("3. 결과는 반드시 다음 형식으로 출력해주세요:\n\n");
	
	    // 출력 예시 제공
	    prompt.append("형식 예시:\n");
	    prompt.append("1일차\n");
	    prompt.append("- 아침: 에그드랍 서초점\n");
	    prompt.append("- 명소1: 서울 더 현대\n");
	    prompt.append("- 점심: 마마스 서래마을본점\n");
	    prompt.append("- 명소2: 롯데월드타워\n");
	    prompt.append("- 저녁: 라이너스 바베큐\n");
	    prompt.append("- 숙소: 글래드 강남 코엑스 센터\n\n");
	
	    prompt.append("2일차\n");
	    prompt.append("- 아침: ...\n");
	    prompt.append("...\n\n");
	
	    // 결과 형식 제한
	    prompt.append("출력은 반드시 위와 같이 '요일 단위 + 장소명만' 포함된 목록으로 해주세요.\n");
	    prompt.append("설명, 요약, 기타 문장은 생략하고, 장소명만 명확히 반환해주세요.");
	
	    return prompt.toString();
	}
	
}
