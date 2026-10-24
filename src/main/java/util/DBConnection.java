package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // J'ai ajouté "&allowPublicKeyRetrieval=true" à la fin de l'URL pour corriger l'erreur
    private static final String URL = "jdbc:mysql://localhost:3306/lias_lab?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "BIGdataVLAN1997"; // ton mot de passe MySQL

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}