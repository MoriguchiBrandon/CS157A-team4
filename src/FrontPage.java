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
                if (SqlConnection.authenticateUser(user, pass)) {
                    JOptionPane.showMessageDialog(null, "Login successful");
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
                System.out.println("Attempting to register user: " + user); // Debug statement
                if (SqlConnection.addUser(user, pass)) {
                    JOptionPane.showMessageDialog(null, "User registered successfully");
                } else {
                    JOptionPane.showMessageDialog(null, "Error registering user");
                }
            }
        });
    }
}
