DROP TABLE IF EXISTS yearly_energy_summary CASCADE;
DROP TABLE IF EXISTS monthly_energy_summary CASCADE;
DROP TABLE IF EXISTS weekly_energy_summary CASCADE;
DROP TABLE IF EXISTS daily_energy_summary CASCADE;
DROP TABLE IF EXISTS alarm_definitions CASCADE;
DROP TABLE IF EXISTS energy_events CASCADE;
DROP TABLE IF EXISTS alarms_log CASCADE;
DROP TABLE IF EXISTS measurements CASCADE;
DROP TABLE IF EXISTS meters CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS app_users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;


CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    zone VARCHAR(100),
    description TEXT
);


CREATE TABLE meters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location_id INT REFERENCES locations(id),
    medium VARCHAR(50) NOT NULL DEFAULT 'Energy',
    unit VARCHAR(20) NOT NULL DEFAULT 'kWh',
    is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE measurements (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    measurement_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    energy_value NUMERIC(10,2) NOT NULL,
    power_value NUMERIC(10,2),
    voltage NUMERIC(10,2),
    current_value NUMERIC(10,2)
);


CREATE TABLE alarm_definitions (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    alarm_name VARCHAR(100) NOT NULL,
    alarm_type VARCHAR(100) NOT NULL,
    threshold_value NUMERIC(10,2),
    priority VARCHAR(50),
    message TEXT,
    is_enabled BOOLEAN DEFAULT TRUE
);


CREATE TABLE alarms_log (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    alarm_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    alarm_type VARCHAR(100) NOT NULL,
    priority VARCHAR(50),
    message TEXT,
    location_name VARCHAR(100),
    medium VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE energy_events (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    event_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    event_type VARCHAR(100),
    previous_value NUMERIC(10,2),
    current_value NUMERIC(10,2),
    difference NUMERIC(10,2)
);


CREATE TABLE daily_energy_summary (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    summary_date DATE NOT NULL,
    total_energy NUMERIC(12,2),
    avg_power NUMERIC(10,2),
    max_power NUMERIC(10,2)
);


CREATE TABLE weekly_energy_summary (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    week_start DATE NOT NULL,
    total_energy NUMERIC(12,2),
    avg_power NUMERIC(10,2),
    max_power NUMERIC(10,2)
);


CREATE TABLE monthly_energy_summary (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    month_number INT NOT NULL,
    year_number INT NOT NULL,
    total_energy NUMERIC(12,2),
    avg_power NUMERIC(10,2),
    max_power NUMERIC(10,2)
);


CREATE TABLE yearly_energy_summary (
    id SERIAL PRIMARY KEY,
    meter_id INT REFERENCES meters(id),
    year_number INT NOT NULL,
    total_energy NUMERIC(12,2),
    avg_power NUMERIC(10,2),
    max_power NUMERIC(10,2)
);


CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE app_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE
);


CREATE TABLE user_roles (
    user_id INT REFERENCES app_users(id),
    role_id INT REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);


INSERT INTO locations (name, zone, description) VALUES
('Production Hall', 'Plant Zone', 'Main production area'),
('Office Room', 'Office Zone', 'Office and analytics area'),
('Server Room', 'Office Zone', 'IT infrastructure room'),
('Warehouse', 'Plant Zone', 'Storage area'),
('Main Switchboard', 'Plant Zone', 'Main electrical distribution point'),
('HVAC Technical', 'Technical Zone', 'HVAC and technical infrastructure area');


INSERT INTO meters (name, location_id, medium, unit) VALUES
('Energy_Meter_Production', 1, 'Energy', 'kWh'),
('Energy_Meter_Office', 2, 'Energy', 'kWh'),
('Energy_Meter_ServerRoom', 3, 'Energy', 'kWh'),
('Energy_Meter_Warehouse', 4, 'Energy', 'kWh'),
('Energy_Meter_MainSwitchboard', 5, 'Energy', 'kWh'),
('Energy_Meter_HVAC', 6, 'Energy', 'kWh');


INSERT INTO roles (role_name) VALUES
('Administrator'),
('Engineer'),
('Operator'),
('Analyst');


INSERT INTO app_users (username, password_hash, full_name) VALUES
('admin1', 'admin123', 'EMS Administrator'),
('engineer1', 'engineer123', 'EMS Engineer 1'),
('engineer2', 'engineer123', 'EMS Engineer 2'),
('operator1', 'operator123', 'EMS Operator 1'),
('operator2', 'operator123', 'EMS Operator 2'),
('analyst1', 'analyst123', 'EMS Analyst');


INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 3),
(5, 3),
(6, 4);


