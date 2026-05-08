package com.example.demo1.servlet;

import com.example.demo1.model.User;
import com.example.demo1.service.SettingsService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/update-settings")
public class SettingsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            res.sendRedirect("dashboard.jsp");
            return;
        }

        try {
            double penalty = Double.parseDouble(req.getParameter("penalty"));
            if (penalty >= 0) {
                SettingsService.setPenaltyPerDay(penalty);
                session.setAttribute("success", "Library settings updated!");
            } else {
                session.setAttribute("error", "Penalty cannot be negative.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Invalid penalty value.");
        }

        res.sendRedirect("admin.jsp");
    }
}
