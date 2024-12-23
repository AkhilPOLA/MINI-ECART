<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Remove From Cart</title>
</head>
<body>
    <%
    String url = "jdbc:mysql://localhost:3306/grocery";
    String user = "root";
    String pass = "Akhil2004@";

    Connection connection = null;
    HttpSession ssion = request.getSession();
    String buyerEmail = (String) ssion.getAttribute("buyerEmail");

    int cart_id = Integer.parseInt(request.getParameter("cart_id"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, pass);

        if (connection != null) {
            String deleteSql = "DELETE FROM cart WHERE cart_id = ? AND buyeremail = ?";
            PreparedStatement deleteStatement = connection.prepareStatement(deleteSql);
            deleteStatement.setInt(1, cart_id);
            deleteStatement.setString(2, buyerEmail);

            int rowsDeleted = deleteStatement.executeUpdate();

            if (rowsDeleted > 0) {
                response.sendRedirect("viewcart.jsp?remove=success");
            } else {
                response.sendRedirect("viewcart.jsp?remove=error");
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
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
</body>
</html>
