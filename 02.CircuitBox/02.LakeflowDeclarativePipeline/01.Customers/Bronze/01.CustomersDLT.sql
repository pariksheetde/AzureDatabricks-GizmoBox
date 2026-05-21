CREATE OR REFRESH STREAMING TABLE ecommerce.bronze.orders
TBLPROPERTIES ('quality' = 'bronze')
AS
SELECT
*,
_metadata.file_path AS file_path,
current_timestamp AS ingestion_timestamp
FROM
cloud_files(
    '/Volumes/circuit/landing/operational_data/customers/',
    'json',
    map('cloudFiles.inferColumnTypes', 'true')
)