public class Product {
    private int productId;
    private String name;
    private String description;
    private int releaseYear;
    private double productCost;
    private String manufacturerId;

    public Product(int productId, String name, String description, int releaseYear, double productCost, String manufacturerId) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.releaseYear = releaseYear;
        this.productCost = productCost;
        this.manufacturerId = manufacturerId;
    }

    public int getProductId() {
        return productId;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public int getReleaseYear() {
        return releaseYear;
    }

    public double getProductCost() {
        return productCost;
    }

    public String getManufacturerId() {
        return manufacturerId;
    }

    @Override
    public String toString() {
        return "Product ID: " + productId + ", Name: " + name + ", Description: " + description +
                ", Release Year: " + releaseYear + ", Cost: $" + productCost + ", Manufacturer ID: " + manufacturerId;
    }
}
