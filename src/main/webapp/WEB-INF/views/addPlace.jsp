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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Place - Camping Sri Lanka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ===== GLOBAL ===== */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary: #667eea; --primary-dark: #5568d3; --secondary: #764ba2;
            --success: #10b981; --danger: #ef4444; --warning: #f59e0b; --info: #3b82f6;
            --light: #f3f4f6; --dark: #1f2937; --gray: #6b7280;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9fafb; color: #333; line-height: 1.6;
        }

        /* ===== NAVBAR ===== */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0;
            background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); z-index: 1000;
            padding: 15px 20px; display: flex; justify-content: space-between; align-items: center;
        }
        .nav-brand { display: flex; align-items: center; gap: 10px; color: var(--primary); font-size: 24px; font-weight: bold; }
        .nav-brand i { font-size: 28px; }
        .nav-menu a { text-decoration: none; color: var(--primary); font-weight: 500; padding: 8px 15px; border-radius: 8px; background: var(--light); transition: all 0.3s ease; }
        .nav-menu a:hover { background: var(--primary); color: white; }

        /* ===== FORM STYLES ===== */
        .form-wrapper {
            background: white; border-radius: 15px; padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3); animation: slideUp 0.5s ease;
            max-width: 600px; margin: 120px auto 60px;
        }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity:1; transform: translateY(0); } }
        .form-header { text-align: center; margin-bottom: 30px; }
        .form-header h1 { color: var(--dark); font-size: 28px; margin-bottom: 10px; }
        .form-header p { color: var(--gray); font-size: 14px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: var(--dark); font-weight: 500; font-size: 14px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px 15px; border: 2px solid #e5e7eb; border-radius: 8px; font-size: 14px; transition: all 0.3s ease; font-family: inherit; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .form-group textarea { resize: vertical; min-height: 100px; }
        .btn { padding: 12px 24px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; text-decoration: none; display: inline-block; }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(102,126,234,0.4); }
        .alert { padding: 12px 15px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .form-wrapper { margin: 80px 20px; padding: 30px; }
            .nav-menu { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="nav-brand"><i class="fas fa-campground"></i> Camping Sri Lanka</div>
    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/dashboard"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
</nav>

<!-- Form Wrapper -->
<div class="form-wrapper">
    <div class="form-header">
        <h1><i class="fas fa-map-marker-alt"></i> Add New Camping Place</h1>
        <p>Share your favorite camping spot with the community</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/place" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label>Place Name *</label>
            <input type="text" name="placeName" placeholder="Enter the name of the camping place" required>
        </div>
        <div class="form-group">
            <label>Location *</label>
            <input type="text" name="location" placeholder="City, district, or region" required>
        </div>
        <div class="form-group">
            <label>Description *</label>
            <textarea name="description" rows="5" placeholder="Describe the camping spot, facilities, and environment" required></textarea>
        </div>
        <div class="form-group">
            <label>Access Type *</label>
            <select name="accessType" required>
                <option value="">Select access type</option>
                <option value="free">Free Entry</option>
                <option value="ticket">Ticket Required</option>
                <option value="permission">Permission Required</option>
            </select>
        </div>
        <div class="form-group">
            <label>Google Maps Link (Optional)</label>
            <input type="url" name="googleMapLink" placeholder="https://maps.google.com/...">
        </div>
        <div class="form-group">
            <label>Tips & Recommendations (Optional)</label>
            <textarea name="tips" rows="4" placeholder="Provide tips for visitors, e.g., best time to visit, nearby amenities"></textarea>
        </div>
        <div class="form-group">
            <label>Upload Images (1–5 images, max 5MB each)</label>
            <input type="file" name="images" accept="image/*" multiple required>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit for Review</button>
        </div>
    </form>
</div>

</body>
</html>
