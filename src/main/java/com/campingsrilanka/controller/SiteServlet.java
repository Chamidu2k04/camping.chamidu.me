// src/main/java/com/campingsrilanka/controller/SiteServlet.java
package com.campingsrilanka.controller;

import com.campingsrilanka.model.CampingSite;
import com.campingsrilanka.service.CampingSiteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/sites")
public class SiteServlet extends HttpServlet {
    private CampingSiteService siteService = new CampingSiteService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        List<CampingSite> sites;
        if (query != null && !query.trim().isEmpty()) {
            // Sanitize query for basic security
            query = query.replaceAll("<script>", "").replaceAll("</script>", "");
            sites = siteService.searchSites(query);
        } else {
            sites = siteService.getAllSites();
        }
        request.setAttribute("sites", sites);
        request.getRequestDispatcher("/sites.jsp").forward(request, response);
    }
}