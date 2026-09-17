-- B-Tree index for fast lookups on emails
CREATE INDEX idx_passengers_email ON passengers(email);

-- Partial Index: Only index confirmed bookings (saves space, speeds up common queries)
CREATE INDEX idx_bookings_confirmed ON bookings(flight_id) WHERE status = 'Confirmed';
-- Create roles
CREATE ROLE booking_agent;
CREATE ROLE data_analyst;

-- Grant specific permissions
GRANT SELECT, INSERT, UPDATE ON bookings, passengers TO booking_agent;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO data_analyst;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO data_analyst;

-- (Optional) Create actual users and assign roles
-- CREATE USER agent_smith WITH PASSWORD 'password123';
-- GRANT ROLE booking_agent TO agent_smith;