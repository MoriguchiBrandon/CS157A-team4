<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gamestore Staff Home Page</title>
</head>
<body>
    <%
        String inputUsername = request.getParameter("inputUsername");
        String inputUserIdStr = request.getParameter("inputuserid");
        int inputUserId = Integer.parseInt(inputUserIdStr);
    %>

    <p>Hello <%= inputUsername %></p>
    <h1>Game Store Staff Home Page</h1>

    <h2>View Store Orders</h2>
    <form action="storeOrders.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="View Orders">
    </form>

    <h2>View All Orders</h2>
    <form action="allOrders.jsp" method="post">
        <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
        <input type="hidden" name="inputuserid" value="<%= inputUserId %>" />
        <input type="submit" value="All Orders">
    </form>


    <h2>Items in Store</h2>
    <table border="1">
        <tr>
            <th>Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Platform</th>
            <th>Made By</th>
        </tr>
        <%
            String db = "gamestore";
            String user = "root";
            String password = "IAmLate2022!";
            String url = "jdbc:mysql://localhost:3306/" + db + "?autoReconnect=true&useSSL=false";

            try (Connection con = DriverManager.getConnection(url, user, password);
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT pr.name, pr.price, pr.description, pl.name AS platform, m.name AS manufacturer " +
                     "FROM gamestore.works_at AS w " +
                     "JOIN gamestore.belongs_to AS b ON w.store_id = b.store_id " +
                     "JOIN gamestore.inventory AS i ON b.inventory_id = i.inventory_num " +
                     "JOIN gamestore.products AS pr ON i.product_id = pr.product_id " +
                     "JOIN gamestore.manufacturers AS m ON pr.manf_id = m.manufactuer_id " +
                     "JOIN gamestore.platform AS pl ON pr.platform_id = pl.platform_id " +
                     "WHERE w.staff_id = ?")) {

                ps.setInt(1, inputUserId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        out.println("<tr>" +
                                    "<td>" + rs.getString("name") + "</td>" +
                                    "<td>" + rs.getBigDecimal("price") + "</td>" +
                                    "<td>" + rs.getString("description") + "</td>" +
                                    "<td>" + rs.getString("platform") + "</td>" +
                                    "<td>" + rs.getString("manufacturer") + "</td>" +
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
