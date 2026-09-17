CREATE DATABASE aerobook;-- 2. Flights Table (Using Postgres specific types)
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