<%@ page import="java.sql.*, java.util.Base64, jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    int defaultItemsPerPage = 10; // Set the default number of items to display per page to 10
    int itemsPerPage = defaultItemsPerPage; // Initialize to the default
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Cart</title>
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

        .item-image {
            width: 100px;
            height: 100px;
        }

        .button {
            border-radius: 8px;
            background-color: white;
            border: 1px solid black;
            padding: 15px 10px;
            width: 100px;
            color: black;
            font-size: 14px;
        }

        .button.update {
            width: 80px;
        }

        .button.remove {
            width: 70px;
        }

        .bottom-center {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <img class="logo" src="logo.png" alt="BLAH-BLAH">
    </div>
    
    <h1>View Cart</h1>

    <%
    String url = "jdbc:mysql://localhost:3306/grocery";
    String user = "root";
    String pass = "Akhil2004@";

    Connection connection = null;
    HttpSession ssion = request.getSession();
    String buyerEmail = (String) ssion.getAttribute("buyerEmail");
    // Initialize a flag to check if the cart is empty
    boolean isCartEmpty = true;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, pass);

        if (connection != null) {
            String selectSql = "SELECT * FROM cart WHERE buyeremail = ?";
            PreparedStatement selectStatement = connection.prepareStatement(selectSql);
            selectStatement.setString(1, buyerEmail);
            ResultSet resultSet = selectStatement.executeQuery();

            out.println("<table>");
            out.println("<tr><th>Item Name</th><th>Price</th><th>Quantity</th><th>Total Price</th><th>Update Quantity</th><th>Remove</th><th>Image</th></tr>");
            while (resultSet.next()) {
            	 isCartEmpty = false; 
                String itemName = resultSet.getString("item_name");
                int price = resultSet.getInt("item_price");
                int quantity = resultSet.getInt("quantity");
                int totalPrice = quantity * price;
                int item_id = resultSet.getInt("item_id");
                int cart_id = resultSet.getInt("cart_id");
                Blob imageBlob = resultSet.getBlob("image");
                byte[] imageBytes = imageBlob.getBytes(1, (int) imageBlob.length());
                String base64Image = Base64.getEncoder().encodeToString(imageBytes);

                // Get the available stock quantity from the items table
                String stockQuantitySql = "SELECT quantity FROM items WHERE item_id = ?";
                PreparedStatement stockQuantityStatement = connection.prepareStatement(stockQuantitySql);
                stockQuantityStatement.setInt(1, item_id);
                ResultSet stockQuantityResult = stockQuantityStatement.executeQuery();

                if (stockQuantityResult.next()) {
                    int stockQuantity = stockQuantityResult.getInt("quantity");

                    out.println("<tr>");
                    out.println("<td>" + itemName + "</td>");
                    out.println("<td>$" + price + "</td>");
                    out.println("<td>" + quantity + "</td>");
                    out.println("<td>$" + totalPrice + "</td>");
                    out.println("<td>");
                    out.println("<form action='updateCart' method='post'>");
                    out.println("<input type='hidden' name='item_id' value='" + item_id + "'>");
                    out.println("<input type='number' name='quantity' value='" + quantity + "' min='1' max='" + stockQuantity + "'>");
                    out.println("<input type='submit' class='button update' value='Update'>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("<td>");
                    out.println("<form action='removeFromCart.jsp' method='post'>");
                    out.println("<input type='hidden' name='cart_id' value='" + cart_id + "'>");
                    out.println("<input type='submit' class='button remove' value='Remove'>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("<td><img class='item-image' src='data:image/jpeg;base64, " + base64Image + "'></td>");
                    out.println("</tr>");
                } else {
                    out.println("Item not found in the items table.");
                }
            }
            out.println("</table>");
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
<div class="bottom-center">
        <%
        if (!isCartEmpty) {
        %>
        <a href="checkout.jsp" class="button">Proceed to Checkout</a>
        <%
        }
        %>
    </div>
     <div class="footer" style="margin-top:30px;background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> Your Company Name. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>
</body>
</html>

