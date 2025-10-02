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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .add-place-container {
            max-width: 800px;
            margin: 100px auto 50px;
            padding: 20px;
        }

        .image-preview-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .image-preview {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            border: 2px solid #e5e7eb;
        }

        .image-preview img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .remove-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .remove-btn:hover {
            background: #dc2626;
        }

        .char-counter {
            text-align: right;
            font-size: 0.85rem;
            color: #6b7280;
            margin-top: 5px;
        }

        .star-rating {
            display: flex;
            gap: 5px;
            margin: 10px 0;
        }

        .file-upload-area {
            border: 2px dashed #d1d5db;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .file-upload-area:hover {
            border-color: var(--primary);
            background: #f9fafb;
        }

        .file-upload-area i {
            font-size: 3rem;
            color: var(--primary);
            margin-bottom: 15px;
        }

        .upload-info {
            color: #6b7280;
            font-size: 0.9rem;
            margin-top: 10px;
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
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="add-place-container">
    <div class="form-wrapper">
        <div class="form-header">
            <h1><i class="fas fa-map-marker-alt"></i> Add New Camping Place</h1>
            <p>Share your favorite camping spot with the community</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/place/add" method="post" enctype="multipart/form-data" onsubmit="return validatePlaceForm()">

            <!-- Place Name -->
            <div class="form-group">
                <label for="placeName">
                    <i class="fas fa-map-pin"></i> Place Name *
                </label>
                <input type="text" id="placeName" name="placeName" required
                       placeholder="e.g., Knuckles Mountain Range">
            </div>

            <!-- Location -->
            <div class="form-group">
                <label for="location">
                    <i class="fas fa-location-dot"></i> Location *
                </label>
                <input type="text" id="location" name="location" required
                       placeholder="e.g., Matale District, Central Province">
            </div>

            <!-- Description -->
            <div class="form-group">
                <label for="description">
                    <i class="fas fa-align-left"></i> Description * (Max 100 words)
                </label>
                <textarea id="description" name="description" required
                          placeholder="Describe the camping site, its features, and what makes it special..."
                          rows="5"></textarea>
                <div id="descriptionCount" class="char-counter">0 / 100 words</div>
            </div>

            <!-- Access Type -->
            <div class="form-group">
                <label for="accessType">
                    <i class="fas fa-door-open"></i> Access Type *
                </label>
                <select id="accessType" name="accessType" required>
                    <option value="">Select access type</option>
                    <option value="free">Free Entry</option>
                    <option value="ticket">Ticket Required</option>
                    <option value="permission">Permission Required</option>
                </select>
            </div>

            <!-- Google Map Link -->
            <div class="form-group">
                <label for="googleMapLink">
                    <i class="fas fa-map"></i> Google Maps Link
                </label>
                <input type="url" id="googleMapLink" name="googleMapLink"
                       placeholder="https://maps.google.com/...">
                <small class="upload-info">Paste the Google Maps share link for this location</small>
            </div>

            <!-- Tips (Optional) -->
            <div class="form-group">
                <label for="tips">
                    <i class="fas fa-lightbulb"></i> Tips & Recommendations (Optional, Max 200 words)
                </label>
                <textarea id="tips" name="tips"
                          placeholder="Share useful tips like best time to visit, what to bring, safety precautions, etc."
                          rows="6"></textarea>
                <div id="tipsCount" class="char-counter">0 / 200 words</div>
            </div>

            <!-- Images Upload -->
            <div class="form-group">
                <label>
                    <i class="fas fa-images"></i> Images * (1-5 images, max 5MB each)
                </label>
                <div class="file-upload-area" onclick="document.getElementById('images').click()">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <h3>Click to Upload Images</h3>
                    <p class="upload-info">Upload 1-5 images (JPG, PNG) - Maximum 5MB per image</p>
                </div>
                <input type="file" id="images" name="images" accept="image/*" multiple
                       style="display: none;" required>
                <div id="imagePreview" class="image-preview-container"></div>
            </div>

            <!-- Submit Buttons -->
            <div class="form-group">
                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    <i class="fas fa-paper-plane"></i> Submit for Review
                </button>
            </div>

            <div class="alert alert-info" style="background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd;">
                <i class="fas fa-info-circle"></i> Your post will be reviewed by our admin team before being published on the site.
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>