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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.lang.System.out;
@WebServlet("/ProductListingServlet")
public class ProductListingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve data from the form
    	 String url = "jdbc:mysql://localhost:3306/grocery";
         String username = "root";
         String password = "Akhil2004@";

         String searchKeyword = request.getParameter("search");

      // SQL query to fetch items that match the search keyword
      String sql = "SELECT * FROM items WHERE item_name LIKE ?"; // Adjust table and column names as needed

      try {
    	  // Establish a database connection
      	Class.forName("com.mysql.cj.jdbc.Driver");
          Connection connection = DriverManager.getConnection(url, username, password);
            
          if (connection == null) {
              out.println("Failed to connect to the database");
              return; // Exit if there's no database connection
          }

          PreparedStatement statement = connection.prepareStatement(sql);
          statement.setString(1, "%" + searchKeyword + "%"); // Use "%" for partial matches

          ResultSet resultSet = statement.executeQuery();

          List<Map<String, Object>> items = new ArrayList<>();
          while (resultSet.next()) {
              Map<String, Object> item = new HashMap<>();
              item.put("itemId", resultSet.getInt("item_id"));
              item.put("itemName", resultSet.getString("item_name"));
              item.put("price", resultSet.getDouble("price"));
              item.put("description", resultSet.getString("description"));
              byte[] imageData = resultSet.getBytes("image");
              // Convert the byte[] to a base64-encoded image string and add it to the map
              item.put("imageData", Base64.getEncoder().encodeToString(imageData));
              // Add other item properties as needed

              items.add(item);
          }

          // Now, "items" contains a list of maps representing the items that match the search keyword (including base64-encoded image data)
      } catch (SQLException | ClassNotFoundException e) {
          e.printStackTrace();
          // Handle any database-related exceptions
      }

    }
}
