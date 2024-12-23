<%@ page import="java.sql.*, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>Item Display</title>
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
        input[type="number"] {
            border: 3px solid #0C2340;
            border-radius: 6px;
            height: 25px;
            width: 450px;
            padding: 10px;
            font-size: 14px;
            margin: 10px;
        }

        /* Style for the "Create Item" and "Update Stock" buttons */
        input[type="submit"],
        .update-button,
        .sub {
            border: 3px solid black;
            border-radius: 8px;
            background-color: white;
            color: black;
            font-size: 14px;
            padding: 10px 20px;
            margin: 10px;
            display: block;
            margin: 0 auto; /* Center the button */
        }

        /* Style for container */
        .item-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        /* Style for individual item box */
        .item-box {
            width: calc(20% - 20px);
            margin: 10px;
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }

        .item-box img {
            max-width: 100%;
            height: auto;
        }

        /* Success message */
        .success-message {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            text-align: center;
            display: none;
        }

        /* Pagination */
        .pagination {
            text-align: center;
            position: relative;
            bottom: 0;
            left: 0;
            right: 0;
        }

        /* Define styles for the flex container */
        .flex-container {
            display: flex;
            justify-content: space-between;
        }

        /* Left and right sides of the flex container */
        .left-side {
            width: 49%;
            text-align: left;
        }

        .right-side {
            width: 49%;
            text-align: right;
        }

        /* Center headings */
        h2 {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="header">
    <img class="logo" src="logo.png" alt="BLAH-BLAH">
    <img class="arr" style="position:absolute; top:23px; left:200px;"src="white arrow.png" alt="Blast mohan">
    <a href="/grocerystore/LogoutServlet" style="color: azure; position: absolute;top: 120px; right: 127px;color: azure; ">Logout</a>
    <b style="position: absolute;top: 7px; right: 124px;">SELLER</b>
    <img class="us" style="color: azure; position: absolute;top: 23px; right: 107px;color: azure; "src="selog.png" alt="failed">
    <a href="viewpurchases.jsp" style="position: absolute;top: 50px; right:400px;color: azure;">VIEW-USER PURCHASES</a>
</div>


<div id="successMessage" class="success-message">
    <h1>Item added Successfully</h1>
</div>

<div id="updateMessage" class="success-message">
    <h1>Stock updated Successfully</h1>
</div>

<h2 style="position:absolute; top:150px; left:50px; margin-bottom:30px;">Update Stock</h2> <br> <br> <br>
<div class="flex-container">
    <div class="left-side">
        <form action="ShopkeeperUpdateServlet" method="post">
            <label style="margin-top:70px;"for="itemname">Select Item Name:</label>
            <select name="itemname" id="itemname">
                <
<%
    HttpSession ssion = request.getSession();
    String shopkeeperEmail = (String) ssion.getAttribute("shopkeeperEmail");

    String url = "jdbc:mysql://localhost:3306/grocery";
    String user = "root";
    String pass = "Akhil2004@";

    Connection connection = null;
    ArrayList<String> itemNames = new ArrayList<String>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, pass);

        if (connection != null) {
            String selectItemNamesSql = "SELECT item_name FROM items WHERE shopkeeperemail = ?";
            PreparedStatement selectItemNamesStatement = connection.prepareStatement(selectItemNamesSql);
            selectItemNamesStatement.setString(1, shopkeeperEmail);
            ResultSet itemNamesResultSet = selectItemNamesStatement.executeQuery();

            while (itemNamesResultSet.next()) {
                String itemName = itemNamesResultSet.getString("item_name");
                itemNames.add(itemName);
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

    for (String itemName : itemNames) {
%>
            <option value="<%= itemName %>"><%= itemName %></option>
<%
    }
%>
            </select> <br>

            <label for="newQuantity">New Quantity:</label>
            <input type="text" name="newQuantity" required><br>

            <input type="hidden" name="action" value="updateStock" onsubmit="return validateUpdateStockForm()" >
            <input type="submit" style="margin-top:10px; margin-right:290px"class="update-button" value="Update Stock">
        </form>
    </div>
    
    <div class="right-side">
        <h2 style="top:150px; right:400px;">Create New Item</h2>
        <form action="ShopkeeperAddServlet" method="post" enctype="multipart/form-data"  onsubmit="return validateCreateItemForm()" name="createItemForm">
            <label for="itemName">Item Name:</label>
            <input type="text" name="itemName" required><br>

            <label for="itemQuantity">Quantity:</label>
            <input type="text" name="itemQuantity" required><br>

            <label for="itemDescription">Description:</label>
            <input type="text" name="itemDescription" required><br>

            <label for="itemPrice">Price:</label>
            <input type="number" name="itemPrice" required><br>

            <label for="itemImage">Item Image:</label>
            <input type="file" name="itemImage" required><br>

            <input type="hidden" name="action" value="createItem">
            <input type="submit" style="margin-top:10px; margin-right:180px"class="sub" value="Create Item">
        </form>
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
<!-- Display items here using JSTL or other templating -->
<script>

function validateUpdateStockForm() {
    var newQuantity = document.forms["action"]["newQuantity"].value;
    
    if (newQuantity === "" || isNaN(newQuantity) || newQuantity <= 0) {
        alert("Please enter a valid quantity.");
        return false;
    }
    return true;
}

function validateCreateItemForm() {
    var itemName = document.forms["createItemForm"]["itemName"].value;
    var itemQuantity = document.forms["createItemForm"]["itemQuantity"].value;
    var itemDescription = document.forms["createItemForm"]["itemDescription"].value;
    var itemPrice = document.forms["createItemForm"]["itemPrice"].value;

    if (itemName === "") {
        alert("Please enter an item name.");
        return false;
    }

    if (itemQuantity === "" || isNaN(itemQuantity) || itemQuantity <= 0) {
        alert("Please enter a valid quantity.");
        return false;
    }

    if (itemDescription === "") {
        alert("Please enter item description.");
        return false;
    }

    if (itemPrice === "" || isNaN(itemPrice) || itemPrice <= 0) {
        alert("Please enter a valid item price.");
        return false;
    }
    return true;
}


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
        var registration = getParameterByName('AddItem');
        var stockUpdate = getParameterByName('Stockupdate');
        var successMessage = document.getElementById('successMessage');
        var updateMessage = document.getElementById('updateMessage');

        if (registration === 'success') {
            successMessage.style.display = 'block';
            setTimeout(function() {
                successMessage.style.display = 'none';
            }, 2000); // Display for 2 seconds
        }

        if (stockUpdate === 'success') {
            updateMessage.style.display = 'block';
            setTimeout(function() {
                updateMessage.style.display = 'none';
            }, 2000); // Display for 2 seconds
        }
    }

    // Call the showSuccessMessage function when the page loads
    window.onload = showSuccessMessage;
</script>

</body>
</html>


