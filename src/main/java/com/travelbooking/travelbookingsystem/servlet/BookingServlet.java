package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.BookingEJB;
import com.travelbooking.travelbookingsystem.model.Booking; // 必须导入
import com.travelbooking.travelbookingsystem.model.User;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "BookingServlet", urlPatterns = "/book")
public class BookingServlet extends HttpServlet {

    @EJB
    private BookingEJB bookingEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        String type = request.getParameter("type");
        String idParam = request.getParameter("id");

        if (type == null || idParam == null) {
            response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=invalid_request");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            Booking booking = null;

            if ("flight".equals(type)) {
                booking = bookingEJB.bookFlight(user.getId(), id);
            } else if ("hotel".equals(type)) {
                booking = bookingEJB.bookHotel(user.getId(), id);
            } else if ("car".equals(type)) {
                booking = bookingEJB.bookCar(user.getId(), id);
            }

            // 检查对象是否为 null 来判断成功/失败
            if (booking != null) {
                // 成功：编码参数并跳转
                String desc = URLEncoder.encode(booking.getDescription(), StandardCharsets.UTF_8);
                String redirectURL = request.getContextPath() + "/bookingSuccess.jsp" +
                        "?id=" + booking.getId() +
                        "&desc=" + desc +
                        "&price=" + booking.getTotalPrice();
                response.sendRedirect(redirectURL);
            } else {
                // 失败
                response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=sold_out_or_error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=server_error");
        }
    }
}