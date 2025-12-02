package com.travelbooking.travelbookingsystem.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "Hotel")
public class Hotel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String location;
    private BigDecimal pricePerNight;
    private int availableRooms;

    @Column(columnDefinition = "INT DEFAULT 2")
    private int maxGuestsPerRoom;

    @Column(length = 512)
    private String imageUrl;

    // --- 新增字段 (基于截图优化) ---

    @Column(precision = 2, scale = 1)
    private double rating; // 评分 (8.8)

    private int reviewCount; // 评论数 (1463)

    private int starRating; // 星级 (4)

    private String distanceText; // "1.5 km from center"

    private boolean freeCancellation;
    private boolean breakfastIncluded;
    private boolean noPrepayment;

    // --- Getters and Setters ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }

    public int getAvailableRooms() { return availableRooms; }
    public void setAvailableRooms(int availableRooms) { this.availableRooms = availableRooms; }

    public int getMaxGuestsPerRoom() { return maxGuestsPerRoom; }
    public void setMaxGuestsPerRoom(int maxGuestsPerRoom) { this.maxGuestsPerRoom = maxGuestsPerRoom; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public int getStarRating() { return starRating; }
    public void setStarRating(int starRating) { this.starRating = starRating; }

    public String getDistanceText() { return distanceText; }
    public void setDistanceText(String distanceText) { this.distanceText = distanceText; }

    public boolean isFreeCancellation() { return freeCancellation; }
    public void setFreeCancellation(boolean freeCancellation) { this.freeCancellation = freeCancellation; }

    public boolean isBreakfastIncluded() { return breakfastIncluded; }
    public void setBreakfastIncluded(boolean breakfastIncluded) { this.breakfastIncluded = breakfastIncluded; }

    public boolean isNoPrepayment() { return noPrepayment; }
    public void setNoPrepayment(boolean noPrepayment) { this.noPrepayment = noPrepayment; }
}