// src/main/java/com/campingsrilanka/service/CampingSiteService.java
package com.campingsrilanka.service;

import com.campingsrilanka.dao.CampingSiteDAO;
import com.campingsrilanka.model.CampingSite;

import java.sql.SQLException;
import java.util.List;

public class CampingSiteService {
    private CampingSiteDAO campingSiteDAO = new CampingSiteDAO();

    public List<CampingSite> getAllSites() {
        try {
            return campingSiteDAO.getAllSites();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public CampingSite getSiteById(int id) {
        try {
            return campingSiteDAO.getSiteById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<CampingSite> searchSites(String query) {
        try {
            return campingSiteDAO.searchSites(query);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public void addSite(CampingSite site) {
        try {
            campingSiteDAO.addSite(site);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateSite(CampingSite site) {
        try {
            campingSiteDAO.updateSite(site);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteSite(int id) {
        try {
            campingSiteDAO.deleteSite(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}