SELECT * 
FROM {{ source('taxi_rides_ny', 'green_tripdata')}}