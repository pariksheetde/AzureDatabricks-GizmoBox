CREATE OR REFRESH STREAMING TABLE CIRCUIT.SILVER.ORDERS_ENRICHED
(
    -- CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
    CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_order_status EXPECT (order_status IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_payment_method EXPECT (payment_method IN ('Credit Card', 'Bank Transfer','PayPal')) ON VIOLATION DROP ROW
)
TBLPROPERTIES ('layer' = 'silver')
AS
SELECT
order_id,
customer_id,
cast(order_timestamp AS timestamp) AS order_timestamp,
payment_method,
items,
order_status,
current_timestamp() AS load_timestamp
FROM STREAM(LIVE.CIRCUIT.BRONZE.ORDERS_RAW)