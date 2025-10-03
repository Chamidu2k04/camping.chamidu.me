<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campingsrilanka.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New Place</title>
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
        .form-wrapper select,
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
        .form-wrapper select:focus,
        .form-wrapper textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-submit {
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
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
<div class="form-wrapper">
    <h1>Add New Camping Place</h1>

    <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/place" method="post" enctype="multipart/form-data">
        <label>Place Name *</label>
        <input type="text" name="placeName" required>

        <label>Location *</label>
        <input type="text" name="location" required>

        <label>Description *</label>
        <textarea name="description" rows="4" required></textarea>

        <label>Access Type *</label>
        <select name="accessType" required>
            <option value="">Select</option>
            <option value="free">Free Entry</option>
            <option value="ticket">Ticket Required</option>
            <option value="permission">Permission Required</option>
        </select>

        <label>Google Maps Link</label>
        <input type="url" name="googleMapLink">

        <label>Tips & Recommendations</label>
        <textarea name="tips" rows="3"></textarea>

        <label>Upload Images (1-5)</label>
        <input type="file" name="images" accept="image/*" multiple>

        <button type="submit" class="btn-submit">Submit for Review</button>
    </form>
</div>
</body>
</html>
