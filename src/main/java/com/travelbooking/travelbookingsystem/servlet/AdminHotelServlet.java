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

@WebServlet(name = "AdminHotelServlet", urlPatterns = "/admin/hotels") // Protected by AdminAuthFilter
public class AdminHotelServlet extends HttpServlet {

    @EJB
    private HotelEJB hotelEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Hotel> hotels = hotelEJB.getAllHotels();
        request.setAttribute("hotels", hotels);
        request.getRequestDispatcher("/admin/manage-hotels.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                String name = request.getParameter("name");
                String location = request.getParameter("location");
                BigDecimal pricePerNight = new BigDecimal(request.getParameter("pricePerNight"));
                int availableRooms = Integer.parseInt(request.getParameter("availableRooms"));

                Hotel newHotel = new Hotel();
                newHotel.setName(name);
                newHotel.setLocation(location);
                newHotel.setPricePerNight(pricePerNight);
                newHotel.setAvailableRooms(availableRooms);

                hotelEJB.createHotel(newHotel);
            } catch (Exception e) {
                e.printStackTrace(); // Add proper error handling
            }
        } else if ("delete".equals(action)) {
            try {
                int hotelId = Integer.parseInt(request.getParameter("hotelId"));
                hotelEJB.deleteHotel(hotelId);
            } catch (Exception e) {
                e.printStackTrace(); // Add proper error handling
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/hotels");
    }
}