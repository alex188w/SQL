USE lesson_2;

-- Используя операторы языка SQL, создайте таблицу “sales”. Заполните ее данными
DROP TABLE IF EXISTS 'sales';
CREATE TABLE sales (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	order_date DATE NOT NULL,
	count_product INT NOT NULL	
);

INSERT INTO `sales` (order_date, count_product)
VALUES
('2022-01-01', 156),
('2022-01-02', 180),
('2022-01-03', 21),
('2022-01-04', 124),
('2022-01-05', 341);

-- Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва : 
-- меньше 100 - Маленький заказ
-- от 100 до 300 - Средний заказ
-- больше 300 - Большой заказ
SELECT 
	id AS 'id заказа',	
	CASE 
		WHEN count_product < 50 THEN 'Маленький заказ'
		WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
		WHEN count_product > 300 THEN 'Большой заказ'
		ELSE 'Не определено'
	END AS 'Тип заказа'	
FROM sales;

-- Создайте таблицу “orders”, заполните ее значениями
DROP TABLE IF EXISTS 'orders';
CREATE TABLE orders (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	employee_id VARCHAR(50) NOT NULL,
	amount DECIMAL (5, 2) NOT NULL,
	order_status VARCHAR(50) NOT NULL	
);

INSERT INTO `orders` (employee_id, amount, order_status)
VALUES
('e03', 15.00, 'OPEN'),
('e01', 25.50, 'OPEN'),
('e05', 100.70 , 'CLOSED'),
('e02', 22.18, 'OPEN'),
('e04', 9.50 , 'CANCELLED');

-- Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
-- OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is cancelled»
SELECT 
	id AS 'Номер заказа',		
	employee_id AS 'Работник',
	amount AS 'Сумма заказа',
	order_status AS 'Статус заказа',
	CASE 
		WHEN order_status = 'OPEN' THEN 'Order is in open state'
		WHEN order_status = 'CLOSED' THEN 'Order is closed'
		WHEN order_status = 'CANCELLED' THEN 'Order is cancelled'
		ELSE 'Не определено'
	END AS 'full_order_status'			
FROM orders;

-- null - переменная, которой не присвоено значение, "0" - натуральное число, со значением "0"