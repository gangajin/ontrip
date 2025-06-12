package com.onTrip.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.onTrip.dao.PlaceDao;
import com.onTrip.dto.PlaceDto;
import com.onTrip.service.DestinationService;
import com.onTrip.service.PlaceService;
import com.onTrip.service.ScheduleService;

import jakarta.servlet.http.HttpServletRequest;

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

 // 장소 등록 폼 이동
    @GetMapping("/admin/insertArea")
    public String showAdminAreaInsertForm(@RequestParam(value="destinationNum", required=false) Integer destinationNum,
                                          Model model) {
        System.out.println("📌 showAdminAreaInsertForm → destinationNum = " + destinationNum);
        model.addAttribute("destinationNum", destinationNum);
        return "Admin/adminAreaInsert";
    }

    // 장소 등록 처리 후 Step2로 redirect
    @RequestMapping("admin/includeinsertArea")
    public String insertArea(@ModelAttribute PlaceDto placeDto,
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

        String destinationName = URLEncoder.encode(destinationService.getDestinationByNum(placeDto.getDestinationNum()).getNameKo(), "UTF-8");

        // Redirect → step2 (스케줄정보는 일단 고정값으로 넣거나 앞으로 세션에 저장해서 넘기기)
        return "redirect:/step2?destinationNum=" + placeDto.getDestinationNum()
                + "&destinationName=" + destinationName
                + "&scheduleStart=2025-06-10" // 임시값
                + "&scheduleEnd=2025-06-12";  // 임시값
    }

    // 🔥 삭제 추천 → ScheduleController에서 관리하기 때문에 중복 필요 없음
    // @RequestMapping("Schedule/selectPlace") → 삭제

    // AJAX 키워드 검색
    @GetMapping("/search")
    @ResponseBody
    public List<PlaceDto> searchPlace(@RequestParam("destinationNum") int destinationNum,
                                      @RequestParam("keyword") String keyword) {
        return placeService.searchPlace(destinationNum, keyword);
    }

    // AJAX 카테고리별 추천
    @GetMapping("/recommend")
    @ResponseBody
    public List<PlaceDto> recommendPlace(@RequestParam("destinationNum") int destinationNum,
                                         @RequestParam("categories") String categories) {
        List<String> categoryList = Arrays.asList(categories.split(","));
        return placeService.recommendPlace(destinationNum, categoryList);
    }
}
