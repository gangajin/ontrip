package com.onTrip.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dao.DestinationDao;
import com.onTrip.dao.PlaceDao;
import com.onTrip.dao.ScheduleDao;
import com.onTrip.dao.StayHotelDao;
import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.ScheduleDto;

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
            HttpSession session,
            Model model) {

        // 날짜 파싱
        LocalDate scheduleStart;
        LocalDate scheduleEnd;

        Object startObj = session.getAttribute("scheduleStart");
        Object endObj = session.getAttribute("scheduleEnd");

        if (startObj instanceof String) {
            scheduleStart = LocalDate.parse((String) startObj);
            scheduleEnd = LocalDate.parse((String) endObj);
        } else {
            scheduleStart = (LocalDate) startObj;
            scheduleEnd = (LocalDate) endObj;
        }

        // 일정 번호가 없고 로그인 상태일 경우 일정 생성
        if (session.getAttribute("scheduleNum") == null && session.getAttribute("userNum") != null) {
            Integer userNum = (Integer) session.getAttribute("userNum");

            ScheduleDto scheduleDto = new ScheduleDto();
            scheduleDto.setUserNum(userNum);
            scheduleDto.setDestinationNum(destinationNum);
            scheduleDto.setScheduleStart(scheduleStart);
            scheduleDto.setScheduleEnd(scheduleEnd);

            scheduleDao.insertSchedule(destinationNum, scheduleStart, scheduleEnd, userNum);
            int scheduleNum = scheduleDao.getLastInsertId(); // ← insert 후 ID를 가져오는 방식 필요
            session.setAttribute("scheduleNum", scheduleNum);
        }

        // 목적지 및 호텔 정보 전달
        DestinationDto destination = destinationDao.selectByNum(destinationNum);

        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("destinationLat", destination.getDestinationLat());
        model.addAttribute("destinationLong", destination.getDestinationLong());
        model.addAttribute("destinationName", destination.getNameKo());
        model.addAttribute("hotelList", placedao.placeHotelList(destinationNum));
        model.addAttribute("scheduleStart", scheduleStart);
        model.addAttribute("scheduleEnd", scheduleEnd);

        // 여행 날짜 리스트
        List<String> travelDates = new ArrayList<>();
        for (LocalDate date = scheduleStart; !date.isAfter(scheduleEnd); date = date.plusDays(1)) {
            travelDates.add(date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        }

        session.setAttribute("destinationNum", destinationNum);
        session.setAttribute("travelDates", travelDates);

        return "Schedule/selectStayHotel";
    }

    @RequestMapping("/saveStayHotel")
    public String saveStayHotel(HttpServletRequest request, HttpSession session) {
        Integer userNum = (Integer) session.getAttribute("userNum");

        if (userNum == null) {
            // 로그인 안 된 상태: 임시 저장 후 로그인 요청
            session.setAttribute("temp_stayHotelDate", request.getParameterValues("stayHotelDate"));
            session.setAttribute("temp_placeNum", request.getParameterValues("placeNum"));
            session.setAttribute("redirectAfterLogin", "/resumeStayHotelSave");
            return "redirect:/login";
        }

        int scheduleNum = (Integer) session.getAttribute("scheduleNum");
        String[] stayHotelDates = request.getParameterValues("stayHotelDate");
        String[] placeNums = request.getParameterValues("placeNum");

        for (int i = 0; i < stayHotelDates.length; i++) {
            stayhoteldao.insertStayHotel(scheduleNum, stayHotelDates[i], Integer.parseInt(placeNums[i]));
        }

        return "redirect:/scheduleDetail?scheduleNum=" + scheduleNum;
    }

    @RequestMapping("/resumeStayHotelSave")
    public String resumeStayHotelSave(HttpSession session) {
        String[] stayHotelDates = (String[]) session.getAttribute("temp_stayHotelDate");
        String[] placeNums = (String[]) session.getAttribute("temp_placeNum");

        Integer userNum = (Integer) session.getAttribute("userNum");
        Integer scheduleNum = (Integer) session.getAttribute("scheduleNum");

        if (stayHotelDates == null || placeNums == null || userNum == null) {
            return "redirect:/";
        }

        // 로그인 후 일정이 없다면 생성
        if (scheduleNum == null) {
            int destinationNum = (Integer) session.getAttribute("destinationNum");
            LocalDate scheduleStart;
            LocalDate scheduleEnd;

            Object startObj = session.getAttribute("scheduleStart");
            Object endObj = session.getAttribute("scheduleEnd");

            if (startObj instanceof String) {
                scheduleStart = LocalDate.parse((String) startObj);
                scheduleEnd = LocalDate.parse((String) endObj);
            } else {
                scheduleStart = (LocalDate) startObj;
                scheduleEnd = (LocalDate) endObj;
            }

            ScheduleDto scheduleDto = new ScheduleDto();
            scheduleDto.setUserNum(userNum);
            scheduleDto.setDestinationNum(destinationNum);
            scheduleDto.setScheduleStart(scheduleStart);
            scheduleDto.setScheduleEnd(scheduleEnd);

            scheduleDao.insertSchedule(destinationNum, scheduleStart, scheduleEnd, userNum);
            scheduleNum = scheduleDao.getLastInsertId(); // 실제 저장된 ID 가져오기
            session.setAttribute("scheduleNum", scheduleNum);
        }

        // 숙소 정보 저장
        for (int i = 0; i < stayHotelDates.length; i++) {
            stayhoteldao.insertStayHotel(scheduleNum, stayHotelDates[i], Integer.parseInt(placeNums[i]));
        }

        // 임시 세션 값 제거
        session.removeAttribute("temp_stayHotelDate");
        session.removeAttribute("temp_placeNum");

        return "redirect:/scheduleDetail?scheduleNum=" + scheduleNum;
    }
}