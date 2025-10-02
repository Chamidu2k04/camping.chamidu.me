// src/main/java/com/campingsrilanka/dao/ExperienceDAO.java
package com.campingsrilanka.dao;

import com.campingsrilanka.model.Experience;
import com.campingsrilanka.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExperienceDAO {
    public void addExperience(Experience exp) throws SQLException {
        String sql = "INSERT INTO experiences (user_id, site_id, title, description, date, rating) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, exp.getUserId());
            pstmt.setInt(2, exp.getSiteId());
            pstmt.setString(3, exp.getTitle());
            pstmt.setString(4, exp.getDescription());
            pstmt.setDate(5, new java.sql.Date(exp.getDate().getTime()));
            pstmt.setInt(6, exp.getRating());
            pstmt.executeUpdate();
        }
    }

    public Experience getExperienceById(int id) throws SQLException {
        String sql = "SELECT * FROM experiences WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Experience exp = new Experience();
                exp.setId(rs.getInt("id"));
                exp.setUserId(rs.getInt("user_id"));
                exp.setSiteId(rs.getInt("site_id"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setDate(rs.getDate("date"));
                exp.setRating(rs.getInt("rating"));
                return exp;
            }
        }
        return null;
    }

    public List<Experience> getExperiencesByUser(int userId) throws SQLException {
        List<Experience> exps = new ArrayList<>();
        String sql = "SELECT * FROM experiences WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setId(rs.getInt("id"));
                exp.setUserId(rs.getInt("user_id"));
                exp.setSiteId(rs.getInt("site_id"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setDate(rs.getDate("date"));
                exp.setRating(rs.getInt("rating"));
                exps.add(exp);
            }
        }
        return exps;
    }

    public List<Experience> getAllExperiences() throws SQLException {
        List<Experience> exps = new ArrayList<>();
        String sql = "SELECT * FROM experiences";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Experience exp = new Experience();
                exp.setId(rs.getInt("id"));
                exp.setUserId(rs.getInt("user_id"));
                exp.setSiteId(rs.getInt("site_id"));
                exp.setTitle(rs.getString("title"));
                exp.setDescription(rs.getString("description"));
                exp.setDate(rs.getDate("date"));
                exp.setRating(rs.getInt("rating"));
                exps.add(exp);
            }
        }
        return exps;
    }

    public void updateExperience(Experience exp) throws SQLException {
        String sql = "UPDATE experiences SET title = ?, description = ?, date = ?, rating = ?, site_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, exp.getTitle());
            pstmt.setString(2, exp.getDescription());
            pstmt.setDate(3, new java.sql.Date(exp.getDate().getTime()));
            pstmt.setInt(4, exp.getRating());
            pstmt.setInt(5, exp.getSiteId());
            pstmt.setInt(6, exp.getId());
            pstmt.executeUpdate();
        }
    }

    public void deleteExperience(int id) throws SQLException {
        String sql = "DELETE FROM experiences WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}