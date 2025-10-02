<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${place.placeName} - Camping Sri Lanka</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .place-detail-container {
            max-width: 1200px;
            margin: 100px auto 50px;
            padding: 20px;
        }

        .place-gallery {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            grid-template-rows: 300px 300px;
            gap: 10px;
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 30px;
        }

        .gallery-main {
            grid-row: 1 / 3;
            grid-column: 1;
        }

        .gallery-main img,
        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .gallery-item:hover img,
        .gallery-main:hover img {
            transform: scale(1.05);
        }

        .place-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .place-title-section h1 {
            font-size: 2.5rem;
            color: var(--dark);
            margin-bottom: 10px;
        }

        .place-meta {
            display: flex;
            gap: 20px;
            color: var(--gray);
            flex-wrap: wrap;
        }

        .place-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .place-actions {
            display: flex;
            gap: 10px;
        }

        .place-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        .main-content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .info-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .info-card h3 {
            margin-bottom: 20px;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .tips-box {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }

        .tips-box h4 {
            color: #92400e;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .reviews-section {
            margin-top: 40px;
        }

        .review-item {
            background: var(--light);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .reviewer-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .review-rating {
            display: flex;
            gap: 3px;
            color: #f59e0b;
        }

        .review-form {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-top: 30px;
        }

        .map-container {
            width: 100%;
            height: 300px;
            border-radius: 12px;
            overflow: hidden;
            margin-top: 20px;
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        @media (max-width: 968px) {
            .place-gallery {
                grid-template-columns: 1fr;
                grid-template-rows: 250px;
            }

            .gallery-main {
                grid-row: 1;
                grid-column: 1;
            }

            .gallery-item {
                display: none;
            }

            .place-content {
                grid-template-columns: 1fr;
            }

            .place-title-section h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="main-nav">
    <div class="nav-container">
        <div class="nav-brand">
            <i class="fas fa-campground"></i>
            <span>Camping Sri Lanka</span>
        </div>
        <ul class="nav-menu">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
        </ul>
    </div>
</nav>

<div class="place-detail-container">
    <!-- Image Gallery -->
    <div class="place-gallery">
        <div class="gallery-main">
            <img src="${pageContext.request.contextPath}/uploads/${place.images[0]}" alt="${place.placeName}">
        </div>
        <c:if test="${place.images.size() > 1}">
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/uploads/${place.images[1]}" alt="${place.placeName}">
            </div>
        </c:if>
        <c:if test="${place.images.size() > 2}">
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/uploads/${place.images[2]}" alt="${place.placeName}">
            </div>
        </c:if>
        <c:if test="${place.images.size() > 3}">
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/uploads/${place.images[3]}" alt="${place.placeName}">
            </div>
        </c:if>
        <c:if test="${place.images.size() > 4}">
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/uploads/${place.images[4]}" alt="${place.placeName}">
            </div>
        </c:if>
    </div>

    <!-- Place Header -->
    <div class="place-header">
        <div class="place-title-section">
            <h1>${place.placeName}</h1>
            <div class="place-meta">
                <span><i class="fas fa-map-marker-alt"></i> ${place.location}</span>
                <span><i class="fas fa-user"></i> Posted by ${place.username}</span>
                <span><i class="fas fa-eye"></i> ${place.viewCount} views</span>
                <span>
                        <i class="fas fa-star" style="color: #f59e0b;"></i>
                        ${place.ratingAvg} (${place.ratingCount} reviews)
                    </span>
            </div>
        </div>
        <div class="place-actions">
            <c:if test="${not empty sessionScope.user}">
                <button id="favorite-${place.id}" onclick="toggleFavorite(${place.id})" class="btn btn-secondary ${place.isFavorited ? 'favorited' : ''}">
                    <i class="${place.isFavorited ? 'fas' : 'far'} fa-heart"></i>
                        ${place.isFavorited ? 'Favorited' : 'Add to Favorites'}
                </button>
            </c:if>
            <button onclick="window.open('${place.googleMapLink}', '_blank')" class="btn btn-primary">
                <i class="fas fa-map"></i> View on Map
            </button>
        </div>
    </div>

    <!-- Content Grid -->
    <div class="place-content">
        <!-- Main Content -->
        <div class="main-content">
            <h2><i class="fas fa-info-circle"></i> About This Place</h2>
            <p style="line-height: 1.8; color: #4b5563; margin: 20px 0;">
                ${place.description}
            </p>

            <c:if test="${not empty place.tips}">
                <div class="tips-box">
                    <h4><i class="fas fa-lightbulb"></i> Tips & Recommendations</h4>
                    <p style="color: #92400e; line-height: 1.6;">${place.tips}</p>
                </div>
            </c:if>

            <!-- Map -->
            <c:if test="${not empty place.googleMapLink}">
                <h3 style="margin-top: 30px;"><i class="fas fa-map-marked-alt"></i> Location</h3>
                <div class="map-container">
                    <iframe src="${place.googleMapLink.replace('maps.google.com', 'maps.google.com/maps').concat('&output=embed')}"
                            allowfullscreen="" loading="lazy"></iframe>
                </div>
            </c:if>

            <!-- Reviews Section -->
            <div class="reviews-section">
                <h2><i class="fas fa-comments"></i> Reviews (${place.ratingCount})</h2>

                <c:forEach items="${reviews}" var="review">
                    <div class="review-item">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                        ${review.username.substring(0, 1).toUpperCase()}
                                </div>
                                <div>
                                    <strong>${review.username}</strong>
                                    <div class="review-rating">
                                        <c:forEach begin="1" end="${review.rating}">
                                            <i class="fas fa-star"></i>
                                        </c:forEach>
                                        <c:forEach begin="${review.rating + 1}" end="5">
                                            <i class="far fa-star"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <span style="color: var(--gray); font-size: 0.9rem;">${review.createdAt}</span>
                        </div>
                        <p style="color: #4b5563; line-height: 1.6;">${review.comment}</p>

                        <c:if test="${not empty review.images}">
                            <div class="image-preview-container" style="margin-top: 15px;">
                                <c:forEach items="${review.images}" var="image">
                                    <div class="image-preview">
                                        <img src="${pageContext.request.contextPath}/uploads/${image}" alt="Review Image">
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>

                <!-- Add Review Form -->
                <c:if test="${not empty sessionScope.user && !hasReviewed}">
                    <div class="review-form">
                        <h3><i class="fas fa-pen"></i> Write a Review</h3>
                        <form action="${pageContext.request.contextPath}/place/${place.id}/review" method="post"
                              enctype="multipart/form-data" onsubmit="return validateReviewForm()">

                            <div class="form-group">
                                <label>Your Rating *</label>
                                <div class="star-rating" id="starRating"></div>
                                <input type="hidden" id="rating" name="rating" required>
                            </div>

                            <div class="form-group">
                                <label for="comment">Your Experience *</label>
                                <textarea id="comment" name="comment" required rows="5"
                                          placeholder="Share your camping experience at this place..."></textarea>
                            </div>

                            <div class="form-group">
                                <label>Photos (Optional, max 5 images)</label>
                                <input type="file" id="reviewImages" name="images" accept="image/*" multiple>
                                <div id="imagePreview" class="image-preview-container"></div>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Submit Review
                            </button>
                        </form>
                    </div>
                </c:if>

                <c:if test="${empty sessionScope.user}">
                    <div class="alert alert-info" style="margin-top: 20px; background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd;">
                        <i class="fas fa-info-circle"></i>
                        <a href="${pageContext.request.contextPath}/login" style="color: #1e40af; text-decoration: underline;">Login</a>
                        to write a review
                    </div>
                </c:if>

                <c:if test="${hasReviewed}">
                    <div class="alert alert-success" style="margin-top: 20px;">
                        <i class="fas fa-check-circle"></i> You have already reviewed this place
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Quick Info Card -->
            <div class="info-card">
                <h3><i class="fas fa-info-circle"></i> Quick Info</h3>
                <div class="info-item">
                    <span style="color: var(--gray);">Access Type</span>
                    <span style="font-weight: 600; text-transform: capitalize;">
                            <c:choose>
                                <c:when test="${place.accessType == 'free'}">
                                    <i class="fas fa-check-circle" style="color: var(--success);"></i> Free Entry
                                </c:when>
                                <c:when test="${place.accessType == 'ticket'}">
                                    <i class="fas fa-ticket-alt" style="color: var(--warning);"></i> Ticket Required
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-lock" style="color: var(--info);"></i> Permission Required
                                </c:otherwise>
                            </c:choose>
                        </span>
                </div>
                <div class="info-item">
                    <span style="color: var(--gray);">Total Reviews</span>
                    <span style="font-weight: 600;">${place.ratingCount}</span>
                </div>
                <div class="info-item">
                    <span style="color: var(--gray);">Average Rating</span>
                    <span style="font-weight: 600;">
                            <i class="fas fa-star" style="color: #f59e0b;"></i> ${place.ratingAvg} / 5
                        </span>
                </div>
                <div class="info-item">
                    <span style="color: var(--gray);">Posted On</span>
                    <span style="font-weight: 600;">${place.createdAt}</span>
                </div>
            </div>

            <!-- Share Card -->
            <div class="info-card">
                <h3><i class="fas fa-share-alt"></i> Share This Place</h3>
                <div style="display: flex; gap: 10px;">
                    <button onclick="window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(window.location.href), '_blank')"
                            class="btn btn-secondary" style="flex: 1;">
                        <i class="fab fa-facebook"></i>
                    </button>
                    <button onclick="window.open('https://twitter.com/intent/tweet?url=' + encodeURIComponent(window.location.href) + '&text=${place.placeName}', '_blank')"
                            class="btn btn-secondary" style="flex: 1;">
                        <i class="fab fa-twitter"></i>
                    </button>
                    <button onclick="navigator.clipboard.writeText(window.location.href); alert('Link copied!');"
                            class="btn btn-secondary" style="flex: 1;">
                        <i class="fas fa-link"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    // Add event listener for review images
    const reviewImagesInput = document.getElementById('reviewImages');
    if (reviewImagesInput) {
        reviewImagesInput.addEventListener('change', function() {
            previewImages(this, 'imagePreview');
        });
    }
</script>
</body>
</html>