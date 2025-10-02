<%@ page import="com.campingsrilanka.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  User user = (User) session.getAttribute("user");
  if (user == null || !user.isAdmin()) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard - Camping Sri Lanka</title>

  <!-- Internal CSS -->
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', sans-serif; background: #f9fafb; color: #333; line-height: 1.6; }
    :root {
      --primary: #667eea; --primary-dark: #5568d3; --secondary: #764ba2;
      --success: #10b981; --danger: #ef4444; --warning: #f59e0b; --info: #3b82f6;
      --light: #f3f4f6; --dark: #1f2937; --gray: #6b7280;
    }
    .navbar { position: fixed; top: 0; left: 0; right: 0; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); z-index: 1000; }
    .nav-container { max-width: 1200px; margin: 0 auto; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
    .nav-brand h2 { color: var(--primary); font-size: 24px; display: flex; align-items: center; gap: 10px; }
    .nav-menu { display: flex; align-items: center; gap: 20px; }
    .nav-user { color: var(--dark); font-weight: 500; display: flex; align-items: center; gap: 8px; }
    .btn-logout { background: var(--danger); color: white; padding: 8px 20px; border-radius: 8px; text-decoration: none; }
    .btn-logout:hover { background: #dc2626; }
    .dashboard-container { margin-top: 80px; padding: 20px; min-height: calc(100vh - 80px); background: var(--light); }
    .dashboard-content { max-width: 1400px; margin: 0 auto; }
    .stat-card { background: white; border-radius: 15px; padding: 20px; display: inline-block; margin-right: 15px; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    .stat-card i { font-size: 2rem; color: var(--primary); margin-bottom: 10px; display: block; }
    .stat-number { font-size: 1.5rem; font-weight: bold; }
    .stat-label { font-size: 0.9rem; color: var(--gray); }
    .admin-tab-btn { padding: 10px 20px; border: none; border-radius: 8px; background: var(--light); margin-right: 5px; cursor: pointer; font-weight: 600; }
    .admin-tab-btn.active { background: var(--primary); color: white; }
    .admin-section { display: none; margin-top: 20px; }
    .admin-section.active { display: block; }
    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { padding: 8px; border: 1px solid #ccc; text-align: left; }
    th { background-color: var(--primary); color: white; }
    .btn { padding: 6px 12px; border-radius: 6px; border: none; cursor: pointer; }
    .btn-approve { background: var(--success); color: white; }
    .btn-approve:hover { background: #059669; }
    .btn-reject { background: var(--danger); color: white; }
    .btn-reject:hover { background: #dc2626; }
  </style>

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<nav class="navbar">
  <div class="nav-container">
    <div class="nav-brand"><i class="fas fa-campground"></i><h2>Admin Panel</h2></div>
    <div class="nav-menu">
      <span class="nav-user"><i class="fas fa-user-shield"></i> <%= user.getFullName() %></span>
      <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
  </div>
</nav>

<div class="dashboard-container">
  <div class="dashboard-content">
    <!-- Stats -->
    <div class="stat-card">
      <i class="fas fa-clock"></i>
      <div class="stat-number">${pendingPlaces}</div>
      <div class="stat-label">Pending Places</div>
    </div>
    <div class="stat-card">
      <i class="fas fa-users"></i>
      <div class="stat-number">${totalUsers}</div>
      <div class="stat-label">Total Users</div>
    </div>

    <!-- Tabs -->
    <div>
      <button class="admin-tab-btn active" onclick="showAdminTab('pendingPlaces', event)">Pending Places</button>
      <button class="admin-tab-btn" onclick="showAdminTab('allPlaces', event)">All Places</button>
      <button class="admin-tab-btn" onclick="showAdminTab('allUsers', event)">Users</button>
    </div>

    <!-- Pending Places -->
    <div id="pendingPlaces" class="admin-section active">
      <c:choose>
        <c:when test="${not empty pendingPlacesList}">
          <table>
            <tr><th>ID</th><th>Name</th><th>Owner</th><th>Actions</th></tr>
            <c:forEach var="place" items="${pendingPlacesList}">
              <tr>
                <td>${place.id}</td>
                <td>${place.placeName}</td>
                <td>${place.username}</td>
                <td>
                  <form action="${pageContext.request.contextPath}/approvePlace" method="post" style="display:inline;">
                    <input type="hidden" name="placeId" value="${place.id}">
                    <button class="btn btn-approve">Approve</button>
                  </form>
                  <form action="${pageContext.request.contextPath}/rejectPlace" method="post" style="display:inline;">
                    <input type="hidden" name="placeId" value="${place.id}">
                    <button class="btn btn-reject">Reject</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </table>
        </c:when>
        <c:otherwise>No pending places.</c:otherwise>
      </c:choose>
    </div>

    <!-- All Places -->
    <div id="allPlaces" class="admin-section">
      <c:choose>
        <c:when test="${not empty approvedPlacesList}">
          <table>
            <tr><th>ID</th><th>Name</th><th>Owner</th></tr>
            <c:forEach var="place" items="${approvedPlacesList}">
              <tr>
                <td>${place.id}</td>
                <td>${place.placeName}</td>
                <td>${place.username}</td>
              </tr>
            </c:forEach>
          </table>
        </c:when>
        <c:otherwise>No approved places.</c:otherwise>
      </c:choose>
    </div>

    <!-- Users -->
    <div id="allUsers" class="admin-section">
      <c:choose>
        <c:when test="${not empty usersList}">
          <table>
            <tr><th>ID</th><th>Username</th><th>Full Name</th><th>Email</th><th>Role</th></tr>
            <c:forEach var="u" items="${usersList}">
              <tr>
                <td>${u.id}</td>
                <td>${u.username}</td>
                <td>${u.fullName}</td>
                <td>${u.email}</td>
                <td><c:choose>
                  <c:when test="${u.admin}">Admin</c:when>
                  <c:otherwise>User</c:otherwise>
                </c:choose></td>
              </tr>
            </c:forEach>
          </table>
        </c:when>
        <c:otherwise>No users found.</c:otherwise>
      </c:choose>
    </div>

  </div>
</div>

<script>
  function showAdminTab(tabName, event) {
    document.querySelectorAll('.admin-section').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.admin-tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(tabName).classList.add('active');
    event.target.classList.add('active');
  }
</script>

</body>
</html>
