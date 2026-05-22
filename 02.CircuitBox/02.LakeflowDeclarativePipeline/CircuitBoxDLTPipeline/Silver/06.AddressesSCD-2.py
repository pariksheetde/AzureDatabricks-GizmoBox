import dlt
import pyspark.sql.functions as F

# 1. Register the target table properties
dlt.create_streaming_table(
    name = 'CIRCUIT.SILVER.ADDRESSES_SCD2',
    comment = 'SCD TYPE2 ADDRESSES DATA'
)

# 2. Apply your SCD Type 2 logic
dlt.apply_changes(
    target = "CIRCUIT.SILVER.ADDRESSES_SCD2",
    source = "CIRCUIT.SILVER.ADDRESSES_ENRICHED", # Put your actual source table stream name here
    keys = ["customer_id"],
    sequence_by = F.col("created_date"),
    stored_as_scd_type = 2
)