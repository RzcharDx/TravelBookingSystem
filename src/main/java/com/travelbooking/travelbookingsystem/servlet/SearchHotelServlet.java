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
import java.util.List;

@WebServlet(name = "SearchHotelServlet", urlPatterns = "/searchHotels")
public class SearchHotelServlet extends HttpServlet {

    @EJB
    private HotelEJB hotelEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String location = request.getParameter("location");

        List<Hotel> hotels = hotelEJB.searchHotels(location);

        request.setAttribute("hotels", hotels);
        request.getRequestDispatcher("/hotelResults.jsp").forward(request, response);
    }
}