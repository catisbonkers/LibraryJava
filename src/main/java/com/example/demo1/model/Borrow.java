package com.example.demo1.model;

import java.time.LocalDate;
import java.util.UUID;

public class Borrow {
    private String borrowId;
    private String username;// besok libur!
    private String bookId;
    private LocalDate borrowDate;
    private LocalDate dueDate;
    private int daysBorrowed;

    public Borrow(String username, String bookId, int daysBorrowed) {
        this.borrowId = UUID.randomUUID().toString();
        this.username = username;
        this.bookId = bookId;
        this.borrowDate = LocalDate.now();
        this.daysBorrowed = daysBorrowed;
        this.dueDate = this.borrowDate.plusDays(daysBorrowed);
    }

    public String getBorrowId() { return borrowId; }
    public void setBorrowId(String borrowId) { this.borrowId = borrowId; }
    public String getUsername() { return username; }
    public String getBookId() { return bookId; }
    public LocalDate getBorrowDate() { return borrowDate; }
    public void setBorrowDate(LocalDate borrowDate) { this.borrowDate = borrowDate; }
    public LocalDate getDueDate() { return dueDate; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }
    public int getDaysBorrowed() { return daysBorrowed; }
}
