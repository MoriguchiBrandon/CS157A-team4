import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryManager {
    private List<Product> products;
    private List<Product> deletedProducts;

    public InventoryManager() {
        products = new ArrayList<>();
        deletedProducts = new ArrayList<>();
        loadProductsFromDatabase();
        loadDeletedProductsFromDatabase();
    }

    private void loadProductsFromDatabase() {
        String query = "SELECT product_id, name, description, release_year, product_cost, manufacturer_id FROM products";

        try (Connection conn = SqlConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                int productId = rs.getInt("product_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                int releaseYear = rs.getInt("release_year");
                double productCost = rs.getDouble("product_cost");
                String manufacturerId = rs.getString("manufacturer_id");

                Product product = new Product(productId, name, description, releaseYear, productCost, manufacturerId);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void loadDeletedProductsFromDatabase() {
        String query = "SELECT product_id, name, description, release_year, product_cost, manufacturer_id FROM deleted_products";

        try (Connection conn = SqlConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                int productId = rs.getInt("product_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                int releaseYear = rs.getInt("release_year");
                double productCost = rs.getDouble("product_cost");
                String manufacturerId = rs.getString("manufacturer_id");

                Product product = new Product(productId, name, description, releaseYear, productCost, manufacturerId);
                deletedProducts.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean addProduct(Product product) {
        String query = "INSERT INTO products (product_id, name, description, release_year, product_cost, manufacturer_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = SqlConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, product.getProductId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setInt(4, product.getReleaseYear());
            stmt.setDouble(5, product.getProductCost());
            stmt.setString(6, product.getManufacturerId());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                products.add(product);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeProduct(int productId) {
        String query = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = SqlConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                Product product = getProductById(productId);
                if (product != null) {
                    products.remove(product);
                    deletedProducts.add(product);
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> getProducts() {
        return products;
    }

    public List<Product> getDeletedProducts() {
        return deletedProducts;
    }

    public Product getProductById(int productId) {
        for (Product product : products) {
            if (product.getProductId() == productId) {
                return product;
            }
        }
        return null;
    }

    public boolean productExists(int productId) {
        String query = "SELECT 1 FROM products WHERE product_id = ?";
        try (Connection conn = SqlConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Static method to search products in the database
    public List<Product> searchProducts(String query) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? OR description LIKE ?";
        try (Connection conn = SqlConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + query + "%");
            stmt.setString(2, "%" + query + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int productId = rs.getInt("product_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                int releaseYear = rs.getInt("release_year");
                double productCost = rs.getDouble("product_cost");
                String manufacturerId = rs.getString("manufacturer_id");
                products.add(new Product(productId, name, description, releaseYear, productCost, manufacturerId));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
