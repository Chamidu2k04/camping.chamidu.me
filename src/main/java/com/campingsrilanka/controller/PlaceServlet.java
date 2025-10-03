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
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;

@WebServlet("/place")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class PlaceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/addPlace.jsp").forward(request, response);
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

        String placeName = request.getParameter("placeName");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String accessType = request.getParameter("accessType");
        String googleMapLink = request.getParameter("googleMapLink");
        String tips = request.getParameter("tips");

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Insert into places table
            String sql = "INSERT INTO places " +
                    "(user_id, place_name, location, description, access_type, google_map_link, tips, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')";
            int placeId;
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, user.getId());
                stmt.setString(2, placeName);
                stmt.setString(3, location);
                stmt.setString(4, description);
                stmt.setString(5, accessType);
                stmt.setString(6, googleMapLink);
                stmt.setString(7, tips);

                stmt.executeUpdate();
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) placeId = rs.getInt(1);
                    else throw new SQLException("Failed to get generated place ID");
                }
            }

            // Handle uploaded images
            String uploadDir = request.getServletContext().getRealPath("/uploads/places/" + placeId);
            Files.createDirectories(Paths.get(uploadDir));

            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                    part.write(uploadDir + File.separator + fileName);
                    String webPath = "uploads/places/" + placeId + "/" + fileName;

                    try (PreparedStatement stmt = conn.prepareStatement(
                            "INSERT INTO place_images (place_id, image_path, image_size, is_primary) VALUES (?, ?, ?, ?)")) {
                        stmt.setInt(1, placeId);
                        stmt.setString(2, webPath);
                        stmt.setLong(3, part.getSize()); // image_size
                        stmt.setInt(4, 0); // is_primary
                        stmt.executeUpdate();
                    }
                }
            }

            conn.commit();
            response.sendRedirect(request.getContextPath() + "/dashboard?success=Place submitted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/addPlace.jsp").forward(request, response);
        }
    }
}
