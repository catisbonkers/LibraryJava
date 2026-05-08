<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 5:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="java.util.List" %>

<html data-theme="light">
<head>
    <title>Browse Books | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<div id="toastContainer" class="toast toast-top toast-end z-50"></div>

<%
    com.example.demo1.model.User user =
            (com.example.demo1.model.User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Book> books = BookService.getAllBooks();
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
                Library Catalog
            </div>

            <div class="ml-auto flex items-center gap-4 px-4">
                <div class="text-sm font-medium">
                    <span class="opacity-70">Welcome back,</span> <span class="font-bold text-primary"><%= user.getUsername() %></span>
                    <div class="badge badge-primary badge-outline badge-sm ml-2"><%= user.getRole() %></div>
                </div>
            </div>
        </div>

        <!-- CONTENT -->
        <div class="p-8 flex-1 overflow-y-auto">

            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-base-content">Browse Books</h1>
                    <p class="text-base-content/60 mt-1">Discover and borrow from our extensive collection.</p>
                </div>
            </div>

            <div class="flex flex-wrap gap-6">
                <% if (books.isEmpty()) { %>
                    <div class="w-full text-center py-12">
                        <i data-lucide="book-x" class="w-16 h-16 mx-auto mb-4 text-base-content/20"></i>
                        <p class="text-xl font-semibold text-base-content/50">No books found.</p>
                    </div>
                <% } else { %>
                    <% for (Book b : books) { %>
                        <%@ include file="/WEB-INF/jspf/book-card.jspf" %>
                    <% } %>
                <% } %>
            </div>

        </div>

    </div>

    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>

</div>

<%@ include file="/WEB-INF/jspf/borrow-modal.jspf" %>

</body>
<script>
    function showToast(message, type) {
        const container = document.getElementById("toastContainer");
        if (!container) return;

        const toast = document.createElement("div");
        toast.className = "alert alert-" + type + " shadow-lg";
        toast.innerHTML = "<span>" + message + "</span>";

        container.appendChild(toast);
        setTimeout(() => toast.remove(), 3000);
    }

    document.addEventListener("DOMContentLoaded", function () {
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        const error = "<%= (String) session.getAttribute("error") %>";
        const success = "<%= (String) session.getAttribute("success") %>";

        if (error && error !== "null") {
            showToast(error, "error");
        }

        if (success && success !== "null") {
            showToast(success, "success");
        }
    });
</script>

<%
    session.removeAttribute("error");
    session.removeAttribute("success");
%>
</html>