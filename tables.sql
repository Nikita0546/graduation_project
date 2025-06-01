-- Создание базы данных
CREATE DATABASE IF NOT EXISTS `center` 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
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

-- Таблица транспортных средств
CREATE TABLE IF NOT EXISTS vehicle (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    gos_number CHAR(17) NOT NULL UNIQUE,
    PTS CHAR(15) NOT NULL UNIQUE,
    STS CHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица контактов
CREATE TABLE IF NOT EXISTS contact (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    SNILS CHAR(11) UNIQUE,
    TIN CHAR(12) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица МЧД
CREATE TABLE IF NOT EXISTS mrp (
     id INT AUTO_INCREMENT PRIMARY KEY,
    source_path VARCHAR(255) NOT NULL,
    date_start DATETIME NOT NULL,
    date_end DATETIME NOT NULL,
    contact_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contact(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица паспортных данных
CREATE TABLE IF NOT EXISTS passport (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    series_number CHAR(10) NOT NULL UNIQUE,
    issued VARCHAR(255) NOT NULL,
    dpt_code CHAR(6) NOT NULL,
    date_issued DATE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    gender ENUM('М','Ж') NOT NULL,
    date_of_birth DATE NOT NULL,
    place_of_birth VARCHAR(255) NOT NULL,
    Contact_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (Contact_id) 
        REFERENCES contact(id) 
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица тахографов
CREATE TABLE IF NOT EXISTS tachograph (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    manufacturer VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    serial_number VARCHAR(16) NOT NULL UNIQUE,
    vehicle_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id),
    contact_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contact(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица активаций
CREATE TABLE IF NOT EXISTS activation (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    contact_id INT UNSIGNED NOT NULL,
    activation_datetime DATETIME NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (contact_id) 
        REFERENCES contact(id) 
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица ремонтов
CREATE TABLE IF NOT EXISTS repair (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    contact_id INT UNSIGNED NOT NULL,
    tachograph_id INT UNSIGNED NOT NULL,
    repair_datetime DATETIME NOT NULL,
    user_id INT NOT NULL,
    description TEXT,
    FOREIGN KEY (contact_id) 
        REFERENCES contact(id) 
        ON DELETE CASCADE,
    FOREIGN KEY (tachograph_id) 
        REFERENCES tachograph(id) 
        ON DELETE CASCADE,
    FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица калибровок
CREATE TABLE IF NOT EXISTS calibration (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tachograph_id INT UNSIGNED NOT NULL,
    calibration_date DATE NOT NULL,
    next_calibration_date DATE NOT NULL,
    user_id INT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (tachograph_id) 
        REFERENCES tachograph(id) 
        ON DELETE CASCADE,
    FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Индексы
CREATE INDEX idx_mrp_dates ON mrp(date_start, date_end);
CREATE INDEX idx_calibration_schedule ON calibration(calibration_date, next_calibration_date);