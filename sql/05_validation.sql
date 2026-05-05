-- =========================================
-- VALIDATION CHECKS (READ-ONLY)
-- =========================================

-- Row counts
SELECT COUNT(*) FROM raw_data;
SELECT COUNT(*) FROM rides_final;

-- Duplicates (expected: 0 rows)
SELECT booking_id, COUNT(*) 
FROM rides_final
GROUP BY booking_id
HAVING COUNT(*) > 1;

-- Completed rides should have distance & value (expected: 0)
SELECT COUNT(*) AS bad_complete 
FROM rides_final 
WHERE booking_status = 'completed'
AND (ride_distance IS NULL OR booking_value IS NULL);

-- Negative values (expected: 0)
SELECT COUNT(*) AS neg_values
FROM rides_final
WHERE booking_value < 0 OR ride_distance < 0;

-- Distinct checks (sanity)
SELECT DISTINCT vehicle_type FROM rides_final;
SELECT DISTINCT pickup_location FROM rides_final;
SELECT DISTINCT booking_status FROM rides_final;
SELECT DISTINCT payment_method FROM rides_final;

-- Invalid ratings (expected: 0)
SELECT *
FROM rides_final
WHERE driver_rating < 0 OR driver_rating > 5;