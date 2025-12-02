package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.Booking;
import com.travelbooking.travelbookingsystem.model.Flight;
import com.travelbooking.travelbookingsystem.model.Hotel;
import com.travelbooking.travelbookingsystem.model.User;
import com.travelbooking.travelbookingsystem.model.CarRental;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.PersistenceContext;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class BookingEJB {

    @PersistenceContext(unitName = "travelDB")
    private EntityManager em;

    // --- 核心修改：返回 Booking 对象而不是 boolean ---

    public Booking bookFlight(int userId, int flightId) {
        try {
            User user = em.find(User.class, userId);
            Flight flight = em.find(Flight.class, flightId, LockModeType.PESSIMISTIC_WRITE);

            if (user == null || flight == null || flight.getAvailableSeats() <= 0) {
                return null; // 失败返回 null
            }

            flight.setAvailableSeats(flight.getAvailableSeats() - 1);
            em.merge(flight);

            String desc = "Flight: " + flight.getAirline() + " (" + flight.getOrigin() + " -> " + flight.getDestination() + ")";
            if (flight.getFlightNumber() != null) desc += " [" + flight.getFlightNumber() + "]";

            return createBookingRecord(user, flight.getPrice(), desc);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Booking bookHotel(int userId, int hotelId) {
        try {
            User user = em.find(User.class, userId);
            Hotel hotel = em.find(Hotel.class, hotelId, LockModeType.PESSIMISTIC_WRITE);

            if (user == null || hotel == null || hotel.getAvailableRooms() <= 0) {
                return null;
            }

            hotel.setAvailableRooms(hotel.getAvailableRooms() - 1);
            em.merge(hotel);

            String desc = "Hotel: " + hotel.getName() + " (" + hotel.getLocation() + ")";
            return createBookingRecord(user, hotel.getPricePerNight(), desc);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Booking bookCar(int userId, int carId) {
        try {
            User user = em.find(User.class, userId);
            CarRental car = em.find(CarRental.class, carId, LockModeType.PESSIMISTIC_WRITE);

            if (user == null || car == null || car.getAvailableCars() <= 0) {
                return null;
            }

            car.setAvailableCars(car.getAvailableCars() - 1);
            em.merge(car);

            String desc = "Car Rental: " + car.getCompany() + " " + car.getModel();
            return createBookingRecord(user, car.getPricePerDay(), desc);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // --- 辅助方法 ---

    private Booking createBookingRecord(User user, BigDecimal price, String description) {
        Booking booking = new Booking();
        booking.setUser(user);
        booking.setTotalPrice(price);
        booking.setBookingDate(LocalDateTime.now());
        booking.setDescription(description);
        booking.setStatus("CONFIRMED");

        em.persist(booking);
        em.flush(); // 立即刷新以获取生成的 ID
        return booking; // 返回创建好的对象
    }

    public List<Booking> getBookingsForUser(int userId) {
        return em.createQuery("SELECT b FROM Booking b WHERE b.user.id = :userId ORDER BY b.bookingDate DESC", Booking.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public boolean cancelBooking(int bookingId, int userId) {
        Booking booking = em.find(Booking.class, bookingId);
        if (booking != null && booking.getUser().getId() == userId && !"CANCELLED".equals(booking.getStatus())) {
            booking.setStatus("CANCELLED");
            em.merge(booking);
            return true;
        }
        return false;
    }
}