package com.travelbooking.travelbookingsystem.model; // 确保包名正确

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

    // --- 新增字段 ---
    // columnDefinition 用于确保数据库中的默认值被 JPA 识别
    @Column(columnDefinition = "INT DEFAULT 2")
    private int maxGuestsPerRoom;

    // --- Getters 和 Setters ---
    // (请使用 IntelliJ 快捷键为所有字段生成或更新 Getters 和 Setters)

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

    // 新字段的 Getter 和 Setter
    public int getMaxGuestsPerRoom() {
        return maxGuestsPerRoom;
    }

    public void setMaxGuestsPerRoom(int maxGuestsPerRoom) {
        this.maxGuestsPerRoom = maxGuestsPerRoom;
    }
}