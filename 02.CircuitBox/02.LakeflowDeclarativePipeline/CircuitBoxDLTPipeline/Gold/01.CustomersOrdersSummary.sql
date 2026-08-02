CREATE OR REFRESH MATERIALIZED VIEW CIRCUIT.GOLD.CUSTOMERS_ORDERS_SUMMARY
AS
SELECT
oi.customer_id,
cust.first_name,
cust.last_name,
cust.email,
cust.telephone,
addr.address_line_1,
addr.city,
addr.state,
addr.postcode,
sum(oi.item_price * oi.item_quantity) AS total_order_amount,
count(distinct oi.order_id) AS total_orders,
sum(oi.item_quantity) AS total_items
FROM
CIRCUIT.SILVER.ORDERS_ITEMS AS oi INNER JOIN CIRCUIT.SILVER.CUSTOMERS_SCD1 AS cust
ON oi.customer_id = cust.customer_id INNER JOIN CIRCUIT.SILVER.ADDRESSES_SCD2 AS addr
ON addr.customer_id = cust.customer_id
AND addr.`__END_AT` IS NULL
GROUP BY ALL;
