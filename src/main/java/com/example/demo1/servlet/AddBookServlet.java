package com.example.demo1.servlet;

import com.example.demo1.model.User;
import com.example.demo1.service.BookService;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/add-book")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class AddBookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            res.sendRedirect("dashboard.jsp");
            return;
        }

        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String publisher = req.getParameter("publisher");
        String publishYearStr = req.getParameter("publishYear");
        String stockStr = req.getParameter("stock");
        String description = req.getParameter("description");

        try {
            int stock = Integer.parseInt(stockStr);
            int publishYear = Integer.parseInt(publishYearStr);

            if (title != null && !title.trim().isEmpty() && author != null && !author.trim().isEmpty()) {
                // Add the book first
                BookService.addBook(title, author, publisher, publishYear, stock);
                java.util.List<com.example.demo1.model.Book> all = BookService.getAllBooks();
                com.example.demo1.model.Book newBook = all.get(all.size() - 1);
                
                if (description != null && !description.trim().isEmpty()) {
                    newBook.setDescription(description);
                }

                // Handle file upload
                try {
                    Part filePart = req.getPart("coverImage");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();
                        // Save directly to workspace directory so it doesn't get wiped by Tomcat restart
                        String uploadPath = getServletContext().getRealPath("/uploads");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        filePart.write(uploadPath + File.separator + fileName);
                        newBook.setCoverUrl(req.getContextPath() + "/uploads/" + fileName);
                    }
                } catch (Exception e) {
                    System.out.println("File upload failed: " + e.getMessage());
                }

                session.setAttribute("success", "Book added successfully!");
            } else {
                session.setAttribute("error", "Title and author cannot be empty.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid numeric values for stock or year.");
        }

        res.sendRedirect(req.getContextPath() + "/admin.jsp");
    }
}
