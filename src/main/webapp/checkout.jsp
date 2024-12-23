<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <style>
        .header {
            height: 130px;
            background-color: #0C2340;
            border-radius: 10px;
            border-style: solid;
            font-family: 'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
            color: azure;
        }

        .logo {
            position: absolute;
            top: 13px;
            left: 670px;
            height: 120px;
            width: 170px;
        }

        h1 {
            margin: 20px;
            text-align: center;
        }

        .checkout-info {
            text-align: center;
        }

        .checkout-button {
            border-radius: 8px;
            background-color: white;
            border: 1px solid black;
            padding: 15px 10px;
            width: 100px;
            color: black;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="header">
        <img class="logo" src="logo.png" alt="BLAH-BLAH">
    </div>

    <h1>Checkout</h1>

    <%
    String url = "jdbc:mysql://localhost:3306/grocery";
    String user = "root";
    String pass = "Akhil2004@";

    Connection connection = null;
    HttpSession ssion = request.getSession();
    String buyerEmail = (String) ssion.getAttribute("buyerEmail");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, pass);

        if (connection != null) {
            String selectSql = "SELECT SUM(quantity * item_price) AS total_price, SUM(quantity) AS total_items FROM cart WHERE buyeremail = ?";
            PreparedStatement selectStatement = connection.prepareStatement(selectSql);
            selectStatement.setString(1, buyerEmail);
            ResultSet resultSet = selectStatement.executeQuery();

            if (resultSet.next()) {
                int totalItems = resultSet.getInt("total_items");
                int totalPrice = resultSet.getInt("total_price");
    %>
    <div class="checkout-info">
        <p>Total Number of Items: <%= totalItems %></p>
        <p>Total Price: $<%= totalPrice %></p>
        <form action="processPayment.jsp" method="post">
            <input type="hidden" name="totalPrice" value="<%= totalPrice %>">
            <input type="submit" class="checkout-button" value="Pay Now">
        </form>
    </div>
    <%
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    %>
     <div class="footer" style="margin-top:300px;background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy;  SKYPIEA-MART. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>
</body>
</html>
