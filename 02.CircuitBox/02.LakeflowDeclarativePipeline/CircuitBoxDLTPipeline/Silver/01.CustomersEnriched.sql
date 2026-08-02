CREATE OR REFRESH STREAMING TABLE CIRCUIT.SILVER.CUSTOMERS_ENRICHED
(
    -- CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION FAIL UPDATE,
    CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_customer_first_name EXPECT (first_name IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_customer_last_name EXPECT (last_name IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_telephone EXPECT (length(telephone) >=10),
    -- CONSTRAINT valid_email EXPECT (email IS NOT NULL),
    CONSTRAINT valid_email EXPECT (email IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT valid_date_of_birth EXPECT (date_of_birth >= '1900-01-01')
)
TBLPROPERTIES ('layer' = 'silver')
AS
SELECT
customer_id,
split(customer_name,' ')[0] AS first_name,
split(customer_name,' ')[1] AS last_name,
date(date_of_birth),
email,
telephone,
created_date,
current_timestamp() AS load_timestamp
FROM STREAM(CIRCUIT.BRONZE.CUSTOMERS_RAW)