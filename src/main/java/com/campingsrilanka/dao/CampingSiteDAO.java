// src/main/java/com/campingsrilanka/dao/CampingSiteDAO.java
package com.campingsrilanka.dao;

import com.campingsrilanka.model.CampingSite;
import com.campingsrilanka.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CampingSiteDAO {
    public List<CampingSite> getAllSites() throws SQLException {
        List<CampingSite> sites = new ArrayList<>();
        String sql = "SELECT * FROM camping_sites";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                CampingSite site = new CampingSite();
                site.setId(rs.getInt("id"));
                site.setName(rs.getString("name"));
                site.setLocation(rs.getString("location"));
                site.setDescription(rs.getString("description"));
                site.setImageUrl(rs.getString("image_url"));
                sites.add(site);
            }
        }
        return sites;
    }

    public CampingSite getSiteById(int id) throws SQLException {
        String sql = "SELECT * FROM camping_sites WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                CampingSite site = new CampingSite();
                site.setId(rs.getInt("id"));
                site.setName(rs.getString("name"));
                site.setLocation(rs.getString("location"));
                site.setDescription(rs.getString("description"));
                site.setImageUrl(rs.getString("image_url"));
                return site;
            }
        }
        return null;
    }

    public List<CampingSite> searchSites(String query) throws SQLException {
        List<CampingSite> sites = new ArrayList<>();
        String sql = "SELECT * FROM camping_sites WHERE name LIKE ? OR location LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + query + "%");
            pstmt.setString(2, "%" + query + "%");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                CampingSite site = new CampingSite();
                site.setId(rs.getInt("id"));
                site.setName(rs.getString("name"));
                site.setLocation(rs.getString("location"));
                site.setDescription(rs.getString("description"));
                site.setImageUrl(rs.getString("image_url"));
                sites.add(site);
            }
        }
        return sites;
    }

    public void addSite(CampingSite site) throws SQLException {
        String sql = "INSERT INTO camping_sites (name, location, description, image_url) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, site.getName());
            pstmt.setString(2, site.getLocation());
            pstmt.setString(3, site.getDescription());
            pstmt.setString(4, site.getImageUrl());
            pstmt.executeUpdate();
        }
    }

    public void updateSite(CampingSite site) throws SQLException {
        String sql = "UPDATE camping_sites SET name = ?, location = ?, description = ?, image_url = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, site.getName());
            pstmt.setString(2, site.getLocation());
            pstmt.setString(3, site.getDescription());
            pstmt.setString(4, site.getImageUrl());
            pstmt.setInt(5, site.getId());
            pstmt.executeUpdate();
        }
    }

    public void deleteSite(int id) throws SQLException {
        String sql = "DELETE FROM camping_sites WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }
}