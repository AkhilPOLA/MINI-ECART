<%@ page import="java.sql.*, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Purchases</title>
    <style>
        body {
            font-family: 'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
            text-align: center;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #0C2340;
            border: 3px solid rgb(19, 51, 15);
            border-radius: 10px;
            height: 130px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            color: azure;
        }

        .logo {
            width: 170px;
            height: 120px;
            margin: 0 10px;
        }

        .arr {
            height: 90px;
        }

        .us {
            width: 100px;
            height: 90px;
        }

        label {
            font-size: 16px;
        }

        /* Style for text inputs */
        input[type="text"],
        input[type="number"],
        input[type="date"] {
            border: 3px solid #0C2340;
            border-radius: 6px;
            height: 25px;
            width: 450px;
            padding: 10px;
            font-size: 14px;
            margin: 10px;
        }

        /* Style for the "Create Item" and "Update Stock" buttons */
        input[type="submit"] {
            border: 3px solid black;
            border-radius: 8px;
            background-color: white;
            color: black;
            font-size: 14px;
            padding: 10px 20px;
            margin: 10px;
        }
    </style>
</head>
<body>
<div class="header">
    <img class="logo" src="logo.png" alt="BLAH-BLAH">
    <img class="arr" src="white arrow.png" alt="Blast mohan">
    <a href="/grocerystore/LogoutServlet" style="color: azure;">Logout</a>
    <b>SELLER</b>
    <img class="us" src="selog.png" alt="failed">
    <a href="viewpurchases.jsp" style="color: azure;">VIEW-USER PURCHASES</a>
</div>

<h1>View Purchases of a User</h1>
<form action="viewUserPurchases.jsp" method="get">
    <label for="buyerEmail">Select Buyer Email:</label>
    <select name="buyerEmail" id="buyerEmail">
        <%
            HttpSession ssion = request.getSession();
            String shopkeeperEmail = (String) ssion.getAttribute("shopkeeperEmail");

            String url = "jdbc:mysql://localhost:3306/grocery";
            String user = "root";
            String pass = "Akhil2004@"; // Replace with your database password

            Connection connection = null;
            ArrayList<String> buyerEmails = new ArrayList<String>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, pass);

                if (connection != null) {
                    String selectBuyerEmailsSql = "SELECT DISTINCT buyeremail FROM transactions WHERE shopkeeperemail = ?";
                    PreparedStatement selectBuyerEmailsStatement = connection.prepareStatement(selectBuyerEmailsSql);
                    selectBuyerEmailsStatement.setString(1, shopkeeperEmail);
                    ResultSet buyerEmailsResultSet = selectBuyerEmailsStatement.executeQuery();

                    while (buyerEmailsResultSet.next()) {
                        String buyerEmail = buyerEmailsResultSet.getString("buyeremail");
                        buyerEmails.add(buyerEmail);
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

            for (String buyerEmail : buyerEmails) {
        %>
        <option value="<%= buyerEmail %>"><%= buyerEmail %></option>
        <%
            }
        %>
    </select>
    <input type="submit" value="View Purchases">
</form>
<form action="generateMonthly.jsp" method="post">
    <label for="startDate">Start Date:</label>
    <input type="date" id="startDate" name="startDate">
    
    <label for="endDate">End Date:</label>
    <input type="date" id="endDate" name="endDate">
    
    <input type="submit" value="Generate Monthly Report">
</form>
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
