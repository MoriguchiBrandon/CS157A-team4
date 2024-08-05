<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Orders Page</title>
</head>
<body>
    <%
        String inputUsername = request.getParameter("inputUsername");
        String inputUserIdStr = request.getParameter("inputuserid");
        int inputUserId = Integer.parseInt(inputUserIdStr);
    %>
    
    <h1>Create New Order</h1>
    <!-- Click to create new order -->
    <form action="NewOrder.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="New Order">
    </form>

    <h1>Back to Home Page</h1>
    <!-- Click to go to home page -->
    <form action="GamestoreCHomePage.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="Go to Homepage">
    </form>

    <%


        String user = "root";
        String password = "IAmLate2022!";
        String dbUrl = "jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load the database driver and establish a connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(dbUrl, user, password);

            // SQL query to retrieve orders
            String query = "SELECT p.name, p.price, p.description, ord.date_ordered, ord.date_fulfilled " +
                           "FROM orders AS o " +
                           "JOIN `order` AS ord ON o.order_id = ord.order_id " +
                           "JOIN inventory AS i ON o.inventory_num = i.inventory_num " +
                           "JOIN products AS p ON i.product_id = p.product_id " +
                           "WHERE o.customer_id = ?";

            ps = con.prepareStatement(query);
            ps.setInt(1, inputUserId);
            rs = ps.executeQuery();
    %>

    <p>Hello <%= inputUsername %></p>
    <h1><%= inputUsername %> Orders</h1>

    <table border="1">
        <tr>
            <th>Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Date Ordered</th>
            <th>Date Fulfilled</th>
        </tr>
        <%
            while (rs.next()) {
                out.println("<tr>" +
                    "<td>" + rs.getString("name") + "</td>" +
                    "<td>" + rs.getBigDecimal("price") + "</td>" +
                    "<td>" + rs.getString("description") + "</td>" +
                    "<td>" + rs.getTimestamp("date_ordered") + "</td>" +
                    "<td>" + rs.getTimestamp("date_fulfilled") + "</td>" +
                "</tr>");
            }
        %>
    </table>

    <%
        } catch (SQLException | ClassNotFoundException e) {
            out.println("Exception caught: " + e.getMessage());
        } finally {
            // Cleanup resources
            try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
            try { if (ps != null) ps.close(); } catch (SQLException e) { /* ignored */ }
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }
        }
    %>

</body>
</html>
