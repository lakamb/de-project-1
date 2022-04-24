DROP VIEW analysis.orders;
CREATE VIEW analysis.orders AS (
SELECT o.order_id, o.order_ts, o.user_id, o.bonus_payment, o.payment, o.cost, o.bonus_grant, stid.status_id AS status
FROM production.orders o
LEFT JOIN (
	SELECT order_id, status_id
	FROM (
		SELECT order_id, status_id, dttm, max(dttm) over(PARTITION BY order_id) max_dttm
		FROM production.OrderStatusLog) t
		WHERE dttm = max_dttm) stid -- status_id/Стыд за такой несуразный запрос
		ON stid.order_id = o.order_id);
		
SELECT * FROM analysis.orders