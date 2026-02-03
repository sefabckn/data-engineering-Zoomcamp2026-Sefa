
SELECT
  COUNT(*) AS total_rows
FROM (
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_01`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_02`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_03`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_04`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_05`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_06`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_07`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_08`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_09`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_10`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_11`
  UNION ALL
  SELECT
    unique_row_id
  FROM
    `taxi-rides-ny-485508`.`zoomcamp`.`green_tripdata_2020_12` );
