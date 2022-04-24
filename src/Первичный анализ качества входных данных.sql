SELECT table_name FROM information_schema.tables
WHERE table_schema = 'production';
users
products
orderitems
orders
orderstatuslog
orderstatuses;

-- production.users - Пользователи
SELECT *
FROM production.users;

-- 1000	1000 1000
SELECT count(*), count(DISTINCT name), count(DISTINCT login)
FROM production.users;

-- 0
SELECT sum(CASE WHEN name IS NULL OR login IS NULL THEN 1 ELSE 0 END)
FROM production.users;



-- production.products - Справочник продуктов
SELECT *
FROM production.products;

-- 21 21 3
SELECT count(*), count(DISTINCT name), count(DISTINCT price)
FROM production.products;

-- 0 0
SELECT sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END), 
       sum(CASE WHEN price IS NULL THEN 1 ELSE 0 END)
FROM production.products;



-- production.orderitems - Содержания заказов
SELECT *
FROM production.orderitems;

-- 47369
SELECT count(*)
FROM production.orderitems;

-- 0 0 0
SELECT sum(CASE WHEN price IS NULL THEN 1 ELSE 0 END), 
       sum(CASE WHEN discount IS NULL THEN 1 ELSE 0 END),
       sum(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END)
FROM production.orderitems;



-- production.orders - Заказы
SELECT *
FROM production.orders;

-- 60; 6360; 2289.936; 2220.0
SELECT min(cost), max(cost), avg(cost), PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER by cost) median
FROM production.orders;

-- 10000 10000
SELECT count(*), count(DISTINCT order_id)
FROM production.orders;

-- 0
SELECT count(*)
FROM production.orders
WHERE bonus_payment != 0;

-- 0 0 0 0 0
SELECT sum(CASE WHEN bonus_payment IS NULL THEN 1 ELSE 0 END), 
       sum(CASE WHEN payment IS NULL THEN 1 ELSE 0 END), 
       sum(CASE WHEN cost IS NULL THEN 1 ELSE 0 END), 
       sum(CASE WHEN bonus_grant IS NULL THEN 1 ELSE 0 END), 
       sum(CASE WHEN status IS NULL THEN 1 ELSE 0 END)
FROM production.orders;



-- production.orderstatuslog - Лог изменений статосов заказов
SELECT *
FROM production.orderstatuslog;

-- 29982 10000
SELECT max(id), count(DISTINCT order_id)
FROM production.orderstatuslog;

-- 
SELECT status_id, count(*)
FROM production.orderstatuslog
GROUP BY 1;



-- production.orderstatuses - Справочник статусов заказов
SELECT *
FROM production.orderstatuses;

SELECT s.KEY, count(*)
FROM production.orderstatuslog l
LEFT JOIN production.orderstatuses s ON l.status_id = s.id
GROUP BY 1;

