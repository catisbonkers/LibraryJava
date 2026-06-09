package com.example.demo1.service;

import com.example.demo1.model.Book;
import com.example.demo1.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookService {

    public static void addBook(
            String title,
            String author,
            String publisher,
            int publishYear,
            int stock,
            String coverUrl
    ) {
        String id = UUID.randomUUID().toString();
        String sql = "INSERT INTO books (id, title, author, publisher, publish_year, stock, cover_url, description, borrowed_count, rating_sum, rating_count, added_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'No description available yet for this book.', 0, 0.0, 0, CURDATE())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.setString(2, title);
            stmt.setString(3, author);
            stmt.setString(4, publisher);
            stmt.setInt(5, publishYear);
            stmt.setInt(6, stock);
            stmt.setString(7, coverUrl);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void addBook(
            String title,
            String author,
            String publisher,
            int publishYear,
            int stock
    ) {
        addBook(title, author, publisher, publishYear, stock, null);
    }

    public static List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                books.add(mapBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public static Book getBookById(String id) {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean updateBook(String id, String title, String author, String publisher, int publishYear, int stock) {
        String sql = "UPDATE books SET title=?, author=?, publisher=?, publish_year=?, stock=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, author);
            stmt.setString(3, publisher);
            stmt.setInt(4, publishYear);
            stmt.setInt(5, stock);
            stmt.setString(6, id);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteBook(String id) {
        String sql = "DELETE FROM books WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean borrowBook(String id) {
        String sqlCheck = "SELECT stock FROM books WHERE id=?";
        String sqlUpdate = "UPDATE books SET stock = stock - 1, borrowed_count = borrowed_count + 1 WHERE id=? AND stock > 0";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmtCheck = conn.prepareStatement(sqlCheck)) {
                stmtCheck.setString(1, id);
                try (ResultSet rs = stmtCheck.executeQuery()) {
                    if (rs.next() && rs.getInt("stock") > 0) {
                        try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                            stmtUpdate.setString(1, id);
                            int rows = stmtUpdate.executeUpdate();
                            if (rows > 0) {
                                conn.commit();
                                return true;
                            }
                        }
                    }
                }
            }
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void returnBook(String id) {
        String sql = "UPDATE books SET stock = stock + 1 WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static List<Book> getPopularBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY borrowed_count DESC LIMIT 4";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                books.add(mapBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public static List<Book> getNewestBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY added_date DESC LIMIT 4";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                books.add(mapBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    private static Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book(
                rs.getString("title"),
                rs.getString("author"),
                rs.getString("publisher"),
                rs.getInt("publish_year"),
                rs.getInt("stock")
        );
        book.setId(rs.getString("id"));
        book.setCoverUrl(rs.getString("cover_url"));
        book.setDescription(rs.getString("description"));
        book.setBorrowedCount(rs.getInt("borrowed_count"));
        book.setRatingSum(rs.getDouble("rating_sum"));
        book.setRatingCount(rs.getInt("rating_count"));
        book.setAddedDate(rs.getDate("added_date").toLocalDate());
        return book;
    }
}

