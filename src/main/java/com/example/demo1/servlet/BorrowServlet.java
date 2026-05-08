package com.example.demo1.servlet;

import com.example.demo1.model.User;
import com.example.demo1.service.BookService;

import com.example.demo1.service.BorrowService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/borrow")
public class BorrowServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        if (!user.isAdmin() && !"VERIFIED".equals(user.getStatus())) {
            res.sendRedirect(req.getContextPath() + "/account-status.jsp");
            return;
        }

        int currentBorrows = BorrowService.getUserBorrows(user.getUsername()).size();
        if (currentBorrows >= user.getBorrowLimit()) {
            session.setAttribute("error", "You have reached your borrow limit of " + user.getBorrowLimit() + " books.");
            res.sendRedirect(req.getContextPath() + "/books.jsp");
            return;
        }

        String bookId = req.getParameter("bookId");
        int daysBorrowed = 7; // default
        try {
            daysBorrowed = Integer.parseInt(req.getParameter("daysBorrowed"));
            if (daysBorrowed < 1) daysBorrowed = 1;
            if (daysBorrowed > 30) daysBorrowed = 30;
        } catch (Exception ignored) {}

        boolean success = BookService.borrowBook(bookId);

        if (success) {
            com.example.demo1.model.Borrow newBorrow = BorrowService.addBorrow(user.getUsername(), bookId, daysBorrowed);
            session.setAttribute("success", "Book borrowed for " + daysBorrowed + " days!");
            res.sendRedirect(req.getContextPath() + "/receipt.jsp?borrowId=" + newBorrow.getBorrowId());
            return;
        } else {
            session.setAttribute("error", "Book is not available");
        }

        res.sendRedirect(req.getContextPath() + "/books.jsp");
    }
}