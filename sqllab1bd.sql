DROP TABLE IF EXISTS excursions CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS buses CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;

DROP SEQUENCE IF EXISTS seq_customers CASCADE;
DROP SEQUENCE IF EXISTS seq_drivers CASCADE;
DROP SEQUENCE IF EXISTS seq_buses CASCADE;
DROP SEQUENCE IF EXISTS seq_excursions CASCADE;

CREATE SEQUENCE seq_customers START 1;
CREATE SEQUENCE seq_drivers START 1;
CREATE SEQUENCE seq_buses START 1;
CREATE SEQUENCE seq_excursions START 1;

CREATE TABLE customers (
    customer_id INT DEFAULT nextval('seq_customers') PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    debt_amount NUMERIC(10, 2) DEFAULT 0 CHECK (debt_amount >= 0),
    debt_days INT DEFAULT 0 CHECK (debt_days >= 0)
);

CREATE TABLE drivers (
    driver_id INT DEFAULT nextval('seq_drivers') PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    license_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE buses (
    bus_id INT DEFAULT nextval('seq_buses') PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0 AND capacity <= 100),
    gas_per_km NUMERIC(5, 2) NOT NULL CHECK (gas_per_km > 0)
);

CREATE TABLE excursions (
    excursion_id INT DEFAULT nextval('seq_excursions') PRIMARY KEY,
    excursion_date DATE NOT NULL,
    destination VARCHAR(100) NOT NULL,
    distance_km NUMERIC(8, 2) NOT NULL CHECK (distance_km > 0),
    duration_hours INT NOT NULL CHECK (duration_hours > 0),
    tourists_count INT NOT NULL CHECK (tourists_count > 0),
    customer_id INT NOT NULL,
    bus_id INT NOT NULL,
    driver_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (bus_id) REFERENCES buses(bus_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

INSERT INTO customers (name, phone, debt_amount, debt_days) VALUES 
('Школа 10', '+380501234567', 0, 0),
('ТОВ Тревел', '+380679876543', 5000, 15);

INSERT INTO drivers (full_name, license_number) VALUES 
('Іванов Іван', 'ВХ123456'),
('Петров Петро', 'СХ654321');

INSERT INTO buses (plate_number, capacity, gas_per_km) VALUES 
('ВС1234АА', 50, 0.25),
('КА9876ВВ', 30, 0.18);

INSERT INTO excursions (excursion_date, destination, distance_km, duration_hours, tourists_count, customer_id, bus_id, driver_id) VALUES 
('2026-03-01', 'Замок Паланок', 250.5, 8, 45, 1, 1, 1),
('2026-03-05', 'Синевир', 300.0, 10, 25, 2, 2, 2);

SELECT * FROM excursions;