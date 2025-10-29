package com.travelbooking.travelbookingsystem.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Flight")
public class Flight {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String airline;

    // --- 新增字段 ---
    @Column(nullable = true)
    private String flightNumber; // 例如 "BA101"

    private String origin;
    private String destination;
    private LocalDateTime departureTime;

    // --- 新增字段 ---
    @Column(nullable = true) // 允许为空
    private LocalDateTime arrivalTime;

    private BigDecimal price;
    private int availableSeats;

    @Column(nullable = true)
    private String cabinClass; // 例如 'Economy', 'Business'

    @Column(columnDefinition = "BOOLEAN DEFAULT FALSE")
    private boolean isDirect;

    // --- Getters 和 Setters ---
    // (请使用 IntelliJ 快捷键为所有字段生成或更新 Getters 和 Setters)

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getAirline() { return airline; }
    public void setAirline(String airline) { this.airline = airline; }
    public String getFlightNumber() { return flightNumber; } // 新增
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; } // 新增
    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    public LocalDateTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalDateTime departureTime) { this.departureTime = departureTime; }
    public LocalDateTime getArrivalTime() { return arrivalTime; } // 新增
    public void setArrivalTime(LocalDateTime arrivalTime) { this.arrivalTime = arrivalTime; } // 新增
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
    public String getCabinClass() { return cabinClass; }
    public void setCabinClass(String cabinClass) { this.cabinClass = cabinClass; }
    public boolean isDirect() { return isDirect; }
    public void setDirect(boolean direct) { isDirect = direct; }
}