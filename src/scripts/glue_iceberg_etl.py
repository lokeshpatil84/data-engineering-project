import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql import SparkSession


args = getResolvedOptions(sys.argv, ['JOB_NAME', 'iceberg_s3_path', 'db_url', 'db_user', 'db_password'])

# Spark Session settings for Iceberg
spark = SparkSession.builder \
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
    .config("spark.sql.catalog.glue_catalog", "org.apache.iceberg.spark.SparkCatalog") \
    .config("spark.sql.catalog.glue_catalog.warehouse", args['iceberg_s3_path']) \
    .config("spark.sql.catalog.glue_catalog.catalog-impl", "org.apache.iceberg.aws.glue.GlueCatalog") \
    .config("spark.sql.catalog.glue_catalog.io-impl", "org.apache.iceberg.aws.s3.S3FileIO") \
    .getOrCreate()

glueContext = GlueContext(SparkContext.getOrCreate())
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# 1. Read from PostgreSQL
jdbc_url = args['db_url']
db_properties = {
    "user": args['db_user'],
    "password": args['db_password'],
    "driver": "org.postgresql.Driver"
}


df_postgres = spark.read.jdbc(url=jdbc_url, table="public.employees", properties=db_properties)
print("Data read from Postgres successfully.")

# 2. Write to Iceberg 
df_postgres.writeTo("glue_catalog.iceberg_lake_db.employees_iceberg") \
    .tableProperty("format-version", "2") \
    .createOrReplace()
    
print("Data written to Iceberg successfully.")

job.commit()