package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.HotelEJB;
import com.travelbooking.travelbookingsystem.model.Hotel;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminHotelServlet", urlPatterns = "/admin/hotels") // 受 AdminAuthFilter 保护
public class AdminHotelServlet extends HttpServlet {

    @EJB
    private HotelEJB hotelEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Hotel> hotels = hotelEJB.getAllHotels();
        request.setAttribute("hotels", hotels);
        // 检查是否有错误消息需要显示 (来自 POST 请求)
        String errorMessage = (String) request.getSession().getAttribute("adminHotelError");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getSession().removeAttribute("adminHotelError"); // 显示后移除
        }
        request.getRequestDispatcher("/admin/manage-hotels.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/admin/hotels"; // 默认重定向 URL

        if ("create".equals(action)) {
            try {
                String name = request.getParameter("name");
                String location = request.getParameter("location");
                BigDecimal pricePerNight = new BigDecimal(request.getParameter("pricePerNight"));
                int availableRooms = Integer.parseInt(request.getParameter("availableRooms"));
                int maxGuestsPerRoom = Integer.parseInt(request.getParameter("maxGuestsPerRoom")); // 新增

                Hotel newHotel = new Hotel();
                newHotel.setName(name);
                newHotel.setLocation(location);
                newHotel.setPricePerNight(pricePerNight);
                newHotel.setAvailableRooms(availableRooms);
                newHotel.setMaxGuestsPerRoom(maxGuestsPerRoom); // 新增

                hotelEJB.createHotel(newHotel);
                // 成功后可以设置成功消息 (可选)
                // request.getSession().setAttribute("adminHotelSuccess", "Hotel created successfully!");

            } catch (NumberFormatException e) {
                // 处理数字格式错误
                e.printStackTrace();
                request.getSession().setAttribute("adminHotelError", "Invalid input format: " + e.getMessage());
            } catch (Exception e) {
                // 处理其他一般错误
                e.printStackTrace();
                request.getSession().setAttribute("adminHotelError", "Failed to create hotel: " + e.getMessage());
            }
        } else if ("delete".equals(action)) {
            try {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                hotelEJB.deleteHotel(hotelId);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("adminHotelError", "Invalid Hotel ID for deletion.");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("adminHotelError", "Failed to delete hotel: " + e.getMessage());
            }
        }
        // 使用重定向，将错误/成功消息通过 session 传递
        response.sendRedirect(redirectUrl);
    }
}