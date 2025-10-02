package com.campingsrilanka.controller;

import com.campingsrilanka.dao.PlaceDAO;
import com.campingsrilanka.dao.UserDAO;

import com.campingsrilanka.model.Place;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/")
public class HomeServlet extends HttpServlet {
    private PlaceDAO placeDAO = new PlaceDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Place> recentPlaces = placeDAO.getAllPlaces(); // you can filter latest 6
        request.setAttribute("recentPlaces", recentPlaces);
        request.setAttribute("trendingPlaces", recentPlaces); // add logic later
        request.setAttribute("uncommonPlaces", recentPlaces); // add logic later

        request.setAttribute("placeCount", recentPlaces.size());
        request.setAttribute("userCount", 50); // example
        request.setAttribute("reviewCount", 200); // example

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
