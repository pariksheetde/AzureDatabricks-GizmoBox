import dlt
import pyspark.sql.functions as F

@dlt.table(
    name = 'CIRCUIT.BRONZE.ADDRESSES_RAW',
    comment = 'RAW ADDRESSES DATA',
    table_properties = {'quality' : 'bronze'}
)

def load_addresses_bronze():
    return (
        spark.readStream
             .format('cloudFiles')
             .option('cloudFiles.format', 'csv')
             .option('cloudFiles.inferColumnTypes', 'true')
             .load('/Volumes/circuit/landing/operational_data/addresses/')
             .select("*")
             .withColumn('input_file_name', F.col('_metadata.file_path'))
             .withColumn('ingestion_load_timestamp', F.current_timestamp())
    )