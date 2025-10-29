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
import java.util.Collections;
import java.util.List;

/**
 * 处理用户搜索航班的请求，支持往返，并将去程和返程航班分别传递给JSP。
 */
@WebServlet(name = "SearchFlightServlet", urlPatterns = "/searchFlights")
public class SearchFlightServlet extends HttpServlet {

    @EJB
    private FlightEJB flightEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departDateStr = request.getParameter("departDate"); // 用户输入的去程日期
        String returnDateStr = request.getParameter("returnDate"); // 用户输入的返程日期 (可选)
        boolean directOnly = "true".equals(request.getParameter("directOnly"));

        List<Flight> outboundFlights = Collections.emptyList();
        List<Flight> inboundFlights = Collections.emptyList(); // 将返程航班命名为 inboundFlights
        String searchError = null;

        if (origin != null && !origin.trim().isEmpty() && destination != null && !destination.trim().isEmpty()) {
            // 1. 搜索去程航班
            outboundFlights = flightEJB.searchFlights(origin.trim(), destination.trim(), departDateStr, directOnly);

            // 2. 如果提供了返程日期，则搜索返程航班
            if (returnDateStr != null && !returnDateStr.trim().isEmpty()) {
                // 返程航班的起点是去程的终点，终点是去程的起点
                inboundFlights = flightEJB.searchFlights(destination.trim(), origin.trim(), returnDateStr, directOnly);
            }

        } else {
            searchError = "Please provide both origin and destination.";
        }

        // 将所有相关数据放入请求属性
        request.setAttribute("origin", origin); // 将原始搜索参数也传回JSP
        request.setAttribute("destination", destination);
        request.setAttribute("departDate", departDateStr);
        request.setAttribute("returnDate", returnDateStr); // 传递用户输入的返程日期
        request.setAttribute("isRoundTripSearch", returnDateStr != null && !returnDateStr.trim().isEmpty()); // 标记是否为往返搜索

        request.setAttribute("outboundFlights", outboundFlights);
        request.setAttribute("inboundFlights", inboundFlights);
        request.setAttribute("searchError", searchError);

        request.getRequestDispatcher("/flightResults.jsp").forward(request, response);
    }
}