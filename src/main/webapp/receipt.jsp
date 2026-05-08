<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.model.User" %>
<%@ page import="com.example.demo1.model.Borrow" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="com.example.demo1.service.BorrowService" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String borrowId = request.getParameter("borrowId");
    Borrow b = BorrowService.getByBorrowId(borrowId);

    if (b == null || !b.getUsername().equals(user.getUsername())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    Book book = BookService.getBookById(b.getBookId());
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>
<html data-theme="light">
<head>
    <title>Borrow Receipt | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            body {
                background: white;
                margin: 0;
                padding: 0;
            }
            .receipt-container {
                box-shadow: none !important;
                border: none !important;
                width: 100% !important;
                max-width: 100% !important;
            }
        }
    </style>
</head>
<body class="bg-base-200 min-h-screen flex flex-col items-center justify-center p-4">

    <!-- Back & Print Buttons (Hidden in Print) -->
    <div class="no-print flex gap-4 mb-6">
        <a href="mybooks.jsp" class="btn btn-ghost gap-2">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Back to My Books
        </a>
        <button onclick="window.print()" class="btn btn-primary gap-2 shadow-lg hover-lift">
            <i data-lucide="printer" class="w-4 h-4"></i> Print Receipt
        </button>
    </div>

    <!-- Receipt Container -->
    <div class="receipt-container bg-base-100 max-w-md w-full p-6 rounded-2xl shadow-xl border border-base-200 relative overflow-hidden">
        
        <!-- Header -->
        <div class="text-center mb-4">
            <div class="inline-flex items-center justify-center p-3 bg-primary/10 rounded-full mb-4">
                <i data-lucide="check-circle" class="w-8 h-8 text-primary"></i>
            </div>
            <h1 class="text-2xl font-bold">Borrow Receipt</h1>
            <p class="text-base-content/50 text-sm">LibraSync Management System</p>
        </div>

        <div class="divider"></div>

        <!-- Book Details -->
        <div class="mb-4">
            <p class="text-xs uppercase tracking-widest text-base-content/50 mb-1 font-semibold">Book Title</p>
            <p class="font-bold text-lg"><%= book.getTitle() %></p>
            <p class="text-base-content/70 text-sm mt-1">By <%= book.getAuthor() %></p>
        </div>

        <!-- Borrow Details -->
        <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
                <p class="text-xs uppercase tracking-widest text-base-content/50 mb-1 font-semibold">Borrowed By</p>
                <p class="font-medium"><%= user.getUsername() %></p>
            </div>
            <div>
                <p class="text-xs uppercase tracking-widest text-base-content/50 mb-1 font-semibold">Duration</p>
                <p class="font-medium"><%= b.getDaysBorrowed() %> Days</p>
            </div>
        </div>

        <!-- Dates -->
        <div class="bg-base-200/50 p-4 rounded-xl mb-4 border border-base-200">
            <div class="flex justify-between items-center mb-2">
                <span class="text-sm font-medium text-base-content/70">Borrow Date</span>
                <span class="font-bold text-sm"><%= b.getBorrowDate().format(formatter) %></span>
            </div>
            <div class="flex justify-between items-center text-primary">
                <span class="text-sm font-medium">Due Date</span>
                <span class="font-bold text-sm"><%= b.getDueDate() != null ? b.getDueDate().format(formatter) : b.getBorrowDate().plusDays(b.getDaysBorrowed()).format(formatter) %></span>
            </div>
        </div>

        <div class="divider"></div>

        <!-- Footer -->
        <div class="text-center">
            <div class="font-mono text-xs text-base-content/40 break-all mb-4">
                Transaction ID: <br/> <%= b.getBorrowId() %>
            </div>
            <p class="text-xs text-base-content/50 italic">Please return the book on or before the due date to avoid penalties.</p>
        </div>

    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
            
            // Auto trigger print dialog on page load
            setTimeout(() => {
                window.print();
            }, 500);
        });
    </script>
</body>
</html>
