package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.CarRental;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class CarRentalEJB {

    @PersistenceContext(unitName = "travelDB")
    private EntityManager em;

    /**
     * [修改] 模糊搜索租车
     */
    public List<CarRental> searchCars(String pickupLocation) {
        return em.createQuery(
                        "SELECT c FROM CarRental c WHERE LOWER(c.pickupLocation) LIKE :location AND c.availableCars > 0",
                        CarRental.class)
                // 添加 % 通配符并转小写
                .setParameter("location", "%" + pickupLocation.trim().toLowerCase() + "%")
                .getResultList();
    }

    // --- Admin CRUD 方法 ---
    public List<CarRental> getAllCars() {
        return em.createQuery("SELECT c FROM CarRental c", CarRental.class).getResultList();
    }

    public CarRental getCarById(int carId) {
        return em.find(CarRental.class, carId);
    }

    public void createCar(CarRental car) {
        em.persist(car);
    }

    public void updateCar(CarRental car) {
        em.merge(car);
    }

    public void deleteCar(int carId) {
        CarRental car = getCarById(carId);
        if (car != null) {
            em.remove(car);
        }
    }
}