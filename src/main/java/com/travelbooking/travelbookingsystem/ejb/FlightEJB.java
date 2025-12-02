package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.Flight;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class FlightEJB {

    @PersistenceContext(unitName = "travelDB")
    private EntityManager em;

    public List<Flight> searchFlights(String origin, String destination, String departDateStr, boolean directOnly) {

        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Flight> cq = cb.createQuery(Flight.class);
        Root<Flight> flight = cq.from(Flight.class);

        List<Predicate> predicates = new ArrayList<>();

        // --- [修改] 模糊搜索 + 不区分大小写 ---
        // 使用 like 和 lower: WHERE LOWER(origin) LIKE '%input%'
        if (origin != null && !origin.trim().isEmpty()) {
            predicates.add(cb.like(cb.lower(flight.get("origin")), "%" + origin.trim().toLowerCase() + "%"));
        }

        if (destination != null && !destination.trim().isEmpty()) {
            predicates.add(cb.like(cb.lower(flight.get("destination")), "%" + destination.trim().toLowerCase() + "%"));
        }

        // 基础条件：有空位
        predicates.add(cb.greaterThan(flight.get("availableSeats"), 0));

        // 可选条件：出发日期
        if (departDateStr != null && !departDateStr.trim().isEmpty()) {
            try {
                LocalDate departDate = LocalDate.parse(departDateStr);
                LocalDateTime startOfDay = departDate.atStartOfDay();
                LocalDateTime endOfDay = departDate.atTime(LocalTime.MAX);
                predicates.add(cb.between(flight.get("departureTime"), startOfDay, endOfDay));
            } catch (Exception e) {
                System.err.println("Invalid date format: " + departDateStr);
            }
        }

        // 可选条件：仅直飞
        if (directOnly) {
            predicates.add(cb.isTrue(flight.get("isDirect")));
        }

        cq.where(predicates.toArray(new Predicate[0]));
        cq.orderBy(cb.asc(flight.get("departureTime")));

        return em.createQuery(cq).getResultList();
    }

    // --- CRUD 方法保持不变 ---
    public List<Flight> getAllFlights() {
        return em.createQuery("SELECT f FROM Flight f ORDER BY f.departureTime ASC", Flight.class).getResultList();
    }

    public Flight getFlightById(int flightId) {
        return em.find(Flight.class, flightId);
    }

    public void createFlight(Flight flight) {
        em.persist(flight);
    }

    public void updateFlight(Flight flight) {
        em.merge(flight);
    }

    public void deleteFlight(int flightId) {
        Flight flight = getFlightById(flightId);
        if (flight != null) {
            em.remove(flight);
        }
    }

    // [新增] 获取去重后的航司列表，用于前端筛选
    public List<String> getDistinctAirlines() {
        return em.createQuery("SELECT DISTINCT f.airline FROM Flight f ORDER BY f.airline", String.class).getResultList();
    }
}