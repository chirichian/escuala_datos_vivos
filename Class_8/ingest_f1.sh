#!/bin/bash

#Download data
echo "DOWNLOADING results.csv"
wget -P ../data https://data-engineer-edvai.s3.amazonaws.com/f1/results.csv

echo "DOWNLOAD drivers.csv"
wget -P ../data https://data-engineer-edvai.s3.amazonaws.com/f1/drivers.csv

echo "DOWNLOAD constructors.csv"
wget -P ../data https://data-engineer-edvai.s3.amazonaws.com/f1/constructors.csv

