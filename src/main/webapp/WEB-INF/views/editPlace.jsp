<%@ page import="com.campingsrilanka.model.Place, com.campingsrilanka.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if(user == null){ response.sendRedirect(request.getContextPath()+"/login"); return; }

  Place place = (Place) request.getAttribute("place");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Place</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f9fafb;
      color: #333;
      margin: 0;
      padding: 0;
    }
    .form-wrapper {
      background: white;
      border-radius: 15px;
      padding: 40px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      max-width: 500px;
      margin: 100px auto;
    }
    .form-wrapper h1 {
      color: #1f2937;
      text-align: center;
      margin-bottom: 25px;
    }
    .form-wrapper label {
      display: block;
      margin-bottom: 8px;
      color: #1f2937;
      font-weight: 500;
    }
    .form-wrapper input,
    .form-wrapper textarea {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e5e7eb;
      border-radius: 8px;
      font-size: 14px;
      margin-bottom: 20px;
      transition: all 0.3s ease;
    }
    .form-wrapper input:focus,
    .form-wrapper textarea:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    .btn-update {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      padding: 12px 25px;
      border-radius: 8px;
      font-weight: 600;
      cursor: pointer;
      width: 100%;
      transition: all 0.3s ease;
    }
    .btn-update:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
    }
    .back-link {
      display: inline-block;
      margin-top: 15px;
      text-decoration: none;
      color: #667eea;
      font-weight: 600;
    }
    .back-link:hover {
      text-decoration: underline;
    }
    img {
      margin-bottom: 15px;
      border-radius: 8px;
    }
  </style>
</head>
<body>
<div class="form-wrapper">
  <h1>Edit Place</h1>
  <form action="${pageContext.request.contextPath}/place/edit" method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<%= place.getId() %>">

    <label>Place Name:</label>
    <input type="text" name="placeName" value="<%= place.getPlaceName() %>" required>

    <label>Location:</label>
    <input type="text" name="location" value="<%= place.getLocation() %>" required>

    <label>Description:</label>
    <textarea name="description" required><%= place.getDescription() %></textarea>

    <label>Primary Image:</label>
    <input type="file" name="primaryImage">
    <img src="${pageContext.request.contextPath}/uploads/<%= place.getPrimaryImage() %>" width="150">

    <button type="submit" class="btn-update">Update Place</button>
  </form>
  <a href="${pageContext.request.contextPath}/dashboard" class="back-link">Back to Dashboard</a>
</div>
</body>
</html>
