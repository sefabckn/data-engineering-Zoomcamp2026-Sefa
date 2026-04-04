WITH source AS (
    SELECT * FROM {{source("taxi_rides_ny", 'green_tripdata')}}
),
renamed_cols as (
    SELECT 

    -- Identifiers
    cast(VendorID as integer) as vendor_id,
    RatecodeID  as rate_code_id,
    cast(PULocationID as integer) as pickup_location_id,
    cast(DOLocationID as integer) as dropoff_location_id,

    --timestamps
    cast(lpep_pickup_datetime as timestamp) as pickup_datetime,
    cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime,

    --trip info 
    cast(store_and_fwd_flag as string) as store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count,
    cast(trip_distance as numeric) as trip_distance,

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(ehail_fee as numeric) as ehail_fee,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    FROM {{ source('taxi_rides_ny', 'green_tripdata')}}
    WHERE VendorID IS NOT NULL
)
SELECT * FROM renamed_cols

