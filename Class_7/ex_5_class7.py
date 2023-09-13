from pyspark.sql.session import SparkSession
from pyspark.context import SparkContext
sc = SparkContext('local')

from pyspark.sql import HiveContext
hc = HiveContext(sc)

# Create a Spark session
spark = SparkSession(sc)

# Read Parquet files
parquet_path_1 = "hdfs://172.17.0.2:9000/ingest/yellow_tripdata_2021-01.parquet"
parquet_path_2 = "hdfs://172.17.0.2:9000/ingest/yellow_tripdata_2021-02.parquet"

#Load data
df_01 = spark.read.parquet(parquet_path_1)

df_02 = spark.read.parquet(parquet_path_2)

#Data union
df_union = df_01.union(df_02)

# Filter data
df_filter = df_union.filter((df_union.airport_fee.isNotNull())&(df_union.airport_fee !=0))

# Select columns
df_result = df_filter.select(df_filter.tpep_pickup_datetime, df_filter.airport_fee, df_filter.payment_type, df_filter.tolls_amount, df_filter.total_amount)

##Creamos una vista con la data filtrada###
df_result.createOrReplaceTempView("tripdata_vista_result")

#Insert data into table
##insertamos el DF filtrado en la tabla tripdata_table
hc.sql("insert into tripdata.airport_trips select * from tripdata_vista_result;")
