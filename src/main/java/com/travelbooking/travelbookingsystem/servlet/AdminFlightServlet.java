package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.FlightEJB;
import com.travelbooking.travelbookingsystem.model.Flight;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException; // 导入异常
import java.util.List;

/**
 * 此 Servlet 受 AdminAuthFilter 保护。
 * 只有 "ADMIN" 角色的用户才能访问。
 * 它处理所有航班的 CRUD 操作。
 */
@WebServlet(name = "AdminFlightServlet", urlPatterns = "/admin/flights")
public class AdminFlightServlet extends HttpServlet {

    @EJB
    private FlightEJB flightEJB;

    /**
     * 当管理员访问 /admin/flights 时调用。
     * 负责获取航班列表并显示管理页面。
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Flight> flights = flightEJB.getAllFlights();
        request.setAttribute("flights", flights);
        // 检查是否有错误消息需要显示 (来自 POST 请求)
        String errorMessage = (String) request.getSession().getAttribute("adminFlightError");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getSession().removeAttribute("adminFlightError"); // 显示后移除
        }
        request.getRequestDispatcher("/admin/manage-flights.jsp").forward(request, response);
    }

    /**
     * 当管理员提交“添加航班”或“删除航班”表单时调用。
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/flights"; // 默认重定向 URL

        if ("create".equals(action)) {
            // --- 处理创建航班 (更新部分) ---
            try {
                // 读取旧字段
                String airline = request.getParameter("airline");
                String flightNumber = request.getParameter("flightNumber"); // 新增
                String origin = request.getParameter("origin");
                String destination = request.getParameter("destination");
                LocalDateTime departureTime = LocalDateTime.parse(request.getParameter("departureTime"));
                String arrivalTimeStr = request.getParameter("arrivalTime"); // 新增
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                int availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
                String cabinClass = request.getParameter("cabinClass");
                boolean isDirect = "on".equals(request.getParameter("isDirect")); // checkbox

                // 创建并填充新的 Flight 实体
                Flight newFlight = new Flight();
                newFlight.setAirline(airline);
                newFlight.setFlightNumber(flightNumber); // 新增
                newFlight.setOrigin(origin);
                newFlight.setDestination(destination);
                newFlight.setDepartureTime(departureTime);

                // 设置新字段 (注意处理可能的空值)
                if (arrivalTimeStr != null && !arrivalTimeStr.isEmpty()) { // 新增
                    newFlight.setArrivalTime(LocalDateTime.parse(arrivalTimeStr));
                }
                newFlight.setPrice(price);
                newFlight.setAvailableSeats(availableSeats);
                if (cabinClass != null && !cabinClass.trim().isEmpty()) {
                    newFlight.setCabinClass(cabinClass.trim());
                }
                newFlight.setDirect(isDirect);

                // 调用 EJB 保存
                flightEJB.createFlight(newFlight);
                // 成功后可以设置成功消息 (可选)
                // request.getSession().setAttribute("adminFlightSuccess", "Flight created successfully!");

            } catch (NumberFormatException | DateTimeParseException e) {
                // 处理数字或日期时间格式错误
                e.printStackTrace();
                request.getSession().setAttribute("adminFlightError", "Invalid input format: " + e.getMessage());
            } catch (Exception e) {
                // 处理其他一般错误
                e.printStackTrace();
                request.getSession().setAttribute("adminFlightError", "Failed to create flight: " + e.getMessage());
            }

        } else if ("delete".equals(action)) {
            // --- 处理删除航班 (保持不变) ---
            try {
                int flightId = Integer.parseInt(request.getParameter("flightId"));
                flightEJB.deleteFlight(flightId);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("adminFlightError", "Invalid Flight ID for deletion.");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("adminFlightError", "Failed to delete flight: " + e.getMessage());
            }
        }

        // 使用重定向，将错误/成功消息通过 session 传递
        response.sendRedirect(redirectUrl);
    }
}