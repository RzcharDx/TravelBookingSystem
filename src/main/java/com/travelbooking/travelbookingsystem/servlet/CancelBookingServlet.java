package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.BookingEJB;
import com.travelbooking.travelbookingsystem.model.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CancelBookingServlet", urlPatterns = "/cancelBooking")
public class CancelBookingServlet extends HttpServlet {

    @EJB
    private BookingEJB bookingEJB;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            // 调用 EJB 取消预订
            bookingEJB.cancelBooking(bookingId, user.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 无论成功与否，都重定向回个人资料页面
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}