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
            for (User u : UserService.getAllUsers()) {
                if (u.getUsername().equals(targetUser)) {
                    if ("verify".equals(action)) {
                        u.setStatus("VERIFIED");
                        u.setStatusReason(null);
                    } else if ("ban".equals(action)) {
                        u.setStatus("BANNED");
                        String reason = req.getParameter("reason");
                        if (reason != null && !reason.trim().isEmpty()) {
                            u.setStatusReason(reason);
                        } else {
                            u.setStatusReason("Violated library policies");
                        }
                    } else if ("unban".equals(action)) {
                        u.setStatus("VERIFIED");
                        u.setStatusReason(null);
                    } else if ("updateLimit".equals(action)) {
                        try {
                            int newLimit = Integer.parseInt(req.getParameter("limit"));
                            u.setBorrowLimit(newLimit);
                        } catch (Exception ignored) {}
                    }
                    break;
                }
            }
        }
        res.sendRedirect(req.getContextPath() + "/admin-users.jsp");
    }
}
