   -- Show all tables in your database
   SELECT table_name 
   FROM information_schema.tables 
   WHERE table_schema = 'public' 
   ORDER BY table_name;

   -- See all airports
SELECT * FROM airports;

-- See all flights (first 10)
SELECT * FROM flights LIMIT 10;

-- See all passengers (first 10)
SELECT * FROM passengers LIMIT 10;

-- See all bookings
SELECT * FROM bookings;

-- See audit log
SELECT * FROM audit_log;
SELECT 'airports' as table_name, COUNT(*) as row_count FROM airports
UNION ALL
SELECT 'flights', COUNT(*) FROM flights
UNION ALL
SELECT 'passengers', COUNT(*) FROM passengers
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'audit_log', COUNT(*) FROM audit_log;