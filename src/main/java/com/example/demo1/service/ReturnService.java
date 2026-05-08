package com.example.demo1.service;

import com.example.demo1.model.ReturnRecord;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class ReturnService {
    private static List<ReturnRecord> returns = new CopyOnWriteArrayList<>();

    public static ReturnRecord addReturn(String username, String bookId, double fine) {
        ReturnRecord returnRecord = new ReturnRecord(username, bookId, fine);
        returns.add(returnRecord);
        return returnRecord;
    }

    public static List<ReturnRecord> getUserReturns(String username) {
        List<ReturnRecord> result = new ArrayList<>();
        for (ReturnRecord r : returns) {
            if (r.getUsername().equals(username)) {
                result.add(r);
            }
        }
        return result;
    }

    public static ReturnRecord getByReturnId(String returnId) {
        for (ReturnRecord r : returns) {
            if (r.getReturnId().equals(returnId)) {
                return r;
            }
        }
        return null;
    }
}
