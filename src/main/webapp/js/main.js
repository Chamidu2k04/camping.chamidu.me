// Mobile Navigation Toggle
document.addEventListener('DOMContentLoaded', function() {
    const navToggle = document.getElementById('navToggle');
    const navMenu = document.getElementById('navMenu');

    if (navToggle) {
        navToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            navToggle.classList.toggle('active');
        });
    }

    // Close menu when clicking outside
    document.addEventListener('click', function(event) {
        if (navMenu && !navMenu.contains(event.target) && !navToggle.contains(event.target)) {
            navMenu.classList.remove('active');
            navToggle.classList.remove('active');
        }
    });
});

// Tab Switching Function
function showTab(tabName) {
    // Hide all tab contents
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.classList.remove('active');
    });

    // Remove active class from all tab buttons
    const tabButtons = document.querySelectorAll('.tab-btn');
    tabButtons.forEach(btn => {
        btn.classList.remove('active');
    });

    // Show selected tab content
    const selectedTab = document.getElementById(tabName);
    if (selectedTab) {
        selectedTab.classList.add('active');
    }

    // Add active class to clicked button
    event.target.classList.add('active');
}

// Search Places Function
function searchPlaces() {
    const searchInput = document.getElementById('searchInput').value;
    if (searchInput.trim()) {
        window.location.href = `/camping/search?q=${encodeURIComponent(searchInput)}`;
    }
}

// Allow search on Enter key
const searchInput = document.getElementById('searchInput');
if (searchInput) {
    searchInput.addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            searchPlaces();
        }
    });
}

// Smooth Scrolling for Anchor Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href !== '#') {
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        }
    });
});

