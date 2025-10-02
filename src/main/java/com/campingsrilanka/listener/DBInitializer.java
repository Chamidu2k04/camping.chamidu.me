// src/main/java/com/campingsrilanka/listener/DBInitializer.java
package com.campingsrilanka.listener;

import com.campingsrilanka.util.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Create users table
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "role VARCHAR(20) NOT NULL DEFAULT 'user'" +
                    ")");

            // Create camping_sites table
            stmt.execute("CREATE TABLE IF NOT EXISTS camping_sites (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "location VARCHAR(100) NOT NULL, " +
                    "description TEXT, " +
                    "image_url VARCHAR(255)" +
                    ")");

            // Create experiences table
            stmt.execute("CREATE TABLE IF NOT EXISTS experiences (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "site_id INT NOT NULL, " +
                    "title VARCHAR(100) NOT NULL, " +
                    "description TEXT, " +
                    "date DATE, " +
                    "rating INT, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (site_id) REFERENCES camping_sites(id) ON DELETE CASCADE" +
                    ")");

            // Insert sample camping sites if they don’t exist
            stmt.execute("INSERT IGNORE INTO camping_sites (name, location, description, image_url) VALUES " +
                    "('Ella Jungle Resort', 'Ella', 'A beautiful jungle camping site.', 'https://via.placeholder.com/150'), " +
                    "('Sinharaja Forest', 'Sinharaja', 'Rainforest camping experience.', 'https://via.placeholder.com/150')");

            // Insert admin user if not exists
            String adminPasswordHash = BCrypt.hashpw("adminpass", BCrypt.gensalt());
            stmt.execute("INSERT IGNORE INTO users (username, password, email, role) VALUES " +
                    "('admin', '" + adminPasswordHash + "', 'admin@example.com', 'admin')");

            System.out.println("Database initialized successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
