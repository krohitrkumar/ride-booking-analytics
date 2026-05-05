DROP TABLE IF EXISTS rides;

CREATE TABLE rides AS
SELECT
    booking_id,
    customer_id,
    vehicle_type,
    pickup_location,
    drop_location,
    ride_timestamp,
    booking_status,

    CASE WHEN ride_distance ~ '^[0-9.]+$' THEN ride_distance::FLOAT END AS ride_distance,
    CASE WHEN booking_value ~ '^[0-9.]+$' THEN booking_value::FLOAT END AS booking_value,
    CASE WHEN driver_rating ~ '^[0-9.]+$' THEN driver_rating::FLOAT END AS driver_rating,
    CASE WHEN customer_rating ~ '^[0-9.]+$' THEN customer_rating::FLOAT END AS customer_rating,

    payment_method
FROM raw_data;