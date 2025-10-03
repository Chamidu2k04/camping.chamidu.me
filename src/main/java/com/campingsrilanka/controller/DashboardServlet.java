package com.campingsrilanka.controller;

import com.campingsrilanka.model.Place;
import com.campingsrilanka.model.User;
import com.campingsrilanka.util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
            return;
        }

        List<Place> userPlaces = new ArrayList<>();
        List<Place> favorites = new ArrayList<>();
        int totalPosts = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {

            // --- Fetch user posts ---
            String sql = "SELECT * FROM places WHERE user_id = ? ORDER BY created_at DESC";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, user.getId());
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Place p = new Place();
                        p.setId(rs.getInt("id"));
                        p.setPlaceName(rs.getString("place_name"));
                        p.setLocation(rs.getString("location"));
                        p.setDescription(rs.getString("description"));
                        p.setStatus(rs.getString("status"));
                        p.setPrimaryImage(getPrimaryImage(conn, rs.getInt("id")));
                        p.setViewCount(rs.getInt("view_count"));
                        p.setRatingAvg(rs.getDouble("rating_avg"));
                        p.setRatingCount(rs.getInt("rating_count"));
                        p.setAdminComment(rs.getString("admin_comment"));
                        p.setCreatedAt(String.valueOf(rs.getTimestamp("created_at")));
                        userPlaces.add(p);
                    }
                }
            }

            totalPosts = userPlaces.size();

            // --- Fetch favorites ---
            String sqlFav = "SELECT p.* FROM favorites f " +
                    "JOIN places p ON f.place_id = p.id WHERE f.user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlFav)) {
                stmt.setInt(1, user.getId());
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Place p = new Place();
                        p.setId(rs.getInt("id"));
                        p.setPlaceName(rs.getString("place_name"));
                        p.setLocation(rs.getString("location"));
                        p.setPrimaryImage(getPrimaryImage(conn, rs.getInt("id")));
                        favorites.add(p);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("userPlaces", userPlaces);
        request.setAttribute("favorites", favorites);
        request.setAttribute("totalPosts", totalPosts);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }

    private String getPrimaryImage(Connection conn, int placeId) throws SQLException {
        String sql = "SELECT image_path FROM place_images WHERE place_id = ? AND is_primary = 1 LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, placeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getString("image_path");
            }
        }
        return null;
    }
}