INSERT INTO measurements 
(meter_id, measurement_time, energy_value, power_value, voltage, current_value)
VALUES
(1, CURRENT_TIMESTAMP - INTERVAL '24 hours', 120.50, 15.20, 230.00, 12.40),
(1, CURRENT_TIMESTAMP - INTERVAL '21 hours', 135.80, 16.70, 229.50, 13.10),
(1, CURRENT_TIMESTAMP - INTERVAL '18 hours', 158.30, 18.40, 231.00, 14.20),
(1, CURRENT_TIMESTAMP - INTERVAL '15 hours', 180.00, 20.10, 230.70, 15.80),
(1, CURRENT_TIMESTAMP - INTERVAL '12 hours', 210.30, 22.50, 231.00, 18.20),
(1, CURRENT_TIMESTAMP - INTERVAL '9 hours', 240.00, 19.30, 228.00, 16.50),
(1, CURRENT_TIMESTAMP - INTERVAL '6 hours', 270.50, 21.20, 230.20, 17.10),
(1, CURRENT_TIMESTAMP - INTERVAL '3 hours', 310.00, 25.50, 232.00, 20.40),

(2, CURRENT_TIMESTAMP - INTERVAL '24 hours', 45.80, 4.90, 229.00, 5.10),
(2, CURRENT_TIMESTAMP - INTERVAL '18 hours', 52.30, 5.40, 228.50, 5.60),
(2, CURRENT_TIMESTAMP - INTERVAL '12 hours', 61.20, 6.20, 229.80, 6.10),
(2, CURRENT_TIMESTAMP - INTERVAL '6 hours', 70.50, 7.10, 230.10, 6.90),

(3, CURRENT_TIMESTAMP - INTERVAL '24 hours', 210.30, 20.50, 231.00, 18.20),
(3, CURRENT_TIMESTAMP - INTERVAL '18 hours', 235.00, 22.10, 231.50, 19.40),
(3, CURRENT_TIMESTAMP - INTERVAL '12 hours', 260.80, 24.30, 232.00, 20.20),
(3, CURRENT_TIMESTAMP - INTERVAL '6 hours', 300.10, 27.70, 232.50, 22.40),

(4, CURRENT_TIMESTAMP - INTERVAL '24 hours', 80.00, 9.30, 228.00, 8.50),
(4, CURRENT_TIMESTAMP - INTERVAL '18 hours', 92.40, 10.10, 228.30, 9.00),
(4, CURRENT_TIMESTAMP - INTERVAL '12 hours', 105.70, 11.20, 229.00, 9.80),
(4, CURRENT_TIMESTAMP - INTERVAL '6 hours', 120.60, 12.40, 229.50, 10.40),

(5, CURRENT_TIMESTAMP - INTERVAL '24 hours', 300.00, 30.20, 230.00, 25.40),
(5, CURRENT_TIMESTAMP - INTERVAL '18 hours', 340.00, 32.80, 231.00, 27.10),
(5, CURRENT_TIMESTAMP - INTERVAL '12 hours', 390.00, 35.60, 232.00, 29.30),
(5, CURRENT_TIMESTAMP - INTERVAL '6 hours', 430.00, 38.90, 233.00, 31.20),

(6, CURRENT_TIMESTAMP - INTERVAL '24 hours', 150.00, 14.20, 228.00, 13.40),
(6, CURRENT_TIMESTAMP - INTERVAL '18 hours', 170.00, 16.10, 229.00, 14.60),
(6, CURRENT_TIMESTAMP - INTERVAL '12 hours', 195.00, 18.50, 230.00, 16.10),
(6, CURRENT_TIMESTAMP - INTERVAL '6 hours', 220.00, 20.20, 230.50, 17.70);


INSERT INTO alarm_definitions
(meter_id, alarm_name, alarm_type, threshold_value, priority, message)
VALUES
(1, 'High_Power', 'Above Setpoint', 300.00, 'High', 'Przekroczenie dopuszczalnego progu mocy'),
(1, 'Low_Voltage', 'Below Setpoint', 210.00, 'Medium', 'Zbyt niskie napięcie na liczniku'),
(1, 'No_Data', 'Bad Quality / No Data', NULL, 'Medium', 'Brak danych pomiarowych z licznika'),
(1, 'Energy_Spike', 'Anomaly', 500.00, 'High', 'Wykryto nienaturalny skok zużycia energii'),

(2, 'High_Power', 'Above Setpoint', 80.00, 'Medium', 'Przekroczenie mocy w strefie biurowej'),
(3, 'High_Power', 'Above Setpoint', 250.00, 'High', 'Wysokie zużycie energii w serwerowni'),
(4, 'High_Power', 'Above Setpoint', 150.00, 'Medium', 'Przekroczenie mocy w magazynie'),
(5, 'High_Power', 'Above Setpoint', 400.00, 'Critical', 'Przekroczenie mocy na głównej rozdzielni'),
(6, 'Low_Voltage', 'Below Setpoint', 210.00, 'Medium', 'Spadek napięcia w strefie HVAC');


