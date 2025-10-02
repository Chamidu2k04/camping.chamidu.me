-- Create database
CREATE DATABASE IF NOT EXISTS camping;

USE camping;

-- Users table with ban functionality
CREATE TABLE users (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(100) NOT NULL,
                       is_admin BOOLEAN DEFAULT FALSE,
                       is_banned BOOLEAN DEFAULT FALSE,
                       banned_at TIMESTAMP NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       INDEX idx_email (email),
                       INDEX idx_username (username)
);

-- Banned emails table to prevent re-registration
CREATE TABLE banned_emails (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               email VARCHAR(100) UNIQUE NOT NULL,
                               banned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               reason VARCHAR(500)
);

-- Places/Posts table
CREATE TABLE places (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT NOT NULL,
                        place_name VARCHAR(200) NOT NULL,
                        location VARCHAR(300) NOT NULL,
                        description TEXT NOT NULL,
                        access_type ENUM('free', 'ticket', 'permission') NOT NULL,
                        google_map_link VARCHAR(500),
                        tips TEXT,
                        status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
                        admin_comment VARCHAR(500),
                        admin_id INT,
                        view_count INT DEFAULT 0,
                        rating_avg DECIMAL(3,2) DEFAULT 0,
                        rating_count INT DEFAULT 0,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        approved_at TIMESTAMP NULL,
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                        FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE SET NULL,
                        INDEX idx_status (status),
                        INDEX idx_user_id (user_id),
                        INDEX idx_rating (rating_avg)
);

-- Place images table (max 5 per place)
CREATE TABLE place_images (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              place_id INT NOT NULL,
                              image_path VARCHAR(500) NOT NULL,
                              image_size INT NOT NULL,
                              is_primary BOOLEAN DEFAULT FALSE,
                              uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
                              INDEX idx_place_id (place_id)
);

-- Reviews/Comments table
CREATE TABLE reviews (
                         id INT AUTO_INCREMENT PRIMARY KEY,
                         place_id INT NOT NULL,
                         user_id INT NOT NULL,
                         comment TEXT NOT NULL,
                         rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
                         status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
                         admin_comment VARCHAR(500),
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
                         FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                         UNIQUE KEY unique_user_place (user_id, place_id),
                         INDEX idx_place_id (place_id),
                         INDEX idx_user_id (user_id),
                         INDEX idx_status (status)
);

-- Review images table (max 5 per review)
CREATE TABLE review_images (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               review_id INT NOT NULL,
                               image_path VARCHAR(500) NOT NULL,
                               image_size INT NOT NULL,
                               uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
                               INDEX idx_review_id (review_id)
);

-- Favorites table
CREATE TABLE favorites (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           user_id INT NOT NULL,
                           place_id INT NOT NULL,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                           FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
                           UNIQUE KEY unique_favorite (user_id, place_id),
                           INDEX idx_user_id (user_id),
                           INDEX idx_place_id (place_id)
);

-- Create views for analytics
CREATE VIEW trending_places AS
SELECT p.*,
       COUNT(DISTINCT f.id) as favorite_count,
       COUNT(DISTINCT r.id) as review_count
FROM places p
         LEFT JOIN favorites f ON p.id = f.place_id
         LEFT JOIN reviews r ON p.id = r.place_id AND r.status = 'approved'
WHERE p.status = 'approved'
GROUP BY p.id
ORDER BY (p.view_count * 0.4 + COUNT(DISTINCT f.id) * 0.3 + COUNT(DISTINCT r.id) * 0.3) DESC
    LIMIT 10;

CREATE VIEW recent_places AS
SELECT p.*, u.username, u.full_name
FROM places p
         JOIN users u ON p.user_id = u.id
WHERE p.status = 'approved'
ORDER BY p.approved_at DESC
    LIMIT 10;

CREATE VIEW uncommon_places AS
SELECT p.*, u.username, u.full_name
FROM places p
         JOIN users u ON p.user_id = u.id
WHERE p.status = 'approved' AND p.view_count < 50
ORDER BY p.rating_avg DESC, p.created_at DESC
    LIMIT 10;