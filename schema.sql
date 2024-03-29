CREATE TABLE macroareas (
    macroarea_id INTEGER PRIMARY KEY AUTOINCREMENT,
    macroarea_name VARCHAR(30) UNIQUE NOT NULL,
    macroarea_color VARCHAR(6) UNIQUE NOT NULL
);

CREATE TABLE activities (
    activity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    macroarea_id INTEGER NOT NULL,
    activity_name VARCHAR(30) NOT NULL,
    UNIQUE (macroarea_id, activity_name),
    FOREIGN KEY (macroarea_id) REFERENCES macroareas(macroarea_id)
);

CREATE TABLE planned_macroareas (
    planned_macroarea_id INTEGER PRIMARY KEY AUTOINCREMENT,
    macroarea_id INTEGER NOT NULL,
    planned_duration INTEGER NOT NULL,
    week_date INTEGER NOT NULL,
    FOREIGN KEY (macroarea_id) REFERENCES macroareas(macroarea_id),
    UNIQUE (week_date, macroarea_id)
);

CREATE TABLE logged_hours (
    logged_id INTEGER PRIMARY KEY AUTOINCREMENT,
    activity_id INTEGER NOT NULL,
    date_logged INTEGER UNIQUE NOT NULL,
    done BOOLEAN NOT NULL,
    note TEXT,
    CHECK (done IN (0, 1)),
    FOREIGN KEY (activity_id) REFERENCES activities(activity_id)
);
