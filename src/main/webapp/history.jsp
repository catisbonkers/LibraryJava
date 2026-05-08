<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.model.User" %>
<%@ page import="com.example.demo1.model.ReturnRecord" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="com.example.demo1.service.ReturnService" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<html data-theme="light">
<head>
    <title>Return History | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<ReturnRecord> history = ReturnService.getUserReturns(user.getUsername());
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>
<div class="drawer lg:drawer-open">
    <input id="drawer" type="checkbox" class="drawer-toggle" />
    <div class="drawer-content flex flex-col min-h-screen">
        <div class="navbar bg-base-100/70 backdrop-blur-md sticky top-0 z-30 shadow-sm border-b border-base-200">
            <label for="drawer" class="btn btn-square btn-ghost lg:hidden">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-6 h-6 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
            </label>
            <div class="px-4 text-lg font-bold bg-clip-text bg-gradient-to-r from-primary to-secondary">
                Borrow History
            </div>
        </div>

        <div class="p-8 flex-1 overflow-y-auto">
            <h1 class="text-3xl font-bold mb-6">Your Return History</h1>
            <div class="bg-base-100 rounded-2xl shadow-sm border border-base-200 overflow-hidden">
                <table class="table w-full">
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Book Title</th>
                            <th>Return Date</th>
                            <th>Fine Paid</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (history.isEmpty()) { %>
                        <tr>
                            <td colspan="4" class="text-center py-8 text-base-content/50">No history found.</td>
                        </tr>
                        <% } else {
                            for (ReturnRecord r : history) {
                                Book book = BookService.getBookById(r.getBookId());
                                String title = book != null ? book.getTitle() : "Unknown Book";
                        %>
                        <tr>
                            <td class="font-mono text-xs"><%= r.getReturnId() %></td>
                            <td class="font-medium"><%= title %></td>
                            <td><%= r.getReturnDate().format(formatter) %></td>
                            <td class="text-error font-semibold"><%= String.format("$%.2f", r.getFine()) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        if (typeof lucide !== 'undefined') lucide.createIcons();
    });
</script>
</body>
</html>
