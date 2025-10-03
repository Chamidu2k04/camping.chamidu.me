package com.campingsrilanka.controller;

import com.campingsrilanka.model.Place;
import com.campingsrilanka.model.User;
import com.campingsrilanka.util.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/place/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,   // 1MB
        maxFileSize = 5 * 1024 * 1024,     // 5MB
        maxRequestSize = 10 * 1024 * 1024  // 10MB
)
public class EditPlaceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int placeId;
        try {
            placeId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Place place = null;

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT * FROM places WHERE id = ? AND user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, placeId);
                stmt.setInt(2, user.getId());
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        place = new Place();
                        place.setId(rs.getInt("id"));
                        place.setPlaceName(rs.getString("place_name"));
                        place.setLocation(rs.getString("location"));
                        place.setDescription(rs.getString("description"));
                        place.setPrimaryImage(getPrimaryImage(conn, placeId));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (place == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.setAttribute("place", place);
        request.getRequestDispatcher("/WEB-INF/views/editPlace.jsp").forward(request, response);
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Parse form fields
            int placeId = Integer.parseInt(request.getParameter("id"));
            String placeName = request.getParameter("placeName");
            String location = request.getParameter("location");
            String description = request.getParameter("description");

            // Handle optional primary image upload
            Part filePart = request.getPart("primaryImage");
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();

                // Ensure uploads folder exists
                String uploadDir = getServletContext().getRealPath("/uploads");
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();

                // Save file to server
                String uploadPath = uploadDir + File.separator + fileName;
                filePart.write(uploadPath);
            }

            // Update database
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "UPDATE places SET place_name = ?, location = ?, description = ? WHERE id = ? AND user_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, placeName);
                    stmt.setString(2, location);
                    stmt.setString(3, description);
                    stmt.setInt(4, placeId);
                    stmt.setInt(5, user.getId());
                    stmt.executeUpdate();
                }

                // Update primary image if uploaded
                if (fileName != null) {
                    String imgSql = "UPDATE place_images SET image_path = ? WHERE place_id = ? AND is_primary = 1";
                    try (PreparedStatement stmt = conn.prepareStatement(imgSql)) {
                        stmt.setString(1, fileName);
                        stmt.setInt(2, placeId);
                        int updated = stmt.executeUpdate();

                        // If no primary image exists yet, insert it
                        if (updated == 0) {
                            String insertSql = "INSERT INTO place_images(place_id, image_path, is_primary) VALUES (?, ?, 1)";
                            try (PreparedStatement stmt2 = conn.prepareStatement(insertSql)) {
                                stmt2.setInt(1, placeId);
                                stmt2.setString(2, fileName);
                                stmt2.executeUpdate();
                            }
                        }
                    }
                }
            }

            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Server error: " + e.getMessage());
        }
    }
}
