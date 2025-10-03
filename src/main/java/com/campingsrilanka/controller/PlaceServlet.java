package com.campingsrilanka.controller;

import com.campingsrilanka.dao.PlaceDAO;
import com.campingsrilanka.model.Place;
import com.campingsrilanka.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/place")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class PlaceServlet extends HttpServlet {
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

        String action = request.getParameter("action");
        if ("view".equals(action)) {
            viewPlace(request, response);
        } else {
            listUserPlaces(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String placeName = request.getParameter("placeName");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String accessType = request.getParameter("accessType");
            String googleMapLink = request.getParameter("googleMapLink");
            String tips = request.getParameter("tips");

            // Handle multiple file uploads
            List<Part> fileParts = new ArrayList<>();
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    fileParts.add(part);
                }
            }

            String uploadDir = request.getServletContext().getRealPath("/uploads");
            Files.createDirectories(Paths.get(uploadDir));

            List<String> imageNames = new ArrayList<>();
            for (Part filePart : fileParts) {
                if (filePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    filePart.write(new File(uploadDir, fileName).getAbsolutePath());
                    imageNames.add(fileName);
                }
            }

            String primaryImage = imageNames.isEmpty() ? null : imageNames.get(0);

            Place place = new Place();
            place.setPlaceName(placeName);
            place.setLocation(location);
            place.setDescription(description);
            place.setAccessType(accessType);
            place.setGoogleMapLink(googleMapLink);
            place.setTips(tips);
            place.setPrimaryImage(primaryImage);
            place.setImages(imageNames);
            place.setUserId(user.getId());
            place.setStatus("pending");
            place.setUsername(user.getUsername());

            if (placeDAO.addPlace(place)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Failed to add place");
                request.getRequestDispatcher("/WEB-INF/views/addPlace.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/addPlace.jsp").forward(request, response);
        }
    }

    private void viewPlace(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int placeId = Integer.parseInt(request.getParameter("id"));
            Place place = placeDAO.getPlaceById(placeId);

            if (place != null) {
                request.setAttribute("place", place);
                request.getRequestDispatcher("/WEB-INF/views/viewPlace.jsp").forward(request, response);
            } else {
                response.sendError(404, "Place not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid place ID");
        }
    }

    private void listUserPlaces(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        List<Place> userPlaces = placeDAO.getPlacesByUserId(user.getId());
        request.setAttribute("userPlaces", userPlaces);
        request.getRequestDispatcher("/WEB-INF/views/userPlaces.jsp").forward(request, response);
    }
}