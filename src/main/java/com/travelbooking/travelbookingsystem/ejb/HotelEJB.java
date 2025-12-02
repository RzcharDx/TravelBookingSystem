package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.Hotel;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class HotelEJB {

    @PersistenceContext(unitName = "travelDB")
    private EntityManager em;

    /**
     * [修改] 模糊搜索酒店
     */
    public List<Hotel> searchHotels(String location, int guests) {
        return em.createQuery(
                        "SELECT h FROM Hotel h WHERE LOWER(h.location) LIKE :location " +  // 使用 LIKE
                                "AND h.availableRooms > 0 " +
                                "AND h.maxGuestsPerRoom >= :guests",
                        Hotel.class)
                // 添加 % 通配符并转小写
                .setParameter("location", "%" + location.trim().toLowerCase() + "%")
                .setParameter("guests", guests)
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