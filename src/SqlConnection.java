import java.sql.*;

public class SqlConnection {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/GameStore?autoReconnect=true&useSSL=false";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "Sexyjutsu100!";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure to load the MySQL driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    public static User authenticateUser(String username, String password) {
        String query = "SELECT role FROM users WHERE username = ? AND password = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String role = rs.getString("role");
                System.out.println("Role found: " + role); // Debug statement
                if ("customer".equalsIgnoreCase(role)) {
                    System.out.println("Creating Customer instance"); // Debug statement
                    return new Customer(username, password);
                } else if ("staff".equalsIgnoreCase(role)) {
                    System.out.println("Creating Staff instance"); // Debug statement
                    return new Staff(username, password);
                }
            } else {
                System.out.println("No user found with the given credentials"); // Debug statement
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean addUser(String username, String password, String role) {
        String query = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, role);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
