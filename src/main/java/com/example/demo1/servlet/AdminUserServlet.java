package com.example.demo1.servlet;

import com.example.demo1.model.User;
import com.example.demo1.service.UserService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null || !admin.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            return;
        }

        String action = req.getParameter("action");
        String targetUser = req.getParameter("username");

        if (targetUser != null) {

            if ("verify".equals(action)) {

                UserService.updateUserStatus(
                        targetUser,
                        "VERIFIED",
                        null
                );

            } else if ("ban".equals(action)) {

                String reason = req.getParameter("reason");

                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Violated library policies";
                }

                UserService.updateUserStatus(
                        targetUser,
                        "BANNED",
                        reason
                );

            } else if ("unban".equals(action)) {

                UserService.updateUserStatus(
                        targetUser,
                        "VERIFIED",
                        null
                );

            } else if ("updateLimit".equals(action)) {

                for (User u : UserService.getAllUsers()) {
                    if (u.getUsername().equals(targetUser)) {
                        try {
                            int newLimit = Integer.parseInt(req.getParameter("limit"));
                            u.setBorrowLimit(newLimit);
                        } catch (Exception ignored) {
                        }
                        break;
                    }
                }
            }
        }
        res.sendRedirect(req.getContextPath() + "/admin-users.jsp");
    }
}
