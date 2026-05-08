<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 10:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Panel | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<div id="toastContainer" class="toast toast-top toast-end z-50"></div>

<%
    com.example.demo1.model.User user =
            (com.example.demo1.model.User) session.getAttribute("user");

    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    List<Book> books = BookService.getAllBooks();
%>

</body>
</html>
