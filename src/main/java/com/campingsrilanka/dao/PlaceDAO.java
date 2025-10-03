package com.campingsrilanka.dao;

import com.campingsrilanka.model.Place;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlaceDAO {
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/campingsrilanka",
                    "username",
                    "password"
            );
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        }
    }

    public boolean addPlace(Place place) {
        String sql = "INSERT INTO places (user_id, place_name, description, location, access_type, " +
                "google_map_link, tips, primary_image, status, username) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, place.getUserId());
            stmt.setString(2, place.getPlaceName());
            stmt.setString(3, place.getDescription());
            stmt.setString(4, place.getLocation());
            stmt.setString(5, place.getAccessType());
            stmt.setString(6, place.getGoogleMapLink());
            stmt.setString(7, place.getTips());
            stmt.setString(8, place.getPrimaryImage());
            stmt.setString(9, place.getStatus());
            stmt.setString(10, place.getUsername());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated place ID
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int placeId = generatedKeys.getInt(1);
                        // Save images if any
                        if (place.getImages() != null && !place.getImages().isEmpty()) {
                            savePlaceImages(placeId, place.getImages(), conn);
                        }
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void savePlaceImages(int placeId, List<String> images, Connection conn) throws SQLException {
        String sql = "INSERT INTO place_images (place_id, image_name) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (String imageName : images) {
                stmt.setInt(1, placeId);
                stmt.setString(2, imageName);
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public List<Place> getPlacesByUserId(int userId) {
        List<Place> places = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "COALESCE((SELECT AVG(rating) FROM ratings WHERE place_id = p.id), 0) as rating_avg, " +
                "COALESCE((SELECT COUNT(*) FROM ratings WHERE place_id = p.id), 0) as rating_count, " +
                "COALESCE((SELECT COUNT(*) FROM place_views WHERE place_id = p.id), 0) as view_count " +
                "FROM places p WHERE p.user_id = ? ORDER BY p.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    places.add(mapResultSetToPlace(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    public Place getPlaceById(int placeId) {
        String sql = "SELECT p.*, " +
                "COALESCE((SELECT AVG(rating) FROM ratings WHERE place_id = p.id), 0) as rating_avg, " +
                "COALESCE((SELECT COUNT(*) FROM ratings WHERE place_id = p.id), 0) as rating_count, " +
                "COALESCE((SELECT COUNT(*) FROM place_views WHERE place_id = p.id), 0) as view_count " +
                "FROM places p WHERE p.id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, placeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Place place = mapResultSetToPlace(rs);
                    // Load images for this place
                    place.setImages(getPlaceImages(placeId, conn));
                    return place;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<String> getPlaceImages(int placeId, Connection conn) throws SQLException {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_name FROM place_images WHERE place_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, placeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_name"));
                }
            }
        }
        return images;
    }

    public List<Place> getFavoritePlaces(int userId) {
        List<Place> favorites = new ArrayList<>();
        String sql = "SELECT p.*, " +
                "COALESCE((SELECT AVG(rating) FROM ratings WHERE place_id = p.id), 0) as rating_avg, " +
                "COALESCE((SELECT COUNT(*) FROM ratings WHERE place_id = p.id), 0) as rating_count " +
                "FROM places p " +
                "INNER JOIN favorites f ON p.id = f.place_id " +
                "WHERE f.user_id = ? AND p.status = 'approved' " +
                "ORDER BY f.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    favorites.add(mapResultSetToPlace(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return favorites;
    }

    private Place mapResultSetToPlace(ResultSet rs) throws SQLException {
        Place place = new Place();
        place.setId(rs.getInt("id"));
        place.setUserId(rs.getInt("user_id"));
        place.setPlaceName(rs.getString("place_name"));
        place.setDescription(rs.getString("description"));
        place.setLocation(rs.getString("location"));
        place.setAccessType(rs.getString("access_type"));
        place.setGoogleMapLink(rs.getString("google_map_link"));
        place.setTips(rs.getString("tips"));
        place.setPrimaryImage(rs.getString("primary_image"));
        place.setStatus(rs.getString("status"));
        place.setUsername(rs.getString("username"));
        place.setCreatedAt(rs.getString("created_at"));
        place.setRatingAvg(rs.getDouble("rating_avg"));
        place.setRatingCount(rs.getInt("rating_count"));
        place.setViewCount(rs.getInt("view_count"));
        place.setAdminComment(rs.getString("admin_comment"));
        return place;
    }
}