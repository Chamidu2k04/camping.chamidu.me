// src/main/java/com/campingsrilanka/model/Experience.java
package com.campingsrilanka.model;

import java.util.Date;

public class Experience {
    private int id;
    private int userId;
    private int siteId;
    private String title;
    private String description;
    private Date date;
    private int rating;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getSiteId() { return siteId; }
    public void setSiteId(int siteId) { this.siteId = siteId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
}