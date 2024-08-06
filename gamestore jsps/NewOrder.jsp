<%@ page import="java.sql.*, java.time.LocalDateTime, java.sql.Timestamp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Create Order Page</title>
</head>
<body>
    <%
        String inputUsername = request.getParameter("inputUsername");
        String inputUserIdStr = request.getParameter("inputuserid");
        int inputUserId = Integer.parseInt(inputUserIdStr);

        // Retrieve form parameters
        String inputProductIdStr = request.getParameter("productid");
        String inputAddress = request.getParameter("address");
        String inputDistrict = request.getParameter("district");
        String inputCity = request.getParameter("city");
        String inputPostalCodeStr = request.getParameter("postal_code");
        String inputCountry = request.getParameter("country");

        boolean orderCreated = false;
        String db = "gamestore";
        String user = "root";
        String password = "IAmLate2022!";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false", user, password);

            if (inputProductIdStr != null && !inputProductIdStr.isEmpty()) {
                int inputProductId = Integer.parseInt(inputProductIdStr);
                int inputPostalCode = Integer.parseInt(inputPostalCodeStr);

                // Get customer id
                String query = "SELECT customer_id FROM customer WHERE user_id = ?";
                ps = con.prepareStatement(query);
                ps.setInt(1, inputUserId);
                rs = ps.executeQuery();
                rs.next();
                int customerID = rs.getInt(1);

                // Check if product exists
                query = "SELECT product_id FROM products WHERE product_id = ?";
                ps = con.prepareStatement(query);
                ps.setInt(1, inputProductId);
                rs = ps.executeQuery();

                

                if (rs.next()) {
                    rs.close();
                    ps.close();

                    // Check inventory
                    query = "SELECT inventory_num FROM inventory WHERE product_id = ? AND inventory_num Not In "+
                    "(SELECT inventory_num from orders)";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, inputProductId);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        int inventoryNum = rs.getInt(1);
                        rs.close();
                        ps.close();

                        // Get new order_id
                        query = "SELECT IFNULL(MAX(order_id), 0) + 1 FROM `order`";
                        ps = con.prepareStatement(query);
                        rs = ps.executeQuery();
                        int newOrderId = rs.next() ? rs.getInt(1) : 1;

                        rs.close();
                        ps.close();

                        // Get new address_id
                        query = "SELECT IFNULL(MAX(address_id), 0) + 1 FROM `address`";
                        ps = con.prepareStatement(query);
                        rs = ps.executeQuery();
                        int newAddressId = rs.next() ? rs.getInt(1) : 1;

                        // Insert new address
                        query = "INSERT INTO `address` (address_id, address, district, city, postal_code, country) VALUES (?, ?, ?, ?, ?, ?)";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, newAddressId);
                        ps.setString(2, inputAddress);
                        ps.setString(3, inputDistrict);
                        ps.setString(4, inputCity);
                        ps.setInt(5, inputPostalCode);
                        ps.setString(6, inputCountry);
                        ps.executeUpdate();
                        ps.close();

                        // Insert new order
                        query = "INSERT INTO `order` (order_id, date_ordered, date_fulfilled) VALUES (?, ?, NULL)";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, newOrderId);
                        ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                        ps.executeUpdate();
                        ps.close();

                        // Insert into orders
                        query = "INSERT INTO `orders` (customer_id, order_id, inventory_num) VALUES (?, ?, ?)";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, customerID);
                        ps.setInt(2, newOrderId);
                        ps.setInt(3, inventoryNum);
                        ps.executeUpdate();
                        ps.close();

                        // Insert into deliver_to
                        query = "INSERT INTO `deliver_to` (order_id, address_id) VALUES (?, ?)";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, newOrderId);
                        ps.setInt(2, newAddressId);
                        ps.executeUpdate();

                        orderCreated = true;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            out.println("Exception caught: " + e.getMessage());
        } finally {
            // Cleanup resources
            try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
            try { if (ps != null) ps.close(); } catch (SQLException e) { /* ignored */ }
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
        }
    %>

    <h1>Customer Create Order Page</h1>

    <!-- Order Form -->
    <form>
        <label for="productid">Product ID:</label>
        <input type="text" id="productid" name="productid" required>
        <br>
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" required>
        <br>
        <label for="district">District:</label>
        <input type="text" id="district" name="district" required>
        <br>
        <label for="city">City:</label>
        <input type="text" id="city" name="city" required>
        <br>
        <label for="postal_code">Postal Code:</label>
        <input type="text" id="postal_code" name="postal_code" required>
        <br>
        <label for="country">Country:</label>
        <input type="text" id="country" name="country" required>
        <br>
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="Order">
    </form>

    <h1>Back to Home Page</h1>
    <!-- Click to go to home page -->
    <form action="GamestoreCHomePage.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputUserIdStr" value="<%= inputUserIdStr %>" />
        <input type="submit" value="Go to Homepage">
    </form>

    <% if (orderCreated) { %>
        <p>Order created successfully!</p>
        <h1>View My Orders</h1>
        <!-- Click to view orders -->
        <form action="CustomerOrders.jsp" method="post">
            <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
            <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
            <input type="submit" value="View">
        </form>

        <h1>Create New Order</h1>
        <!-- Click to create new order -->
        <form action="NewOrder.jsp" method="post">
            <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
            <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
            <input type="submit" value="New Order">
        </form>
    
    <% } %>
    

    <!-- Display Products -->
    <h1>Products for Sale</h1>
    <table border="1">
        <tr>
            <th>Product ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Platform</th>
            <th>Made By</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false", user, password);
                Statement stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT pr.product_id, pr.name, pr.price, pr.description, pl.name AS platform, m.name AS manufacturer FROM gamestore.products pr " +
                                        "JOIN gamestore.manufacturers m ON pr.manf_id = m.manufactuer_id " +
                                        "JOIN gamestore.platform pl ON pr.platform_id = pl.platform_id");

                while (rs.next()) {
                    out.println("<tr>" +
                        "<td>" + rs.getInt("product_id") + "</td>" +
                        "<td>" + rs.getString("name") + "</td>" +
                        "<td>" + rs.getBigDecimal("price") + "</td>" +
                        "<td>" + rs.getString("description") + "</td>" +
                        "<td>" + rs.getString("platform") + "</td>" +
                        "<td>" + rs.getString("manufacturer") + "</td>" +
                    "</tr>");
                }
            } catch (SQLException | ClassNotFoundException e) {
                out.println("Exception caught: " + e.getMessage());
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
                try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
            }
        %>
    </table>
</body>
</html>
