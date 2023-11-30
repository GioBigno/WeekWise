CREATE DATABASE weekwise;

\c weekwise

CREATE TABLE WeeklySchedule (
    ScheduleID SERIAL PRIMARY KEY,
    DateStart TIMESTAMP NOT NULL,
    DateEnd TIMESTAMP NOT NULL
);

CREATE TABLE Activities (
    ActivityID SERIAL PRIMARY KEY,
    ActivityName VARCHAR(255) NOT NULL
);

CREATE TABLE PlannedHours (
    PlannedID SERIAL PRIMARY KEY,
    ScheduleID INT,
    ActivityID INT,
    PlannedDuration INT NOT NULL,
    FOREIGN KEY (ScheduleID) REFERENCES WeeklySchedule(ScheduleID),
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID)
);

CREATE TABLE LoggedHours (
    LogID SERIAL PRIMARY KEY,
    ScheduleID INT,
    ActivityID INT,
    ActualDuration INT NOT NULL,
    DateLogged DATE NOT NULL,
    FOREIGN KEY (ScheduleID) REFERENCES WeeklySchedule(ScheduleID),
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID)
);
