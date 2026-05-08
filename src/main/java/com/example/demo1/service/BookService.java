package com.example.demo1.service;

import com.example.demo1.model.Book;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import java.util.concurrent.ConcurrentHashMap;

public class BookService {
    private static final Map<String, Book> books = new ConcurrentHashMap<>();

    static {
        addBook("Clean Code", "Robert C. Martin", "Prentice Hall", 2008, 5);
        addBook("Effective Java", "Joshua Bloch", "Addison-Wesley", 2017, 3);
        addBook("Design Patterns", "Gang of Four", "Addison-Wesley", 1994, 4);
        addBook("The Pragmatic Programmer", "David Thomas & Andrew Hunt", "Addison-Wesley", 2019, 6);
        addBook("Clean Architecture", "Robert C. Martin", "Prentice Hall", 2017, 2);
        addBook("You Don't Know JS", "Kyle Simpson", "O'Reilly Media", 2015, 7);
        addBook("Refactoring", "Martin Fowler", "Addison-Wesley", 2018, 3);
        addBook("Introduction to Algorithms", "CLRS", "MIT Press", 2009, 4);
    }


    public static void addBook(String title, String author, String publisher, int publishYear, int stock) {
        Book book = new Book(title, author, publisher, publishYear, stock);
        books.put(book.getId(), book);
    }

    public static List<Book> getAllBooks() {
        return new ArrayList<>(books.values());
    }

    public static Book getBookById(String id) {
        return books.get(id);
    }

    public static boolean updateBook(String id, String title, String author, String publisher, int publishYear, int stock) {
        Book book = books.get(id);
        if (book != null) {
            book.setTitle(title);
            book.setAuthor(author);
            book.setPublisher(publisher);
            book.setPublishYear(publishYear);
            book.setStock(stock);
            return true;
        }
        return false;
    }

    public static boolean deleteBook(String id) {
        return books.remove(id) != null;
    }

    public static boolean borrowBook(String id) {
        Book book = books.get(id);

        if (book != null && book.isAvailable()) {
            book.borrow();
            return true;
        }

        return false;
    }

    public static void returnBook(String id) {
        Book book = books.get(id);
        if (book != null) {
            book.returnBook();
        }
    }

    /** Top 4 books by total borrowed count */
    public static List<Book> getPopularBooks() {
        List<Book> all = getAllBooks();
        all.sort((a, b) -> Integer.compare(b.getBorrowedCount(), a.getBorrowedCount()));
        return all.subList(0, Math.min(4, all.size()));
    }

    /** 4 most recently added books */
    public static List<Book> getNewestBooks() {
        List<Book> all = getAllBooks();
        all.sort((a, b) -> b.getAddedDate().compareTo(a.getAddedDate()));
        return all.subList(0, Math.min(4, all.size()));
    }
}

