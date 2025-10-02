// src/main/java/com/campingsrilanka/controller/RegisterServlet.java
package com.campingsrilanka.controller;

import com.campingsrilanka.model.User;
import com.campingsrilanka.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        // Basic input validation (prevent empty fields, simple XSS check)
        if (username == null || password == null || email == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty() ||
                username.length() < 3 || password.length() < 6 || !email.contains("@")) {
            request.setAttribute("error", "Invalid input: Username min 3 chars, Password min 6 chars, Valid email required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Sanitize inputs (basic, for XSS prevention)
        username = username.replaceAll("<script>", "").replaceAll("</script>", "");
        email = email.replaceAll("<script>", "").replaceAll("</script>", "");

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setEmail(email);

        if (userService.register(newUser)) {
            response.sendRedirect("/login.jsp?success=Registration successful!");
        } else {
            request.setAttribute("error", "Username or email already exists.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}