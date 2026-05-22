CREATE OR REFRESH STREAMING TABLE CIRCUIT.SILVER.ORDERS_ITEMS
TBLPROPERTIES ('layer' = 'silver')
AS
SELECT 
order_id,
customer_id,
payment_method,
order_status,
item.item_id AS item_id,
item.name AS item_name,
item.category AS category,
item.price AS item_price,
item.quantity AS item_quantity
FROM
(
SELECT 
order_id,
customer_id,
payment_method,
order_status,
explode(items) AS item,
order_timestamp,
load_timestamp
 FROM STREAM(LIVE.CIRCUIT.SILVER.ORDERS_ENRICHED)
)