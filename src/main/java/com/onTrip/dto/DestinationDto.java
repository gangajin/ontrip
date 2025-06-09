package com.onTrip.dto;

import lombok.Data;

@Data
public class DestinationDto {
    private int destinationNum;      
    private String nameKo;           
    private String nameEn;           
    private double destinationLat;   
    private double destinationLong;  
    private String destinationImage; 
    private String destinationContent;
}

