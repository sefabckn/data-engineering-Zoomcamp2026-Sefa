#citybike Table sample
SELECT station_id, name
FROM `bigquery-public-data.new_york_citibike.citibike_stations`
LIMIT 100

# Creating external table referring to gcs path

CREATE OR REPLACE EXTERNAL TABLE `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://taxi-rides-ny-485508-terra-bucket/yellow_tripdata_2019-*.csv',
    'gs://taxi-rides-ny-485508-terra-bucket/yellow_tripdata_2020-*.csv'
  ],
  skip_leading_rows = 1
);

#Creatin non partitioned table
CREATE OR REPLACE TABLE taxi-rides-ny-485508.zoomcamp.yellow_tripdata_non_partitioned
AS
SELECT * FROM `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata`;


#Creating paritioned table based on pickup datetime
CREATE OR REPLACE TABLE taxi-rides-ny-485508.zoomcamp.yellow_tripdata_partitioned
PARTITION BY
  DATE(tpep_pickup_datetime)
AS
SELECT * FROM `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata`


#Querying the non partitioned data table, to test how slow it is
#Bytes processed
-- 1.59 GB
-- Bytes billed
-- 1.59 GB
SELECT DISTINCT(VendorID)
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_non_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30'; 



-- If i run the same query on partitioned table:
-- Bytes processed
-- 105.91 MB
-- Bytes billed
-- 106 MB
SELECT DISTINCT(VendorID)
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30'; 

-- Discovering partitioned table
SELECT table_name, partition_id,total_rows
FROM `taxi-rides-ny-485508.zoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned'



CREATE OR REPLACE TABLE taxi-rides-ny-485508.zoomcamp.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata`

-- Query without clustered table 1,1GB
SELECT count(*) 
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_partitioned` 
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;


-- Query with clustered table : 800MB
SELECT count(*) 
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_partitioned_clustered` 
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;
