package com.example.demo1.servlet;

import com.example.demo1.model.User;
import com.example.demo1.service.BookService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/delete-book")
public class DeleteBookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            res.sendRedirect("dashboard.jsp");
            return;
        }

        String bookId = req.getParameter("bookId");

        if (bookId != null && !bookId.trim().isEmpty()) {
            boolean success = BookService.deleteBook(bookId);
            if (success) {
                session.setAttribute("success", "Book deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete the book.");
            }
        }

        res.sendRedirect(req.getContextPath() + "/admin.jsp");
    }
}
