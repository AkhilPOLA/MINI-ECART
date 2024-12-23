package grocerystore;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/shop")
public class ShopkeeperRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final String jdbcUrl = "jdbc:mysql://localhost:3306/Grocery";
    private final String jdbcUsername = "root"; // Replace with your MySQL username
    private final String jdbcPassword = "Akhil2004@"; // Replace with your MySQL password


     protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form data
        String fname = request.getParameter("Fname");
        String lname = request.getParameter("Lname");
        String country = request.getParameter("Country");
        String email = request.getParameter("Email");
        String phone = request.getParameter("Mobilenum");
        String address = request.getParameter("Address");
        String pincode = request.getParameter("Pincode");
        String password = request.getParameter("password");
        

      
        Connection conn = null;
      try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	
            conn = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
            if (conn != null) {
                System.out.println("Database connection established.");
            }
            
            String sql = "INSERT INTO shopkeeper (first_name, last_name, country, email, phone, ProductInterest, pincode, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = conn.prepareStatement(sql);	
            preparedStatement.setString(1, fname);
            preparedStatement.setString(2, lname);
            preparedStatement.setString(3, country);
            preparedStatement.setString(4, email);
            preparedStatement.setString(5, phone);
            preparedStatement.setString(6, address);
            preparedStatement.setString(7, pincode);
            preparedStatement.setString(8, password);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle the database error appropriately (e.g., log the error, display an error message, etc.).
        } catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }


        // Redirect to a success page or display a success message
        response.sendRedirect("shopkeeperlogin.html?registration=success");

    }
}

