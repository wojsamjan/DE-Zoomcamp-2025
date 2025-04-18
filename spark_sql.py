#!/usr/bin/env python
# coding: utf-8

import argparse

import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql import types


parser = argparse.ArgumentParser()

parser.add_argument('--input_csv_file', required=True)
parser.add_argument('--output_bq_table', required=True)

args = parser.parse_args()

input_csv_file = args.input_csv_file
output_bq_table = args.output_bq_table

spark = SparkSession.builder \
    .appName('dezoomcamp2025') \
    .getOrCreate()

spark.conf.set('temporaryGcsBucket', '<Some temp bucket ex. DATAPROC TEMP BUCKET>')

df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .csv(input_csv_file)

target_columns = [
    'EVENT_UNIQUE_ID',
    'REPORT_DATE',
    'OCC_DATE',
    'REPORT_YEAR',
    'REPORT_MONTH',
    'REPORT_DAY',
    'REPORT_DOW',
    'OCC_YEAR',
    'OCC_MONTH',
    'OCC_DAY',
    'OCC_DOW',
    'DIVISION',
    'LOCATION_TYPE',
    'PREMISES_TYPE',
    'OFFENCE',
    'MCI_CATEGORY',
    'NEIGHBOURHOOD_158'
]
df = df.select(*target_columns)

# Filter out incomplete data & drop duplicates based on 'EVENT_UNIQUE_ID'
df = df.filter(df.OCC_YEAR != 'None').dropDuplicates(['EVENT_UNIQUE_ID'])

# Trim values
df = df.withColumn("REPORT_DOW", F.trim(df.REPORT_DOW))
df = df.withColumn("OCC_DOW", F.trim(df.OCC_DOW))

df.write.format('bigquery').option('table', output_bq_table).mode("overwrite").save()
