-- Creating External table for 2024 data
CREATE OR REPLACE EXTERNAL TABLE `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata_2024`
OPTIONS (
  format = 'parquet',
  uris = ['gs://taxi-rides-ny-485508-terra-bucket/yellow_tripdata_2024-*.parquet']
);

-- Creating a (regular/materialized) table using the Yellow Taxi Trip Records
CREATE OR REPLACE TABLE `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024` AS
SELECT * FROM `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata_2024`;


-- Query for Q1-What is count of records for the 2024 Yellow Taxi Data?
SELECT count(1) FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`;
--Output: 20332093

-- Query for Q2 Part-1: Estimated amount of data for external table
SELECT COUNT(DISTINCT PULocationID) as count_
FROM `taxi-rides-ny-485508.zoomcamp.external_yellow_tripdata_2024`;
-- Estimation for External table is 0 MB

-- Query for Q2 Part-2: Estimated amount of data for non-partitioned table
SELECT COUNT(DISTINCT PULocationID) as count_
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`;
-- Estimation for External table is 155.12MB


-- Query for Q3: Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. 
-- Now write a query to retrieve the PULocationID and DOLocationID on the same table.
-- Why are the estimated number of Bytes different?

SELECT PULocationID
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`;
-- Estimation for PULocationID is 155.12 MB


SELECT PULocationID, DOLocationID
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`;
-- Estimation for both is 310.24 MB

--Reason: BigQuery is a columnar database, and it only scans the specific columns requested in the query. 
--Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

-- Q4 : How many records have a fare_amount of 0?

SELECT Count(1)
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`
WHERE fare_amount = 0;

-- Output : 8333

--Q5: What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime 
--    and order the results by VendorID (Create a new table with this strategy)


CREATE OR REPLACE TABLE `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * from `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`;

--Q6: Question 6. Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive). 
-- Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from 
-- clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? (1 point)

SELECT DISTINCT VendorID
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
-- Non partitioned table will process 310.24 MB when run.

SELECT DISTINCT VendorID
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024_partitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
-- Partitioned table will process 26.84 MB when run.

-- No Points: Write a SELECT count(*) query FROM the materialized table you created. 
-- Q9 How many bytes does it estimate will be read? Why?

SELECT count(*) 
FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_2024`;

-- Its going to read 0 Bytes
-- COUNT(*) can be answered from table metadata
-- BigQuery does not need to scan any data to compute COUNT(*) on a table.
