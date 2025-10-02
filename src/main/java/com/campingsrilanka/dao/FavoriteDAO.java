package com.campingsrilanka.dao;

import com.campingsrilanka.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FavoriteDAO {

    public boolean toggleFavorite(int userId, int placeId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Check if already favorited
            String checkSql = "SELECT * FROM favorites WHERE user_id=? AND place_id=?";
            try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, placeId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    // Remove favorite
                    String deleteSql = "DELETE FROM favorites WHERE user_id=? AND place_id=?";
                    try (PreparedStatement delStmt = conn.prepareStatement(deleteSql)) {
                        delStmt.setInt(1, userId);
                        delStmt.setInt(2, placeId);
                        return delStmt.executeUpdate() > 0;
                    }
                } else {
                    // Add favorite
                    String insertSql = "INSERT INTO favorites(user_id, place_id) VALUES(?, ?)";
                    try (PreparedStatement insStmt = conn.prepareStatement(insertSql)) {
                        insStmt.setInt(1, userId);
                        insStmt.setInt(2, placeId);
                        return insStmt.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
