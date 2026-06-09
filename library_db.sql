-- Database Creation
CREATE DATABASE IF NOT EXISTS `library_db`;
USE `library_db`;

-- Drop existing tables to avoid conflicts during import
DROP TABLE IF EXISTS `ratings`;
DROP TABLE IF EXISTS `return_records`;
DROP TABLE IF EXISTS `borrows`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `books`;
DROP TABLE IF EXISTS `users`;

-- Table: users
CREATE TABLE `users` (
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role` VARCHAR(20) NOT NULL,
  `address` VARCHAR(255) DEFAULT NULL,
  `date_registered` DATE NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `status_reason` VARCHAR(255) DEFAULT NULL,
  `borrow_limit` INT NOT NULL DEFAULT 5,
  `jumlah_pinjam` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: books
CREATE TABLE `books` (
  `id` VARCHAR(36) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `author` VARCHAR(255) NOT NULL,
  `publisher` VARCHAR(255) NOT NULL,
  `publish_year` INT NOT NULL,
  `stock` INT NOT NULL,
  `cover_url` VARCHAR(255) DEFAULT NULL,
  `description` TEXT,
  `borrowed_count` INT NOT NULL DEFAULT 0,
  `rating_sum` DOUBLE NOT NULL DEFAULT 0.0,
  `rating_count` INT NOT NULL DEFAULT 0,
  `added_date` DATE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: borrows
CREATE TABLE `borrows` (
  `borrow_id` VARCHAR(36) NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `book_id` VARCHAR(36) NOT NULL,
  `borrow_date` DATE NOT NULL,
  `due_date` DATE NOT NULL,
  `days_borrowed` INT NOT NULL,
  PRIMARY KEY (`borrow_id`),
  CONSTRAINT `fk_borrows_user` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  CONSTRAINT `fk_borrows_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: return_records
CREATE TABLE `return_records` (
  `return_id` VARCHAR(36) NOT NULL,
  `return_date` DATE NOT NULL,
  `fine` DOUBLE NOT NULL DEFAULT 0.0,
  `username` VARCHAR(50) NOT NULL,
  `book_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`return_id`),
  CONSTRAINT `fk_returns_user` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  CONSTRAINT `fk_returns_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: ratings
CREATE TABLE `ratings` (
  `username` VARCHAR(50) NOT NULL,
  `book_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`username`, `book_id`),
  CONSTRAINT `fk_ratings_user` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  CONSTRAINT `fk_ratings_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: settings
CREATE TABLE `settings` (
  `setting_key` VARCHAR(50) NOT NULL,
  `setting_value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Initial Data: Settings
INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES ('penaltyPerDay', '2.0');

-- Initial Data: Users
INSERT INTO `users` (`username`, `password`, `role`, `date_registered`, `status`, `status_reason`, `borrow_limit`, `jumlah_pinjam`) 
VALUES ('admin', 'Admin123', 'ADMIN', CURDATE(), 'VERIFIED', 'Pending admin verification', 5, 0);

-- Initial Data: Books
INSERT INTO `books` (`id`, `title`, `author`, `publisher`, `publish_year`, `stock`, `cover_url`, `description`, `borrowed_count`, `rating_sum`, `rating_count`, `added_date`) VALUES
(UUID(), 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 5, '/uploads/CleanCode.webp', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'Effective Java', 'Joshua Bloch', 'Addison-Wesley', 2017, 3, '/uploads/EffectiveJava.jpg', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'Design Patterns', 'Gang of Four', 'Addison-Wesley', 1994, 4, '/uploads/DesignPatterns.jpg', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'The Pragmatic Programmer', 'David Thomas & Andrew Hunt', 'Addison-Wesley', 2019, 6, '/uploads/ThePragmaticProgrammer.jpg', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'Clean Architecture', 'Robert C. Martin', 'Prentice Hall', 2017, 2, '/uploads/CleanArchitecture.jpg', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'Up & Going', 'Kyle Simpson', 'O\'Reilly Media', 2015, 7, '/uploads/UpAndGoing.jpg', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'Refactoring', 'Martin Fowler', 'Addison-Wesley', 2018, 3, '/uploads/Refactoring.webp', 'No description available yet for this book.', 0, 0, 0, CURDATE()),
(UUID(), 'Introduction to Algorithms', 'CLRS', 'MIT Press', 2009, 4, NULL, 'No description available yet for this book.', 0, 0, 0, CURDATE());
