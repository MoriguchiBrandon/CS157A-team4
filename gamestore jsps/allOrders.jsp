<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Orders Page</title>
</head>
<body>
    <%
        String inputUsername = request.getParameter("inputUsername");
        String inputUserIdStr = request.getParameter("inputuserid");
        int inputUserId = Integer.parseInt(inputUserIdStr);
    %>
    
    <p>Hello <%= inputUsername %></p>
    <h1>Game Store Staff View All Orders Page</h1>

    <h2>View Store Orders</h2>
    <form action="storeOrders.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="View Orders">
    </form>

    <h2>Back to Staff Home Page</h2>
    <form action="GamestoreSHomePage.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="Staff Home Page">
    </form>

    <h2>Orders List</h2>
    <table border="1">
        <tr>
            <th>Inventory Number</th>
            <th>Product Name</th>
            <th>Price</th>
            <th>Customer Email</th>
            <th>Date Ordered</th>
            <th>Date Fulfilled</th>
        </tr>
        <%
            String user = "root";
            String password = "IAmLate2022!";
            String dbUrl = "jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false";

            try (Connection con = DriverManager.getConnection(dbUrl, user, password);
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT i.inventory_num, p.name, p.price, c.email, ord.date_ordered, ord.date_fulfilled " +
                     "FROM orders AS o " +
                     "JOIN `order` AS ord ON o.order_id = ord.order_id " +
                     "JOIN inventory AS i ON o.inventory_num = i.inventory_num " +
                     "JOIN products AS p ON i.product_id = p.product_id "+
                     "JOIN customer AS c ON o.customer_id = c.customer_id "+
                     "ORDER BY c.email")) {

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.println("<tr>" +
                                    "<td>" + rs.getInt("inventory_num") + "</td>" +
                                    "<td>" + rs.getString("name") + "</td>" +
                                    "<td>" + rs.getBigDecimal("price") + "</td>" +
                                    "<td>" + rs.getString("c.email") + "</td>" +
                                    "<td>" + rs.getTimestamp("date_ordered") + "</td>" +
                                    "<td>" + rs.getTimestamp("date_fulfilled") + "</td>" +
                                    "</tr>");
                    }
                }
            } catch (SQLException e) {
                out.println("SQLException caught: " + e.getMessage());
            }
        %>
    </table>
</body>
</html>
