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
import java.util.ArrayList; // 需要导入 ArrayList
import java.util.List;

@Stateless
public class FlightEJB {

    @PersistenceContext(unitName = "travelDB") // 确保与 persistence.xml 匹配
    private EntityManager em;

    /**
     * 更新后的核心功能：供用户搜索航班，支持日期和直飞选项
     * @param origin 起始地
     * @param destination 目的地
     * @param departDateStr 出发日期字符串 (YYYY-MM-DD), 可为空
     * @param directOnly 是否仅直飞
     * @return 匹配的航班列表
     */
    public List<Flight> searchFlights(String origin, String destination, String departDateStr, boolean directOnly) {

        // 使用 Criteria API 构建动态查询 (比拼接字符串更安全)
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Flight> cq = cb.createQuery(Flight.class);
        Root<Flight> flight = cq.from(Flight.class);

        // Predicate 列表用于存储 WHERE 条件
        List<Predicate> predicates = new ArrayList<>();

        // 基础条件：出发地和目的地
        predicates.add(cb.equal(flight.get("origin"), origin));
        predicates.add(cb.equal(flight.get("destination"), destination));
        predicates.add(cb.greaterThan(flight.get("availableSeats"), 0)); // 仍然只显示有座位的

        // 可选条件：出发日期 (比较日期部分，忽略时间)
        if (departDateStr != null && !departDateStr.trim().isEmpty()) {
            try {
                LocalDate departDate = LocalDate.parse(departDateStr);
                // 查找 departureTime >= departDate 且 departureTime < departDate + 1 天
                LocalDateTime startOfDay = departDate.atStartOfDay();
                LocalDateTime endOfDay = departDate.atTime(LocalTime.MAX);
                predicates.add(cb.between(flight.get("departureTime"), startOfDay, endOfDay));
            } catch (Exception e) {
                System.err.println("Invalid date format for departDate: " + departDateStr);
                // 忽略无效日期或返回空列表，取决于业务需求
                // return Collections.emptyList();
            }
        }

        // 可选条件：仅直飞
        if (directOnly) {
            predicates.add(cb.isTrue(flight.get("isDirect")));
        }

        // 将所有条件组合为 AND
        cq.where(predicates.toArray(new Predicate[0]));

        // 添加排序（可选）
        cq.orderBy(cb.asc(flight.get("departureTime")));

        return em.createQuery(cq).getResultList();
    }

    // --- CRUD 方法 ---

    public List<Flight> getAllFlights() {
        return em.createQuery("SELECT f FROM Flight f ORDER BY f.departureTime ASC", Flight.class).getResultList();
    }

    public Flight getFlightById(int flightId) {
        return em.find(Flight.class, flightId);
    }

    /**
     * 更新后的核心功能 (CRUD - Create)：由管理员添加新航班
     * @param flight 一个新的、包含所有（包括新）字段的 Flight 对象
     */
    public void createFlight(Flight flight) {
        // 可以在这里添加验证逻辑，例如 returnTime 必须晚于 departureTime
        em.persist(flight);
    }

    /**
     * 更新后的核心功能 (CRUD - Update)：由管理员更新现有航班
     * @param flight 一个包含更新数据的 Flight 对象
     */
    public void updateFlight(Flight flight) {
        // 注意：merge 会覆盖所有字段，确保传入的 flight 对象包含所有需要保留的旧值
        em.merge(flight);
    }

    public void deleteFlight(int flightId) {
        Flight flight = getFlightById(flightId);
        if (flight != null) {
            em.remove(flight);
        }
    }
}