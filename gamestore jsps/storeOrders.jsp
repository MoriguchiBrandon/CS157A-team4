<%@ page import="java.sql.*, java.time.LocalDateTime, java.sql.Timestamp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Store Orders Page</title>
</head>
<body>
    <%  
        String inputUsername = request.getParameter("inputUsername");
        String inputUserIdStr = request.getParameter("inputuserid");
        int inputUserId = Integer.parseInt(inputUserIdStr);

        String inputOrderIdStr = request.getParameter("inputOrderId");
        boolean tableUpdated = false;  // Initialize tableUpdated

        String productName = "";
        String customer_fname = "";
        String customer_lname = "";
        String platform = "";
        String Address = "";
        String City = "";
        String District = "";
        int Postal = 0;
        String Country = "";
        int staffID = 0;

        String user = "root";
        String password = "IAmLate2022!";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load database driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false", user, password);

            String staffIDQuery = "SELECT staff_id FROM staff WHERE user_id = ?";
            ps = con.prepareStatement(staffIDQuery);
            ps.setInt(1, inputUserId);
            rs = ps.executeQuery();

            
            rs.next();
            staffID = rs.getInt("staff_id");
            
            rs.close();
            ps.close();

            if (inputOrderIdStr != null && !inputOrderIdStr.isEmpty()) {
                int inputOrderId = Integer.parseInt(inputOrderIdStr);

                // Check if the Order exists and if it's already fulfilled
                String query = "SELECT date_fulfilled FROM `order` WHERE order_id = ?";
                ps = con.prepareStatement(query);
                ps.setInt(1, inputOrderId);
                rs = ps.executeQuery();

                if (rs.next() && rs.getTimestamp("date_fulfilled") == null) {
                    rs.close();
                    ps.close();

                    query = "SELECT c.first_name, c.last_name, pr.name AS product_name, pl.name AS platform_name, " +
                            "a.address, a.city, a.district, a.postal_code, a.country " +
                            "FROM orders AS o " +
                            "JOIN deliver_to AS d ON o.order_id=d.order_id " +
                            "JOIN address AS a ON d.address_id=a.address_id " +
                            "JOIN inventory AS i ON o.inventory_num=i.inventory_num " +
                            "JOIN products AS pr ON i.product_id=pr.product_id " +
                            "JOIN platform AS pl ON pr.platform_id = pl.platform_id " +
                            "JOIN customer AS c ON o.customer_id=c.customer_id " +
                            "WHERE o.order_id = ?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, inputOrderId);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        productName = rs.getString("product_name");
                        customer_fname = rs.getString("first_name");
                        customer_lname = rs.getString("last_name");
                        platform = rs.getString("platform_name");
                        Address = rs.getString("address");
                        City = rs.getString("city");
                        District = rs.getString("district");
                        Postal = rs.getInt("postal_code");
                        Country = rs.getString("country");
                    }
                    rs.close();
                    ps.close();

                    // Order exists and is not fulfilled
                    query = "INSERT INTO `fulfilled_by` (`order_id`, `staff_id`) VALUES (?, ?)";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, inputOrderId);
                    ps.setInt(2, staffID);
                    ps.executeUpdate();
                    ps.close();

                    // Update the order fulfillment date
                    query = "UPDATE `order` SET date_fulfilled = ? WHERE order_id = ?";
                    ps = con.prepareStatement(query);
                    ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setInt(2, inputOrderId);
                    int rowsUpdated = ps.executeUpdate();
                    ps.close();

                    if (rowsUpdated > 0) {
                        tableUpdated = true;
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
    <p>Hello <%= inputUsername %></p>
    <h1>Game Store Staff View Store Orders Page</h1>

    <h2>Fulfill An Order</h2>
    <form action="storeOrders.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <label for="inputOrderId">Order ID:</label>
        <input type="text" id="inputOrderId" name="inputOrderId" required>
        <input type="submit" value="Fulfill Order">
    </form>

    <% if (tableUpdated) { %>
        <p>Delivered <%= productName %> on <%= platform %> to <%= customer_fname %> <%= customer_lname %> at <%= Address %>, <%= City %>, <%= District %> <%= Postal %>, <%= Country %> </p>
    <% } else if (inputOrderIdStr != null && !inputOrderIdStr.isEmpty()) { %>
        <p>Order Fulfill Error</p>
    <% } %>

    <h2>Back to Staff Home Page</h2>
    <form action="GamestoreSHomePage.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="Staff Home Page">
    </form>

    <h2>Orders List</h2>
    <table border="1">
        <tr>
            <th>Order ID</th>
            <th>Inventory Number</th>
            <th>Product Name</th>
            <th>Price</th>
            <th>Customer Email</th>
            <th>Date Ordered</th>
            <th>Date Fulfilled</th>
        </tr>
        <%
            try {
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false", user, password);
                String ordersQuery = "SELECT o.order_id, i.inventory_num, p.name, p.price, c.email, ord.date_ordered, ord.date_fulfilled " +
                     "FROM orders AS o " +
                     "JOIN `order` AS ord ON o.order_id = ord.order_id " +
                     "JOIN inventory AS i ON o.inventory_num = i.inventory_num " +
                     "JOIN products AS p ON i.product_id = p.product_id " +
                     "JOIN customer AS c ON o.customer_id = c.customer_id " +
                     "JOIN belongs_to AS b ON i.inventory_num = b.inventory_id " +
                     "JOIN works_at AS w ON b.store_id = w.store_id " +
                     "WHERE w.staff_id = ? " +
                     "ORDER BY c.email";
                ps = con.prepareStatement(ordersQuery);
                ps.setInt(1, staffID);
                rs = ps.executeQuery();
                while (rs.next()) {
                    out.println("<tr>" +
                                "<td>" + rs.getInt("order_id") + "</td>" +
                                "<td>" + rs.getInt("inventory_num") + "</td>" +
                                "<td>" + rs.getString("name") + "</td>" +
                                "<td>" + rs.getBigDecimal("price") + "</td>" +
                                "<td>" + rs.getString("email") + "</td>" +
                                "<td>" + rs.getTimestamp("date_ordered") + "</td>" +
                                "<td>" + rs.getTimestamp("date_fulfilled") + "</td>" +
                                "</tr>");
                }
            } catch (SQLException e) {
                out.println("Error retrieving orders: " + e.getMessage());
            } finally {
                // Cleanup resources
                try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
                try { if (ps != null) ps.close(); } catch (SQLException e) { /* ignored */ }
                try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
            }
        %>
    </table>
</body>
</html>