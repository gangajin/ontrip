package com.onTrip.service;

import java.util.ArrayList ;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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

    public String buildAiPrompt(List<PlaceDto> placeList, String transportType, String scheduleStart, String scheduleEnd) {
        StringBuilder prompt = new StringBuilder();

        prompt.append("당신은 여행 동선을 최적화하는 여행 전문가입니다.\n\n");
        prompt.append("사용자는 다음과 같은 여행 계획을 가지고 있습니다:\n");
        prompt.append("- 이동 수단: ").append(transportType).append("\n");
        prompt.append("- 여행 기간: ").append(scheduleStart).append(" ~ ").append(scheduleEnd).append("\n\n");

        prompt.append("여행자가 선택한 장소 목록은 다음과 같습니다:\n");
        for (PlaceDto place : placeList) {
            prompt.append("- ").append(place.getPlaceName())
                  .append(" (").append(place.getPlaceCategory()).append(", ")
                  .append(place.getPlaceRoadAddr()).append(")\n");
        }

        prompt.append("\n아래 조건에 따라 요일별 일정을 구성해주세요:\n");

        prompt.append("1. 하루 기준 일정 흐름:\n");
        prompt.append("   - 하루 일정은 다음 순서를 따르세요 :\n");
        prompt.append("     호텔 → 명소 → 식당 → 카페 → 명소 → 호텔\n");
        prompt.append("   - 첫날은 기차역에서 시작하고 호텔에서 마무리하세요.\n");
        prompt.append("   - 마지막 날은 호텔에서 시작해서 기차역에서 마무리하세요.\n");
        prompt.append("   - 숙소는 하루의 시작 또는 끝에만 등장해야 하며, 하루에 2번 이상 포함하지 마세요.\n");
        prompt.append("   - 둘째 날 부터 전날 마무리했던 숙소 위치헤서 시작해야합니다.\n\n");
        prompt.append("   - 명소는 하루에 1~3곳 포함하세요. 같은 장소 반복 금지.\n");
        
        prompt.append("2. 지역 기준 구성:\n");
        prompt.append("   - 하루 일정은 반드시 같은 '구(區)' 또는 인접한 구 1개 내에서만 구성하세요.\n");
        prompt.append("   - 서로 멀리 떨어진 지역(구/동)을 하루에 섞지 마세요.\n");
        prompt.append("   - 인접한 장소끼리 묶어서 동선이 자연스럽게 연결되도록 하세요.\n");
        prompt.append("   - 예: 기장에서 시작했다면 기장과 해운대 정도까지만 포함하세요.\n\n");

        prompt.append("3. 이동시간 명시:\n");
        prompt.append("   - 장소 간 이동시간(시속 60km 기준)은 반드시 다음 형식으로 출력하세요:\n");
        prompt.append("     \"→ 🚗 약 XX분 이동\"\n\n");

        prompt.append("4. 장소 제한:\n");
        prompt.append("   - 사용자가 선택한 장소 목록 외의 장소는 절대 포함하지 마세요.\n\n");

        prompt.append("5. 출력 형식:\n");
        prompt.append("   - 출력은 아래 형식을 따라야 합니다:\n");
        prompt.append("     [장소명] → 🚗 약 XX분 이동 → [장소명] → ...\n");
        prompt.append("   - 각 장소는 줄 단위로 작성하세요. 설명, 요약, 해설 문장 금지.\n\n");

        prompt.append("6. 정확한 명칭:\n");
        prompt.append("   - 장소명을 정확히 반환하고, 주소나 요약 문장은 포함하지 마세요.\n\n");

        prompt.append("\n형식 예시:\n");
        prompt.append("1일차\n");
        prompt.append("시그니엘 부산 \n");
        prompt.append("→ 🚗 약 12분 이동\n");
        prompt.append("해운대 블루라인파크\n");
        prompt.append("→ 🚗 약 15분 이동\n");
        prompt.append("오반장 밀면\n");
        prompt.append("→ 🚗 약 10분 이동\n");
        prompt.append("미포철길\n");
        prompt.append("→ 🚗 약 8분 이동\n");
        prompt.append("미포카페거리\n");
        prompt.append("→ 🚗 약 9분 이동\n");
        prompt.append("시그니엘 부산\n");
        return prompt.toString();
    }

    public List<String> getOrderedLinesWithMemo(String prompt) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            String requestBody = """
                {
                    \"model\": \"gpt-4\",
                    \"messages\": [
                        { \"role\": \"system\", \"content\": \"너는 여행 전문가이자 동선 설계자야. 사용자의 장소 리스트를 가장 효율적인 순서로 재배열해줘.\" },
                        { \"role\": \"user\", \"content\": \"%s\" }
                    ],
                    \"temperature\": 0.7
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
                    line = line.trim();
                    if (!line.isEmpty()) {
                        result.add(line);
                    }
                }
                return result;
            } else {
                throw new RuntimeException("GPT 호출 실패: " + response.getStatusCode());
            }

        } catch (Exception e) {
            throw new RuntimeException("GPT 처리 오류", e);
        }
    }

    public List<String> getOrderedPlaceNames(String prompt) {
        List<String> rawLines = getOrderedLinesWithMemo(prompt);
        List<String> result = new ArrayList<>();
        Set<String> seen = new HashSet<>();
        for (String line : rawLines) {
            if (line.startsWith("→")) continue;
            line = line.replaceAll("^[0-9]+[.)]?\\s*", "")
                       .replaceAll("^(아침|점심|저녁|숙소|명소\\d*):\\s*", "")
                       .replaceAll("[^가-힣a-zA-Z0-9\\s]", "")
                       .trim();
            if (!line.isEmpty() && seen.add(line)) {
                result.add(line);
            }
        }
        return result;
    }

    public List<PlaceDto> matchOrderedPlaces(List<String> orderedNames, List<PlaceDto> placeList) {
        List<PlaceDto> orderedList = new ArrayList<>();
        Set<Integer> seenPlaceNums = new HashSet<>();

        for (String name : orderedNames) {
            String cleanedName = name.trim()
                                     .replaceAll("[^가-힣a-zA-Z0-9\\s]", "")
                                     .toLowerCase();

            for (PlaceDto place : placeList) {
                String dbName = place.getPlaceName().trim()
                                     .replaceAll("[^가-힣a-zA-Z0-9\\s]", "")
                                     .toLowerCase();
                String dbAddr = place.getPlaceRoadAddr().trim()
                                     .replaceAll("[^가-힣a-zA-Z0-9\\s]", "")
                                     .toLowerCase();

                if ((dbName.equals(cleanedName) || dbName.contains(cleanedName) || cleanedName.contains(dbName) ||
                     dbAddr.equals(cleanedName) || dbAddr.contains(cleanedName) || cleanedName.contains(dbAddr))
                    && seenPlaceNums.add(place.getPlaceNum())) {
                    orderedList.add(place);
                    break;
                }
            }
        }

        return orderedList;
    }
} 
