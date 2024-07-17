import javax.swing.*;
import java.util.List;

public class HomePage extends JFrame {
    private InventoryManager inventoryManager;
    private User user;

    public HomePage(User user) {
        this.user = user;
        this.inventoryManager = new InventoryManager();

        setTitle(capitalize(user.getRole()) + " Home Page");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JPanel panel = new JPanel();
        add(panel);

        JLabel welcomeLabel = new JLabel("Welcome " + user.getUsername() + ",");
        panel.add(welcomeLabel);

        // Add role-based functionalities here
        JButton viewProductsButton = new JButton("View Products");
        panel.add(viewProductsButton);
        viewProductsButton.addActionListener(e -> displayProducts());

        // Search field and button
        JTextField searchField = new JTextField(20);
        JButton searchButton = new JButton("Search Products");
        panel.add(searchField);
        panel.add(searchButton);
        searchButton.addActionListener(e -> searchProducts(searchField.getText()));

        if (user instanceof Staff) {
            // Add staff-specific buttons and functionalities
            JButton manageInventoryButton = new JButton("Manage Inventory");
            panel.add(manageInventoryButton);
            manageInventoryButton.addActionListener(e -> Staff.manageInventory(this, inventoryManager));

            JButton viewDeletedProductsButton = new JButton("View Deleted Products");
            panel.add(viewDeletedProductsButton);
            viewDeletedProductsButton.addActionListener(e -> Staff.displayDeletedProducts(this, inventoryManager));
        }

        // Logout button
        JButton logoutButton = new JButton("Logout");
        panel.add(logoutButton);
        logoutButton.addActionListener(e -> {
            dispose(); // Close the home page
            // Return to login page
            SwingUtilities.invokeLater(() -> new FrontPage());
        });

        setVisible(true);
    }

    private void displayProducts() {
        JFrame productsFrame = new JFrame("Products");
        productsFrame.setSize(600, 400);
        productsFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel panel = new JPanel();
        productsFrame.add(panel);

        List<Product> products = inventoryManager.getProducts();
        StringBuilder productList = new StringBuilder();
        for (Product product : products) {
            productList.append(product.toString()).append("\n");
        }

        JTextArea productsTextArea = new JTextArea(productList.toString());
        productsTextArea.setEditable(false);
        panel.add(new JScrollPane(productsTextArea));

        // Back button
        JButton backButton = new JButton("Back");
        panel.add(backButton);
        backButton.addActionListener(e -> {
            productsFrame.dispose();
            setVisible(true);
        });

        productsFrame.setVisible(true);
        setVisible(false);
    }

    private void searchProducts(String query) {
        JFrame searchResultsFrame = new JFrame("Search Results");
        searchResultsFrame.setSize(600, 400);
        searchResultsFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel panel = new JPanel();
        searchResultsFrame.add(panel);

        List<Product> products = inventoryManager.searchProducts(query);
        StringBuilder productList = new StringBuilder();
        for (Product product : products) {
            productList.append(product.toString()).append("\n");
        }

        JTextArea searchResultsTextArea = new JTextArea(productList.toString());
        searchResultsTextArea.setEditable(false);
        panel.add(new JScrollPane(searchResultsTextArea));

        // Back button
        JButton backButton = new JButton("Back");
        panel.add(backButton);
        backButton.addActionListener(e -> {
            searchResultsFrame.dispose();
            setVisible(true);
        });

        searchResultsFrame.setVisible(true);
        setVisible(false);
    }

    private String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
}
