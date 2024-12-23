package grocerystore;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import static java.lang.System.out;
@WebServlet("/ShopkeeperUpdateServlet")
public class ShopkeeperUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve data from the form
    	 String url = "jdbc:mysql://localhost:3306/grocery";
         String username = "root";
         String password = "Akhil2004@";

        String itemName = request.getParameter("itemname");
        int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));
        HttpSession session = request.getSession();
        String shopkeeperEmail = (String) session.getAttribute("shopkeeperEmail");

        // Implement your database update logic here
        try {
            // Establish a database connection
        	Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);
              
            if (connection == null) {
                out.println("Failed to connect to the database");
                return; // Exit if there's no database connection
            }

            String updateQuery = "UPDATE items SET quantity = ? WHERE item_name = ? AND shopkeeperemail = ?";
            PreparedStatement statement = connection.prepareStatement(updateQuery);
            statement.setInt(1, newQuantity);
            statement.setString(2, itemName);
            statement.setString(3, shopkeeperEmail);

            int rowsUpdated = statement.executeUpdate();

            // Close the connection
            connection.close();

             if(rowsUpdated>0) {
            response.sendRedirect("shopkeeperdashboard.jsp?Stockupdate=success");// If rowsUpdated is greater than 0, the update was successful.
             } else {
            	 response.sendRedirect("shopkeeperdashboard.jsp?error=Stock update failed");
             }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("shopkeeperdashboard.html?error=Stock update failed");// Update failed
        
      
    }
    }
}

