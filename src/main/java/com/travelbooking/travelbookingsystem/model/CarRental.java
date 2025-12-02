package com.travelbooking.travelbookingsystem.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "CarRental")
public class CarRental {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String company;
    private String model;
    private String pickupLocation;
    private BigDecimal pricePerDay;
    private int availableCars;

    @Column(nullable = true)
    private String dropoffLocation;

    @Column(columnDefinition = "INT DEFAULT 21")
    private int minDriverAge;

    // --- 新增字段 (用于 UI 展示) ---

    @Column(length = 512)
    private String imageUrl;

    private String category; // Economy, Compact, SUV

    // 规格
    private int seats;
    private int doors;
    private int bags;
    private String transmission; // Automatic, Manual
    private boolean airConditioning;

    // 评分
    @Column(precision = 2, scale = 1)
    private double rating;
    private int reviewCount;

    // 政策
    private String fuelPolicy; // Full to full
    private boolean unlimitedMileage;
    private boolean freeCancellation;

    // --- Getters and Setters ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }

    public BigDecimal getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(BigDecimal pricePerDay) { this.pricePerDay = pricePerDay; }

    public int getAvailableCars() { return availableCars; }
    public void setAvailableCars(int availableCars) { this.availableCars = availableCars; }

    public String getDropoffLocation() { return dropoffLocation; }
    public void setDropoffLocation(String dropoffLocation) { this.dropoffLocation = dropoffLocation; }

    public int getMinDriverAge() { return minDriverAge; }
    public void setMinDriverAge(int minDriverAge) { this.minDriverAge = minDriverAge; }

    // 新增字段的 Getter/Setter
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getSeats() { return seats; }
    public void setSeats(int seats) { this.seats = seats; }

    public int getDoors() { return doors; }
    public void setDoors(int doors) { this.doors = doors; }

    public int getBags() { return bags; }
    public void setBags(int bags) { this.bags = bags; }

    public String getTransmission() { return transmission; }
    public void setTransmission(String transmission) { this.transmission = transmission; }

    public boolean isAirConditioning() { return airConditioning; }
    public void setAirConditioning(boolean airConditioning) { this.airConditioning = airConditioning; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public String getFuelPolicy() { return fuelPolicy; }
    public void setFuelPolicy(String fuelPolicy) { this.fuelPolicy = fuelPolicy; }

    public boolean isUnlimitedMileage() { return unlimitedMileage; }
    public void setUnlimitedMileage(boolean unlimitedMileage) { this.unlimitedMileage = unlimitedMileage; }

    public boolean isFreeCancellation() { return freeCancellation; }
    public void setFreeCancellation(boolean freeCancellation) { this.freeCancellation = freeCancellation; }
}