import javax.swing.*;

public class Main {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            FrontPage homePage = new FrontPage();
            homePage.setContentPane(homePage.GameStore);
            homePage.setTitle("Game Store");
            homePage.setSize(400, 300);
            homePage.setVisible(true);
            homePage.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        });
    }
}
