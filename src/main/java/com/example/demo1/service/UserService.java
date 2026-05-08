package com.example.demo1.service;

import com.example.demo1.model.Book;
import com.example.demo1.model.User;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.util.concurrent.ConcurrentHashMap;

public class UserService {
    private static Map<String, User> users = new ConcurrentHashMap<>();

    static {
        User admin = new User("admin", "Admin123", "ADMIN");
        admin.setStatus("VERIFIED");
        users.put("admin", admin);
    }

    public static List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }

    public static boolean register(String username, String password, String role, String address){
        if (users.containsKey(username)) return false;
        User user = new User(username, password, role);
        user.setAddress(address);
        users.put(username, user);
        return true;
    }

    public static User login(String username, String password){
        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    public static boolean deleteUser(String username){
        if ("admin".equals(username)) {
            return false;
        }
        return users.remove(username) != null;
    }
}
