<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
</head>
<body>
    <h1>Login Page</h1>
    
    <!-- Login Form -->
    <form>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        <br>
        <input type="submit" value="Submit">
    </form>
    
    <%
    boolean loginSuccessful = false;
    boolean isStaff = false;
    boolean isCustomer = false;
    String db = "gamestore";
    String user = "root";
    String password = "IAmLate2022!";
    
    // Retrieve username and password from the request
    String inputUsername = request.getParameter("username");
    String inputPassword = request.getParameter("password");
    int inputuserid = 0;
    
    if (inputUsername != null && inputPassword != null) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Load database driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false", user, password);
            
            // Prepare SQL query for login
            String query = "SELECT user_id FROM user WHERE username = ? AND password = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, inputUsername);
            ps.setString(2, inputPassword);
            
            // Execute query
            rs = ps.executeQuery();
            
            // Check if user exists
            if (rs.next()) {
                loginSuccessful = true;
                inputuserid = rs.getInt("user_id");

                // Check if user_id is in staff
                ps.close();
                rs.close();
                
                query = "SELECT COUNT(*) FROM staff WHERE user_id = ?";
                ps = con.prepareStatement(query);
                ps.setInt(1, inputuserid);
                rs = ps.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    isStaff = true;
                }
                
                // Check if user_id is in customer
                ps.close();
                rs.close();
                
                query = "SELECT COUNT(*) FROM customer WHERE user_id = ?";
                ps = con.prepareStatement(query);
                ps.setInt(1, inputuserid);
                rs = ps.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    isCustomer = true;
                }
            }
        } catch (SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            out.println("ClassNotFoundException caught: " + e.getMessage());
        } finally {
            // Clean up resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("SQLException caught during cleanup: " + e.getMessage());
            }
        }
    }
    
    if (loginSuccessful) {
        if (isStaff) {
    %>
        <p>Login successful! Welcome, <%= inputUsername %>.</p>
        <form action="GamestoreSHomePage.jsp" method="post">
            <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
            <input type="hidden" name="inputuserid" value="<%= inputuserid %>" />
            <input type="submit" value="Go to Homepage">
        </form>
    <%
        } else if (isCustomer) {
    %>
        <p>Login successful! Welcome, <%= inputUsername %>.</p>
        <form action="GamestoreCHomePage.jsp" method="post">
            <input type="hidden" name="inputUsername" value="<%= inputUsername %>" />
            <input type="hidden" name="inputuserid" value="<%= inputuserid %>" />
            <input type="submit" value="Go to Customer Homepage">
        </form>
    <%
        }
    } else if (inputUsername != null && inputPassword != null) {
    %>
        <p style="color:red;">Invalid username or password. Please try again.</p>
    <%
    }
    %>
</body>
</html>
