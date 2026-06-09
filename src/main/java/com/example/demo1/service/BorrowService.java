package com.example.demo1.service;

import com.example.demo1.model.Borrow;
import com.example.demo1.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BorrowService {

    public static Borrow addBorrow(String username, String bookId, int daysBorrowed) {
        Borrow borrow = new Borrow(username, bookId, daysBorrowed);
        String sql = "INSERT INTO borrows (borrow_id, username, book_id, borrow_date, due_date, days_borrowed) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, borrow.getBorrowId());
            stmt.setString(2, borrow.getUsername());
            stmt.setString(3, borrow.getBookId());
            stmt.setDate(4, java.sql.Date.valueOf(borrow.getBorrowDate()));
            stmt.setDate(5, java.sql.Date.valueOf(borrow.getDueDate()));
            stmt.setInt(6, borrow.getDaysBorrowed());
            stmt.executeUpdate();
            return borrow;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static List<Borrow> getAllBorrows() {
        List<Borrow> borrows = new ArrayList<>();
        String sql = "SELECT * FROM borrows";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                borrows.add(mapBorrow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return borrows;
    }

    public static List<Borrow> getUserBorrows(String username) {
        List<Borrow> borrows = new ArrayList<>();
        String sql = "SELECT * FROM borrows WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    borrows.add(mapBorrow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return borrows;
    }

    public static Borrow getByBorrowId(String borrowId) {
        String sql = "SELECT * FROM borrows WHERE borrow_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, borrowId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapBorrow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void returnBook(String borrowId) {
        String sql = "DELETE FROM borrows WHERE borrow_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, borrowId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static Borrow mapBorrow(ResultSet rs) throws SQLException {
        Borrow borrow = new Borrow(
                rs.getString("username"),
                rs.getString("book_id"),
                rs.getInt("days_borrowed")
        );
        borrow.setBorrowId(rs.getString("borrow_id"));
        borrow.setBorrowDate(rs.getDate("borrow_date").toLocalDate());
        borrow.setDueDate(rs.getDate("due_date").toLocalDate());
        return borrow;
    }
}
