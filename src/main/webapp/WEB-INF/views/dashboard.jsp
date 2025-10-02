<%@ page import="com.campingsrilanka.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav>
    <h2>Camping Sri Lanka</h2>
    <div>
        Welcome, <%= user.getFullName() %>!
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <h1>Dashboard</h1>
    <p>Username: <%= user.getUsername() %></p>
    <p>Email: <%= user.getEmail() %></p>
    <p>Full Name: <%= user.getFullName() %></p>

    <% if (user.isAdmin()) { %>
    <div class="admin-panel">
        <h2>Admin Panel</h2>
        <p>Manage users and camping entries here.</p>
    </div>
    <% } %>
</div>
</body>
</html>
