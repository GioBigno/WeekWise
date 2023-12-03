CREATE DATABASE weekwise;

-- Connect to the weekwise database

CREATE TABLE WeeklySchedule (
    ScheduleID SERIAL PRIMARY KEY,
    DateStart TIMESTAMP NOT NULL,
    DateEnd TIMESTAMP NOT NULL
);

CREATE TABLE MacroAreas (
    MacroAreaID SERIAL PRIMARY KEY,
    MacroAreaName VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Activities (
    ActivityID SERIAL PRIMARY KEY,
    MacroAreaID INT NOT NULL,
    ActivityName VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (MacroAreaID) REFERENCES MacroAreas(MacroAreaID)
);

CREATE TABLE PlannedHours (
    PlannedID SERIAL PRIMARY KEY,
    ScheduleID INT NOT NULL,
    ActivityID INT NOT NULL,
    PlannedDuration INT NOT NULL,
    FOREIGN KEY (ScheduleID) REFERENCES WeeklySchedule(ScheduleID),
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID),
    UNIQUE (ScheduleID, ActivityID)
);

CREATE TABLE LoggedHours (
    ScheduleID INT PRIMARY KEY,
    ActivityID INT NOT NULL,
    DateLogged DATE UNIQUE NOT NULL,
    FOREIGN KEY (ScheduleID) REFERENCES WeeklySchedule(ScheduleID),
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID)
);
