package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.CarRentalEJB;
import com.travelbooking.travelbookingsystem.model.CarRental;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchCarServlet", urlPatterns = "/searchCars")
public class SearchCarServlet extends HttpServlet {

    @EJB
    private CarRentalEJB carRentalEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pickupLocation = request.getParameter("pickupLocation");

        List<CarRental> cars = carRentalEJB.searchCars(pickupLocation);

        request.setAttribute("cars", cars);
        request.getRequestDispatcher("/carResults.jsp").forward(request, response);
    }
}