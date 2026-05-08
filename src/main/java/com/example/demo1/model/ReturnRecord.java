package com.example.demo1.model;

import java.time.LocalDate;
import java.util.UUID;

public class ReturnRecord {
    private String returnId;
    private LocalDate returnDate;
    private double fine;
    private String username;
    private String bookId;

    public ReturnRecord(String username, String bookId, double fine) {
        this.returnId = UUID.randomUUID().toString();
        this.returnDate = LocalDate.now();
        this.fine = fine;
        this.username = username;
        this.bookId = bookId;
    }

    public String getReturnId() { return returnId; }
    public LocalDate getReturnDate() { return returnDate; }
    public double getFine() { return fine; }
    public String getUsername() { return username; }
    public String getBookId() { return bookId; }
}
