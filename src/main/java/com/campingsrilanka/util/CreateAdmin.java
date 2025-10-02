package com.campingsrilanka.util;

import com.campingsrilanka.dao.UserDAO;
import com.campingsrilanka.model.User;

public class CreateAdmin {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();

        String username = "admin";
        String email = "admin@chamidu.me";
        String password = "Admin@123";
        String fullName = "chamidu Lakshan";

        // Check if admin already exists
        if (dao.usernameExists(username) || dao.emailExists(email)) {
            System.out.println("Admin user already exists. Skipping creation.");
            return;
        }

        // Create admin user
        User admin = new User(username, email, password, fullName, true);

        if (dao.registerUser(admin)) {
            System.out.println("Admin created successfully!");
        } else {
            System.out.println("Failed to create admin.");
        }
    }
}