INSERT INTO alarms_log
(meter_id, alarm_type, priority, message, location_name, medium, is_active)
VALUES
(1, 'High_Power', 'High', 'Przekroczenie mocy dla Meter_01', 'Production Hall', 'Energy', TRUE),
(1, 'Low_Voltage', 'Medium', 'Zbyt niskie napięcie dla Meter_01', 'Production Hall', 'Energy', TRUE),
(3, 'High_Power', 'High', 'Wysokie zużycie energii w serwerowni', 'Server Room', 'Energy', FALSE),
(5, 'Energy_Spike', 'Critical', 'Nienaturalny skok zużycia energii na rozdzielni', 'Main Switchboard', 'Energy', TRUE);


INSERT INTO energy_events
(meter_id, event_type, previous_value, current_value, difference)
VALUES
(1, 'Energy increase', 100.00, 120.50, 20.50),
(1, 'Energy spike', 120.50, 180.00, 59.50),
(2, 'Energy increase', 40.00, 45.80, 5.80),
(3, 'Energy increase', 190.00, 210.30, 20.30),
(5, 'Energy spike', 300.00, 430.00, 130.00);


INSERT INTO daily_energy_summary
(meter_id, summary_date, total_energy, avg_power, max_power)
VALUES
(1, CURRENT_DATE, 310.00, 19.80, 25.50),
(2, CURRENT_DATE, 70.50, 5.90, 7.10),
(3, CURRENT_DATE, 300.10, 23.70, 27.70),
(4, CURRENT_DATE, 120.60, 10.75, 12.40),
(5, CURRENT_DATE, 430.00, 34.40, 38.90),
(6, CURRENT_DATE, 220.00, 17.25, 20.20);


INSERT INTO weekly_energy_summary
(meter_id, week_start, total_energy, avg_power, max_power)
VALUES
(1, CURRENT_DATE - INTERVAL '6 days', 2170.00, 20.30, 28.00),
(2, CURRENT_DATE - INTERVAL '6 days', 493.50, 6.10, 8.00),
(3, CURRENT_DATE - INTERVAL '6 days', 2100.70, 24.20, 30.00),
(4, CURRENT_DATE - INTERVAL '6 days', 844.20, 11.10, 14.50),
(5, CURRENT_DATE - INTERVAL '6 days', 3010.00, 35.00, 42.00),
(6, CURRENT_DATE - INTERVAL '6 days', 1540.00, 18.40, 22.30);


INSERT INTO monthly_energy_summary
(meter_id, month_number, year_number, total_energy, avg_power, max_power)
VALUES
(1, EXTRACT(MONTH FROM CURRENT_DATE), EXTRACT(YEAR FROM CURRENT_DATE), 9300.00, 21.20, 32.00),
(2, EXTRACT(MONTH FROM CURRENT_DATE), EXTRACT(YEAR FROM CURRENT_DATE), 2115.00, 6.30, 9.20),
(3, EXTRACT(MONTH FROM CURRENT_DATE), EXTRACT(YEAR FROM CURRENT_DATE), 9003.00, 25.20, 35.00),
(4, EXTRACT(MONTH FROM CURRENT_DATE), EXTRACT(YEAR FROM CURRENT_DATE), 3618.00, 11.40, 16.30),
(5, EXTRACT(MONTH FROM CURRENT_DATE), EXTRACT(YEAR FROM CURRENT_DATE), 12900.00, 36.80, 48.00),
(6, EXTRACT(MONTH FROM CURRENT_DATE), EXTRACT(YEAR FROM CURRENT_DATE), 6600.00, 18.70, 25.40);


INSERT INTO yearly_energy_summary
(meter_id, year_number, total_energy, avg_power, max_power)
VALUES
(1, EXTRACT(YEAR FROM CURRENT_DATE), 111600.00, 22.10, 35.00),
(2, EXTRACT(YEAR FROM CURRENT_DATE), 25380.00, 6.70, 10.00),
(3, EXTRACT(YEAR FROM CURRENT_DATE), 108036.00, 26.40, 38.00),
(4, EXTRACT(YEAR FROM CURRENT_DATE), 43416.00, 12.00, 18.00),
(5, EXTRACT(YEAR FROM CURRENT_DATE), 154800.00, 38.00, 52.00),
(6, EXTRACT(YEAR FROM CURRENT_DATE), 79200.00, 19.40, 28.00);


SELECT 'EMS Energy database initialized successfully' AS status;