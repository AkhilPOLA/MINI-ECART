package grocerystore;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateCart")
public class updateCart extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:mysql://localhost:3306/grocery";
        String username = "root";
        String password = "Akhil2004@";

        HttpSession session = request.getSession();
        String buyerEmail = (String) session.getAttribute("buyerEmail");

        int item_id = Integer.parseInt(request.getParameter("item_id"));
        int updatedQuantity = Integer.parseInt(request.getParameter("quantity"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            if (connection != null) {
                if (updatedQuantity > 0) {
                    String updateSql = "UPDATE cart SET quantity = ? WHERE item_id = ? AND buyeremail = ?";
                    PreparedStatement updateStatement = connection.prepareStatement(updateSql);
                    updateStatement.setInt(1, updatedQuantity);
                    updateStatement.setInt(2, item_id);
                    updateStatement.setString(3, buyerEmail);

                    int rowsUpdated = updateStatement.executeUpdate();

                    if (rowsUpdated > 0) {
                        response.sendRedirect("viewcart.jsp?update=success");
                    } else {
                        response.sendRedirect("viewcart.jsp?update=error");
                    }
                } else {
                    response.sendRedirect("viewcart.jsp?update=invalid");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}
