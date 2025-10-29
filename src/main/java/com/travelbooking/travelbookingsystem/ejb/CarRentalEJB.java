package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.CarRental;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class CarRentalEJB {

    @PersistenceContext(unitName = "travelDB") // 确保与 persistence.xml 匹配
    private EntityManager em;

    // 根据取车地点搜索可用车辆
    public List<CarRental> searchCars(String pickupLocation) {
        return em.createQuery("SELECT c FROM CarRental c WHERE c.pickupLocation = :location AND c.availableCars > 0", CarRental.class)
                .setParameter("location", pickupLocation)
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