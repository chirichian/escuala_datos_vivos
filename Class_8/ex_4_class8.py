from pyspark.sql.session import SparkSession
from pyspark.context import SparkContext
sc = SparkContext('local')

from pyspark.sql import HiveContext
hc = HiveContext(sc)

# Create a Spark session
spark = SparkSession(sc)

# Read Parquet files
results_csv = "hdfs://172.17.0.2:9000/ingest/results.csv"
drivers_csv = "hdfs://172.17.0.2:9000/ingest/drivers.csv"
constructors_csv = "hdfs://172.17.0.2:9000/ingest/constructors.csv"

#Load data
df_res = spark.read.option("header", True).csv(results_csv)
df_res = df_res.withColumn("points", df_res["points"].cast("integer"))

df_driv = spark.read.option("header", True).csv(drivers_csv)

df_cons = spark.read.option("header", True).csv(constructors_csv)

#join drivers and results
drivers_res = df_res.join(df_driv, df_res.driverId == df_driv.driverId)
#select columns
drivers_res= drivers_res.select(drivers_res.forename, drivers_res.surname, drivers_res.nationality, drivers_res.points, df_res.driverId)
#group by drivers sum point
most_point = df_res.groupBy("driverId").sum("points").orderBy("sum(points)", ascending=False)
#filter columns > than 0
most_point = most_point.filter(most_point["sum(points)"] > 0)

#Filter drivers with most points
drivers_load = drivers_res.filter(drivers_res.driverId == most_point.driverId).select(drivers_res.forename,drivers_res.surname,drivers_res.nationality,drivers_res.points)

##Creamos una vista con la data filtrada###
drivers_load.createOrReplaceTempView("drivers_load_view")

#Insert data into table
##insertamos el DF filtrado en la tabla tripdata_table
hc.sql("insert into f1.driver_results select * from drivers_load_view;")