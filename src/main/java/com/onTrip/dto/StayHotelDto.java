package com.onTrip.dto;

import java.time.LocalDate;

import lombok.Data;
@Data
public class StayHotelDto {
   private int stayHotelNum;
   private LocalDate stayHotelDate;
   private int scheduleNum ;
   private int placeNum ; 
   
   private String placeName;
   private String placeImage;
   
   private double placeLat;
   private double placeLong;
}
