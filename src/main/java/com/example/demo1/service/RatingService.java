package com.example.demo1.service;

import com.example.demo1.model.Book;

import java.util.*;

import java.util.concurrent.ConcurrentHashMap;

public class RatingService {
    // bookId -> Set of usernames who have already rated (one rating per user per book)
    private static Map<String, Set<String>> userRatings = new ConcurrentHashMap<>();

    public static boolean hasRated(String username, String bookId) {
        return userRatings.getOrDefault(bookId, Collections.emptySet()).contains(username);
    }

    public static boolean addRating(String username, String bookId, int stars) {
        if (hasRated(username, bookId)) return false;
        if (stars < 1 || stars > 5) return false;
        userRatings.computeIfAbsent(bookId, k -> ConcurrentHashMap.newKeySet()).add(username);
        Book book = BookService.getBookById(bookId);
        if (book != null) {
            book.addRating(stars);
        }
        return true;
    }
}
