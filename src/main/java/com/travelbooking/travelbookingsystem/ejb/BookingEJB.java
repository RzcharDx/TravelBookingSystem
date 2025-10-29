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

/**
 * 这是一个事务性 EJB，用于处理所有预订逻辑。
 * EJB 默认是 "Container-Managed Transactions" (CMT)，
 * 这意味着 bookFlight() 和 bookHotel() 方法要么完全成功，
 * 要么在发生任何错误时自动完全回滚。
 */
@Stateless
public class BookingEJB {

    @PersistenceContext(unitName = "travelDB")
    private EntityManager em;

    /**
     * 预订一个航班。
     * 这是一个事务性操作。
     * @param userId 正在预订的用户 ID
     * @param flightId 正在被预订的航班 ID
     * @return 如果预订成功则返回 true，如果售罄或出错则返回 false
     */
    public boolean bookFlight(int userId, int flightId) {
        try {
            // 1. 获取用户
            User user = em.find(User.class, userId);
            if (user == null) {
                return false; // 用户不存在
            }

            // 2. [关键] 锁定航班行
            // 我们使用 PESSIMISTIC_WRITE 锁来锁定数据库中的航班行。
            // 这可以防止 "race condition" (竞态条件)，
            // 即两个用户在同一毫秒尝试预订最后一个座位。
            Flight flight = em.find(Flight.class, flightId, LockModeType.PESSIMISTIC_WRITE);

            // 3. 检查库存
            if (flight == null || flight.getAvailableSeats() <= 0) {
                return false; // 航班不存在或已售罄
            }

            // 4. 更新库存（原子操作的一部分）
            flight.setAvailableSeats(flight.getAvailableSeats() - 1);
            em.merge(flight);

            // 5. 创建预订记录
            createBookingRecord(user, flight.getPrice(), "Flight: " + flight.getAirline());

            return true; // 事务在此处提交

        } catch (Exception e) {
            // 如果发生任何异常（例如锁超时），
            // EJB 将自动回滚事务（航班座位数将恢复）。
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 预订一个酒店房间。（逻辑与 bookFlight 类似）
     * @param userId 用户 ID
     * @param hotelId 酒店 ID
     * @return 如果预订成功则返回 true
     */
    public boolean bookHotel(int userId, int hotelId) {
        try {
            User user = em.find(User.class, userId);

            // 锁定酒店行
            Hotel hotel = em.find(Hotel.class, hotelId, LockModeType.PESSIMISTIC_WRITE);

            if (user == null || hotel == null || hotel.getAvailableRooms() <= 0) {
                return false; // 酒店不存在或已订满
            }

            // 更新库存
            hotel.setAvailableRooms(hotel.getAvailableRooms() - 1);
            em.merge(hotel);

            // 创建预订记录
            createBookingRecord(user, hotel.getPricePerNight(), "Hotel: " + hotel.getName());

            return true; // 事务在此处提交

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * 预订一辆车。（逻辑与 bookHotel 类似）
     * @param userId 用户 ID
     * @param carId 车辆 ID
     * @return 如果预订成功则返回 true
     */
    public boolean bookCar(int userId, int carId) {
        try {
            User user = em.find(User.class, userId);

            // 锁定车辆行
            CarRental car = em.find(CarRental.class, carId, LockModeType.PESSIMISTIC_WRITE);

            if (user == null || car == null || car.getAvailableCars() <= 0) {
                return false; // 车辆不存在或已租完
            }

            // 更新库存
            car.setAvailableCars(car.getAvailableCars() - 1);
            em.merge(car);

            // 创建预订记录
            createBookingRecord(user, car.getPricePerDay(), "Car: " + car.getCompany() + " " + car.getModel());

            return true; // 事务在此处提交

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 创建一个通用的预订记录的私有辅助方法。
     * @param user 进行预订的用户
     * @param price 预订的价格
     * @param description 预订的描述（在更复杂的设计中，这会是一个 BookingItem）
     */
    private void createBookingRecord(User user, BigDecimal price, String description) {
        Booking booking = new Booking();
        booking.setUser(user);
        booking.setTotalPrice(price);
        booking.setBookingDate(LocalDateTime.now());
        // booking.setDescription(description); // (您需要在 Booking.java 中添加一个 description 字段)

        em.persist(booking);
    }

    /**
     * 获取指定用户的所有预订记录。
     * @param userId 要查询的用户 ID
     * @return 该用户的预订列表
     */
    public List<Booking> getBookingsForUser(int userId) {
        // 使用 JPQL 查询与给定 userId 关联的所有 Booking 实体
        return em.createQuery("SELECT b FROM Booking b WHERE b.user.id = :userId ORDER BY b.bookingDate DESC", Booking.class)
                .setParameter("userId", userId)
                .getResultList();
    }
}
