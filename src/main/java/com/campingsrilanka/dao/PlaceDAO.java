package com.campingsrilanka.dao;

import com.campingsrilanka.model.Place;
import com.campingsrilanka.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlaceDAO {

    public Place getPlaceById(int id) {
        Place place = null;
        String query = "SELECT * FROM places WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                place = mapResultSetToPlace(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return place;
    }

    public List<Place> getAllPlaces() {
        List<Place> places = new ArrayList<>();
        String query = "SELECT * FROM places";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                places.add(mapResultSetToPlace(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    // --- New CRUD methods ---
    public void addPlace(Place place) {
        String query = "INSERT INTO places (placeName, description, location, accessType, username, createdAt) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, place.getPlaceName());
            stmt.setString(2, place.getDescription());
            stmt.setString(3, place.getLocation());
            stmt.setString(4, place.getAccessType());
            stmt.setString(5, place.getUsername());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updatePlace(Place place) {
        String query = "UPDATE places SET placeName = ?, description = ?, location = ?, accessType = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, place.getPlaceName());
            stmt.setString(2, place.getDescription());
            stmt.setString(3, place.getLocation());
            stmt.setString(4, place.getAccessType());
            stmt.setInt(5, place.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deletePlace(int id) {
        String query = "DELETE FROM places WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Helper method to map ResultSet to Place object
    private Place mapResultSetToPlace(ResultSet rs) throws SQLException {
        Place place = new Place();
        place.setId(rs.getInt("id"));
        place.setPlaceName(rs.getString("placeName"));
        place.setDescription(rs.getString("description"));
        place.setLocation(rs.getString("location"));
        place.setAccessType(rs.getString("accessType"));
        place.setUsername(rs.getString("username"));
        place.setCreatedAt(rs.getString("createdAt"));
        // Add more fields if needed
        return place;
    }
}
