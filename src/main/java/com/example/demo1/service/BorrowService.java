package com.example.demo1.service;

import com.example.demo1.model.Borrow;

import java.util.ArrayList;
import java.util.List;

import java.util.concurrent.CopyOnWriteArrayList;

public class BorrowService {
    private static List<Borrow> borrows = new CopyOnWriteArrayList<>();

    public static Borrow addBorrow(String username, String bookId, int daysBorrowed) {
        Borrow borrow = new Borrow(username, bookId, daysBorrowed);
        borrows.add(borrow);
        return borrow;
    }

    public static List<Borrow> getAllBorrows() {
        return new ArrayList<>(borrows);
    }

    public static List<Borrow> getUserBorrows(String username) {
        List<Borrow> result = new ArrayList<>();

        for (Borrow b : borrows) {
            if (b.getUsername().equals(username)) {
                result.add(b);
            }
        }

        return result;
    }

    public static Borrow getByBorrowId(String borrowId) {
        for (Borrow b : borrows) {
            if (b.getBorrowId().equals(borrowId)) {
                return b;
            }
        }
        return null;
    }

    public static void returnBook(String borrowId) {
        borrows.removeIf(b -> b.getBorrowId().equals(borrowId));
    }
}
