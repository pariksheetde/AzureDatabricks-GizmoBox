import dlt
import pyspark.sql.functions as F

@dlt.expect_or_fail('valid_customer_id', 'customer_id is not null')
@dlt.expect_or_drop('valid_address_line_1', 'address_line_1 is not null')
@dlt.expect_or_drop('valid_postcode', 'postcode is not null')

@dlt.table(
    name = 'CIRCUIT.SILVER.ADDRESSES_ENRICHED',
    comment = 'CLEANSED ADDRESSES DATA',
    table_properties = {'quality' : 'silver'}
)

def load_addresses_silver():
    return (
        dlt.read_stream('CIRCUIT.BRONZE.ADDRESSES_RAW')  # Correct way to read an internal DLT stream
           .select(
                'customer_id', 
                'address_line_1', 
                'city', 
                'state', 
                'postcode', 
                F.col('created_date').cast('date')  # Closed parenthesis properly
            )
           .withColumn('ingestion_load_timestamp', F.current_timestamp())
    )