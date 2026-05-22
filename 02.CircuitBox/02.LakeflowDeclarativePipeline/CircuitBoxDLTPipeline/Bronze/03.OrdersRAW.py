import dlt
import pyspark.sql.functions as F
from pyspark.sql.types import StructType, StructField, IntegerType, StringType, ArrayType, DoubleType

# 1. Define an explicit schema to stop Auto Loader from guessing your rows as columns
orders_schema = StructType([
    StructField("order_id", IntegerType(), True),
    StructField("customer_id", IntegerType(), True),
    StructField("order_timestamp", StringType(), True),
    StructField("payment_method", StringType(), True),
    StructField("order_status", StringType(), True),
    StructField("items", ArrayType(
        StructType([
            StructField("item_id", IntegerType(), True),
            StructField("name", StringType(), True),
            StructField("category", StringType(), True),
            StructField("price", DoubleType(), True),
            StructField("quantity", IntegerType(), True)
        ])
    ), True)
])

@dlt.table(
    name = 'CIRCUIT.BRONZE.ORDERS_RAW',
    comment = 'RAW ORDERS DATA INGESTED VIA CLEANED SCHEMA',
    table_properties = {'quality' : 'bronze'}
)
def load_orders_bronze():
    return (
        spark.readStream
             .format('cloudFiles')
             .option('cloudFiles.format', 'json')
             .option('multiLine', 'true')
             .schema(orders_schema)  # <-- Forces Spark to apply the exact structural format
             .load('/Volumes/circuit/landing/operational_data/orders/')
             .withColumn('file_path', F.col('_metadata.file_path'))
             .withColumn('ingestion_timestamp', F.current_timestamp())
    )
