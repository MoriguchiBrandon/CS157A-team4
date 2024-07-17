import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class FrontPage extends JFrame {
    protected JPanel mainPanel;
    protected CardLayout cardLayout;
    protected JPanel loginPanel;
    protected JPanel registerPanel;
    protected JPanel resetPasswordPanel;
    protected JTextField userText;
    protected JPasswordField passwordField;
    protected JTextField registerUserText;
    protected JPasswordField registerPasswordField;
    protected JTextField roleText;
    protected JTextField resetUserText;
    protected JPasswordField resetNewPasswordField;
    protected JButton loginButton;
    protected JButton registerButton;
    protected JButton resetPasswordButton;
    protected JButton submitRegisterButton;
    protected JButton submitResetPasswordButton;
    protected User user;

    public FrontPage() {
        mainPanel = new JPanel();
        cardLayout = new CardLayout();
        mainPanel.setLayout(cardLayout);

        // Initialize login panel
        loginPanel = new JPanel(new GridBagLayout());
        initializeLoginPanel();

        // Initialize register panel
        registerPanel = new JPanel(new GridBagLayout());
        initializeRegisterPanel();

        // Initialize reset password panel
        resetPasswordPanel = new JPanel(new GridBagLayout());
        initializeResetPasswordPanel();

        // Add panels to card layout
        mainPanel.add(loginPanel, "loginPanel");
        mainPanel.add(registerPanel, "registerPanel");
        mainPanel.add(resetPasswordPanel, "resetPasswordPanel");

        setContentPane(mainPanel);
        setTitle("Game Store");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setVisible(true);
    }

    private void initializeLoginPanel() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(10, 10, 10, 10);

        // User label and text field
        JLabel userLabel = new JLabel("User:");
        gbc.gridx = 0;
        gbc.gridy = 0;
        loginPanel.add(userLabel, gbc);

        userText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 0;
        loginPanel.add(userText, gbc);

        // Password label and password field
        JLabel passwordLabel = new JLabel("Password:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        loginPanel.add(passwordLabel, gbc);

        passwordField = new JPasswordField(20);
        gbc.gridx = 1;
        gbc.gridy = 1;
        loginPanel.add(passwordField, gbc);

        // Login button
        loginButton = new JButton("Login");
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        loginPanel.add(loginButton, gbc);

        // Register button
        registerButton = new JButton("Register");
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.gridwidth = 2;
        loginPanel.add(registerButton, gbc);

        // Reset Password button
        resetPasswordButton = new JButton("Reset Password");
        gbc.gridx = 0;
        gbc.gridy = 4;
        gbc.gridwidth = 2;
        loginPanel.add(resetPasswordButton, gbc);

        // Add action listeners for the buttons
        addLoginButtonAction();
        addRegisterButtonAction();
        addResetPasswordButtonAction();
    }

    private void initializeRegisterPanel() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(10, 10, 10, 10);

        // User label and text field for register
        JLabel registerUserLabel = new JLabel("User:");
        gbc.gridx = 0;
        gbc.gridy = 0;
        registerPanel.add(registerUserLabel, gbc);

        registerUserText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 0;
        registerPanel.add(registerUserText, gbc);

        // Password label and password field for register
        JLabel registerPasswordLabel = new JLabel("Password:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        registerPanel.add(registerPasswordLabel, gbc);

        registerPasswordField = new JPasswordField(20);
        gbc.gridx = 1;
        gbc.gridy = 1;
        registerPanel.add(registerPasswordField, gbc);

        // Role label and text field for register
        JLabel roleLabel = new JLabel("Role:");
        gbc.gridx = 0;
        gbc.gridy = 2;
        registerPanel.add(roleLabel, gbc);

        roleText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 2;
        registerPanel.add(roleText, gbc);

        // Submit button for register
        submitRegisterButton = new JButton("Submit");
        gbc.gridx = 0;
        gbc.gridy = 3;
        gbc.gridwidth = 2;
        registerPanel.add(submitRegisterButton, gbc);

        // Add action listener for the submit register button
        addSubmitRegisterButtonAction();
    }

    private void initializeResetPasswordPanel() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(10, 10, 10, 10);

        // User label and text field for reset password
        JLabel resetUserLabel = new JLabel("User:");
        gbc.gridx = 0;
        gbc.gridy = 0;
        resetPasswordPanel.add(resetUserLabel, gbc);

        resetUserText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 0;
        resetPasswordPanel.add(resetUserText, gbc);

        // New password label and password field for reset password
        JLabel resetPasswordLabel = new JLabel("New Password:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        resetPasswordPanel.add(resetPasswordLabel, gbc);

        resetNewPasswordField = new JPasswordField(20);
        gbc.gridx = 1;
        gbc.gridy = 1;
        resetPasswordPanel.add(resetNewPasswordField, gbc);

        // Submit button for reset password
        submitResetPasswordButton = new JButton("Submit");
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        resetPasswordPanel.add(submitResetPasswordButton, gbc);

        // Add action listener for the submit reset password button
        addSubmitResetPasswordButtonAction();
    }

    protected void addLoginButtonAction() {
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String username = userText.getText();
                String password = new String(passwordField.getPassword());
                user = SqlConnection.authenticateUser(username, password);
                if (user != null) {
                    JOptionPane.showMessageDialog(null, "Login successful");
                    openHomePage(user);
                } else {
                    JOptionPane.showMessageDialog(null, "Invalid credentials");
                }
            }
        });
    }

    protected void addRegisterButtonAction() {
        registerButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                cardLayout.show(mainPanel, "registerPanel");
            }
        });
    }

    protected void addResetPasswordButtonAction() {
        resetPasswordButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                cardLayout.show(mainPanel, "resetPasswordPanel");
            }
        });
    }

    protected void addSubmitRegisterButtonAction() {
        submitRegisterButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String username = registerUserText.getText();
                String password = new String(registerPasswordField.getPassword());
                String role = roleText.getText();
                if (User.registerUser(username, password, role)) {
                    JOptionPane.showMessageDialog(null, "User registered successfully");
                    cardLayout.show(mainPanel, "loginPanel");
                }
            }
        });
    }

    protected void addSubmitResetPasswordButtonAction() {
        submitResetPasswordButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String username = resetUserText.getText();
                String newPassword = new String(resetNewPasswordField.getPassword());
                if (User.resetPassword(username, newPassword)) {
                    JOptionPane.showMessageDialog(null, "Password reset successfully");
                    cardLayout.show(mainPanel, "loginPanel");
                }
            }
        });
    }

    public void openHomePage(User user) {
        new HomePage(user);
        dispose();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new FrontPage());
    }
}
