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
   <div id="successMessage" style="display: none; background-color: #4CAF50; color: white; padding: 10px; text-align: center;">
        <h1>Payment Successful</h1>
        
    </div> 
    

      <form method="get" action="<%= request.getRequestURI() %>">
            <label style="font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;"for="itemsPerPage">Items Per Page:</label>
            <input type="text" style="border-radius: 6px;
        border-style: solid;
        
        border-width: 3px;
        border-color:#0C2340;
         height: 19px;
         width: 150px;
         padding: 12px 9px;
         font-size: 11px;" id="itemsPerPage" name="itemsPerPage" value="<%= itemsPerPage %>">
            <input style="border-radius: 8px;
            margin-bottom:20px;
            margin-top:20px;
            
            
        background-color:white;
             border-color:black;
      padding: 15px 10px;
        width: 70px;
        color: black;
        font-size: 14px; display:inline-block" type="submit" value="Update">  <br>
        
        </form> 

    <div class="item-container">
       
        <%
        
            String url = "jdbc:mysql://localhost:3306/grocery";
            String user = "root";
            String pass = "Akhil2004@";
            int currentPage = 1; // Current page number, you can change it as needed

            // Check if a page number is provided in the request
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }

            // Check if itemsPerPage is specified in the request
            String itemsPerPageParam = request.getParameter("itemsPerPage");
            if (itemsPerPageParam != null) {
                itemsPerPage = Integer.parseInt(itemsPerPageParam);
            }

            // Store itemsPerPage in a session attribute for persistence
            HttpSession userSession = request.getSession();
            userSession.setAttribute("itemsPerPage", itemsPerPage);

            // Retrieve itemsPerPage from the session or use the default
            Integer sessionItemsPerPage = (Integer) userSession.getAttribute("itemsPerPage");
            if (sessionItemsPerPage != null) {
                itemsPerPage = sessionItemsPerPage;
            } else {
                itemsPerPage = defaultItemsPerPage;
            }

            Connection connection = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, pass);
                int offset = (currentPage - 1) * itemsPerPage;
                String sql = "SELECT item_id, item_name, price, image, shopkeeperEmail FROM items LIMIT " + itemsPerPage + " OFFSET " + offset;
                Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(sql);
                while (resultSet.next()) {
                    String itemName = resultSet.getString("item_name");
                    int price = resultSet.getInt("price");
                    byte[] imageData = resultSet.getBytes("image");
                    String base64Image = Base64.getEncoder().encodeToString(imageData);
                    String shopkeeperEmail = resultSet.getString("shopkeeperEmail");
        %>
         
         <div style=" 
         margin-left:40px;
         margin-right:22px;
         margin-top:25px;
        border-style: solid;
        border-width: 5px;
        border-radius: 6px;
        border-color: #0C2340; font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;"class="item-box">
            <img src="data:image/jpeg;base64,<%= base64Image %>" width="100" height="100">
            <h3><%= itemName %></h3>
            <p>Price: $<%= price %></p>
            <p class="x" > Shopkeeper Email: <%= shopkeeperEmail %></p>
            <form action="showFullDetails.jsp" method="post">
                <input type="hidden" name="item_name" value="<%= itemName %>">
                <input type="submit" style="border-radius: 8px;
        background-color:white;
             border-color:black;
      padding: 15px 10px;
        width: 240px;
        color: black;
        font-size: 14px; margin-bottom:10px" value="Show Full Details">
            </form>
            <form action="addToCart" method="post">
                <input type="hidden" name="item_id" value="<%= resultSet.getInt("item_id") %>">
                <input type="hidden" name="item_name" value="<%= itemName %>">
                <input type="hidden" name="item_price" value="<%= price %>">
                <input type="hidden" name="item_image" value="<%= base64Image %>">
                <input type="hidden"  name="shopkeeper_email" value="<%= shopkeeperEmail %>">
                <input type="submit" style="border-radius: 8px;
        background-color:white;
             border-color:black;
      padding: 15px 10px;
        width: 210px;
        color: black;
        font-size: 14px;"value="Add to Cart">
            </form>
        </div>
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
        </div>
   
 
        <div class="pagination">
            <ul>
                <li><a href="<%= request.getRequestURI() %>?page=<%= currentPage - 1 %>&itemsPerPage=<%= itemsPerPage %>">Previous</a></li>
                <li><a href="<%= request.getRequestURI() %>?page=<%= currentPage + 1 %>&itemsPerPage=<%= itemsPerPage %>">Next</a></li>
            </ul>
        </div>
    </div>
    
    
    <div class="footer" style="background-color: #333; color: #fff; text-align: center; padding: 10px;">
        <p><a href="aboutUs.jsp" style="color: #fff; text-decoration: none;">About Us</a></p>
        <p>Follow Us:</p>
        <a href="https://www.facebook.com/your-facebook-page" style="color: #fff; text-decoration: none; margin: 0 10px;">Facebook</a>
        <!-- Add links to other social media platforms as needed -->
        <p>&copy; SKYPIEA-MART. All Rights Reserved.</p>
        <img src="copyright.png" alt="Copyright" style="height: 20px;">
    </div>
     <script> 
		function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }
        function showSuccessMessage() {
            var registration = getParameterByName('payment');
            if (registration === 'success') {
                var successMessage = document.getElementById('successMessage');
                successMessage.style.display = 'block';

                setTimeout(function() {
                    successMessage.style.display = 'none';
                }, 2000); // Display for 3 seconds
            }
        }

        // Call the showSuccessMessage function when the page loads
        window.onload = showSuccessMessage;</script>
</body>
</html>


