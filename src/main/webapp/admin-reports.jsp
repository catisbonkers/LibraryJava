<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.model.User" %>
<%@ page import="com.example.demo1.model.Borrow" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="com.example.demo1.service.BorrowService" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<html data-theme="light">
<head>
    <title>Reports | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !admin.isAdmin()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // We could get all borrows. 
    // Since BorrowService only has getUserBorrows and getByBorrowId, 
    // we need to add a getAllBorrows method, but since we can't easily edit without it,
    // let's use BookService to iterate through all books and check status, or just show missing books.
    // Wait, BorrowService might not have getAllBorrows. I will just edit BorrowService to add it.
%>
<div class="drawer lg:drawer-open">
    <input id="drawer" type="checkbox" class="drawer-toggle" />
    <div class="drawer-content flex flex-col min-h-screen">
        <div class="navbar bg-base-100/70 backdrop-blur-md sticky top-0 z-30 shadow-sm border-b border-base-200">
            <label for="drawer" class="btn btn-square btn-ghost lg:hidden">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
            </label>
            <div class="px-4 text-lg font-bold bg-clip-text bg-gradient-to-r from-primary to-secondary">
                Library Reports
            </div>
        </div>

        <div class="p-8 flex-1 overflow-y-auto">
            <h1 class="text-3xl font-bold mb-6">Library Reports</h1>
            
            <div class="grid grid-cols-1 gap-8">
                <!-- Borrowed Books Report -->
                <div class="bg-base-100 rounded-2xl shadow-sm border border-base-200 p-6">
                    <h2 class="text-xl font-bold mb-4">All Active Borrows & Overdue</h2>
                    <div class="overflow-x-auto">
                        <table class="table w-full">
                            <thead>
                                <tr>
                                    <th>Borrow ID</th>
                                    <th>User</th>
                                    <th>Book Title</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Borrow> allBorrows = BorrowService.getAllBorrows();
                                    if (allBorrows == null || allBorrows.isEmpty()) { 
                                %>
                                <tr>
                                    <td colspan="5" class="text-center py-4">No active borrows.</td>
                                </tr>
                                <% } else {
                                    LocalDate today = LocalDate.now();
                                    for (Borrow b : allBorrows) {
                                        Book book = BookService.getBookById(b.getBookId());
                                        String title = book != null ? book.getTitle() : "Unknown";
                                        long overdueDays = b.getDueDate() != null ? ChronoUnit.DAYS.between(b.getDueDate(), today) : 0;
                                %>
                                <tr>
                                    <td class="font-mono text-xs"><%= b.getBorrowId() %></td>
                                    <td class="font-bold"><%= b.getUsername() %></td>
                                    <td><%= title %></td>
                                    <td><%= b.getDueDate() %></td>
                                    <td>
                                        <% if (overdueDays > 0) { %>
                                            <div class="badge badge-error">Overdue (<%= overdueDays %> days)</div>
                                        <% } else { %>
                                            <div class="badge badge-success">On Time</div>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
</div>
</body>
</html>
