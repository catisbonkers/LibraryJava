<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 6:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="com.example.demo1.model.Borrow" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="com.example.demo1.service.BorrowService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<html data-theme="light">
<head>
    <title>My Borrows | LibraSync</title>
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

    List<Borrow> borrows = BorrowService.getUserBorrows(user.getUsername());
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
                My Borrows
            </div>
            <div class="ml-auto flex items-center gap-4 px-4">
                <div class="text-sm font-medium">
                    <span class="opacity-70">Welcome back,</span> <span class="font-bold text-primary"><%= user.getUsername() %></span>
                    <div class="badge badge-primary badge-outline badge-sm ml-2"><%= user.getRole() %></div>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="p-8 flex-1 overflow-y-auto">

            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-base-content">My Borrowed Books</h1>
                    <p class="text-base-content/60 mt-1">Keep track of the books you are currently reading.</p>
                </div>
            </div>

            <% if (borrows.isEmpty()) { %>
            <div class="glass-panel rounded-2xl p-12 text-center">
                <div class="mb-4 opaScity-50 icon-stamp"></div>
                <h3 class="text-xl font-semibold mb-2">No books borrowed yet</h3>
                <p class="text-base-content/70 mb-6">Looks like you haven't borrowed any books from our library.</p>
                <a href="books.jsp" class="btn btn-primary hover-lift">Browse Catalog</a>
            </div>
            <% } else { %>
            <div class="glass-panel rounded-2xl overflow-hidden shadow-sm">
                <table class="table w-full border-collapse">
                    <thead class="bg-base-200 text-base-content">
                    <tr>
                        <th class="font-semibold text-sm">Title</th>
                        <th class="font-semibold text-sm">Author</th>
                        <th class="font-semibold text-sm text-center">Due Date</th>
                        <th class="font-semibold text-sm text-center">Action</th>
                    </tr>
                    </thead>

                    <tbody>

                    <%
                        for (Borrow b : borrows) {
                            Book book = BookService.getBookById(b.getBookId());
                    %>
                    <tr class="hover:bg-base-100/50 transition-colors">
                        <td class="font-medium"><%= book.getTitle() %></td>
                        <td class="text-base-content/70"><%= book.getAuthor() %></td>
                        <td class="text-center text-sm">
                            <%
                                LocalDate due = b.getDueDate();
                                if (due == null) due = b.getBorrowDate().plusDays(7); // Fallback for old records
                                long daysLeft = ChronoUnit.DAYS.between(LocalDate.now(), due);
                                if (daysLeft < 0) {
                            %>
                                <span class="badge badge-error gap-1"><i data-lucide="alert-circle" class="w-3 h-3"></i> Overdue (<%= Math.abs(daysLeft) %>d)</span>
                            <%  } else if (daysLeft == 0) { %>
                                <span class="badge badge-warning">Due Today</span>
                            <%  } else { %>
                                <%= due %> <span class="text-base-content/50 text-xs">(<%= daysLeft %>d left)</span>
                            <%  } %>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-secondary btn-outline rounded-full px-6 hover-lift"
                                    onclick="openRatingModal('<%= b.getBorrowId() %>', '<%= book.getTitle().replace("'", "\\'") %>')">
                                Return
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    %>

                    </tbody>
                </table>
            </div>
            <% } %>

        </div>

    </div>

    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
</div>

<%@ include file="/WEB-INF/jspf/rating-modal.jspf" %>

</body>
<style>
    .icon-stamp {
        font-size: 6rem;
    }
</style>
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

        const success = "<%= (String) session.getAttribute("success") %>";
        if (success && success !== "null") {
            showToast(success, "success");
        }
    });
</script>

<%
    session.removeAttribute("success");
%>
</html>
