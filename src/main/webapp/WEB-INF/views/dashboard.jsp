<%@ page import="com.campingsrilanka.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
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
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 80px auto 20px;
            padding: 20px;
        }

        .welcome-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .user-info-card {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #667eea;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #4b5563;
        }

        .info-value {
            color: #1f2937;
        }

        .dashboard-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .posts-section, .favorites-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .status-filter {
            display: flex;
            gap: 10px;
            margin: 20px 0;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 8px 16px;
            border: 2px solid #e5e7eb;
            background: white;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .post-card {
            display: flex;
            gap: 20px;
            padding: 20px;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            margin-bottom: 20px;
            transition: transform 0.3s ease;
        }

        .post-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .post-image {
            width: 150px;
            height: 150px;
            border-radius: 10px;
            overflow: hidden;
            flex-shrink: 0;
        }

        .post-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .post-content {
            flex: 1;
        }

        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-approved {
            background: #d1fae5;
            color: #065f46;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .post-location {
            color: #6b7280;
            margin-bottom: 10px;
        }

        .post-description {
            color: #4b5563;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .admin-feedback {
            background: #fef2f2;
            border-left: 4px solid #ef4444;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
        }

        .post-stats {
            display: flex;
            gap: 20px;
            margin: 15px 0;
            color: #6b7280;
        }

        .post-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
        }

        .post-date {
            color: #9ca3af;
            font-size: 0.9rem;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #d1d5db;
        }

        .favorites-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .favorite-card {
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .favorite-card:hover {
            transform: translateY(-2px);
        }

        .favorite-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .favorite-content {
            padding: 15px;
        }

        @media (max-width: 768px) {
            .post-card {
                flex-direction: column;
            }

            .post-image {
                width: 100%;
                height: 200px;
            }

            .dashboard-actions {
                flex-direction: column;
            }

            .post-header {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
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
                <a href="${pageContext.request.contextPath}/addPlace" class="btn btn-primary">
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
                            <c:choose>
                                <c:when test="${not empty place.primaryImage}">
                                    <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/default-place.jpg" alt="Default Image">
                                </c:otherwise>
                            </c:choose>
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

                            <c:if test="${place.status == 'rejected' && not empty place.adminComment}">
                                <div class="admin-feedback">
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
                                    <a href="${pageContext.request.contextPath}/place/edit?id=${place.id}" class="btn btn-small">
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
                        <c:choose>
                            <c:when test="${not empty place.primaryImage}">
                                <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/default-place.jpg" alt="Default Image">
                            </c:otherwise>
                        </c:choose>
                        <div class="favorite-content">
                            <h4>${place.placeName}</h4>
                            <p>${place.location}</p>
                            <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small">View</a>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty favorites}">
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <i class="fas fa-heart" style="color: #fbb6ce;"></i>
                        <h3>No favorites yet</h3>
                        <p>Start exploring and add places to your favorites!</p>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary" style="margin-top: 20px;">
                            <i class="fas fa-search"></i> Browse Places
                        </a>
                    </div>
                </c:if>
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