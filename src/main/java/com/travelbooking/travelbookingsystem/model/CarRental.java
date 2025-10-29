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

    // --- Getters 和 Setters ---
    // (请使用 IntelliJ 快捷键生成: Cmd+N 或 Ctrl+Enter -> "Getter and Setter")

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
}
