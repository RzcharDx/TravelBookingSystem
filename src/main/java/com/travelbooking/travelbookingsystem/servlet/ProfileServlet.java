package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.BookingEJB;
import com.travelbooking.travelbookingsystem.model.Booking;
import com.travelbooking.travelbookingsystem.model.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * 处理显示用户个人资料和预订历史的请求。
 */
@WebServlet(name = "ProfileServlet", urlPatterns = "/profile")
public class ProfileServlet extends HttpServlet {

    @EJB
    private BookingEJB bookingEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. [安全] 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        // 2. 调用 EJB 获取该用户的预订列表
        List<Booking> bookings = bookingEJB.getBookingsForUser(user.getId());

        // 3. 将预订列表放入请求中，以便 JSP 可以访问
        request.setAttribute("bookings", bookings);

        // 4. 将用户信息也放入请求（可选，JSP 也可以直接从 session 获取）
        request.setAttribute("user", user);

        // 5. 转发到 profile.jsp 视图
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}