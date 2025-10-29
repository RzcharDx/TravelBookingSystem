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

    // --- Getters 和 Setters ---
    // (请使用 IntelliJ 快捷键生成)

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public BigDecimal getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(BigDecimal pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public int getAvailableRooms() {
        return availableRooms;
    }

    public void setAvailableRooms(int availableRooms) {
        this.availableRooms = availableRooms;
    }
}