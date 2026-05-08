package com.example.demo1.servlet;

import com.example.demo1.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String address = req.getParameter("address");

        if (password == null || !password.equals(confirmPassword)) {
            req.getSession().setAttribute("error", "Passwords do not match");
            res.sendRedirect(req.getContextPath() + "/register.jsp");
            return;
        }

        if (username == null || username.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Username is required");
            res.sendRedirect(req.getContextPath() + "/register.jsp");
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.getSession().setAttribute("error", "Password is required");
            res.sendRedirect(req.getContextPath() + "/register.jsp");
            return;
        }

        boolean success = UserService.register(username, password, "USER", address);

        if (success) {
            req.getSession().setAttribute("success", "Account created successfully!");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            req.getSession().setAttribute("error", "Username already exists");
            res.sendRedirect(req.getContextPath() + "/register.jsp");
        }
    }
}
