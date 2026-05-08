<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 2:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html data-theme="light">
<head>
    <title>Library Register</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>

<body class="bg-base-200">

<!-- Toast container -->
<div id="toastContainer" class="toast toast-top toast-end z-50"></div>

<div class="flex items-center justify-center min-h-screen p-4">

    <div class="card lg:card-side glass-panel shadow-xl max-w-4xl w-full">

        <!-- Image -->
        <figure class="relative lg:w-1/2">
            <img
                    src="https://images.stockcake.com/public/f/0/c/f0ce76f2-bd96-455c-8fca-ba5f777772e8_large/library-reading-session-stockcake.jpg"
                    alt="Library"
                    class="h-full w-full object-cover"
            />
            <div class="absolute bottom-0 left-0 right-0 bg-black/60 text-white p-4">
                <h2 class="text-lg font-semibold">Join Smart Library</h2>
                <p class="text-sm opacity-80">
                    Create your account and start exploring books.
                </p>
            </div>
        </figure>

        <!-- Form -->
        <div class="card-body lg:w-1/2">

            <div class="mb-2">
                <h2 class="card-title text-2xl">Register</h2>
                <p class="text-sm opacity-70">
                    Create your library account
                </p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="post" class="space-y-4">

                <fieldset class="fieldset">
                    <legend class="fieldset-legend">Username</legend>
                    <input
                            type="text"
                            name="username"
                            value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                            class="input input-bordered w-full"
                            placeholder="Choose username"
                            required
                    />
                </fieldset>

                <fieldset class="fieldset">
                    <legend class="fieldset-legend">Password</legend>
                    <input
                            type="password"
                            id="password"
                            name="password"
                            class="input input-bordered w-full"
                            placeholder="Create password"
                            required
                    />
                </fieldset>

                <fieldset class="fieldset">
                    <legend class="fieldset-legend">Confirm Password</legend>
                    <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            class="input input-bordered w-full"
                            placeholder="Repeat password"
                            required
                    />
                    <p id="passwordMessage" class="text-sm mt-1"></p>
                </fieldset>

                <fieldset class="fieldset">
                    <legend class="fieldset-legend">Address</legend>
                    <textarea
                            name="address"
                            class="textarea textarea-bordered w-full"
                            placeholder="Enter your full address"
                            required
                    ><%= request.getParameter("address") != null ? request.getParameter("address") : "" %></textarea>
                </fieldset>

                <button id="submitBtn" type="submit" class="btn btn-primary w-full">
                    Register
                </button>
            </form>

            <div class="divider">OR</div>

            <a href="${pageContext.request.contextPath}/login.jsp"
               class="btn btn-outline w-full">
                Back to Login
            </a>

        </div>
    </div>
</div>

<!-- JS -->
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const password = document.getElementById("password");
        const confirmPassword = document.getElementById("confirmPassword");
        const message = document.getElementById("passwordMessage");
        const submitBtn = document.getElementById("submitBtn");

        function checkPassword() {
            if (confirmPassword.value === "") {
                message.textContent = "";
                submitBtn.disabled = true;
                return;
            }

            if (password.value === confirmPassword.value) {
                message.textContent = "Passwords match";
                message.className = "text-green-500 text-sm mt-1";
                submitBtn.disabled = false;
            } else {
                message.textContent = "Passwords do not match";
                message.className = "text-red-500 text-sm mt-1";
                submitBtn.disabled = true;
            }
        }

        password.addEventListener("input", checkPassword);
        confirmPassword.addEventListener("input", checkPassword);

        // Toast function
        function showToast(message, type) {
            const container = document.getElementById("toastContainer");
            if (!container) return;

            const toast = document.createElement("div");
            toast.className = "alert alert-" + type + " shadow-lg";
            toast.innerHTML = "<span>" + message + "</span>";

            container.appendChild(toast);
            setTimeout(() => toast.remove(), 3000);
        }

        // Get error from session
        const error = "<%= (String) session.getAttribute("error") %>";

        if (error && error !== "null") {
            showToast(error, "error");
        }
    });
</script>

<%
    session.removeAttribute("error");
%>

</body>
</html>