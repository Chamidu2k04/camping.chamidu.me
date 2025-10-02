package com.campingsrilanka.util;

import com.campingsrilanka.dao.UserDAO;
import com.campingsrilanka.model.User;

public class CreateAdmin {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        // username, email, password, full name, isAdmin
        User admin = new User("admin", "admin@chamidu.me", "Admin@123", "chamidu Lakshan", true);

        if (dao.registerUser(admin)) {
            System.out.println("Admin created successfully!");
        } else {
            System.out.println("Failed to create admin.");
        }
    }
}
