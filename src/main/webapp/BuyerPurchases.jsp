<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Purchases</title>
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
            left: 13px;
            height: 120px;
            width: 170px;
        }

        h1 {
            margin: 20px;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #0C2340;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #0C2340;
            color: azure;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:nth-child(odd) {
            background-color: #e5e5e5;
        }
    </style>
</head>
<body>
    <div class="header">
        <img class="logo" src="logo.png" alt="BLAH-BLAH">
    </div>
    
    <h1>User Purchases</h1>
    
    <%
    HttpSession ssion = request.getSession();
    String buyerEmail = (String) ssion.getAttribute("buyerEmail");

    if (buyerEmail == null || buyerEmail.isEmpty()) {
    %>
    <p>No user email found in the session.</p>
    <%
    } else {
        String url = "jdbc:mysql://localhost:3306/grocery";
        String user = "root";
        String pass = "Akhil2004@";

        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, pass);
            String sql = "SELECT * FROM transactions WHERE buyeremail = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, buyerEmail);

            ResultSet resultSet = preparedStatement.executeQuery();
    %>
    <table>
        <tr>
            <th>Transaction ID</th>
            <th>Item Name</th>
            <th>Quantity</th>
            <th>Transaction Date</th>
            <th>Total Amount</th>
        </tr>
        <%
            while (resultSet.next()) {
                int transactionId = resultSet.getInt("transaction_id");
                String itemName = resultSet.getString("item_name");
                int quantity = resultSet.getInt("quantity");
                Timestamp transactionDate = resultSet.getTimestamp("transaction_date");
                double totalAmount = resultSet.getDouble("total_price");
        %>
        <tr>
            <td><%= transactionId %></td>
            <td><%= itemName %></td>
            <td><%= quantity %></td>
            <td><%= transactionDate %></td>
            <td>$<%= totalAmount %></td>
        </tr>
        <%
            }
            resultSet.close();
            preparedStatement.close();
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
    }
    %>
    </table>
     <div class="footer" style="background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy;SKYPIEA-MART. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>
</body>
</html>

