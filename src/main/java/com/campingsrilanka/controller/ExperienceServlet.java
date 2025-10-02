// src/main/java/com/campingsrilanka/controller/ExperienceServlet.java
package com.campingsrilanka.controller;

import com.campingsrilanka.model.CampingSite;
import com.campingsrilanka.model.Experience;
import com.campingsrilanka.model.User;
import com.campingsrilanka.service.CampingSiteService;
import com.campingsrilanka.service.ExperienceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/experiences")
public class ExperienceServlet extends HttpServlet {
    private ExperienceService experienceService = new ExperienceService();
    private CampingSiteService siteService = new CampingSiteService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("profile".equals(action)) {
            int userId = ((User) session.getAttribute("user")).getId();
            List<Experience> experiences = experienceService.getExperiencesByUser(userId);
            request.setAttribute("experiences", experiences);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            List<CampingSite> sites = siteService.getAllSites();
            request.setAttribute("sites", sites);
            request.getRequestDispatcher("/add_experience.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int expId = Integer.parseInt(request.getParameter("id"));
            Experience exp = experienceService.getExperienceById(expId);
            if (exp != null && exp.getUserId() == ((User) session.getAttribute("user")).getId()) {
                request.setAttribute("experience", exp);
                List<CampingSite> sites = siteService.getAllSites();
                request.setAttribute("sites", sites);
                request.getRequestDispatcher("/edit_experience.jsp").forward(request, response);
            } else {
                response.sendRedirect("/experiences?action=profile");
            }
        } else if ("delete".equals(action)) {
            int expId = Integer.parseInt(request.getParameter("id"));
            Experience exp = experienceService.getExperienceById(expId);
            if (exp != null && exp.getUserId() == ((User) session.getAttribute("user")).getId()) {
                experienceService.deleteExperience(expId);
            }
            response.sendRedirect("/experiences?action=profile");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action) || "edit".equals(action)) {
            // Common logic for add/edit
            Experience exp = new Experience();
            exp.setTitle(request.getParameter("title"));
            exp.setDescription(request.getParameter("description"));
            exp.setSiteId(Integer.parseInt(request.getParameter("siteId")));
            exp.setRating(Integer.parseInt(request.getParameter("rating")));

            // Parse date
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date date = sdf.parse(request.getParameter("date"));
                exp.setDate(date);
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format");
                if ("add".equals(action)) {
                    request.getRequestDispatcher("/add_experience.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/edit_experience.jsp").forward(request, response);
                }
                return;
            }

            int userId = ((User) session.getAttribute("user")).getId();
            exp.setUserId(userId);

            // Validation
            if (exp.getTitle() == null || exp.getTitle().trim().isEmpty() || exp.getRating() < 1 || exp.getRating() > 5) {
                request.setAttribute("error", "Invalid input: Title required, Rating 1-5.");
                if ("add".equals(action)) {
                    request.getRequestDispatcher("/add_experience.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/edit_experience.jsp").forward(request, response);
                }
                return;
            }

            // Sanitize
            exp.setTitle(exp.getTitle().replaceAll("<script>", "").replaceAll("</script>", ""));
            exp.setDescription(exp.getDescription().replaceAll("<script>", "").replaceAll("</script>", ""));

            if ("add".equals(action)) {
                experienceService.addExperience(exp);
            } else {
                // For edit, set ID from parameter
                exp.setId(Integer.parseInt(request.getParameter("id")));
                experienceService.updateExperience(exp);
            }

            response.sendRedirect("/experiences?action=profile");
        }
    }
}