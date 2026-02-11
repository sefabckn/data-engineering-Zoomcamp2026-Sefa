-- CREATE a ML TAble With Appropriate data types
CREATE or REPLACE TABLE `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
(
  `passenger_count` INTEGER,
  `trip_distance` FLOAT64,
  `PULocationID` STRING,
  `DOLocationID` STRING,
  `payment_type` STRING,
  `fare_amount` FLOAT64,
  `tolls_amount` FLOAT64,
  `tip_amount` FLOAT64
)
AS
(
  SELECT passenger_count, trip_distance, cast(PULocationID AS STRING), CAST(DOLocationID AS STRING),
  CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
  FROM `taxi-rides-ny-485508.zoomcamp.yellow_tripdata_partitioned`
  WHERE fare_amount != 0
);

-- CREATE Model With Defualt Settings
CREATE OR REPLACE MODEL `taxi-rides-ny-485508.zoomcamp.tip_model`
OPTIONS
  (model_type='linear_reg',
  input_label_cols=['tip_amount'] ,-- this is what we want to predict
  DATA_SPLIT_METHOD ='AUTO_SPLIT')
  AS 
  SELECT * 
  FROM `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
  WHERE tip_amount IS NOT NULL;
  

SELECT * FROM ML.FEATURE_INFO(MODEL `taxi-rides-ny-485508.zoomcamp.tip_model`);


-- Evaluate the model
SELECT
*
FROM
ML.EVALUATE(MODEL `taxi-rides-ny-485508.zoomcamp.tip_model`,
(
SELECT
*
FROM
  `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
WHERE
tip_amount IS NOT NULL
));


-- Predict the model

SELECT
*
FROM
ML.PREDICT(MODEL `taxi-rides-ny-485508.zoomcamp.tip_model`,
(
 SELECT * 
 FROM `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
 WHERE tip_amount IS NOT NULL
 ));



-- Predict and Explain
SELECT * 
FROM ML.EXPLAIN_PREDICT(MODEL `taxi-rides-ny-485508.zoomcamp.tip_model`,
(
  SELECT * 
  FROM `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
  WHERE tip_amount IS NOT NULL
), STRUCT(3 as top_k_features));



-- HYPER PARAM TUNING

CREATE Or REPLACE MODEL `taxi-rides-ny-485508.zoomcamp.tip_hyper_model`
OPTIONS
(
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  data_split_method='AUTO_SPLIT',
  num_trials=5,
  max_parallel_trials=2,
  l1_reg = hparam_range(0,20),
  l2_reg = hparam_candidates([0,0.1, 1, 10])) AS 
  
  SELECT * 
  FROM `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
  WHERE tip_amount is not null
;


-- Evaluate hyper tuned model
SELECT * 
FROM ML.EVALUATE(
  MODEL `taxi-rides-ny-485508.zoomcamp.tip_hyper_model`,
(
  SELECT * 
  FROM `taxi-rides-ny-485508.zoomcamp.yellow_trip_data_ml`
  WHERE tip_amount IS NOT NULL
));





