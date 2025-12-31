-- Script SQL para crear la base de datos y tablas
-- Ejecuta este script en tu servidor MySQL antes de iniciar el recurso

-- Crear base de datos (opcional, puedes usar una existente)
CREATE DATABASE IF NOT EXISTS mta_login CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE mta_login;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registerDate DATETIME NOT NULL,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Crear tabla de personajes
CREATE TABLE IF NOT EXISTS characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 18,
    gender INT NOT NULL DEFAULT 0,
    skin INT NOT NULL DEFAULT 0,
    money INT NOT NULL DEFAULT 5000,
    created DATETIME NOT NULL,
    posX FLOAT DEFAULT 1959.55,
    posY FLOAT DEFAULT -1714.46,
    posZ FLOAT DEFAULT 10.0,
    rotation FLOAT DEFAULT 0.0,
    interior INT DEFAULT 0,
    dimension INT DEFAULT 0,
    lastLogin DATETIME,
    INDEX idx_username (username),
    INDEX idx_char_id (id),
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

