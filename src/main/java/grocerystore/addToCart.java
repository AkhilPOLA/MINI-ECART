package grocerystore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;

@WebServlet("/addToCart")
public class addToCart extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "Akhil2004@";

        HttpSession session = request.getSession();
        String buyerEmail = (String) session.getAttribute("buyerEmail"); // Retrieve buyer's email from session

        int item_id = Integer.parseInt(request.getParameter("item_id"));
        String item_name = request.getParameter("item_name");
        int item_price = (int) Double.parseDouble(request.getParameter("item_price"));
        String item_imageBase64 = request.getParameter("item_image"); // Retrieve the base64 image data
        String shopkeeper_email = request.getParameter("shopkeeper_email"); // Retrieve shopkeeper's email

        // Calculate total price (quantity * price) - set default quantity to 1
        int quantity = 1; // Default quantity
        double total_price = quantity * item_price;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            if (connection == null) {
                System.out.println("Failed to connect to the database");
            } else {
                // Insert the selected item into the cart table
            	String insertQuery = "INSERT INTO cart (item_id, item_name, quantity, image, item_price, shopkeeperemail, buyeremail) VALUES (?, ?, ?, ?, ?, ?, ?)";
            	PreparedStatement preparedStatement = connection.prepareStatement(insertQuery);
            	preparedStatement.setInt(1, item_id);
            	preparedStatement.setString(2, item_name);
            	preparedStatement.setInt(3, quantity);
            	// Convert base64 image data to bytes
            	byte[] imageBytes = Base64.getDecoder().decode(item_imageBase64);
            	// Create an input stream from the image bytes
            	InputStream imageStream = new ByteArrayInputStream(imageBytes);
            	preparedStatement.setBinaryStream(4, imageStream, imageBytes.length); // Set the image as a binary stream
            	preparedStatement.setInt(5, item_price); // Include item_price
            	preparedStatement.setString(6, shopkeeper_email); // Use the provided shopkeeper's email
            	preparedStatement.setString(7, buyerEmail); // Include buyerEmail


                int rows = preparedStatement.executeUpdate();
                if (rows > 0) {
                	 response.sendRedirect("items.jsp");
                    System.out.println("Item added to the cart successfully.");
                } else {
                    System.out.println("Failed to add the item to the cart.");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}

