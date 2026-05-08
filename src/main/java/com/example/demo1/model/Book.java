package com.example.demo1.model;

import java.time.LocalDate;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.DoubleAdder;

public class Book {
    private String id;
    private String title;
    private String author;
    private String publisher;
    private int publishYear;
    private AtomicInteger stock;
    private String coverUrl;
    private String description;
    private AtomicInteger borrowedCount;
    private DoubleAdder ratingSum;
    private AtomicInteger ratingCount;
    private LocalDate addedDate;

    public Book(String title, String author, String publisher, int publishYear, int stock) {
        this.id = UUID.randomUUID().toString();
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.publishYear = publishYear;
        this.stock = new AtomicInteger(stock);
        this.coverUrl = "https://picsum.photos/seed/" + this.id.substring(0, 8) + "/300/420";
        this.description = "No description available yet for this book.";
        this.borrowedCount = new AtomicInteger(0);
        this.ratingSum = new DoubleAdder();
        this.ratingCount = new AtomicInteger(0);
        this.addedDate = LocalDate.now();
    }

    public String getId() { return id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public int getPublishYear() { return publishYear; }
    public void setPublishYear(int publishYear) { this.publishYear = publishYear; }
    public int getStock() { return stock.get(); }
    public void setStock(int stock) { this.stock.set(stock); }
    public String getCoverUrl() { return coverUrl; }
    public void setCoverUrl(String coverUrl) { this.coverUrl = coverUrl; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getBorrowedCount() { return borrowedCount.get(); }
    public LocalDate getAddedDate() { return addedDate; }
    public int getRatingCount() { return ratingCount.get(); }

    public double getAverageRating() {
        int count = ratingCount.get();
        return count == 0 ? 0.0 : ratingSum.sum() / count;
    }

    public int getRoundedRating() {
        return (int) Math.round(getAverageRating());
    }

    public void addRating(int stars) {
        ratingSum.add(stars);
        ratingCount.incrementAndGet();
    }

    public boolean isAvailable() { return stock.get() > 0; }

    public void borrow() {
        if (stock.getAndDecrement() > 0) {
            borrowedCount.incrementAndGet();
        } else {
            stock.incrementAndGet(); // Revert if we decremented past 0
        }
    }

    public void returnBook() { stock.incrementAndGet(); }

    public boolean isNew() {
        return addedDate.isAfter(LocalDate.now().minusDays(30));
    }
}
