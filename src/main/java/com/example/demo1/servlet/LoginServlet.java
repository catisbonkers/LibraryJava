package com.example.demo1.servlet;

import com.example.demo1.model.User;
import com.example.demo1.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = UserService.login(username, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if (!user.isAdmin() && !"VERIFIED".equals(user.getStatus())) {
                res.sendRedirect(req.getContextPath() + "/account-status.jsp");
            } else {
                res.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            }
        } else {
            req.getSession().setAttribute("error", "Invalid username or password");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}
