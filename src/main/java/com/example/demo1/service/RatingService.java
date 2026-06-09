package com.example.demo1.service;

import com.example.demo1.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RatingService {

    public static boolean hasRated(String username, String bookId) {
        String sql = "SELECT 1 FROM ratings WHERE username = ? AND book_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean addRating(String username, String bookId, int stars) {
        if (hasRated(username, bookId)) return false;
        if (stars < 1 || stars > 5) return false;
        
        String sqlInsert = "INSERT INTO ratings (username, book_id) VALUES (?, ?)";
        String sqlUpdate = "UPDATE books SET rating_sum = rating_sum + ?, rating_count = rating_count + 1 WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
                 PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                
                stmtInsert.setString(1, username);
                stmtInsert.setString(2, bookId);
                stmtInsert.executeUpdate();
                
                stmtUpdate.setDouble(1, stars);
                stmtUpdate.setString(2, bookId);
                stmtUpdate.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
