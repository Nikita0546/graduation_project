# Руководство по запуску дипломного проекта

1. **Требования**:
- Python 3.11+ 
- MySQL Server 8.0+ 
- Библиотеки Python: `pymysql`, `tkinter`,`openpyxl`

2. **Установите все для работы**:
     ```bash
    pip install pymysql
    pip install openpyxl 
     ```

3. **Создайте базу данных**:

     ```bash
    mysql -u root -p -e "CREATE DATABASE center CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
     ```

4. **Создайте таблицы**:
     ```bash
    mysql -u root -p center < tables.sql
     ```

   **Аккаунт Администратора**;
   Логин: admin
   Пароль: admin