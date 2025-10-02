package com.campingsrilanka.dao;

import com.campingsrilanka.model.Review;
import com.campingsrilanka.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // Get all reviews for a specific place
    public List<Review> getReviewsByPlaceId(int placeId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM reviews WHERE place_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, placeId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reviews.add(mapReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Add a new review
    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (place_id, user_id, rating, comment, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getPlaceId());
            stmt.setInt(2, review.getUserId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update average rating of a place
    public void updatePlaceRating(int placeId) {
        String sql = "UPDATE places SET rating_avg = (SELECT AVG(rating) FROM reviews WHERE place_id = ?) WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, placeId);
            stmt.setInt(2, placeId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Helper method to map ResultSet to Review object
    private Review mapReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getInt("id"));
        review.setPlaceId(rs.getInt("place_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getString("created_at"));
        return review;
    }
}
