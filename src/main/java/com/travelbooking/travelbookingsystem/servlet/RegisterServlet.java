package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.UserEJB;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 处理新用户注册请求。
 * 实现了“Secure registration... functionality”
 */
@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    @EJB
    private UserEJB userEJB;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // 1. 服务器端验证：检查密码是否匹配
        if (password == null || username == null || !password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=mismatch");
            return;
        }

        try {
            // 2. 尝试调用 EJB 注册用户
            // 我们将在下一节课中改进 UserEJB 来检查用户名是否已存在
            userEJB.registerUser(username, password);

            // 3. 成功：重定向到登录页面并显示成功消息
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=true");

        } catch (Exception e) {
            // 4. 失败（很可能是因为用户名违反了数据库的 "UNIQUE" 约束）
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=taken");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 当用户仅访问 /register 时，显示注册页面
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}