<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="com.example.demo1.model.Book" %>
<html data-theme="light">
<head>
    <%
        String bookId = request.getParameter("id");
        Book book = bookId != null ? BookService.getBookById(bookId) : null;
    %>
    <title><%= book != null ? book.getTitle() : "Book Details" %> | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<div id="toastContainer" class="toast toast-top toast-end z-50"></div>

<%
    com.example.demo1.model.User user =
            (com.example.demo1.model.User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (book == null) {
%>
    <div class="min-h-screen flex items-center justify-center">
        <div class="text-center">
            <i data-lucide="book-x" class="w-24 h-24 mx-auto mb-4 text-base-content/20"></i>
            <h1 class="text-3xl font-bold mb-2">Book Not Found</h1>
            <p class="mb-6">The book you are looking for does not exist or was removed.</p>
            <a href="books.jsp" class="btn btn-primary">Back to Catalog</a>
        </div>
    </div>
    <script>if (typeof lucide !== 'undefined') lucide.createIcons();</script>
<%
        return;
    }
    String contextPath = request.getContextPath();
    Book b = book; // aliased for rating-display.jspf
%>

<div class="drawer lg:drawer-open">
    <input id="drawer" type="checkbox" class="drawer-toggle" />
    <div class="drawer-content flex flex-col min-h-screen">

        <!-- Navbar -->
        <div class="navbar bg-base-100/70 backdrop-blur-md sticky top-0 z-30 shadow-sm border-b border-base-200">
            <label for="drawer" class="btn btn-square btn-ghost lg:hidden">
                <i data-lucide="menu" class="w-5 h-5"></i>
            </label>
            <div class="px-4 text-lg font-bold bg-clip-text bg-gradient-to-r from-primary to-secondary">
                Book Details
            </div>
            <div class="ml-auto flex items-center gap-4 px-4">
                <div class="text-sm font-medium">
                    <span class="opacity-70">Welcome,</span>
                    <span class="font-bold text-primary"><%= user.getUsername() %></span>
                </div>
                <a href="books.jsp" class="btn btn-sm btn-ghost gap-2">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i> Back
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="p-8 flex-1 overflow-y-auto">
            <div class="max-w-4xl mx-auto glass-panel rounded-3xl overflow-hidden shadow-lg p-8 md:p-12">
                <div class="flex flex-col md:flex-row gap-10">
                    <!-- Cover Image -->
                    <div class="md:w-1/3 shrink-0">
                        <figure class="relative rounded-2xl overflow-hidden shadow-md aspect-[3/4] bg-base-300">
                            <%
                                String cover = b.getCoverUrl();
                                if (cover.startsWith("http")) {
                            %>
                            <img src="<%= cover %>" alt="<%= book.getTitle() %>" class="w-full h-full object-cover" />
                            <%
                            } else {
                            %>
                            <img src="${pageContext.request.contextPath}<%= book.getCoverUrl() %>" alt="<%= book.getTitle() %>" class="w-full h-full object-cover" />
                            <%
                                }
                            %>
                            <% if (book.isNew()) { %>
                                <div class="absolute top-3 left-3">
                                    <span class="badge badge-accent shadow-sm font-bold">NEW</span>
                                </div>
                            <% } %>
                        </figure>
                    </div>

                    <!-- Details -->
                    <div class="md:w-2/3 flex flex-col">
                        <div class="mb-6">
                            <h1 class="text-4xl font-bold text-base-content mb-2"><%= book.getTitle() %></h1>
                            <p class="text-xl text-base-content/70 flex items-center gap-2">
                                <i data-lucide="user-pen" class="w-5 h-5"></i>
                                <%= book.getAuthor() %>
                            </p>
                            <p class="text-base text-base-content/60 mt-2 flex items-center gap-2">
                                <i data-lucide="building" class="w-4 h-4"></i>
                                <%= book.getPublisher() != null ? book.getPublisher() : "Unknown Publisher" %> &bull; <%= book.getPublishYear() > 0 ? book.getPublishYear() : "N/A" %>
                            </p>
                        </div>

                        <div class="flex flex-wrap items-center gap-6 mb-8 bg-base-200/50 p-4 rounded-xl">
                            <div class="flex flex-col">
                                <span class="text-xs uppercase font-bold text-base-content/50 tracking-wider mb-1">Rating</span>
                                <%@ include file="/WEB-INF/jspf/rating-display.jspf" %>
                            </div>
                            <div class="w-px h-10 bg-base-300"></div>
                            <div class="flex flex-col">
                                <span class="text-xs uppercase font-bold text-base-content/50 tracking-wider mb-1">Stock</span>
                                <span class="font-semibold text-lg <%= book.getStock() > 0 ? "text-success" : "text-error" %>">
                                    <%= book.getStock() %> available
                                </span>
                            </div>
                            <div class="w-px h-10 bg-base-300"></div>
                            <div class="flex flex-col">
                                <span class="text-xs uppercase font-bold text-base-content/50 tracking-wider mb-1">Total Borrows</span>
                                <span class="font-semibold text-lg flex items-center gap-1">
                                    <i data-lucide="trending-up" class="w-4 h-4 text-primary"></i>
                                    <%= book.getBorrowedCount() %> times
                                </span>
                            </div>
                        </div>

                        <div class="mb-10 flex-1">
                            <h3 class="text-lg font-bold mb-3 flex items-center gap-2">
                                <i data-lucide="book-open-text" class="w-5 h-5 text-primary"></i>
                                Synopsis
                            </h3>
                            <p class="text-base-content/80 leading-relaxed">
                                <%= book.getDescription() %>
                            </p>
                        </div>

                        <!-- Actions -->
                        <div class="flex gap-4 mt-auto">
                            <% if (book.isAvailable()) { %>
                                <button type="button" class="btn btn-primary btn-lg flex-1 gap-2 hover-lift shadow-md"
                                        onclick="openBorrowModal('<%= book.getId() %>', '<%= book.getTitle().replace("'", "\\'") %>')">
                                    <i data-lucide="book-down" class="w-5 h-5"></i>
                                    Borrow This Book
                                </button>
                            <% } else { %>
                                <button class="btn btn-error btn-outline btn-lg flex-1 gap-2" disabled>
                                    <i data-lucide="x-circle" class="w-5 h-5"></i>
                                    Currently Unavailable
                                </button>
                            <% } %>
                            <% if (user.isAdmin()) { %>
                                <a href="admin.jsp" class="btn btn-accent btn-outline btn-lg gap-2">
                                    <i data-lucide="pencil" class="w-5 h-5"></i>
                                    Edit
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
</div>

<%@ include file="/WEB-INF/jspf/borrow-modal.jspf" %>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    });
</script>
</body>
</html>
