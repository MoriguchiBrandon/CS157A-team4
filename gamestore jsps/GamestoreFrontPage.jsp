<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Gamestore Guest Page</title>
</head>
<body>
<h1>Game Store Front Page</h1>

<h1>Login Here</h1>
    <!-- click to login -->
    <form action="login.jsp" method="post">
        <input type=submit value="Login">
    </form>

<table border="1">
  <tr>
    
    <td>pr.name</td>
    <td>pr.price</td>
    <td>pr.description</td>
    <td>m.name</td>
    <td>pl.name</td>
  </tr>
    <%
     String db = "gamestore";
        String user; // assumes database name is the same as username
          user = "root";
        String password = "IAmLate2022!";
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/gamestore?autoReconnect=true&useSSL=false",user, password);
            

            out.println("Products for sale \"Guest View\": <br/>");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT pr.name, pr.price, pr.description, pl.name, m.name FROM gamestore.products as pr Join gamestore.manufacturers AS m ON pr.manf_id = m.manufactuer_id Join gamestore.platform AS pl ON pr.platform_id = pl.platform_id");

            while (rs.next()) {
         out.println("<tr>" + "<td>" +  rs.getString(1) + "</td>"+ "<td>" +    rs.getBigDecimal(2) + "</td>"+   "<td>" + rs.getString(3) + "</td>"  + "<td>" + rs.getString(4) + "</td>" + "<td>" + rs.getString(5) + "</td>" + "</tr>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %>
</body>
</html>