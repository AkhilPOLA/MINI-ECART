<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*, java.util.Base64, jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    int defaultItemsPerPage = 10; // Set the default number of items to display per page to 10
    int itemsPerPage = defaultItemsPerPage; // Initialize to the default
%>
<!DOCTYPE html>
<html>
<head>
    <title>Item Display</title>
    <style>
   
     
     .header{
             height: 130px;
             width:autopx;
            
             background-color:#0C2340;
             border-color:rgb(19,51,15);
            border-radius: 10px;
            border-style: solid;
            font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
            color: azure;
        }
       .logo{
      position: absolute; 
      top: 13px;
      left: 13px;
        height: 120px;
        width:170px;
       }
       .arrow{
        position: relative; 
      top: 15px;
      left: 500px;
       
       }
       .arr{
        position: absolute; 
      top: 28px;
      left: 200px;
      height: 90px;
        
       }
       .us{
        position: absolute; 
      top: 28px;
      right: 85px;
        height: 90px;
        width: 100px;
       }
      
      
     
    .x{
    visibility:hidden;
    }
    
        .item-container {
            display: flex;
            flex-wrap: wrap;
            
        margin-top: 10px;
        margin-bottom: 10px; 
        

       
      
       
        
        border-style: solid;
        border-width: 8px;
        border-radius: 6px;
        border-color: #0C2340;
        height: auto;
        width: auto;
    }
        /* Adjust this value to control the amount of space */
    }
        
        .item-box {
        
            width: calc(20% - 20px); /* Adjust the width as needed for 5 items per row */
            margin: 10px;
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        .item-box img {
            max-width: 100%;
            height: auto;
        }
       .funk{
       position:absolute;
           top:27px;
        border-radius: 6px;
        border-style: solid;
        
        border-width: 3px;
        border-color:#0C2340;
         height: 25px;
         width: 450px;
         padding: 15px 10px;
         font-size: 14px;
         
    }
     .sub{
     position:relative;
         top:30px;
         right:80px;
        border-radius: 8px;
        background-color:white;
             border-color:black;
      padding: 15px 10px;
        width: 70px;
        color: black;
        font-size: 14px;
    }
    .pagination {
    text-align: center;
    position: relative;
    bottom: 0;
    left: 0;
    right: 0;
}

        /* Style the item image */
        .item-image {
            flex: 1; 
            position:relative; top:170px;left:100px;   
        }

        /* Style the item info */
        .item-info {
            flex: 1; /* Take up half of the container */
        }
    
     
        
    </style>
</head>
<body>
 <div class="header">
        <img class="logo" src="logo.png" alt="BLAH-BLAH">
        <img class="arr" src="white arrow.png" alt="Blast mohan">
        <form class="arrow" action="searchResults.jsp" method="post">
        <input type="text" class="funk" name="search" placeholder="Search by item name">
        <input type="submit" class="sub" value="Search">
    </form>
          <img style="position: absolute; 
      top: 15px;
      right: 175px;
        height: 130px;
        width: 150px;"src="cart.png" alt="failed">
       
        <a href="/grocerystore/outServlet" style="position: absolute;top: 120px; right: 107px;color: azure; ;">Logout</a>
    
          <b style="position: absolute;top: 10px; right: 110px; ">BUYER</b> 
         <img class="us"src="Userlog.png" alt="failed">
         
         <a href="viewcart.jsp" style="position: absolute;top: 120px; right: 237px;color: azure; ;">CART</a>
         <a href="BuyerPurchases.jsp" style="position: absolute;top: 120px;
      left: 250px;color: azure; ">MY ORDERS</a>
        
        
    </div>  


<%
    String itemName = request.getParameter("item_name");
    String url = "jdbc:mysql://localhost:3306/grocery";
    String user = "root";
    String pass = "Akhil2004@";

    Connection connection = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, pass);
        String sql = "SELECT * FROM items WHERE item_name = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, itemName);
        ResultSet resultSet = statement.executeQuery();
        if (resultSet.next()) {
            String itemDescription = resultSet.getString("description");
            double itemPrice = resultSet.getDouble("price");
            String shopkeeperEmail = resultSet.getString("shopkeeperemail");
            byte[] imageData = resultSet.getBytes("image");
            String base64Image = Base64.getEncoder().encodeToString(imageData);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Full Item Details</title>
</head>
<body>
    
     <div style="
      display: flex;
            justify-content: space-between;
            align-items: flex-start;
        border-style: solid;
        border-width: 8px;
        border-radius: 6px;
        border-color: white;
        height: auto;
        width: auto;"class="item-details-container">
     <h1 style="   position:absolute; top:170px;left:160px;         font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;">Full Item Details</h1>
        <div class="item-image">
            <img src="data:image/jpeg;base64,<%= base64Image %>" width="500" height="500">
        </div>
        <div style="  font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif; position:absolute; top:400px;left:860px;"class="item-info">
            <h2><%= itemName %></h2>
            <p><%= itemDescription %></p>
            <p>Price: $<%= itemPrice %></p>
            <p>Seller: <%= shopkeeperEmail %></p>
            <form method="post" action="addToCart">
                <!-- Include all the hidden input fields here -->
                <input type="hidden" name="item_id" value="<%= resultSet.getInt("item_id") %>">
                <input type="hidden" name="item_name" value="<%= itemName %>">
                <input type="hidden" name="item_price" value="<%= itemPrice %>">
                <input type="hidden" name="item_image" value="<%= base64Image %>">
                <input type="hidden" name="shopkeeper_email" value="<%= shopkeeperEmail %>">
                <input type="submit" style="border-radius: 8px;
        background-color:white;
             border-color:black;
      padding: 15px 10px;
        width: 210px;
        color: black;
        font-size: 14px;" value="Add to Cart">
            </form>
        </div>
    </div>
     <div class="footer" style="margin-top:300px;background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy; SKYPIEA-MART. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>
</body>
</html>
<%
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

