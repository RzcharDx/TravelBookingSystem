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
import java.util.Collections;
import java.util.List;

@WebServlet(name = "SearchHotelServlet", urlPatterns = "/searchHotels")
public class SearchHotelServlet extends HttpServlet {

    @EJB
    private HotelEJB hotelEJB;

// ... (包声明, 导入, @WebServlet, @EJB 保持不变) ...

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取所有相关参数
        String location = request.getParameter("location");
        String guestsStr = request.getParameter("guests");
        String checkin = request.getParameter("checkin"); // 获取日期，暂未使用
        String checkout = request.getParameter("checkout"); // 获取日期，暂未使用

        List<Hotel> hotels = Collections.emptyList(); // 默认为空列表
        String searchError = null;
        int guests = 1; // 默认入住人数为 1

        // 解析入住人数
        if (guestsStr != null && !guestsStr.trim().isEmpty()) {
            try {
                guests = Integer.parseInt(guestsStr);
                if (guests < 1) guests = 1; // 至少为 1
            } catch (NumberFormatException e) {
                guests = 1; // 无效输入则默认为 1
            }
        }

        // 基本验证
        if (location != null && !location.trim().isEmpty()) {
            // 调用更新后的 EJB 方法
            hotels = hotelEJB.searchHotels(location.trim(), guests);
        } else {
            searchError = "Please provide a destination.";
        }

        // 将结果和原始搜索参数传给 JSP
        request.setAttribute("hotels", hotels);
        request.setAttribute("searchLocation", location);
        request.setAttribute("searchCheckin", checkin);
        request.setAttribute("searchCheckout", checkout);
        request.setAttribute("searchGuests", guests);
        request.setAttribute("searchError", searchError);

        request.getRequestDispatcher("/hotelResults.jsp").forward(request, response);
    }
}