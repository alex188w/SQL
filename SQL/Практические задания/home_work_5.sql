DROP DATABASE IF EXISTS home_work_5;
CREATE DATABASE home_work_5;
USE home_work_5;

-- 1. Создайте представление, в которое попадет информация о пользователях 
-- (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW v_users AS
SELECT CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь', p.hometown AS 'Город', p.gender AS 'Пол'
FROM lesson_4.users u
JOIN lesson_4.profiles p ON  u.id=p.user_id
WHERE (YEAR(NOW())-YEAR(p.birthday)) < 20;

SELECT * FROM v_users;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
SELECT 	 
	CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь', 
	COUNT(m.id) AS 'кол-во сообщений',
	DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS 'DENSE_RANK'
FROM lesson_4.users u
LEFT JOIN lesson_4.messages m ON  u.id=m.from_user_id
GROUP BY u.id;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и 
-- найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
SELECT 
	id,
	body,
	created_at,	
	TIMEDIFF(LEAD(created_at, 1, 0) OVER(ORDER BY created_at), created_at) AS 'Разница в отправлении'
FROM lesson_4.messages;  
