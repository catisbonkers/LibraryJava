<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %>
</h1>
<br/>
<h1 class="text-3xl text-blue-500 font-bold underline">
    Hello world!
</h1>
<a href="hello-servlet">Hello Servlet</a>
<jsp:forward page="dashboard.jsp"/>
</body>
</html>