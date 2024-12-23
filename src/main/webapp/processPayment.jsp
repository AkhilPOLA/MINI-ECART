<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Processing</title>
</head>
<body>
    <%
    String url = "jdbc:mysql://localhost:3306/grocery";
    String user = "root";
    String pass = "Akhil2004@";

    Connection connection = null;
    HttpSession ssion = request.getSession();
    String buyerEmail = (String) ssion.getAttribute("buyerEmail");
    int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, pass);

        if (connection != null) {
            // Handle the payment processing here (e.g., using a payment gateway)
            boolean paymentSuccessful = true; // Set this based on the actual payment result

            if (paymentSuccessful) {
                // Move items from cart to transactions table
                String insertSql = "INSERT INTO transactions (buyeremail, item_name, item_price, quantity, total_price, shopkeeperemail) " +
                                  "SELECT ?, item_name, item_price, quantity, (item_price * quantity), shopkeeperemail FROM cart WHERE buyeremail = ?";
                PreparedStatement insertStatement = connection.prepareStatement(insertSql);
                insertStatement.setString(1, buyerEmail);
                insertStatement.setString(2, buyerEmail);
                int rowsInserted = insertStatement.executeUpdate();

                if (rowsInserted > 0) {
                    // Update stock quantities in the items table
                    String updateStockSql = "UPDATE items i, cart c SET i.quantity = i.quantity - c.quantity " +
                                            "WHERE i.item_name = c.item_name AND c.buyeremail = ?";
                    PreparedStatement updateStockStatement = connection.prepareStatement(updateStockSql);
                    updateStockStatement.setString(1, buyerEmail);
                    updateStockStatement.executeUpdate();

                    // Remove items from the cart
                    String deleteSql = "DELETE FROM cart WHERE buyeremail = ?";
                    PreparedStatement deleteStatement = connection.prepareStatement(deleteSql);
                    deleteStatement.setString(1, buyerEmail);
                    deleteStatement.executeUpdate();

                    response.sendRedirect("items.jsp?payment=success");
                } else {
                    response.sendRedirect("checkout.jsp?payment=error");
                }
            } else {
                response.sendRedirect("checkout.jsp?payment=error");
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

