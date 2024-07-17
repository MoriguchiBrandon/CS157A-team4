import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class Customer extends User {

    public Customer(String username, String password) {
        super(username, password, "customer");
    }

    public static void displayProducts(JFrame homePage, InventoryManager inventoryManager) {
        JFrame productFrame = new JFrame("Products");
        productFrame.setSize(400, 300);
        productFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel panel = new JPanel();
        productFrame.add(panel);

        List<Product> products = inventoryManager.getProducts();
        StringBuilder productList = new StringBuilder();
        for (Product product : products) {
            productList.append(product.toString()).append("\n");
        }

        JTextArea productTextArea = new JTextArea(productList.toString());
        productTextArea.setEditable(false);
        panel.add(new JScrollPane(productTextArea));

        // Back button
        JButton backButton = new JButton("Back");
        panel.add(backButton);
        backButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                productFrame.dispose();
                homePage.setVisible(true);
            }
        });

        productFrame.setVisible(true);
        homePage.setVisible(false);
    }
}
