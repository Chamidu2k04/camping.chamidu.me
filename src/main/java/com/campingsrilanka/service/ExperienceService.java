// src/main/java/com/campingsrilanka/service/ExperienceService.java
package com.campingsrilanka.service;

import com.campingsrilanka.dao.ExperienceDAO;
import com.campingsrilanka.model.Experience;

import java.sql.SQLException;
import java.util.List;

public class ExperienceService {
    private ExperienceDAO experienceDAO = new ExperienceDAO();

    public void addExperience(Experience exp) {
        try {
            experienceDAO.addExperience(exp);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Experience getExperienceById(int id) {
        try {
            return experienceDAO.getExperienceById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Experience> getExperiencesByUser(int userId) {
        try {
            return experienceDAO.getExperiencesByUser(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Experience> getAllExperiences() {
        try {
            return experienceDAO.getAllExperiences();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public void updateExperience(Experience exp) {
        try {
            experienceDAO.updateExperience(exp);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteExperience(int id) {
        try {
            experienceDAO.deleteExperience(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}