// src/main/java/com/campingsrilanka/controller/AdminServlet.java
package com.campingsrilanka.controller;

import com.campingsrilanka.model.CampingSite;
import com.campingsrilanka.model.Experience;
import com.campingsrilanka.model.User;
import com.campingsrilanka.service.CampingSiteService;
import com.campingsrilanka.service.ExperienceService;
import com.campingsrilanka.service.UserService;
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

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UserService userService = new UserService();
    private CampingSiteService siteService = new CampingSiteService();
    private ExperienceService expService = new ExperienceService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect("/index.jsp");
            return;
        }

        String section = request.getParameter("section");
        String action = request.getParameter("action");
        if ("users".equals(section)) {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                User user = userService.getUserById(id);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
                return;
            }
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } else if ("sites".equals(section)) {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                CampingSite site = siteService.getSiteById(id);
                request.setAttribute("site", site);
                request.getRequestDispatcher("/admin/edit_site.jsp").forward(request, response);
                return;
            } else if ("add".equals(action)) {
                request.getRequestDispatcher("/admin/add_site.jsp").forward(request, response);
                return;
            }
            List<CampingSite> sites = siteService.getAllSites();
            request.setAttribute("sites", sites);
            request.getRequestDispatcher("/admin/sites.jsp").forward(request, response);
        } else if ("experiences".equals(section)) {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Experience exp = expService.getExperienceById(id);
                request.setAttribute("experience", exp);
                List<CampingSite> sites = siteService.getAllSites();
                request.setAttribute("sites", sites);
                request.getRequestDispatcher("/admin/edit_experience.jsp").forward(request, response);
                return;
            }
            List<Experience> experiences = expService.getAllExperiences();
            request.setAttribute("experiences", experiences);
            request.getRequestDispatcher("/admin/experiences.jsp").forward(request, response);
        } else {
            // Default admin dashboard
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect("/index.jsp");
            return;
        }

        String section = request.getParameter("section");
        String action = request.getParameter("action");

        if ("users".equals(section)) {
            if ("update".equals(action)) {
                User user = new User();
                user.setId(Integer.parseInt(request.getParameter("id")));
                user.setUsername(request.getParameter("username"));
                user.setEmail(request.getParameter("email"));
                user.setRole(request.getParameter("role"));
                // Sanitize
                user.setUsername(user.getUsername().replaceAll("<script>", "").replaceAll("</script>", ""));
                user.setEmail(user.getEmail().replaceAll("<script>", "").replaceAll("</script>", ""));
                userService.updateUser(user);
                response.sendRedirect("/admin?section=users");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (id != currentUser.getId()) { // Prevent self-delete
                    userService.deleteUser(id);
                }
                response.sendRedirect("/admin?section=users");
            }
        } else if ("sites".equals(section)) {
            CampingSite site = new CampingSite();
            site.setName(request.getParameter("name"));
            site.setLocation(request.getParameter("location"));
            site.setDescription(request.getParameter("description"));
            site.setImageUrl(request.getParameter("imageUrl"));
            // Sanitize
            site.setName(site.getName().replaceAll("<script>", "").replaceAll("</script>", ""));
            site.setLocation(site.getLocation().replaceAll("<script>", "").replaceAll("</script>", ""));
            site.setDescription(site.getDescription().replaceAll("<script>", "").replaceAll("</script>", ""));
            site.setImageUrl(site.getImageUrl().replaceAll("<script>", "").replaceAll("</script>", ""));

            if ("add".equals(action)) {
                if (site.getName() != null && !site.getName().trim().isEmpty()) {
                    siteService.addSite(site);
                }
                response.sendRedirect("/admin?section=sites");
            } else if ("update".equals(action)) {
                site.setId(Integer.parseInt(request.getParameter("id")));
                siteService.updateSite(site);
                response.sendRedirect("/admin?section=sites");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                siteService.deleteSite(id);
                response.sendRedirect("/admin?section=sites");
            }
        } else if ("experiences".equals(section)) {
            if ("update".equals(action)) {
                Experience exp = new Experience();
                exp.setId(Integer.parseInt(request.getParameter("id")));
                exp.setTitle(request.getParameter("title"));
                exp.setDescription(request.getParameter("description"));
                exp.setSiteId(Integer.parseInt(request.getParameter("siteId")));
                exp.setRating(Integer.parseInt(request.getParameter("rating")));
                exp.setUserId(Integer.parseInt(request.getParameter("userId"))); // Assuming from form, but typically not changed

                // Parse date
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date date = sdf.parse(request.getParameter("date"));
                    exp.setDate(date);
                } catch (ParseException e) {
                    response.sendRedirect("/admin?section=experiences&error=Invalid date");
                    return;
                }

                // Sanitize
                exp.setTitle(exp.getTitle().replaceAll("<script>", "").replaceAll("</script>", ""));
                exp.setDescription(exp.getDescription().replaceAll("<script>", "").replaceAll("</script>", ""));

                expService.updateExperience(exp);
                response.sendRedirect("/admin?section=experiences");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                expService.deleteExperience(id);
                response.sendRedirect("/admin?section=experiences");
            }
        }
    }
}