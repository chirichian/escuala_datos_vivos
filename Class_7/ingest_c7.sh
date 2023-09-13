#!/bin/bash

echo "remove files from /home/hadoop/landing"
rm /home/hadoop/landing/*.*

#Download data
echo "DOWNLOAD tripdata_2021_01"
wget -P /home/hadoop/landing https://data-engineer-edvai.s3.amazonaws.com/yellow_tripdata_2021-01.parquet

echo "DOWNLOAD tripdata_2021_02"
wget -P /home/hadoop/landing https://data-engineer-edvai.s3.amazonaws.com/yellow_tripdata_2021-02.parquet


echo "copy files from landing to ingest"
/home/hadoop/hadoop/bin/hdfs dfs -put /home/hadoop/landing/*.* /ingest
