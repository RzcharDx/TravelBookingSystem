package com.travelbooking.travelbookingsystem.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 处理用户注销请求。
 */
@WebServlet(name = "LogoutServlet", urlPatterns = "/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. 获取当前会话（如果存在）
        // "false" 参数意味着：如果会话不存在，不要创建新会话
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. 如果会话存在，使其无效（销毁会话）
            session.invalidate();
        }

        // 3. 将用户重定向回登录页面
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}