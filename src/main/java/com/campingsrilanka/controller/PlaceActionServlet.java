package com.campingsrilanka.controller;

import com.campingsrilanka.dao.PlaceDAO;
import com.campingsrilanka.model.Place;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/place/action/*") // Different URL pattern from PlaceServlet
public class PlaceActionServlet extends HttpServlet {
    private PlaceDAO placeDAO = new PlaceDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equalsIgnoreCase(action)) {
            createPlace(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            updatePlace(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {
            deletePlace(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void createPlace(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Place place = new Place();
        place.setPlaceName(request.getParameter("placeName"));
        place.setDescription(request.getParameter("description"));
        place.setLocation(request.getParameter("location"));
        place.setAccessType(request.getParameter("accessType"));
        placeDAO.addPlace(place);
        response.sendRedirect(request.getContextPath() + "/admin/places"); // redirect after creation
    }

    private void updatePlace(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Place place = placeDAO.getPlaceById(id);
        if (place != null) {
            place.setPlaceName(request.getParameter("placeName"));
            place.setDescription(request.getParameter("description"));
            place.setLocation(request.getParameter("location"));
            place.setAccessType(request.getParameter("accessType"));
            placeDAO.updatePlace(place);
        }
        response.sendRedirect(request.getContextPath() + "/admin/places");
    }

    private void deletePlace(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        placeDAO.deletePlace(id);
        response.sendRedirect(request.getContextPath() + "/admin/places");
    }
}
