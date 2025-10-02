<%@ page import="com.campingsrilanka.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null || !user.isAdmin()) {
    response.sendRedirect(request.getContextPath() + "/dashboard");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard - Camping Sri Lanka</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* Your CSS styling from previous code */
    :root {
      --primary: #10b981;
      --success: #3b82f6;
      --danger: #ef4444;
      --info: #0ea5e9;
      --dark: #111827;
      --gray: #6b7280;
      --light: #f9fafb;
    }
    body { font-family: Arial, sans-serif; background: #f3f4f6; margin: 0; }
    /* ... keep all the previous CSS ... */
  </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar">
  <div class="nav-container">
    <div class="nav-brand">
      <i class="fas fa-campground"></i>
      <h2>Camping Sri Lanka - Admin Panel</h2>
    </div>
    <div class="nav-menu">
      <span class="nav-user"><i class="fas fa-user-shield"></i> <%= user.getFullName() %></span>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary"><i class="fas fa-home"></i> User Dashboard</a>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
  </div>
</nav>

<div class="dashboard-container">
  <div class="dashboard-content" style="max-width: 1400px;">
    <!-- Admin Stats -->
    <div class="admin-stats">
      <div class="stat-card pending">
        <i class="fas fa-clock"></i>
        <div class="stat-number">${pendingPlaces}</div>
        <div class="stat-label">Pending Places</div>
      </div>
      <div class="stat-card users">
        <i class="fas fa-users"></i>
        <div class="stat-number">${totalUsers}</div>
        <div class="stat-label">Total Users</div>
      </div>
      <div class="stat-card places">
        <i class="fas fa-map-marker-alt"></i>
        <div class="stat-number">${approvedPlaces}</div>
        <div class="stat-label">Approved Places</div>
      </div>
      <div class="stat-card reviews">
        <i class="fas fa-comment"></i>
        <div class="stat-number">${pendingReviews}</div>
        <div class="stat-label">Pending Reviews</div>
      </div>
    </div>

    <!-- Admin Tabs -->
    <div class="admin-tabs">
      <button class="admin-tab-btn active" onclick="showAdminTab('pendingPlaces', event)">
        <i class="fas fa-clock"></i> Pending Places
      </button>
      <button class="admin-tab-btn" onclick="showAdminTab('pendingReviews', event)">
        <i class="fas fa-comment"></i> Pending Reviews
      </button>
      <button class="admin-tab-btn" onclick="showAdminTab('allPlaces', event)">
        <i class="fas fa-list"></i> All Places
      </button>
      <button class="admin-tab-btn" onclick="showAdminTab('users', event)">
        <i class="fas fa-users"></i> Manage Users
      </button>
    </div>

    <!-- Pending Places Section -->
    <div id="pendingPlaces" class="admin-section active">
      <h2><i class="fas fa-clock"></i> Pending Place Submissions</h2>
      <c:forEach items="${pendingPlacesList}" var="place">
        <div class="review-card">
          <div class="review-header">
            <div>
              <h4>Review for: ${place.placeName}</h4>
              <p><small>By: ${place.username} on ${place.createdAt}</small></p>
            </div>
          </div>
          <p><strong>Description:</strong> ${place.description}</p>
          <p><strong>Access Type:</strong> ${place.accessType}</p>
          <c:if test="${not empty place.tips}">
            <p><strong>Tips:</strong> ${place.tips}</p>
          </c:if>
          <c:if test="${not empty place.googleMapLink}">
            <p><strong>Map:</strong> <a href="${place.googleMapLink}" target="_blank">View on Google Maps</a></p>
          </c:if>

          <!-- Images -->
          <div class="image-preview-container">
            <c:forEach items="${place.images}" var="image">
              <div class="image-preview">
                <img src="${pageContext.request.contextPath}/uploads/${image}" alt="Place Image">
              </div>
            </c:forEach>
          </div>

          <!-- Admin Actions -->
          <form action="${pageContext.request.contextPath}/admin/place/review" method="post">
            <input type="hidden" name="placeId" value="${place.id}">
            <div class="feedback-form">
              <label>Admin Comment (Optional):</label>
              <textarea name="adminComment" rows="2" placeholder="Enter feedback or reason for rejection..." style="width: 100%; margin-top: 8px;"></textarea>
            </div>
            <div class="review-actions">
              <button type="submit" name="action" value="approve" class="btn btn-small btn-approve"><i class="fas fa-check"></i> Approve</button>
              <button type="submit" name="action" value="reject" class="btn btn-small btn-reject"><i class="fas fa-times"></i> Reject</button>
              <a href="${pageContext.request.contextPath}/admin/place/edit/${place.id}" class="btn btn-small btn-edit"><i class="fas fa-edit"></i> Edit</a>
              <button type="button" onclick="deletePlace(${place.id})" class="btn btn-small btn-reject"><i class="fas fa-trash"></i> Delete</button>
            </div>
          </form>
        </div>
      </c:forEach>
      <c:if test="${empty pendingPlacesList}">
        <div class="empty-state">
          <i class="fas fa-check-circle"></i>
          <h3>No Pending Places</h3>
          <p>All place submissions have been reviewed</p>
        </div>
      </c:if>
    </div>

    <!-- Pending Reviews Section -->
    <div id="pendingReviews" class="admin-section">
      <h2><i class="fas fa-comment"></i> Pending Review Comments</h2>
      <c:forEach items="${pendingReviewsList}" var="review">
        <div class="review-card">
          <div class="review-header">
            <div>
              <h4>Review for: ${review.placeName}</h4>
              <p><small>By: ${review.username} on ${review.createdAt}</small></p>
            </div>
            <div class="place-rating">
              <i class="fas fa-star"></i> ${review.rating} / 5
            </div>
          </div>
          <p><strong>Comment:</strong> ${review.comment}</p>
          <c:if test="${not empty review.images}">
            <div class="image-preview-container">
              <c:forEach items="${review.images}" var="image">
                <div class="image-preview">
                  <img src="${pageContext.request.contextPath}/uploads/${image}" alt="Review Image">
                </div>
              </c:forEach>
            </div>
          </c:if>
          <form action="${pageContext.request.contextPath}/admin/review/moderate" method="post">
            <input type="hidden" name="reviewId" value="${review.id}">
            <div class="feedback-form">
              <label>Admin Comment (Optional):</label>
              <textarea name="adminComment" rows="2" placeholder="Enter reason for rejection..." style="width: 100%; margin-top: 8px;"></textarea>
            </div>
            <div class="review-actions">
              <button type="submit" name="action" value="approve" class="btn btn-small btn-approve"><i class="fas fa-check"></i> Approve</button>
              <button type="submit" name="action" value="reject" class="btn btn-small btn-reject"><i class="fas fa-times"></i> Reject</button>
              <button type="button" onclick="if(confirm('Delete this review?')) this.closest('form').action='${pageContext.request.contextPath}/admin/review/delete/${review.id}'; this.closest('form').submit();" class="btn btn-small btn-reject"><i class="fas fa-trash"></i> Delete</button>
            </div>
          </form>
        </div>
      </c:forEach>
      <c:if test="${empty pendingReviewsList}">
        <div class="empty-state">
          <i class="fas fa-check-circle"></i>
          <h3>No Pending Reviews</h3>
          <p>All reviews have been moderated</p>
        </div>
      </c:if>
    </div>

    <!-- All Places Section -->
    <div id="allPlaces" class="admin-section">
      <h2><i class="fas fa-list"></i> All Places</h2>
      <table class="user-table">
        <thead>
        <tr>
          <th>Place Name</th>
          <th>Location</th>
          <th>Status</th>
          <th>Views</th>
          <th>Rating</th>
          <th>Posted By</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${allPlacesList}" var="place">
          <tr>
            <td><strong>${place.placeName}</strong></td>
            <td>${place.location}</td>
            <td><span class="status-badge status-${place.status}">${place.status}</span></td>
            <td>${place.viewCount}</td>
            <td><i class="fas fa-star" style="color: #f59e0b;"></i> ${place.ratingAvg} (${place.ratingCount})</td>
            <td>${place.username}</td>
            <td>
              <div class="action-btns">
                <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small" target="_blank"><i class="fas fa-eye"></i></a>
                <a href="${pageContext.request.contextPath}/admin/place/edit/${place.id}" class="btn btn-small btn-edit"><i class="fas fa-edit"></i></a>
                <button onclick="deletePlace(${place.id})" class="btn btn-small btn-reject"><i class="fas fa-trash"></i></button>
              </div>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- Users Management Section -->
    <div id="users" class="admin-section">
      <h2><i class="fas fa-users"></i> User Management</h2>
      <table class="user-table">
        <thead>
        <tr>
          <th>Username</th>
          <th>Full Name</th>
          <th>Email</th>
          <th>Role</th>
          <th>Status</th>
          <th>Joined</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${usersList}" var="u">
          <tr>
            <td><strong>${u.username}</strong></td>
            <td>${u.fullName}</td>
            <td>${u.email}</td>
            <td>
              <c:choose>
                <c:when test="${u.admin}"><span style="color: var(--primary); font-weight: 600;"><i class="fas fa-user-shield"></i> Admin</span></c:when>
                <c:otherwise><span style="color: var(--gray);"><i class="fas fa-user"></i> Member</span></c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:choose>
                <c:when test="${u.banned}"><span class="banned-badge"><i class="fas fa-ban"></i> Banned</span></c:when>
                <c:otherwise><span style="color: var(--success); font-weight: 600;"><i class="fas fa-check-circle"></i> Active</span></c:otherwise>
              </c:choose>
            </td>
            <td>${u.createdAt}</td>
            <td>
              <c:if test="${u.id != user.id}">
                <div class="action-btns">
                  <c:choose>
                    <c:when test="${u.banned}">
                      <button onclick="unbanUser(${u.id})" class="btn btn-small btn-approve"><i class="fas fa-user-check"></i> Unban</button>
                    </c:when>
                    <c:otherwise>
                      <button onclick="banUser(${u.id})" class="btn btn-small btn-ban"><i class="fas fa-ban"></i> Ban</button>
                    </c:otherwise>
                  </c:choose>
                  <button onclick="if(confirm('Delete user ${u.username} and all their posts?')) window.location.href='${pageContext.request.contextPath}/admin/user/delete/${u.id}'" class="btn btn-small btn-reject"><i class="fas fa-trash"></i></button>
                </div>
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
  function showAdminTab(tabName, event) {
    document.querySelectorAll('.admin-section').forEach(section => section.classList.remove('active'));
    document.querySelectorAll('.admin-tab-btn').forEach(btn => btn.classList.remove('active'));
    document.getElementById(tabName).classList.add('active');
    event.target.classList.add('active');
  }

  function deletePlace(id) {
    if(confirm('Delete this place?')) {
      window.location.href='${pageContext.request.contextPath}/admin/place/delete/' + id;
    }
  }

  function banUser(id) {
    if(confirm('Ban this user?')) {
      window.location.href='${pageContext.request.contextPath}/admin/user/ban/' + id;
    }
  }

  function unbanUser(id) {
    window.location.href='${pageContext.request.contextPath}/admin/user/unban/' + id;
  }
</script>
</body>
</html>
