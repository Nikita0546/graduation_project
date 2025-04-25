-- Создание базы данных
CREATE DATABASE IF NOT EXISTS `center` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `center`;

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    account_type ENUM('admin', 'operator', 'master') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Добавление администратора
INSERT INTO users (username, password, account_type) 
VALUES ('admin', 'admin', 'admin');

-- Основные таблицы
CREATE TABLE IF NOT EXISTS client (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    legal_entity BIT(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Добавление значений для legal_entity
INSERT INTO client (legal_entity) VALUES (0), (1);

CREATE TABLE IF NOT EXISTS vehicle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(255) DEFAULT NULL,
    model VARCHAR(255) DEFAULT NULL,
    VIN CHAR(17) DEFAULT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS mrp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_path VARCHAR(255) NOT NULL,
    date_start DATETIME NOT NULL,
    date_end DATETIME NOT NULL,
    Client_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (Client_id) REFERENCES client(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS contact (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    SNILS CHAR(11) DEFAULT NULL UNIQUE,
    TIN CHAR(12) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    PTS CHAR(15) NOT NULL,
    STS CHAR(10) NOT NULL,
    Client_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (Client_id) REFERENCES client(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tachograph (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    serial_number VARCHAR(16) NOT NULL UNIQUE,
    Client_id INT UNSIGNED NOT NULL,
    Vehicle_id INT NOT NULL,
    FOREIGN KEY (Client_id) REFERENCES client(id),
    FOREIGN KEY (Vehicle_id) REFERENCES vehicle(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS passport (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    series_number CHAR(10) NOT NULL UNIQUE,
    issued VARCHAR(255) NOT NULL,
    dpt_code CHAR(6) NOT NULL,
    date_issued DATE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    date_of_birth DATE NOT NULL,
    place_of_birth VARCHAR(255) NOT NULL,
    Contact_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (Contact_id) REFERENCES contact(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Дополнительные таблицы
CREATE TABLE IF NOT EXISTS activation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contact_id INT UNSIGNED NOT NULL,
    activation_datetime DATETIME NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contact(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS repair (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contact_id INT UNSIGNED NOT NULL,
    tachograph_id INT NOT NULL,
    repair_datetime DATETIME NOT NULL,
    user_id INT NOT NULL,
    notes TEXT,
    FOREIGN KEY (contact_id) REFERENCES contact(id),
    FOREIGN KEY (tachograph_id) REFERENCES tachograph(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS calibration (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tachograph_id INT NOT NULL,
    calibration_date DATE NOT NULL,
    next_calibration_date DATE NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (tachograph_id) REFERENCES tachograph(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Индексы
CREATE INDEX idx_calibration_dates ON calibration(calibration_date, next_calibration_date);
CREATE INDEX idx_vehicle_vin ON vehicle(VIN);
CREATE INDEX idx_tachograph_serial ON tachograph(serial_number);