package com.campingsrilanka.controller;

import com.campingsrilanka.dao.PlaceDAO;
import com.campingsrilanka.dao.ReviewDAO;
import com.campingsrilanka.model.Place;
import com.campingsrilanka.model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/place/*") // For viewing places
public class PlaceServlet extends HttpServlet {
    private PlaceDAO placeDAO = new PlaceDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo(); // /{id}
        if (pathInfo != null && pathInfo.length() > 1) {
            int placeId = Integer.parseInt(pathInfo.substring(1));
            Place place = placeDAO.getPlaceById(placeId);
            List<Review> reviews = reviewDAO.getReviewsByPlaceId(placeId);
            request.setAttribute("place", place);
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/placeDetail.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
