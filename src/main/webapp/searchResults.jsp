<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Blob" %>
<%@ page import="java.util.Base64" %>

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
        margin-bottom: 10px; /* Adjust this value to control the amount of space */
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
      table {
        width: 95%; /* Adjust the width as needed to make it wider */
        margin: 0 auto;
        border-collapse: collapse;
        margin-top: 20px;
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
        max-width: 100px;
        height: auto;
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
    String shopkeeperEmail = (String) session.getAttribute("shopkeeperEmail");
   
%>

<center>
    <h1>Search Results</h1>
    <table>
        <tr>
            <th>Image</th>
            <th>Item ID</th>
            <th>Item Name</th>
            <th>Price</th>
            <th>Show Full Details</th> <!-- New column for Show Full Details button -->
             <!-- New column for Add to Cart buttons -->
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/grocery";
            String username = "root";
            String password = "Akhil2004@";
            String searchQuery = request.getParameter("search");
            String query = "SELECT item_id, item_name, price, image FROM items WHERE item_name LIKE ?";

            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, "%" + searchQuery + "%");

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    while (resultSet.next()) {
                        int itemId = resultSet.getInt("item_id");
                        String itemName = resultSet.getString("item_name");
                        double itemPrice = resultSet.getDouble("price");
                        byte[] imageData = resultSet.getBytes("image");
        %>
        <tr>
            <td><img src="data:image/jpeg;base64,<%= new String(Base64.getEncoder().encode(imageData)) %>" width="100" height="100"></td>
            <td><%= itemId %></td>
            <td><%= itemName %></td>
            <td>$<%= itemPrice %></td>
             
            <td>
                <form action="showFullDetails.jsp" method="get">
                    <input type="hidden" name="item_name" value="<%= itemName %>">
                    <input type="submit" value="Show Full Details">
                </form>
            </td>

          
        </tr>
        <%
                }
            }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new RuntimeException("Failed to fetch product data from the database: " + e.getMessage());
            }
        %>
    </table>
</center>
 <div class="footer" style="background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy;SKYPIEA-MART. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>


