package com.example.demo1.servlet;

import com.example.demo1.model.Borrow;
import com.example.demo1.model.User;
import com.example.demo1.service.BookService;
import com.example.demo1.service.BorrowService;
import com.example.demo1.service.RatingService;

import com.example.demo1.service.RatingService;
import com.example.demo1.service.SettingsService;
import com.example.demo1.service.ReturnService;
import com.example.demo1.model.ReturnRecord;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/return")
public class ReturnServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String borrowId = req.getParameter("borrowId");
        String ratingParam = req.getParameter("rating");

        if (borrowId != null && !borrowId.isEmpty()) {
            Borrow borrow = BorrowService.getByBorrowId(borrowId);

            if (borrow != null && borrow.getUsername().equals(user.getUsername())) {
                // Save rating if provided and non-zero
                if (ratingParam != null && !ratingParam.isEmpty()) {
                    try {
                        int stars = Integer.parseInt(ratingParam);
                        if (stars >= 1 && stars <= 5) {
                            RatingService.addRating(user.getUsername(), borrow.getBookId(), stars);
                        }
                    } catch (NumberFormatException ignored) {}
                }

                // Check for overdue
                long daysOverdue = ChronoUnit.DAYS.between(borrow.getDueDate(), LocalDate.now());
                String extraMsg = "";
                if (daysOverdue > 0) {
                    double penalty = daysOverdue * SettingsService.getPenaltyPerDay();
                    extraMsg = String.format(" Book was %d days overdue. Penalty fee: $%.2f.", daysOverdue, penalty);
                }

                // Return the book
                BookService.returnBook(borrow.getBookId());
                BorrowService.returnBook(borrowId);
                
                double penalty = 0.0;
                if (daysOverdue > 0) {
                    penalty = daysOverdue * SettingsService.getPenaltyPerDay();
                }
                
                ReturnRecord returnRecord = ReturnService.addReturn(user.getUsername(), borrow.getBookId(), penalty);
                
                session.setAttribute("success", "Book returned successfully!" + extraMsg);
                res.sendRedirect(req.getContextPath() + "/return_receipt.jsp?returnId=" + returnRecord.getReturnId());
                return;
            } else {
                session.setAttribute("error", "Invalid return request.");
            }
        }

        res.sendRedirect(req.getContextPath() + "/mybooks.jsp");
    }
}