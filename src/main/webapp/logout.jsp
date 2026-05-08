<%--
  Created by IntelliJ IDEA.
  User: johnt
  Date: 5/5/2026
  Time: 12:36 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
