import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class FrontPage extends JFrame {
    protected JPanel GameStore;
    private JTextField userText;
    private JPasswordField password;
    private JButton loginButton;
    private JButton registerButton;

    public FrontPage() {
        // Initialize the panel and set layout
        GameStore = new JPanel();
        GameStore.setLayout(new GridBagLayout());

        // Set GridBagConstraints
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(10, 10, 10, 10);

        // User label and text field
        JLabel userLabel = new JLabel("User:");
        gbc.gridx = 0;
        gbc.gridy = 0;
        GameStore.add(userLabel, gbc);

        userText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 0;
        GameStore.add(userText, gbc);

        // Password label and password field
        JLabel passwordLabel = new JLabel("Password:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        GameStore.add(passwordLabel, gbc);

        password = new JPasswordField(20);
        gbc.gridx = 1;
        gbc.gridy = 1;
        GameStore.add(password, gbc);

        // Login button
        loginButton = new JButton("Login");
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        GameStore.add(loginButton, gbc);

        // Register button
        registerButton = new JButton("Register");
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.gridwidth = 2;
        GameStore.add(registerButton, gbc);

        // Action listener for the login button
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String user = userText.getText();
                String pass = new String(password.getPassword());
                System.out.println("Attempting to authenticate user: " + user); // Debug statement
                User authenticatedUser = SqlConnection.authenticateUser(user, pass);
                if (authenticatedUser != null) {
                    JOptionPane.showMessageDialog(null, "Login successful");
                    openHomePage(authenticatedUser);
                } else {
                    JOptionPane.showMessageDialog(null, "Invalid credentials");
                }
            }
        });

        // Action listener for the register button
        registerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String user = userText.getText();
                String pass = new String(password.getPassword());
                String role = JOptionPane.showInputDialog("Enter role (customer/staff):");
                System.out.println("Attempting to register user: " + user); // Debug statement
                if (SqlConnection.addUser(user, pass, role)) {
                    JOptionPane.showMessageDialog(null, "User registered successfully");
                } else {
                    JOptionPane.showMessageDialog(null, "Error registering user");
                }
            }
        });
    }

    private void openHomePage(User user) {
        JFrame homePage = new JFrame();
        homePage.setTitle(capitalize(user.getRole()) + " Home Page");
        homePage.setSize(400, 300);
        homePage.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JPanel panel = new JPanel();
        homePage.add(panel);

        JLabel welcomeLabel = new JLabel("Welcome " + user.getUsername() + ",");
        panel.add(welcomeLabel);

        // Add role-based functionalities here
        switch (user.getRole().toLowerCase()) {
            case "customer":
                // Add customer-specific buttons and functionalities
                JButton viewProductsButton = new JButton("View Products");
                panel.add(viewProductsButton);
                // Add more customer-specific functionality
                break;
            case "staff":
                // Add staff-specific buttons and functionalities
                JButton manageInventoryButton = new JButton("Manage Inventory");
                panel.add(manageInventoryButton);
                // Add more staff-specific functionality
                break;
            default:
                break;
        }

        homePage.setVisible(true);
    }

    private String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
}