// Image Preview for File Upload
function previewImages(input, previewContainer) {
    if (input.files) {
        const files = Array.from(input.files);
        const container = document.getElementById(previewContainer);
        container.innerHTML = '';

        if (files.length > 5) {
            alert('Maximum 5 images allowed');
            input.value = '';
            return;
        }

        files.forEach((file, index) => {
            if (file.size > 5 * 1024 * 1024) {
                alert(`Image ${file.name} exceeds 5MB limit`);
                return;
            }

            const reader = new FileReader();
            reader.onload = function(e) {
                const imgDiv = document.createElement('div');
                imgDiv.className = 'image-preview';
                imgDiv.innerHTML = `
                    <img src="${e.target.result}" alt="Preview ${index + 1}">
                    <button type="button" onclick="removeImage(${index})" class="remove-btn">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                container.appendChild(imgDiv);
            };
            reader.readAsDataURL(file);
        });
    }
}

// Remove Image from Preview
function removeImage(index) {
    const input = document.querySelector('input[type="file"]');
    const dt = new DataTransfer();
    const files = input.files;

    for (let i = 0; i < files.length; i++) {
        if (i !== index) {
            dt.items.add(files[i]);
        }
    }

    input.files = dt.files;
    previewImages(input, 'imagePreview');
}

// Star Rating System
function setRating(stars) {
    const ratingInput = document.getElementById('rating');
    if (ratingInput) {
        ratingInput.value = stars;
    }

    // Update star display
    const starElements = document.querySelectorAll('.star-rating i');
    starElements.forEach((star, index) => {
        if (index < stars) {
            star.classList.remove('far');
            star.classList.add('fas');
        } else {
            star.classList.remove('fas');
            star.classList.add('far');
        }
    });
}

// Initialize Star Rating Display
function initStarRating() {
    const starContainer = document.querySelector('.star-rating');
    if (starContainer) {
        for (let i = 1; i <= 5; i++) {
            const star = document.createElement('i');
            star.className = 'far fa-star';
            star.style.cursor = 'pointer';
            star.style.fontSize = '24px';
            star.style.color = '#f59e0b';
            star.style.marginRight = '5px';
            star.onclick = () => setRating(i);
            starContainer.appendChild(star);
        }
    }
}

// Form Validation
function validatePlaceForm() {
    const placeName = document.getElementById('placeName').value.trim();
    const location = document.getElementById('location').value.trim();
    const description = document.getElementById('description').value.trim();
    const fileInput = document.getElementById('images');

    if (!placeName) {
        alert('Please enter place name');
        return false;
    }

    if (!location) {
        alert('Please enter location');
        return false;
    }

    if (!description || description.length > 100 * 10) { // Approx 100 words
        alert('Description must be less than 100 words');
        return false;
    }

    if (fileInput && fileInput.files.length === 0) {
        alert('Please upload at least one image');
        return false;
    }

    if (fileInput && fileInput.files.length > 5) {
        alert('Maximum 5 images allowed');
        return false;
    }

    // Validate file sizes
    if (fileInput) {
        for (let i = 0; i < fileInput.files.length; i++) {
            if (fileInput.files[i].size > 5 * 1024 * 1024) {
                alert('Each image must be less than 5MB');
                return false;
            }
        }
    }

    return true;
}

function validateReviewForm() {
    const comment = document.getElementById('comment').value.trim();
    const rating = document.getElementById('rating').value;

    if (!comment) {
        alert('Please enter a comment');
        return false;
    }

    if (!rating || rating < 1 || rating > 5) {
        alert('Please select a rating');
        return false;
    }

    return true;
}

// Character Counter for Textareas
function updateCharCount(textarea, counterId, maxWords) {
    const counter = document.getElementById(counterId);
    if (counter && textarea) {
        const words = textarea.value.trim().split(/\s+/).filter(word => word.length > 0).length;
        counter.textContent = `${words} / ${maxWords} words`;

        if (words > maxWords) {
            counter.style.color = '#ef4444';
        } else {
            counter.style.color = '#6b7280';
        }
    }
}

// Confirm Dialog
function confirmAction(message) {
    return confirm(message);
}

// Delete Place (Admin)
function deletePlace(placeId) {
    if (confirmAction('Are you sure you want to delete this place?')) {
        window.location.href = `/camping/admin/place/delete/${placeId}`;
    }
}

// Ban/Unban User (Admin)
function banUser(userId) {
    const reason = prompt('Enter reason for ban:');
    if (reason) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = `/camping/admin/user/ban/${userId}`;

        const reasonInput = document.createElement('input');
        reasonInput.type = 'hidden';
        reasonInput.name = 'reason';
        reasonInput.value = reason;

        form.appendChild(reasonInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function unbanUser(userId) {
    if (confirmAction('Are you sure you want to unban this user?')) {
        window.location.href = `/camping/admin/user/unban/${userId}`;
    }
}

// Add to Favorites
function toggleFavorite(placeId) {
    fetch(`/camping/favorite/toggle/${placeId}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const btn = document.getElementById(`favorite-${placeId}`);
                if (btn) {
                    if (data.favorited) {
                        btn.innerHTML = '<i class="fas fa-heart"></i> Favorited';
                        btn.classList.add('favorited');
                    } else {
                        btn.innerHTML = '<i class="far fa-heart"></i> Add to Favorites';
                        btn.classList.remove('favorited');
                    }
                }
            }
        })
        .catch(error => console.error('Error:', error));
}

// Load More Places (Pagination)
let currentPage = 1;
function loadMorePlaces() {
    currentPage++;
    fetch(`/camping/api/places?page=${currentPage}`)
        .then(response => response.json())
        .then(data => {
            const container = document.querySelector('.places-grid');
            data.places.forEach(place => {
                const placeCard = createPlaceCard(place);
                container.appendChild(placeCard);
            });

            if (!data.hasMore) {
                document.getElementById('loadMoreBtn').style.display = 'none';
            }
        })
        .catch(error => console.error('Error:', error));
}

// Create Place Card Element
function createPlaceCard(place) {
    const card = document.createElement('div');
    card.className = 'place-card';
    card.innerHTML = `
        <div class="place-image">
            <img src="/camping/uploads/${place.primaryImage}" alt="${place.placeName}">
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
                <a href="/camping/place/${place.id}" class="btn btn-small">View Details</a>
            </div>
        </div>
    `;
    return card;
}

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Initialize star rating if exists
    initStarRating();

    // Add event listeners for textareas with character count
    const descriptionTextarea = document.getElementById('description');
    if (descriptionTextarea) {
        descriptionTextarea.addEventListener('input', function() {
            updateCharCount(this, 'descriptionCount', 100);
        });
    }

    const tipsTextarea = document.getElementById('tips');
    if (tipsTextarea) {
        tipsTextarea.addEventListener('input', function() {
            updateCharCount(this, 'tipsCount', 200);
        });
    }

    // Add event listener for image input
    const imageInput = document.getElementById('images');
    if (imageInput) {
        imageInput.addEventListener('change', function() {
            previewImages(this, 'imagePreview');
        });
    }
});

// Show loading spinner
function showLoading() {
    const loader = document.createElement('div');
    loader.id = 'loader';
    loader.className = 'loader-overlay';
    loader.innerHTML = '<div class="spinner"></div>';
    document.body.appendChild(loader);
}

function hideLoading() {
    const loader = document.getElementById('loader');
    if (loader) {
        loader.remove();
    }
}