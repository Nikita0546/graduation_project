-- Отключаем проверки для ускорения вставки
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

DELIMITER $$

-- Процедура для заполнения основных таблиц
CREATE PROCEDURE FillBasicTables()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 10000 DO
        -- Вставляем транспорт
        INSERT INTO vehicle (brand, model, gos_number, PTS, STS)
        VALUES (
            ELT(FLOOR(1 + RAND() * 5), 'Kamaz', 'Volvo', 'MAN', 'Scania', 'DAF'),
            ELT(FLOOR(1 + RAND() * 5), 'Model A', 'Model B', 'Model C', 'Model D', 'Model E'),
            CONCAT(CHAR(FLOOR(65 + RAND()*26)), FLOOR(RAND()*999), CHAR(FLOOR(65 + RAND()*26)), CHAR(FLOOR(65 + RAND()*26)), ' ', FLOOR(1000000000 + RAND()*9000000000)),
            CONCAT('PTS', LPAD(i, 12, '0')),
            CONCAT('STS', LPAD(i, 7, '0'))
        );
        
        -- Вставляем контакт
        INSERT INTO contact (full_name, SNILS, TIN, phone)
        VALUES (
            CONCAT('FIO_', i),
            LPAD(FLOOR(RAND()*100000000000), 11, '0'),
            LPAD(FLOOR(RAND()*1000000000000), 12, '0'),
            CONCAT('+7', FLOOR(9000000000 + RAND()*1000000000))
        );
        
        -- Вставляем паспорт
        INSERT INTO passport (series_number, issued, dpt_code, date_issued, full_name, gender, date_of_birth, place_of_birth, Contact_id)
        VALUES (
            LPAD(FLOOR(RAND()*10000000000), 10, '0'),
            CONCAT('Issued_by_', i),
            LPAD(FLOOR(RAND()*1000000), 6, '0'),
            DATE(NOW() - INTERVAL FLOOR(20 + RAND()*50) YEAR),
            CONCAT('FIO_', i),
            IF(RAND() > 0.5, 'M', 'F'),
            DATE(NOW() - INTERVAL FLOOR(20 + RAND()*50) YEAR - INTERVAL FLOOR(1 + RAND()*12) MONTH),
            CONCAT('City_', FLOOR(RAND()*1000)),
            i
        );
        
        -- Вставляем тахограф
        INSERT INTO tachograph (manufacturer, model, serial_number, vehicle_id, contact_id)
        VALUES (
            ELT(FLOOR(1 + RAND() * 5), 'Siemens', 'Stoneridge', 'VDO', 'IntelliFleet', 'EFAS'),
            CONCAT('Model_', FLOOR(RAND()*100)),
            CONCAT('SN', LPAD(i, 14, '0')),
            i,
            i
        );
        
        SET i = i + 1;
    END WHILE;
END$$

-- Процедура для заполнения МЧД
CREATE PROCEDURE FillMRP()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 1000 DO
        INSERT INTO mrp (source_path, date_start, date_end, contact_id)
        VALUES (
            CONCAT('/reports/mrp_', i, '.pdf'),
            NOW() - INTERVAL FLOOR(1 + RAND()*365) DAY,
            NOW() - INTERVAL FLOOR(1 + RAND()*365) DAY + INTERVAL 8 HOUR,
            FLOOR(1 + RAND()*10000)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Процедура для заполнения активаций
CREATE PROCEDURE FillActivations()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 3506 DO
        INSERT INTO activation (contact_id, activation_datetime)
        VALUES (
            FLOOR(1 + RAND()*10000),
            NOW() - INTERVAL FLOOR(1 + RAND()*365) DAY
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Процедура для заполнения ремонтов
CREATE PROCEDURE FillRepairs()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 6405 DO
        INSERT INTO repair (contact_id, tachograph_id, repair_datetime, user_id, description)
        VALUES (
            FLOOR(1 + RAND()*10000),
            FLOOR(1 + RAND()*10000),
            NOW() - INTERVAL FLOOR(1 + RAND()*365) DAY,
            1,
            CONCAT('Repair description ', i)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- Процедура для заполнения калибровок
CREATE PROCEDURE FillCalibrations()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 2065 DO
        INSERT INTO calibration (tachograph_id, calibration_date, next_calibration_date, user_id)
        VALUES (
            FLOOR(1 + RAND()*10000),
            NOW() - INTERVAL FLOOR(1 + RAND()*365) DAY,
            NOW() + INTERVAL 365 DAY,
            1
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Выполняем процедуры
CALL FillBasicTables();
CALL FillMRP();
CALL FillActivations();
CALL FillRepairs();
CALL FillCalibrations();

-- Включаем проверки обратно
SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;