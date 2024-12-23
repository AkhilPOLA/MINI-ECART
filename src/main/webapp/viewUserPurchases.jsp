<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Purchases</title>
    <style>
    *{
            font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
        }
        .header{
             height: 130px;
             width:auto;
           
             background-color:#0C2340;
             border-color:rgb(19,51,15);
            border-radius: 10px;
            border-style: solid;
            font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
            color: azure;
        }
        .logo{
      position: absolute; 
      top: 13px;
      left: 630px;
        height: 120px;
        width:170px;
       }
        body {
           
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h1 {
            text-align: center;
            padding: 20px;
            font-size: 28px;
        }

        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        /* Header styling */
        header {
            background-color: #007bff;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    
    <div class="header"></div>
    <img class="logo" src="logo.png" alt="BLAH-BLAH">

    <center>
        <h1>User Purchases</h1>
        <table>
            <tr>
                <th>Transaction ID</th>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Total Price</th>
                <th>Purchase Date</th>
            </tr>
            <%
                String buyerEmail = request.getParameter("buyerEmail");
                String url = "jdbc:mysql://localhost:3306/grocery";
                String username = "root";
                String password = "Akhil2004@";
                HttpSession ssion = request.getSession();
                String shopkeeperEmail = (String) ssion.getAttribute("shopkeeperEmail");
                String query = "SELECT transaction_id, item_name, quantity, total_price, transaction_date FROM transactions WHERE buyeremail = ? AND shopkeeperemail = ?";

                try (Connection connection = DriverManager.getConnection(url, username, password);
                     PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                    preparedStatement.setString(1, buyerEmail);
                    preparedStatement.setString(2, shopkeeperEmail);

                    try (ResultSet resultSet = preparedStatement.executeQuery()) {
                        while (resultSet.next()) {
                            int transactionId = resultSet.getInt("transaction_id");
                            String itemName = resultSet.getString("item_name");
                            int quantity = resultSet.getInt("quantity");
                            double totalPrice = resultSet.getDouble("total_price");
                            Timestamp purchaseTimestamp = resultSet.getTimestamp("transaction_date");
                            String purchaseDate = purchaseTimestamp.toString(); // Convert Timestamp to String
            %>
            <tr>
                <td><%= transactionId %></td>
                <td><%= itemName %></td>
                <td><%= quantity %></td>
                <td>$<%= totalPrice %></td>
                <td><%= purchaseDate %></td>
            </tr>
            <%
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    throw new RuntimeException("Failed to fetch purchase data from the database: " + e.getMessage());
                }
            %>
        </table>
    </center>
     <div class="footer" style="background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy; SKYPIEA-MART. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>
</body>
</html>

