package com.example.demo1.service;

import com.example.demo1.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SettingsService {

    public static double getPenaltyPerDay() {
        String sql = "SELECT setting_value FROM settings WHERE setting_key = 'penaltyPerDay'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return Double.parseDouble(rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 2.00; // default fallback
    }

    public static void setPenaltyPerDay(double newPenalty) {
        String sql = "UPDATE settings SET setting_value = ? WHERE setting_key = 'penaltyPerDay'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, String.valueOf(newPenalty));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
