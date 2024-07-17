import javax.swing.*;
import java.awt.*;
import java.util.List;

public class Staff extends User {

    public Staff(String username, String password) {
        super(username, password, "staff");
    }

    public static void displayProducts(JFrame homePage, InventoryManager inventoryManager) {
        Customer.displayProducts(homePage, inventoryManager);
    }

    public static void displayDeletedProducts(JFrame homePage, InventoryManager inventoryManager) {
        JFrame deletedProductFrame = new JFrame("Deleted Products");
        deletedProductFrame.setSize(400, 300);
        deletedProductFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel panel = new JPanel();
        deletedProductFrame.add(panel);

        List<Product> deletedProducts = inventoryManager.getDeletedProducts();
        StringBuilder deletedProductList = new StringBuilder();
        for (Product product : deletedProducts) {
            deletedProductList.append(product.toString()).append("\n");
        }

        JTextArea deletedProductTextArea = new JTextArea(deletedProductList.toString());
        deletedProductTextArea.setEditable(false);
        panel.add(new JScrollPane(deletedProductTextArea));

        // Back button
        JButton backButton = new JButton("Back");
        panel.add(backButton);
        backButton.addActionListener(e -> {
            deletedProductFrame.dispose();
            homePage.setVisible(true);
        });

        deletedProductFrame.setVisible(true);
        homePage.setVisible(false);
    }

    public static void manageInventory(JFrame homePage, InventoryManager inventoryManager) {
        JFrame inventoryFrame = new JFrame("Manage Inventory");
        inventoryFrame.setSize(400, 400);
        inventoryFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel panel = new JPanel(new GridBagLayout());
        inventoryFrame.add(panel);

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(10, 10, 10, 10);

        // Product ID label and text field
        JLabel idLabel = new JLabel("Product ID:");
        gbc.gridx = 0;
        gbc.gridy = 0;
        panel.add(idLabel, gbc);

        JTextField idText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 0;
        panel.add(idText, gbc);

        // Product name label and text field
        JLabel nameLabel = new JLabel("Product Name:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        panel.add(nameLabel, gbc);

        JTextField nameText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 1;
        panel.add(nameText, gbc);

        // Description label and text field
        JLabel descriptionLabel = new JLabel("Description:");
        gbc.gridx = 0;
        gbc.gridy = 2;
        panel.add(descriptionLabel, gbc);

        JTextField descriptionText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 2;
        panel.add(descriptionText, gbc);

        // Release year label and text field
        JLabel releaseYearLabel = new JLabel("Release Year:");
        gbc.gridx = 0;
        gbc.gridy = 3;
        panel.add(releaseYearLabel, gbc);

        JTextField releaseYearText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 3;
        panel.add(releaseYearText, gbc);

        // Product cost label and text field
        JLabel costLabel = new JLabel("Product Cost:");
        gbc.gridx = 0;
        gbc.gridy = 4;
        panel.add(costLabel, gbc);

        JTextField costText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 4;
        panel.add(costText, gbc);

        // Manufacturer ID label and text field
        JLabel manufacturerIdLabel = new JLabel("Manufacturer ID:");
        gbc.gridx = 0;
        gbc.gridy = 5;
        panel.add(manufacturerIdLabel, gbc);

        JTextField manufacturerIdText = new JTextField(20);
        gbc.gridx = 1;
        gbc.gridy = 5;
        panel.add(manufacturerIdText, gbc);

        // Add product button
        JButton addProductButton = new JButton("Add Product");
        gbc.gridx = 0;
        gbc.gridy = 6;
        gbc.gridwidth = 2;
        panel.add(addProductButton, gbc);

        addProductButton.addActionListener(e -> {
            try {
                int productId = Integer.parseInt(idText.getText());
                String name = nameText.getText();
                String description = descriptionText.getText();
                int releaseYear = Integer.parseInt(releaseYearText.getText());
                double productCost = Double.parseDouble(costText.getText().replace("$", ""));
                String manufacturerId = manufacturerIdText.getText();  // Allow alphanumeric manufacturer ID

                // Check if the manufacturer ID exists
                if (!SqlConnection.manufacturerExists(manufacturerId)) {
                    JOptionPane.showMessageDialog(null, "Manufacturer ID does not exist. Please enter a valid manufacturer ID.");
                    return;
                }

                // Check if the product already exists
                if (inventoryManager.productExists(productId)) {
                    JOptionPane.showMessageDialog(null, "Product ID already exists. Please enter a unique Product ID.");
                    return;
                }

                Product product = new Product(productId, name, description, releaseYear, productCost, manufacturerId);
                inventoryManager.addProduct(product);
                JOptionPane.showMessageDialog(null, "Product added successfully");
                idText.setText("");
                nameText.setText("");
                descriptionText.setText("");
                releaseYearText.setText("");
                costText.setText("");
                manufacturerIdText.setText("");
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(null, "Invalid input. Please enter valid data.");
            }
        });

        // Remove product button
        JButton removeProductButton = new JButton("Remove Product");
        gbc.gridx = 0;
        gbc.gridy = 7;
        gbc.gridwidth = 2;
        panel.add(removeProductButton, gbc);

        removeProductButton.addActionListener(e -> {
            try {
                int productId = Integer.parseInt(idText.getText());

                // Check if the product exists before attempting to remove it
                if (!inventoryManager.productExists(productId)) {
                    JOptionPane.showMessageDialog(null, "Product not found. Please enter a valid Product ID.");
                    return;
                }

                if (inventoryManager.removeProduct(productId)) {
                    JOptionPane.showMessageDialog(null, "Product removed successfully");
                } else {
                    JOptionPane.showMessageDialog(null, "Error removing product");
                }
                idText.setText("");
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(null, "Invalid input. Please enter a valid product ID.");
            }
        });

        // Back button
        JButton backButton = new JButton("Back");
        gbc.gridx = 0;
        gbc.gridy = 8;
        gbc.gridwidth = 2;
        panel.add(backButton, gbc);
        backButton.addActionListener(e -> {
            inventoryFrame.dispose();
            homePage.setVisible(true);
        });

        inventoryFrame.setVisible(true);
        homePage.setVisible(false);
    }
}
