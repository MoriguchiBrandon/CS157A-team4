import java.sql.*;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class User {
    protected String username;
    protected String password;
    protected String role;

    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

    @Override
    public String toString() {
        return "User{" +
                "username='" + username + '\'' +
                ", role='" + role + '\'' +
                '}';
    }

    // Method to register a new user
    public static boolean registerUser(String username, String password, String role) {
        if (username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            JOptionPane.showMessageDialog(null, "All fields must be filled out.");
            return false;
        }

        try {
            if (SqlConnection.addUser(username, password, role)) {
                JOptionPane.showMessageDialog(null, "User registered successfully");
                return true;
            } else {
                JOptionPane.showMessageDialog(null, "Error registering user");
                return false;
            }
        } catch (SQLIntegrityConstraintViolationException ex) {
            JOptionPane.showMessageDialog(null, "Username already exists. Please choose another one.");
            return false;
        }
    }

    // Method to reset the password of an existing user
    public static boolean resetPassword(String username, String newPassword) {
        if (username.isEmpty() || newPassword.isEmpty()) {
            JOptionPane.showMessageDialog(null, "All fields must be filled out.");
            return false;
        }

        String query = "UPDATE users SET password = ? WHERE username = ?";
        try (Connection conn = SqlConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, username);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                JOptionPane.showMessageDialog(null, "Password reset successfully");
                return true;
            } else {
                JOptionPane.showMessageDialog(null, "User not found");
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error resetting password");
            return false;
        }
    }

    // Method to handle login
    public static User authenticateUser(String username, String password) {
        String query = "SELECT role FROM users WHERE username = ? AND password = ?";
        try (Connection conn = SqlConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String role = rs.getString("role");
                System.out.println("Role found: " + role); // Debug statement
                if ("customer".equalsIgnoreCase(role)) {
                    return new Customer(username, password);
                } else if ("staff".equalsIgnoreCase(role)) {
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

    // Static method to create and add the Register button action listener
    public static void addRegisterButtonAction(JButton registerButton) {
        registerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JTextField usernameField = new JTextField();
                JPasswordField passwordField = new JPasswordField();
                JTextField roleField = new JTextField();

                Object[] message = {
                        "Username:", usernameField,
                        "Password:", passwordField,
                        "Role (customer/staff):", roleField
                };

                int option = JOptionPane.showConfirmDialog(null, message, "Register", JOptionPane.OK_CANCEL_OPTION);
                if (option == JOptionPane.OK_OPTION) {
                    String user = usernameField.getText();
                    String pass = new String(passwordField.getPassword());
                    String role = roleField.getText();

                    // Input validation
                    if (user.isEmpty() || pass.isEmpty() || role.isEmpty()) {
                        JOptionPane.showMessageDialog(null, "All fields must be filled out.");
                        return;
                    }

                    System.out.println("Attempting to register user: " + user); // Debug statement
                    registerUser(user, pass, role);
                }
            }
        });
    }

    // Static method to create and add the Reset Password button action listener
    public static void addResetPasswordButtonAction(JButton resetPasswordButton) {
        resetPasswordButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JTextField usernameField = new JTextField();
                JPasswordField newPasswordField = new JPasswordField();

                Object[] message = {
                        "Username:", usernameField,
                        "New Password:", newPasswordField
                };

                int option = JOptionPane.showConfirmDialog(null, message, "Reset Password", JOptionPane.OK_CANCEL_OPTION);
                if (option == JOptionPane.OK_OPTION) {
                    String user = usernameField.getText();
                    String newPassword = new String(newPasswordField.getPassword());

                    // Input validation
                    if (user.isEmpty() || newPassword.isEmpty()) {
                        JOptionPane.showMessageDialog(null, "All fields must be filled out.");
                        return;
                    }

                    System.out.println("Attempting to reset password for user: " + user); // Debug statement
                    resetPassword(user, newPassword);
                }
            }
        });
    }

    // Static method to create and add the Login button action listener
    public static void addLoginButtonAction(JButton loginButton, JTextField userText, JPasswordField passwordField, FrontPage frontPage) {
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String user = userText.getText();
                String pass = new String(passwordField.getPassword());
                System.out.println("Attempting to authenticate user: " + user); // Debug statement
                User authenticatedUser = authenticateUser(user, pass);
                if (authenticatedUser != null) {
                    JOptionPane.showMessageDialog(null, "Login successful");
                    frontPage.openHomePage(authenticatedUser);
                } else {
                    JOptionPane.showMessageDialog(null, "Invalid credentials");
                }
            }
        });
    }
}
