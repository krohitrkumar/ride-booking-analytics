-- Add timestamp column
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'raw_data'
          AND column_name = 'ride_timestamp'
    ) THEN
        ALTER TABLE raw_data ADD COLUMN ride_timestamp TIMESTAMP;
    END IF;
END $$;

-- Populate timestamp
UPDATE raw_data
SET ride_timestamp = date::timestamp + time::interval
WHERE ride_timestamp IS NULL;

-- Normalize text
UPDATE raw_data
SET
    vehicle_type   = REPLACE(LOWER(TRIM(vehicle_type)), ' ', '_'),
    pickup_location = REPLACE(LOWER(TRIM(pickup_location)), ' ', '_'),
    drop_location   = REPLACE(LOWER(TRIM(drop_location)), ' ', '_'),
    booking_status  = REPLACE(LOWER(TRIM(booking_status)), ' ', '_'),
    payment_method  = REPLACE(LOWER(TRIM(payment_method)), ' ', '_');

-- Fix nulls
UPDATE raw_data SET ride_distance = NULL WHERE LOWER(TRIM(ride_distance)) IN ('', 'null');
UPDATE raw_data SET booking_value = NULL WHERE LOWER(TRIM(booking_value)) IN ('', 'null');
UPDATE raw_data SET driver_rating = NULL WHERE LOWER(TRIM(driver_rating)) IN ('', 'null');
UPDATE raw_data SET customer_rating = NULL WHERE LOWER(TRIM(customer_rating)) IN ('', 'null');