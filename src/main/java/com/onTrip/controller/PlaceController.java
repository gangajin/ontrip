package com.onTrip.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.onTrip.dao.PlaceDao;
import com.onTrip.dto.PlaceDto;
import com.onTrip.service.DestinationService;
import com.onTrip.service.PlaceService;
import com.onTrip.service.ScheduleService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PlaceController {

    @Autowired
    public PlaceDao placedao;

    @Autowired
    public PlaceService placeService;

    @Autowired
    public DestinationService destinationService;

    @Autowired
    public ScheduleService scheduleService;

    @RequestMapping("/insertplaceform")
    public String insertHotelForm() {
        return "Admin/adminPlaceInsert";
    }

    @RequestMapping("/insertplace")
    public String insertHotel(@ModelAttribute PlaceDto placeDto,
                              @RequestParam("placeImageFile") MultipartFile file,
                              HttpServletRequest request) throws Exception {

        String webPath = "/images/";
        String realPath = request.getServletContext().getRealPath(webPath);

        File dir = new File(realPath);
        if (!dir.exists()) dir.mkdirs();

        if (!file.isEmpty()) {
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String uuid = UUID.randomUUID().toString();
            String saveFilename = uuid + extension;

            File saveFile = new File(realPath, saveFilename);
            file.transferTo(saveFile);

            placeDto.setPlaceImage(webPath + saveFilename);
        }

        placedao.insertPlace(placeDto);
        return "redirect:insertplaceform";
    }

    @RequestMapping("/admin/Popup")
    public String jusoPopup() {
        return "Admin/jusoPopup";
    }

    // 장소 등록 폼 이동 (세션 사용)
    @GetMapping("/admin/insertArea")
    public String showAdminAreaInsertForm(HttpSession session, Model model) {

        Integer destinationNum = (Integer) session.getAttribute("destinationNum");
        String scheduleStart = (String) session.getAttribute("scheduleStart");
        String scheduleEnd = (String) session.getAttribute("scheduleEnd");

        System.out.println("📌 showAdminAreaInsertForm → destinationNum = " + destinationNum);

        model.addAttribute("destinationNum", destinationNum);
        model.addAttribute("scheduleStart", scheduleStart);
        model.addAttribute("scheduleEnd", scheduleEnd);

        return "Admin/adminAreaInsert";
    }

    // 장소 등록 처리 후 step2로 redirect (세션 기반)
    @RequestMapping("admin/includeinsertArea")
    public String insertArea(@ModelAttribute PlaceDto placeDto,
                             @RequestParam("placeImageFile") MultipartFile file,
                             HttpSession session,
                             HttpServletRequest request) throws Exception {

        Integer destinationNum = (Integer) session.getAttribute("destinationNum");
        String scheduleStart = (String) session.getAttribute("scheduleStart");
        String scheduleEnd = (String) session.getAttribute("scheduleEnd");

        String webPath = "/images/";
        String realPath = request.getServletContext().getRealPath(webPath);

        File dir = new File(realPath);
        if (!dir.exists()) dir.mkdirs();

        if (!file.isEmpty()) {
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String uuid = UUID.randomUUID().toString();
            String saveFilename = uuid + extension;

            File saveFile = new File(realPath, saveFilename);
            file.transferTo(saveFile);

            placeDto.setPlaceImage(webPath + saveFilename);
        }

        placedao.insertPlace(placeDto);

        return "redirect:/step2"
        		+ "?destinationNum=" + destinationNum
                + "&destinationName=" + URLEncoder.encode(placeDto.getPlaceName(), "UTF-8")
                + "&destinationLat=" + placeDto.getPlaceLat()
                + "&destinationLong=" + placeDto.getPlaceLong()
                + "&scheduleStart=" + scheduleStart
                + "&scheduleEnd=" + scheduleEnd;
    }
}
