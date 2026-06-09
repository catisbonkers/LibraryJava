package com.example.demo1.service;

import com.example.demo1.model.ReturnRecord;
import com.example.demo1.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReturnService {

    public static ReturnRecord addReturn(String username, String bookId, double fine) {
        ReturnRecord returnRecord = new ReturnRecord(username, bookId, fine);
        String sql = "INSERT INTO return_records (return_id, return_date, fine, username, book_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, returnRecord.getReturnId());
            stmt.setDate(2, java.sql.Date.valueOf(returnRecord.getReturnDate()));
            stmt.setDouble(3, returnRecord.getFine());
            stmt.setString(4, returnRecord.getUsername());
            stmt.setString(5, returnRecord.getBookId());
            stmt.executeUpdate();
            return returnRecord;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static List<ReturnRecord> getUserReturns(String username) {
        List<ReturnRecord> returns = new ArrayList<>();
        String sql = "SELECT * FROM return_records WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    returns.add(mapReturnRecord(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return returns;
    }

    public static ReturnRecord getByReturnId(String returnId) {
        String sql = "SELECT * FROM return_records WHERE return_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, returnId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapReturnRecord(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static ReturnRecord mapReturnRecord(ResultSet rs) throws SQLException {
        ReturnRecord record = new ReturnRecord(
                rs.getString("username"),
                rs.getString("book_id"),
                rs.getDouble("fine")
        );
        record.setReturnId(rs.getString("return_id"));
        record.setReturnDate(rs.getDate("return_date").toLocalDate());
        return record;
    }
}
