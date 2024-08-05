<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gamestore Customer Home Page</title>
</head>
<body>
    <%
        String inputUsername = request.getParameter("inputUsername");
        String inputUserId = request.getParameter("inputuserid"); 
    %>

    <p>Hello <%= inputUsername %></p>
    <h1>Game Store Customer Home Page</h1>

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

    <h1>Products for Sale</h1>
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
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Load database driver and establish connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false", user, password);

                // Prepare and execute SQL query
                String query = "SELECT pr.name, pr.price, pr.description, pl.name AS platform, m.name AS manufacturer FROM gamestore.products pr " +
                               "JOIN gamestore.manufacturers m ON pr.manf_id = m.manufactuer_id " +
                               "JOIN gamestore.platform pl ON pr.platform_id = pl.platform_id";
                stmt = con.createStatement();
                rs = stmt.executeQuery(query);

                // Output results
                while (rs.next()) {
                    out.println("<tr>" +
                                "<td>" + rs.getString("name") + "</td>" +
                                "<td>" + rs.getBigDecimal("price") + "</td>" +
                                "<td>" + rs.getString("description") + "</td>" +
                                "<td>" + rs.getString("platform") + "</td>" +
                                "<td>" + rs.getString("manufacturer") + "</td>" +
                                "</tr>");
                }
            } catch (SQLException e) {
                out.println("SQLException caught: " + e.getMessage());
            } catch (ClassNotFoundException e) {
                out.println("ClassNotFoundException caught: " + e.getMessage());
            } finally {
                // Clean up resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    out.println("SQLException caught during cleanup: " + e.getMessage());
                }
            }
        %>
    </table>
</body>
</html>
