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
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminCarRentalServlet", urlPatterns = "/admin/cars") // 受 AdminAuthFilter 保护
public class AdminCarRentalServlet extends HttpServlet {

    @EJB
    private CarRentalEJB carRentalEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CarRental> cars = carRentalEJB.getAllCars();
        request.setAttribute("cars", cars);
        request.getRequestDispatcher("/admin/manage-cars.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                String company = request.getParameter("company");
                String model = request.getParameter("model");
                String pickupLocation = request.getParameter("pickupLocation");
                BigDecimal pricePerDay = new BigDecimal(request.getParameter("pricePerDay"));
                int availableCars = Integer.parseInt(request.getParameter("availableCars"));

                CarRental newCar = new CarRental();
                newCar.setCompany(company);
                newCar.setModel(model);
                newCar.setPickupLocation(pickupLocation);
                newCar.setPricePerDay(pricePerDay);
                newCar.setAvailableCars(availableCars);

                carRentalEJB.createCar(newCar);
            } catch (Exception e) {
                e.printStackTrace(); // 添加错误处理
            }
        } else if ("delete".equals(action)) {
            try {
                int carId = Integer.parseInt(request.getParameter("carId"));
                carRentalEJB.deleteCar(carId);
            } catch (Exception e) {
                e.printStackTrace(); // 添加错误处理
            }
        }
        // 重定向回 GET 请求以刷新列表
        response.sendRedirect(request.getContextPath() + "/admin/cars");
    }
}
