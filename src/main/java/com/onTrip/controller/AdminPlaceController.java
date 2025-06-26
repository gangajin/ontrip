package com.onTrip.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.onTrip.dao.DestinationDao;
import com.onTrip.dao.PlaceDao;
import com.onTrip.dto.DestinationDto;
import com.onTrip.dto.PlaceDto;
import com.onTrip.service.PlaceService;

@Controller
@RequestMapping("/admin/place")
public class AdminPlaceController {

    @Autowired
    private PlaceDao placeDao;

    @Autowired
    private DestinationDao destinationDao;

    @Autowired
    private PlaceService placeService;

    // 장소 목록 조회 + 필터 + 페이징
    @GetMapping("/list")
    public String adminPlaceList(
            @RequestParam(value = "destinationNum", required = false) Integer destinationNum,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        int pageSize = 10;
        int start = (page - 1) * pageSize;

        List<DestinationDto> destinationList = destinationDao.selectAll(); // 드롭다운 용

        List<PlaceDto> placeList;
        int totalPlaces;

        if (destinationNum != null) {
            placeList = placeDao.adminPlaceByDestination(destinationNum);
            totalPlaces = placeList.size();  // 필터 결과 전체 수
            model.addAttribute("selectedDestinationNum", destinationNum);
        } else {
            placeList = placeService.adminPagedPlaces(start, pageSize);
            totalPlaces = placeService.adminPlaceCount();
        }

        int totalPages = (int) Math.ceil((double) totalPlaces / pageSize);
        
        //페이징 블럭계산
        int pageBlock = 10;
        int blockStart = ((page - 1) / pageBlock) * pageBlock + 1;
        int blockEnd = Math.min(blockStart + pageBlock - 1, totalPages);

        model.addAttribute("destinationList", destinationList);
        model.addAttribute("placeList", placeList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("blockStart", blockStart);
        model.addAttribute("blockEnd", blockEnd);

        return "Admin/adminPlaceList";
    }

    // 장소 삭제
    @PostMapping("/delete")
    public String adminDeletePlace(@RequestParam("placeNum") int placeNum,
                                   @RequestParam(value = "destinationNum", required = false) Integer destinationNum) {

        placeDao.admindeletePlace(placeNum);

        if (destinationNum != null) {
            return "redirect:/admin/place/list?destinationNum=" + destinationNum;
        } else {
            return "redirect:/admin/place/list";
        }
    }
    
    // 키워드 검색 (placeName, placeRoadAddr)
    @GetMapping("/search")
    public String adminSearchPlace(@RequestParam("keyword") String keyword, Model model) {

        List<DestinationDto> destinationList = destinationDao.selectAll();  // 드롭다운 유지용
        List<PlaceDto> placeList = placeService.adminSearchPlace(keyword);

        model.addAttribute("destinationList", destinationList);
        model.addAttribute("placeList", placeList);
        model.addAttribute("keyword", keyword);

        return "Admin/adminPlaceList";
    }
}
