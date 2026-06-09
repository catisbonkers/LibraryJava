package com.example.demo1.model;

import java.time.LocalDate;

public class User {
    private String username;
    private String password;
    private String role;
    private String address;
    private LocalDate dateRegistered;
    private String status; // "UNVERIFIED", "VERIFIED", "BANNED"
    private String statusReason;
    private int borrowLimit;
    private int jumlahPinjam;

    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.dateRegistered = LocalDate.now();
        this.status = "UNVERIFIED";
        this.statusReason = "Pending admin verification";
        this.borrowLimit = 5; // default limit
        this.jumlahPinjam = 0;
    }

    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public LocalDate getDateRegistered() { return dateRegistered; }
    public void setDateRegistered(LocalDate dateRegistered) { this.dateRegistered = dateRegistered; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getStatusReason() { return statusReason; }
    public void setStatusReason(String statusReason) { this.statusReason = statusReason; }
    public int getBorrowLimit() { return borrowLimit; }
    public void setBorrowLimit(int borrowLimit) { this.borrowLimit = borrowLimit; }
    public int getJumlahPinjam() { return jumlahPinjam; }
    public void setJumlahPinjam(int jumlahPinjam) { this.jumlahPinjam = jumlahPinjam; }

    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }
}
