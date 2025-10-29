package com.travelbooking.travelbookingsystem.servlet;

import com.travelbooking.travelbookingsystem.ejb.UserEJB;
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
 * 处理用户登录请求。
 * 它实现了“Secure ... login functionality” [cite: 30]。
 */
@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    // 1. 注入 UserEJB，它包含了登录的业务逻辑
    @EJB
    private UserEJB userEJB;

    /**
     * 处理来自登录表单的 POST 请求
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 2. 从表单获取用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 3. 调用 EJB 尝试登录
        User user = userEJB.loginUser(username, password);

        if (user != null) {
            // 4. 登录成功：创建一个新会话
            HttpSession session = request.getSession();

            // 5. 将用户对象存储在会话中，以便稍后访问
            session.setAttribute("loggedInUser", user);

            // 6. 根据用户角色重定向 [cite: 29]
            if ("ADMIN".equals(user.getRole())) {
                // 如果是管理员，重定向到管理员仪表盘
                response.sendRedirect(request.getContextPath() + "/admin/manage-flights.jsp");
            } else {
                // 如果是普通用户，重定向到主页
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            // 7. 登录失败：重定向回登录页面，并附带一个错误标志
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
        }
    }

    /**
     * (可选) 处理 GET 请求，仅显示登录页面
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 直接转发到登录页面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}