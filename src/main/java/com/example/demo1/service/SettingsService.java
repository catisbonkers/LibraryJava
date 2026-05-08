package com.example.demo1.service;

import java.util.concurrent.atomic.AtomicReference;

public class SettingsService {
    // Default penalty is 2.00 per day
    private static AtomicReference<Double> penaltyPerDay = new AtomicReference<>(2.00);

    public static double getPenaltyPerDay() {
        return penaltyPerDay.get();
    }

    public static void setPenaltyPerDay(double newPenalty) {
        penaltyPerDay.set(newPenalty);
    }
}
