package com.example.demo1.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String USERNAME = "root";
    private static final String PASSWORD = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load MySQL JDBC Driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String dbHost = System.getenv("DB_HOST");
        if (dbHost == null || dbHost.isEmpty()) {
            dbHost = "localhost";
        }
        String url = "jdbc:mysql://" + dbHost + ":3306/library_db";
        return DriverManager.getConnection(url, USERNAME, PASSWORD);
    }
}
