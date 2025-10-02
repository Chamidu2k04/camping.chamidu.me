<%@ page import="com.campingsrilanka.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<%
    if (user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/adminDashboard");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Camping Sri Lanka</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<!-- Navbar -->
<nav class="navbar">
    <div class="nav-container">
        <div class="nav-brand">
            <i class="fas fa-campground"></i>
            <h2>Camping Sri Lanka</h2>
        </div>
        <div class="nav-menu">
                <span class="nav-user">
                    <i class="fas fa-user-circle"></i> <%= user.getFullName() %>
                </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>

<!-- Dashboard Container -->
<div class="dashboard-container">
    <div class="dashboard-content">
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h1>Welcome back, <%= user.getFullName() %>!</h1>
            <p class="subtitle">Manage your camping posts and explore new places</p>

            <!-- User Info -->
            <div class="user-info-card">
                <h3><i class="fas fa-user"></i> Profile Information</h3>
                <div class="info-row">
                    <span class="info-label">Username:</span>
                    <span class="info-value"><%= user.getUsername() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-value"><%= user.getEmail() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Account Type:</span>
                    <span class="info-value"><%= user.isAdmin() ? "Administrator" : "Member" %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Total Posts:</span>
                    <span class="info-value">${totalPosts}</span>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="dashboard-actions">
                <a href="${pageContext.request.contextPath}/place/add" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Place
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                    <i class="fas fa-search"></i> Browse Places
                </a>
            </div>
        </div>

        <!-- User Posts Section -->
        <div class="posts-section">
            <h2><i class="fas fa-list"></i> My Camping Posts</h2>

            <!-- Status Filter -->
            <div class="status-filter">
                <button class="filter-btn active" data-status="all">All Posts</button>
                <button class="filter-btn" data-status="pending">Pending</button>
                <button class="filter-btn" data-status="approved">Approved</button>
                <button class="filter-btn" data-status="rejected">Rejected</button>
            </div>

            <!-- Posts List -->
            <div class="posts-list">
                <c:forEach items="${userPlaces}" var="place">
                    <div class="post-card" data-status="${place.status}">
                        <div class="post-image">
                            <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                        </div>
                        <div class="post-content">
                            <div class="post-header">
                                <h3>${place.placeName}</h3>
                                <span class="status-badge status-${place.status}">
                                        <c:choose>
                                            <c:when test="${place.status == 'pending'}">
                                                <i class="fas fa-clock"></i> Pending Review
                                            </c:when>
                                            <c:when test="${place.status == 'approved'}">
                                                <i class="fas fa-check-circle"></i> Approved
                                            </c:when>
                                            <c:when test="${place.status == 'rejected'}">
                                                <i class="fas fa-times-circle"></i> Rejected
                                            </c:when>
                                        </c:choose>
                                    </span>
                            </div>
                            <p class="post-location"><i class="fas fa-map-marker-alt"></i> ${place.location}</p>
                            <p class="post-description">${place.description}</p>

                            <c:if test="${place.status == 'rejected' && place.adminComment != null}">
                                <div class="admin-feedback rejected">
                                    <strong><i class="fas fa-exclamation-circle"></i> Admin Feedback:</strong>
                                    <p>${place.adminComment}</p>
                                </div>
                            </c:if>

                            <c:if test="${place.status == 'approved'}">
                                <div class="post-stats">
                                    <span><i class="fas fa-eye"></i> ${place.viewCount} views</span>
                                    <span><i class="fas fa-star"></i> ${place.ratingAvg} (${place.ratingCount} reviews)</span>
                                </div>
                            </c:if>

                            <div class="post-actions">
                                <c:if test="${place.status == 'approved'}">
                                    <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small">
                                        <i class="fas fa-eye"></i> View
                                    </a>
                                </c:if>
                                <c:if test="${place.status == 'pending' || place.status == 'rejected'}">
                                    <a href="${pageContext.request.contextPath}/place/edit/${place.id}" class="btn btn-small">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                </c:if>
                                <span class="post-date">Posted: ${place.createdAt}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty userPlaces}">
                    <div class="empty-state">
                        <i class="fas fa-mountain"></i>
                        <h3>No posts yet</h3>
                        <p>Start sharing your camping experiences!</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Favorites Section -->
        <div class="favorites-section">
            <h2><i class="fas fa-heart"></i> My Favorite Places</h2>
            <div class="favorites-grid">
                <c:forEach items="${favorites}" var="place">
                    <div class="favorite-card">
                        <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                        <div class="favorite-content">
                            <h4>${place.placeName}</h4>
                            <p>${place.location}</p>
                            <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small">View</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    // Filter posts by status
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const status = this.dataset.status;
            document.querySelectorAll('.post-card').forEach(card => {
                if (status === 'all' || card.dataset.status === status) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });
</script>
</body>
</html>