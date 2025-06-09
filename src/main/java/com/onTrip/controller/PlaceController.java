package com.onTrip.controller;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.onTrip.dao.PlaceDao;
import com.onTrip.dto.PlaceDto;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PlaceController {
	@Autowired
	public PlaceDao placedao;
	
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
    @RequestMapping("Popup")
    public String jusoPopup() {
        return "Admin/jusoPopup";
    }
}
