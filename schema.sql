CREATE DATABASE weekwise;

-- Connect to the weekwise database
\c weekwise

CREATE TABLE weekly_schedule (
    schedule_id SERIAL PRIMARY KEY,
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL
);

CREATE TABLE macroareas (
    macroarea_id SERIAL PRIMARY KEY,
    macroarea_name VARCHAR(255) UNIQUE NOT NULL,
    macroarea_color VARCHAR(6) UNIQUE NOT NULL
);

CREATE TABLE activities (
    activity_id SERIAL PRIMARY KEY,
    macroarea_id INT NOT NULL,
    activity_name VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (macroarea_id) REFERENCES macroareas(macroarea_id)
);

CREATE TABLE planned_hours (
    planned_id SERIAL PRIMARY KEY,
    schedule_id INT NOT NULL,
    activity_id INT NOT NULL,
    planned_duration INT NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES weekly_schedule(schedule_id),
    FOREIGN KEY (activity_id) REFERENCES activities(activity_id),
    UNIQUE (schedule_id, activity_id)
);

CREATE TABLE logged_hours (
    schedule_id INT PRIMARY KEY,
    activity_id INT NOT NULL,
    date_logged DATE UNIQUE NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES weekly_schedule(schedule_id),
    FOREIGN KEY (activity_id) REFERENCES activities(activity_id)
);
