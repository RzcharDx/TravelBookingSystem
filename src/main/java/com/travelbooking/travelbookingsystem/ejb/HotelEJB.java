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

    /**
     * 更新后的搜索方法：根据地点和入住人数搜索酒店
     * @param location 目的地
     * @param guests 入住人数
     * @return 匹配的酒店列表
     */
    public List<Hotel> searchHotels(String location, int guests) {
        // 注意：实际的日期范围可用性检查非常复杂，需要额外的表或逻辑。
        // 这里简化为：检查是否有空房，并且房间最大容量 >= 入住人数。
        return em.createQuery(
                        "SELECT h FROM Hotel h WHERE h.location = :location " +
                                "AND h.availableRooms > 0 " +
                                "AND h.maxGuestsPerRoom >= :guests", // 新增人数条件
                        Hotel.class)
                .setParameter("location", location)
                .setParameter("guests", guests) // 绑定人数参数
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