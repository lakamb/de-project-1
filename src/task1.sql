DROP TABLE IF EXISTS analysis.dm_rfm_segments;
CREATE TABLE analysis.dm_rfm_segments AS
WITH 
last_usersorder_dt AS (
SELECT user_id, max(order_ts) lastorder_dt
FROM analysis.orders o
LEFT JOIN analysis.orderstatuses s ON o.status = s.id 
WHERE s.KEY = 'Closed'
GROUP BY 1),
countorders AS (
SELECT user_id, count(*) cnt 
FROM analysis.orders o
LEFT JOIN analysis.orderstatuses s ON o.status = s.id 
WHERE s.KEY = 'Closed'
GROUP BY 1),
sumcost AS (
SELECT user_id, sum(cost) AS sumcost
FROM analysis.orders o
LEFT JOIN analysis.orderstatuses s ON o.status = s.id 
WHERE s.KEY = 'Closed'
GROUP BY 1)
SELECT u.id AS user_id,
	   NTILE(5) OVER(ORDER BY COALESCE(lastorder_dt, date'1900-01-01')) AS recency,
	   NTILE(5) OVER(ORDER BY COALESCE(cnt, 0)) AS frequency,
	   NTILE(5) OVER(ORDER BY COALESCE(sumcost, 0)) AS monetary_value
FROM analysis.users u
LEFT JOIN last_usersorder_dt lo ON lo.user_id = u.id
LEFT JOIN countorders co ON co.user_id = u.id
LEFT JOIN sumcost sc ON sc.user_id = u.id;


SELECT * FROM analysis.dm_rfm_segments



