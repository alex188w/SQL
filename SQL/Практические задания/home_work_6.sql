DROP DATABASE IF EXISTS home_work_6;
CREATE DATABASE home_work_6;
USE home_work_6;

/* 1. Создайте таблицу users_old, аналогичную таблице users.
Создайте процедуру, с помощью которой можно переместить любого 
(одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно). */
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old LIKE lesson_4.users;
-- Поверхностное клонирование без копирования данных
DROP PROCEDURE IF EXISTS move_user;
DELIMITER //
CREATE PROCEDURE move_user(user_id INT, OUT tran_result varchar(100))
BEGIN
	
	DECLARE move_check BIT DEFAULT FALSE;
	DECLARE move_code varchar(100);
	DECLARE move_error varchar(100);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET move_check = TRUE;
 		GET stacked DIAGNOSTICS CONDITION 1
			move_code = RETURNED_SQLSTATE, move_error = MESSAGE_TEXT; 		
	END;

	START TRANSACTION;
	    INSERT INTO users_old(id, firstname, lastname, email)
	    SELECT id, firstname, lastname, email FROM lesson_4.users
	    WHERE EXISTS (id = user_id);
	   
	    DELETE FROM lesson_4.users
	    WHERE id = user_id;	   
		
	IF move_check THEN
		SET tran_result = CONCAT('Ошибка перемещения: ', move_code, ' Текст ошибки: ', move_error);
		ROLLBACK;
	ELSE
		SET tran_result = 'Перемещение данного пользователя выполнено.';
		COMMIT;
	END IF;
END//
DELIMITER ;

CALL move_user(135, @tran_result);
SELECT @tran_result;

/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 
 С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 с 18:00 до 00:00 — "Добрый вечер", 
 с 00:00 до 6:00 — "Доброй ночи". */ 
DROP PROCEDURE IF EXISTS hello;
DELIMITER //
CREATE PROCEDURE hello()
BEGIN
	CASE 
		WHEN CURTIME() BETWEEN '06:00:00' AND '11:59:59' THEN
			SELECT 'Доброе утро';
		WHEN CURTIME() BETWEEN '12:00:00' AND '17:59:59' THEN
			SELECT 'Добрый день';
		WHEN CURTIME() BETWEEN '18:00:00' AND '23:59:59' THEN
			SELECT 'Добрый вечер';
		ELSE
			SELECT 'Доброй ночи';
	END CASE;
END //
DELIMITER ;

CALL hello();

/* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, 
 * название таблицы, идентификатор первичного ключа. */
DROP TABLE IF EXISTS logs;
-- таблица logs с атрибутами как в задании
CREATE TABLE logs (table_name varchar(55), time_created timestamp, primary_key_id int) ENGINE = Archive;

USE lesson_4;
-- триггер для таблицы users 
DROP TRIGGER IF EXISTS users_insert;
DELIMITER //
CREATE TRIGGER users_insert BEFORE INSERT ON lesson_4.users 
FOR EACH ROW 
BEGIN 
	INSERT INTO home_work_6.logs (logs.table_name, logs.time_created, logs.primary_key_id) 
	VALUES ('users', curtime(), (SELECT id FROM lesson_4.users ORDER BY id DESC LIMIT 1));
END //
DELIMITER ;

-- триггер для таблицы messages 
DROP TRIGGER IF EXISTS messages_insert;
DELIMITER //
CREATE TRIGGER messages_insert BEFORE INSERT ON lesson_4.messages  
	FOR EACH ROW 
	BEGIN 
		INSERT INTO home_work_6.logs (logs.table_name, logs.time_created, logs.primary_key_id) 
		VALUES ('messages', curtime(), (SELECT m.id FROM lesson_4.messages m ORDER BY id DESC LIMIT 1));
	END //

DELIMITER ;

-- триггер для таблицы communities 
DROP TRIGGER IF EXISTS communities_insert;
DELIMITER //
CREATE TRIGGER communities_insert BEFORE INSERT ON lesson_4.communities  
	FOR EACH ROW 
	BEGIN 
		INSERT INTO home_work_6.logs (logs.table_name, logs.time_created, logs.primary_key_id) 
		VALUES ('communities', curtime(), (SELECT c.id FROM lesson_4.communities c ORDER BY id DESC LIMIT 1));
	END //

DELIMITER //


INSERT INTO lesson_4.users (firstname, lastname, email) VALUES 
('Ivan', 'Ivanovith', 'ivanov@mail.ru');

INSERT INTO lesson_4.communities (name) VALUES ('football');

INSERT INTO lesson_4.messages (from_user_id, to_user_id, body) VALUES 
(3, 8, 'Hello, Hello');



