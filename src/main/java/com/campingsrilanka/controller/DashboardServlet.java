package com.campingsrilanka.controller;

import com.campingsrilanka.dao.PlaceDAO;
import com.campingsrilanka.model.Place;
import com.campingsrilanka.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private PlaceDAO placeDAO;

    @Override
    public void init() {
        placeDAO = new PlaceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
            return;
        }

        try {
            // Get user's places
            List<Place> userPlaces = placeDAO.getPlacesByUserId(user.getId());

            // Get user's favorites (you'll need to implement this in PlaceDAO)
            List<Place> favorites = placeDAO.getFavoritePlaces(user.getId());

            // Calculate total posts
            int totalPosts = userPlaces.size();

            request.setAttribute("userPlaces", userPlaces);
            request.setAttribute("favorites", favorites);
            request.setAttribute("totalPosts", totalPosts);

            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard");
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        }
    }
}