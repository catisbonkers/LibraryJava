<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 10:36 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html data-theme="light">
<head>
    <title>Library Login</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>

<body class="bg-base-200">

<!-- Toast container -->
<div id="toastContainer" class="toast toast-top toast-end z-50"></div>

<%
    com.example.demo1.model.User user =
            (com.example.demo1.model.User) session.getAttribute("user");

    if (user != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");

    // Clear messages after reading
    session.removeAttribute("error");
    session.removeAttribute("success");
%>

<div class="flex items-center justify-center min-h-screen p-4">
    <div class="card lg:card-side glass-panel shadow-xl max-w-4xl w-full">

        <!-- Image -->
        <figure class="relative lg:w-1/2">
            <img
                    src="${pageContext.request.contextPath}/assets/sidebar.webp"
                    alt="Library"
                    class="h-full w-full object-cover"
            />
            <div class="absolute bottom-0 left-0 right-0 bg-black/60 text-white p-4">
                <h2 class="text-lg font-semibold">Welcome to Smart Library</h2>
                <p class="text-sm opacity-80">
                    Discover, borrow, and manage books with ease.
                </p>
            </div>
        </figure>

        <!-- Form -->
        <div class="card-body lg:w-1/2">
            <div class="mb-2">
                <h2 class="card-title text-2xl">Login</h2>
                <p class="text-sm opacity-70">
                    Access your library account
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-4">
                <fieldset class="fieldset">
                    <legend class="fieldset-legend">Username</legend>
                    <input name="username" class="input input-bordered w-full" required autofocus/>
                </fieldset>

                <fieldset class="fieldset">
                    <legend class="fieldset-legend">Password</legend>
                    <input type="password" name="password" class="input input-bordered w-full" required/>
                </fieldset>

                <button class="btn btn-primary w-full">Login</button>
            </form>

            <div class="divider">OR</div>

            <a href="${pageContext.request.contextPath}/register.jsp"
               class="btn btn-outline w-full">
                Create an account
            </a>
        </div>
    </div>
</div>

<!-- Toast logic -->
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

        const error = "<%= error %>";
        const success = "<%= success %>";

        if (error && error !== "null") {
            showToast(error, "error");
        }

        if (success && success !== "null") {
            showToast(success, "success");
        }
    });
</script>

</body>
</html>