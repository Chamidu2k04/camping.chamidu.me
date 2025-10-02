// src/main/java/com/campingsrilanka/util/DBConnection.java
package com.campingsrilanka.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static Connection connection;

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            String url = System.getenv("DB_URL"); // e.g., jdbc:mysql://localhost:3306/camping_db
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");
            connection = DriverManager.getConnection(url, user, pass);
        }
        return connection;
    }
}