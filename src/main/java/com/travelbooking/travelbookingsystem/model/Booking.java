package com.travelbooking.travelbookingsystem.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Booking")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private LocalDateTime bookingDate;

    @Column(nullable = false)
    private BigDecimal totalPrice;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userId", nullable = false) // "userId" 是 "Booking" 表中的外键列
    private User user;

    // 注意：一个更复杂的设计会使用 @OneToMany 来关联一个 "BookingItem" 实体，
    // "BookingItem" 再去关联 Flight 或 Hotel。
    // 但为了简单起见，我们可以在 EJB 逻辑中处理总价。

    // --- Getters 和 Setters ---
    // (请使用 IntelliJ 快捷键生成)

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}