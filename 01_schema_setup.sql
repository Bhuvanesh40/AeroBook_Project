-- Create the database (Run this directly in pgAdmin or terminal first)
-- CREATE DATABASE aerobook;

-- Connect to aerobook in VS Code SQLTools, then run:

-- 1. Airports Table
CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    timezone VARCHAR(50) NOT NULL
);

-- 2. Flights Table (Using Postgres specific types)
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(10) UNIQUE NOT NULL,
    origin CHAR(3) REFERENCES airports(airport_code),
    destination CHAR(3) REFERENCES airports(airport_code),
    departure_time TIMESTAMPTZ NOT NULL, -- Timezone aware timestamp
    arrival_time TIMESTAMPTZ NOT NULL,
    base_price NUMERIC(10, 2) NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    CONSTRAINT chk_seats CHECK (available_seats >= 0 AND available_seats <= total_seats)
);

-- 3. Passengers Table
CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    loyalty_tier VARCHAR(20) DEFAULT 'Bronze',
    loyalty_points INT DEFAULT 0
);

-- 4. Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    flight_id INT REFERENCES flights(flight_id),
    booking_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Confirmed', -- Confirmed, Cancelled, Completed
    total_amount NUMERIC(10, 2) NOT NULL,
    CONSTRAINT chk_status CHECK (status IN ('Confirmed', 'Cancelled', 'Completed'))
);

-- 5. Audit Log Table (For Triggers)
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    action_type VARCHAR(10), -- INSERT, UPDATE, DELETE
    action_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB, -- Postgres JSONB type for flexible storage
    new_data JSONB
);