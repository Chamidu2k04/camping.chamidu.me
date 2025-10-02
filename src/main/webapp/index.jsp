<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Camping Sri Lanka - Discover Amazing Camping Sites</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<!-- Navigation -->
<nav class="main-nav">
    <div class="nav-container">
        <div class="nav-brand">
            <i class="fas fa-campground"></i>
            <span>Camping Sri Lanka</span>
        </div>

        <div class="nav-toggle" id="navToggle">
            <span></span>
            <span></span>
            <span></span>
        </div>

        <ul class="nav-menu" id="navMenu">
            <li><a href="#home">Home</a></li>
            <li><a href="#places">Search Places</a></li>
            <li><a href="#">Rent Gear</a></li>
            <li><a href="#">About Us</a></li>
            <li><a href="#">Contact</a></li>
            <li class="nav-login"><a href="login" class="btn btn-login">Login</a></li>
        </ul>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero" id="home">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1 class="hero-title">Discover Sri Lanka's Best Camping Spots</h1>
        <p class="hero-subtitle">Explore hidden gems, share experiences, and connect with fellow campers</p>
        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Get Started</a>
            <a href="#places" class="btn btn-secondary">Explore Places</a>
        </div>
        <div class="hero-stats">
            <div class="stat-item">
                <i class="fas fa-map-marker-alt"></i>
                <span class="stat-number">${placeCount}</span>
                <span class="stat-label">Camping Sites</span>
            </div>
            <div class="stat-item">
                <i class="fas fa-users"></i>
                <span class="stat-number">${userCount}</span>
                <span class="stat-label">Campers</span>
            </div>
            <div class="stat-item">
                <i class="fas fa-star"></i>
                <span class="stat-number">${reviewCount}</span>
                <span class="stat-label">Reviews</span>
            </div>
        </div>
    </div>
</section>

<!-- Search Section -->
<section class="search-section" id="places">
    <div class="container">
        <h2 class="section-title">Find Your Perfect Camping Spot</h2>
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search by place name or location...">
            <button class="btn btn-search" onclick="searchPlaces()">
                <i class="fas fa-search"></i> Search
            </button>
        </div>
    </div>
</section>

<!-- Tab Navigation -->
<section class="places-section">
    <div class="container">
        <div class="tab-navigation">
            <button class="tab-btn active" onclick="showTab('recent')">
                <i class="fas fa-clock"></i> Recent Places
            </button>
            <button class="tab-btn" onclick="showTab('trending')">
                <i class="fas fa-fire"></i> Trending
            </button>
            <button class="tab-btn" onclick="showTab('uncommon')">
                <i class="fas fa-gem"></i> Hidden Gems
            </button>
        </div>

        <!-- Recent Places -->
        <div id="recent" class="tab-content active">
            <div class="places-grid">
                <c:forEach items="${recentPlaces}" var="place">
                    <div class="place-card">
                        <div class="place-image">
                            <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                            <span class="place-badge ${place.accessType}">${place.accessType}</span>
                        </div>
                        <div class="place-content">
                            <h3>${place.placeName}</h3>
                            <p class="place-location"><i class="fas fa-map-marker-alt"></i> ${place.location}</p>
                            <p class="place-description">${place.description}</p>
                            <div class="place-footer">
                                <div class="place-rating">
                                    <i class="fas fa-star"></i>
                                    <span>${place.ratingAvg} (${place.ratingCount})</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Trending Places -->
        <div id="trending" class="tab-content">
            <div class="places-grid">
                <c:forEach items="${trendingPlaces}" var="place">
                    <div class="place-card">
                        <div class="place-image">
                            <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                            <span class="place-badge trending-badge"><i class="fas fa-fire"></i> Trending</span>
                        </div>
                        <div class="place-content">
                            <h3>${place.placeName}</h3>
                            <p class="place-location"><i class="fas fa-map-marker-alt"></i> ${place.location}</p>
                            <p class="place-description">${place.description}</p>
                            <div class="place-footer">
                                <div class="place-rating">
                                    <i class="fas fa-star"></i>
                                    <span>${place.ratingAvg} (${place.ratingCount})</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Uncommon/Hidden Gems -->
        <div id="uncommon" class="tab-content">
            <div class="places-grid">
                <c:forEach items="${uncommonPlaces}" var="place">
                    <div class="place-card">
                        <div class="place-image">
                            <img src="${pageContext.request.contextPath}/uploads/${place.primaryImage}" alt="${place.placeName}">
                            <span class="place-badge gem-badge"><i class="fas fa-gem"></i> Hidden Gem</span>
                        </div>
                        <div class="place-content">
                            <h3>${place.placeName}</h3>
                            <p class="place-location"><i class="fas fa-map-marker-alt"></i> ${place.location}</p>
                            <p class="place-description">${place.description}</p>
                            <div class="place-footer">
                                <div class="place-rating">
                                    <i class="fas fa-star"></i>
                                    <span>${place.ratingAvg} (${place.ratingCount})</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/place/${place.id}" class="btn btn-small">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section">
    <div class="container">
        <h2 class="section-title">Why Choose Camping Sri Lanka?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <i class="fas fa-shield-alt"></i>
                <h3>Verified Reviews</h3>
                <p>All camping sites are reviewed and approved by our admin team</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-users"></i>
                <h3>Community Driven</h3>
                <p>Share your experiences and help fellow campers discover new places</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-map-marked-alt"></i>
                <h3>Detailed Information</h3>
                <p>Get access requirements, location details, and insider tips</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-camera"></i>
                <h3>Photo Gallery</h3>
                <p>View authentic photos from real campers</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3><i class="fas fa-campground"></i> Camping Sri Lanka</h3>
                <p>Your trusted platform for discovering and sharing camping experiences across Sri Lanka.</p>
            </div>
            <div class="footer-section">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                    <li><a href="${pageContext.request.contextPath}/gear-rental">Gear Rental</a></li>
                    <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Connect</h4>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 Camping Sri Lanka. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>