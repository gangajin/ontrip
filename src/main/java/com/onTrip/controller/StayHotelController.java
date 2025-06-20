package com.onTrip.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.onTrip.dao.DestinationDao;
import com.onTrip.dao.PlaceDao;
import com.onTrip.dao.ScheduleDao;
import com.onTrip.dao.StayHotelDao;
import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.PlaceDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class StayHotelController {

    @Autowired
    private PlaceDao placedao;

    @Autowired
    private ScheduleDao scheduleDao;

    @Autowired
    private StayHotelDao stayhoteldao;

    @Autowired
    private DestinationDao destinationDao;

    @RequestMapping("selectStayHotel")
    public String selectStayHotel(
            @RequestParam("destinationNum") int destinationNum,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "scheduleStart", required = false) String startStr,
            @RequestParam(value = "scheduleEnd", required = false) String endStr,
            HttpSession session,
            Model model) {


        // 날짜 가져오기
        Object startObj = session.getAttribute("scheduleStart");
        Object endObj = session.getAttribute("scheduleEnd");

        LocalDate scheduleStart;
        LocalDate scheduleEnd;

        try {
            scheduleStart = (startObj instanceof String)
                    ? LocalDate.parse((String) startObj)
                    : (LocalDate) startObj;

            scheduleEnd = (endObj instanceof String)
                    ? LocalDate.parse((String) endObj)
                    : (LocalDate) endObj;
        } catch (Exception e) {
            scheduleStart = LocalDate.now();
            scheduleEnd = scheduleStart.plusDays(2);
            session.setAttribute("scheduleStart", scheduleStart.toString());
            session.setAttribute("scheduleEnd", scheduleEnd.toString());
        }

        // 날짜 리스트 생성
        List<String> travelDates = new ArrayList<>();
        LocalDate current = scheduleStart;
        while (current.isBefore(scheduleEnd)) {
            travelDates.add(current.toString());
            current = current.plusDays(1);
        }
        model.addAttribute("travelDates", travelDates);

        // 목적지 정보
        DestinationDto destination = destinationDao.selectByNum(destinationNum);
        if (destination == null) throw new RuntimeException("목적지 조회 실패");

        model.addAttribute("destinationLat", destination.getDestinationLat());
        model.addAttribute("destinationLong", destination.getDestinationLong());
        model.addAttribute("destinationName", destination.getNameKo());
        model.addAttribute("destinationNum", destinationNum);

        // 숙소 리스트
        List<PlaceDto> hotelList = (keyword == null || keyword.isEmpty())
                ? placedao.placeHotelList(destinationNum)
                : placedao.searchHotel(destinationNum, keyword);
        model.addAttribute("hotelList", hotelList);

        // JSON 변환
        try {
        	String json = new ObjectMapper().writeValueAsString(hotelList);
            System.out.println("🔥 직렬화된 hotelListJson: " + json);  // ← 이 줄
        	model.addAttribute("hotelListJson", json); 
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            model.addAttribute("hotelListJson", "[]");
        }
        for (PlaceDto hotel : hotelList) {
            System.out.println("호텔명: " + hotel.getPlaceName());
            System.out.println("placelike: " + hotel.getPlacelike());
        }
        return "Schedule/selectStayHotel";
    }

    @RequestMapping("saveStayHotel")
    public String saveStayHotel(HttpServletRequest request, HttpSession session, Model model) {
        Integer userNum = (Integer) session.getAttribute("userNum");
        String[] stayHotelDates = request.getParameterValues("stayHotelDate");
        String[] placeNums = request.getParameterValues("placeNum");
        
        if (stayHotelDates == null || placeNums == null || stayHotelDates.length == 0 || placeNums.length == 0) {
            model.addAttribute("errorMessage", "숙소를 최소 1개 이상 선택해야 합니다.");
            return "stayHotelError"; 
        }

        if (userNum == null) {
            session.setAttribute("temp_stayHotelDate", request.getParameterValues("stayHotelDate"));
            session.setAttribute("temp_placeNum", request.getParameterValues("placeNum"));
            session.setAttribute("redirectAfterLogin", "/resumeStayHotelSave");
            return "redirect:/login";
        }

        int scheduleNum = (Integer) session.getAttribute("scheduleNum");

        for (int i = 0; i < stayHotelDates.length; i++) {
            stayhoteldao.insertStayHotel(scheduleNum, stayHotelDates[i], Integer.parseInt(placeNums[i]));
        }

        return "redirect:/schedulePreview?scheduleNum=" + scheduleNum;
    }

    @RequestMapping("resumeStayHotelSave")
    public String resumeStayHotelSave(HttpSession session) {
        String[] stayHotelDates = (String[]) session.getAttribute("temp_stayHotelDate");
        String[] placeNums = (String[]) session.getAttribute("temp_placeNum");
        Integer userNum = (Integer) session.getAttribute("userNum");
        Integer scheduleNum = (Integer) session.getAttribute("scheduleNum");

        if (stayHotelDates == null || placeNums == null || userNum == null) {
            return "redirect:/";
        }

        if (scheduleNum == null) {
            int destinationNum = (Integer) session.getAttribute("destinationNum");

            Object startObj = session.getAttribute("scheduleStart");
            Object endObj = session.getAttribute("scheduleEnd");

            LocalDate start, end;

            try {
                start = (startObj instanceof String)
                        ? LocalDate.parse((String) startObj)
                        : (LocalDate) startObj;

                end = (endObj instanceof String)
                        ? LocalDate.parse((String) endObj)
                        : (LocalDate) endObj;
            } catch (Exception e) {
                throw new RuntimeException("여행 날짜가 유효하지 않습니다.", e);
            }

            scheduleDao.insertSchedule(destinationNum, start, end, userNum);
            scheduleNum = scheduleDao.getLastInsertId();
            session.setAttribute("scheduleNum", scheduleNum);
        }

        for (int i = 0; i < stayHotelDates.length; i++) {
            stayhoteldao.insertStayHotel(scheduleNum, stayHotelDates[i], Integer.parseInt(placeNums[i]));
        }

        session.removeAttribute("temp_stayHotelDate");
        session.removeAttribute("temp_placeNum");

        return "redirect:/scheduleDetail?scheduleNum=" + scheduleNum;
    }

    @ResponseBody
    @RequestMapping("/ajax/searchHotel")
    public List<PlaceDto> searchHotel(@RequestParam("destinationNum") int destinationNum,
                                      @RequestParam("keyword") String keyword) {
        List<PlaceDto> result = placedao.searchHotel(destinationNum, keyword);
        return result;
    }
}
