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

/**
 * 处理来自 JSP 页面的预订请求。
 * URL 示例: /book?type=flight&id=5, /book?type=hotel&id=12, /book?type=car&id=3
 */
@WebServlet(name = "BookingServlet", urlPatterns = "/book")
public class BookingServlet extends HttpServlet {

    @EJB
    private BookingEJB bookingEJB;

    /**
     * 我们使用 doGet() 来处理来自简单 <a> 链接的点击
     * (在真实项目中，使用 POST 会更符合 RESTful 规范)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. [安全] 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            // 如果未登录，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        // 2. 获取请求参数
        String type = request.getParameter("type");
        String idParam = request.getParameter("id");

        if (type == null || idParam == null) {
            response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=invalid_request");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            boolean success = false;

            // 3. 根据类型调用相应的 EJB 方法
            if ("flight".equals(type)) {
                success = bookingEJB.bookFlight(user.getId(), id);
            } else if ("hotel".equals(type)) {
                success = bookingEJB.bookHotel(user.getId(), id);
            } else if ("car".equals(type)) { // <-- 这是添加的部分
                // 调用您在 BookingEJB 中添加的 bookCar 方法
                success = bookingEJB.bookCar(user.getId(), id);
            }

            // 4. 重定向到成功或失败页面
            if (success) {
                response.sendRedirect(request.getContextPath() + "/bookingSuccess.jsp");
            } else {
                // 失败原因可能是售罄，或其他 EJB 内部错误
                response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=sold_out_or_error");
            }

        } catch (NumberFormatException e) {
            // 如果 id 参数不是有效的数字
            response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=invalid_id");
        } catch (Exception e) {
            // 捕获 EJB 可能抛出的其他未预料异常
            e.printStackTrace(); // 记录服务器日志
            response.sendRedirect(request.getContextPath() + "/bookingFailed.jsp?reason=server_error");
        }
    }
}
