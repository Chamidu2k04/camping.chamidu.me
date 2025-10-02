// src/main/java/com/campingsrilanka/model/User.java
package com.campingsrilanka.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String role; // "user" or "admin"

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}