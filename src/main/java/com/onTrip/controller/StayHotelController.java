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
    public PlaceDao placedao;

    @Autowired
    public ScheduleDao scheduleDao;

    @Autowired
    public StayHotelDao stayhoteldao;
    
    @Autowired
    DestinationDao destinationDao;

    @RequestMapping("selectStayHotel")
    public String selectStayHotel(
            @RequestParam("destinationNum") int destinationNum,
            HttpSession session,
            Model model) {

	    	String scheduleStartStr = (String) session.getAttribute("scheduleStart");
	    	String scheduleEndStr = (String) session.getAttribute("scheduleEnd");
	
	    	LocalDate scheduleStart = LocalDate.parse(scheduleStartStr);
	    	LocalDate scheduleEnd = LocalDate.parse(scheduleEndStr);

        if (session.getAttribute("scheduleNum") == null) {
            Integer userNum = (Integer) session.getAttribute("userNum"); // 로그인된 유저 번호


            ScheduleDto scheduleDto = new ScheduleDto();
            scheduleDto.setUserNum(userNum);
            scheduleDto.setDestinationNum(destinationNum);
            scheduleDto.setScheduleStart(scheduleStart);
            scheduleDto.setScheduleEnd(scheduleEnd);
            int scheduleNum = scheduleDto.getScheduleNum();
            session.setAttribute("scheduleNum", scheduleNum);
        }
        DestinationDto destination = destinationDao.selectByNum(destinationNum);
        
        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("destinationLat", destination.getDestinationLat());
        model.addAttribute("destinationLong", destination.getDestinationLong());
        model.addAttribute("destinationName", destination.getNameKo());
        
        model.addAttribute("hotelList", placedao.placeHotelList(destinationNum));
        model.addAttribute("scheduleStart", scheduleStart);
        model.addAttribute("scheduleEnd", scheduleEnd);

        List<String> travelDates = new ArrayList<>();
        for (LocalDate date = scheduleStart; !date.isAfter(scheduleEnd); date = date.plusDays(1)) {
            travelDates.add(date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        }

        session.setAttribute("travelDates", travelDates); 
        return "Schedule/selectStayHotel";
    }

    @RequestMapping("/saveStayHotel")
    public String saveStayHotel(HttpServletRequest request, HttpSession session) {
        Integer userNum = (Integer) session.getAttribute("userNum");
        if (userNum == null) {
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
    //로그인을 하면 저장됨
    @RequestMapping("/resumeStayHotelSave")
    public String resumeStayHotelSave(HttpSession session) {
        String[] stayHotelDates = (String[]) session.getAttribute("temp_stayHotelDate");
        String[] placeNums = (String[]) session.getAttribute("temp_placeNum");

        if (stayHotelDates == null || placeNums == null) {
            return "redirect:/"; 
        }

        int scheduleNum = (Integer) session.getAttribute("scheduleNum");

        for (int i = 0; i < stayHotelDates.length; i++) {
            stayhoteldao.insertStayHotel(scheduleNum, stayHotelDates[i], Integer.parseInt(placeNums[i]));
        }

        session.removeAttribute("temp_stayHotelDate");
        session.removeAttribute("temp_placeNum");

        return "redirect:/scheduleDetail?scheduleNum=" + scheduleNum;
    }
}