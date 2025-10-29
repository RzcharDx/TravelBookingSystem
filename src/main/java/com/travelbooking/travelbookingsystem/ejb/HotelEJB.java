package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.Hotel;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class HotelEJB {

    @PersistenceContext(unitName = "travelDB") // Use the name from your persistence.xml
    private EntityManager em;

    // Search for hotels based on location
    public List<Hotel> searchHotels(String location) {
        return em.createQuery("SELECT h FROM Hotel h WHERE h.location = :location AND h.availableRooms > 0", Hotel.class)
                .setParameter("location", location)
                .getResultList();
    }

    // --- Admin CRUD Methods ---
    public List<Hotel> getAllHotels() {
        return em.createQuery("SELECT h FROM Hotel h", Hotel.class).getResultList();
    }

    public Hotel getHotelById(int hotelId) {
        return em.find(Hotel.class, hotelId);
    }

    public void createHotel(Hotel hotel) {
        em.persist(hotel);
    }

    public void updateHotel(Hotel hotel) {
        em.merge(hotel);
    }

    public void deleteHotel(int hotelId) {
        Hotel hotel = getHotelById(hotelId);
        if (hotel != null) {
            em.remove(hotel);
        }
    }
}