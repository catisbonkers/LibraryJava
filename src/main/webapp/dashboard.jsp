<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 10:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="com.example.demo1.service.BorrowService" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="java.util.List" %>
<html data-theme="light">
<head>
    <title>Dashboard | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
    <div>
        <%
            com.example.demo1.model.User user =
                    (com.example.demo1.model.User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            
            List<Book> allBooks = BookService.getAllBooks();
            long availableBooks = allBooks.stream().filter(Book::isAvailable).count();
            int myBorrowsCount = BorrowService.getUserBorrows(user.getUsername()).size();
            
            List<Book> popularBooks = BookService.getPopularBooks();
            List<Book> newBooks = BookService.getNewestBooks();
            String contextPath = request.getContextPath();
        %>
        <div class="drawer lg:drawer-open">
            <input id="drawer" type="checkbox" class="drawer-toggle" />
            <div class="drawer-content flex flex-col min-h-screen">
                <!-- Navbar -->
                <div class="navbar bg-base-100/70 backdrop-blur-md sticky top-0 z-30 shadow-sm border-b border-base-200">
                    <label for="drawer" class="btn btn-square btn-ghost lg:hidden">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                    </label>

                    <div class="px-4 text-lg font-bold bg-clip-text bg-gradient-to-r from-primary to-secondary">
                        Overview
                    </div>

                    <div class="ml-auto flex items-center gap-4 px-4">
                        <div class="text-sm font-medium">
                            <span class="opacity-70">Welcome back,</span> <span class="font-bold text-primary"><%= user.getUsername() %></span>
                            <div class="badge badge-primary badge-outline badge-sm ml-2"><%= user.getRole() %></div>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="p-8 flex-1 overflow-y-auto">
                    
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h1 class="text-3xl font-bold text-base-content">Dashboard</h1>
                            <p class="text-base-content/60 mt-1">Here is what's happening with your library today.</p>
                        </div>
                    </div>

                    <!-- Stats Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="stat glass-panel rounded-2xl hover-lift">
                            <div class="stat-figure text-primary">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-8 h-8 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                            </div>
                            <div class="stat-title font-semibold">Total Titles</div>
                            <div class="stat-value text-primary"><%= allBooks.size() %></div>
                            <div class="stat-desc mt-1">Books currently in our system</div>
                        </div>
                        
                        <div class="stat glass-panel rounded-2xl hover-lift">
                            <div class="stat-figure text-success">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-8 h-8 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                            <div class="stat-title font-semibold">Available Now</div>
                            <div class="stat-value text-success"><%= availableBooks %></div>
                            <div class="stat-desc mt-1">Ready to be borrowed</div>
                        </div>
                        
                        <div class="stat glass-panel rounded-2xl hover-lift">
                            <div class="stat-figure text-secondary">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-8 h-8 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            </div>
                            <div class="stat-title font-semibold">My Active Borrows</div>
                            <div class="stat-value text-secondary"><%= myBorrowsCount %></div>
                            <div class="stat-desc mt-1">
                                <% if (myBorrowsCount > 0) { %>
                                    <a href="mybooks.jsp" class="link link-hover link-secondary">View your books</a>
                                <% } else { %>
                                    <a href="books.jsp" class="link link-hover link-primary">Browse to borrow</a>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Popular Books -->
                    <div class="mb-8">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-2xl font-bold text-base-content flex items-center gap-2">
                                <i data-lucide="trending-up" class="w-6 h-6 text-primary"></i>
                                Popular Books
                            </h2>
                            <a href="books.jsp" class="btn btn-sm btn-ghost">View All</a>
                        </div>
                        <div class="flex flex-wrap gap-6">
                            <% for (Book b : popularBooks) { %>
                                <%@ include file="/WEB-INF/jspf/book-card.jspf" %>
                            <% } %>
                        </div>
                    </div>

                    <!-- New Arrivals -->
                    <div class="mb-8">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-2xl font-bold text-base-content flex items-center gap-2">
                                <i data-lucide="sparkles" class="w-6 h-6 text-accent"></i>
                                New Arrivals
                            </h2>
                            <a href="books.jsp" class="btn btn-sm btn-ghost">View All</a>
                        </div>
                        <div class="flex flex-wrap gap-6">
                            <% for (Book b : newBooks) { %>
                                <%@ include file="/WEB-INF/jspf/book-card.jspf" %>
                            <% } %>
                        </div>
                    </div>

                </div>
            </div>

            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/borrow-modal.jspf" %>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Render all lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        });
    </script>
</body>
</html>
