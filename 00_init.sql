CREATE SCHEMA carmate;

CREATE TYPE accountstatus AS ENUM('Student', 'Teacher');
CREATE TABLE carmate.user (
    id                  SERIAL          PRIMARY KEY,
    first_name          VARCHAR(255)    NOT NULL,
    last_name           VARCHAR(255)    NOT NULL,
    email_address       VARCHAR(255)    NOT NULL    UNIQUE,
    "password"          BYTEA           NOT NULL,
    account_status      accountstatus   NOT NULL,
    created_at          TIMESTAMP       NOT NULL    DEFAULT NOW(),
    profile_picture     BYTEA           DEFAULT NULL
);

CREATE TABLE carmate.token (
    token       BYTEA       PRIMARY KEY,
    expire_at   TIMESTAMP   NOT NULL,
    user_id     INTEGER     NOT NULL REFERENCES carmate.user(id)
);

CREATE TABLE carmate.message (
    id          SERIAL      PRIMARY KEY,
    sent_at     DATE        NOT NULL,
    "message"   TEXT        NOT NULL,
    is_read     BOOLEAN     NOT NULL DEFAULT FALSE,
    sender_id   INTEGER     NOT NULL REFERENCES carmate.user(id),
    receiver_id INTEGER     NOT NULL REFERENCES carmate.user(id)
);

CREATE TYPE documenttype AS ENUM('Driver', 'Basic');
CREATE TYPE validationstatus AS ENUM('Pending', 'Rejected', 'Approved');
CREATE TABLE carmate.license (
    id                  SERIAL              PRIMARY KEY,
    license_img         BYTEA               NOT NULL,
    document_type       documenttype        NOT NULL DEFAULT 'Basic',
    validation_status   validationstatus    NOT NULL DEFAULT 'Pending',
    published_at        TIMESTAMP           NOT NULL DEFAULT NOW(),
    user_id             INTEGER             REFERENCES carmate.user(id)
);

CREATE TABLE carmate.user_admin (
    user_id INTEGER PRIMARY KEY REFERENCES carmate.user(id)
);

CREATE TABLE carmate.user_banned (
    user_id     INTEGER     PRIMARY KEY REFERENCES carmate.user(id),
    banned_by   INTEGER     NOT NULL    REFERENCES carmate.user(id),
    banned_at   TIMESTAMP   NOT NULL
);

CREATE TABLE carmate.user_email_validated (
    token       BYTEA       PRIMARY KEY,
    expire_at   TIMESTAMP   NOT NULL,
    validated   BOOLEAN     NOT NULL DEFAULT FALSE,
    user_id     INTEGER     NOT NULL REFERENCES carmate.user(id)
);

CREATE TABLE carmate.driver_profile (
    id                  SERIAL      PRIMARY KEY,
    "description"       TEXT        NOT NULL    DEFAULT ' ',
    created_at          TIMESTAMP   NOT NULL    DEFAULT NOW(),
    user_id             INTEGER     NOT NULL    UNIQUE REFERENCES carmate.user(id)
);

CREATE TYPE weekday AS ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
CREATE TABLE carmate.scheduled_carpooling (
    id              SERIAL              PRIMARY KEY,
    label           VARCHAR             NOT NULL DEFAULT ' ',
    starting_point  DOUBLE PRECISION[2] NOT NULL,
    destination     DOUBLE PRECISION[2] NOT NULL,
    start_hour      TIME                NOT NULL,
    start_date      DATE                NOT NULL,
    end_date        DATE                NOT NULL,
    days            weekday[7]          NOT NULL,
    max_passengers  INTEGER             NOT NULL,
    driver_id       INTEGER             NOT NULL REFERENCES carmate.driver_profile(id),

    /* Only in french country */
    CHECK (starting_point[1] >= 41.3 AND starting_point[1] <= 51.1
        AND starting_point[2] >= -5.142 AND starting_point[2] <= 9.561),
    CHECK (destination[1] >= 41.3 AND destination[1] <= 51.1
        AND destination[2] >= -5.142 AND destination[2] <= 9.561)
);

CREATE TABLE carmate.passengers_profile (
    id              SERIAL      PRIMARY KEY,
    "description"   TEXT        NOT NULL    DEFAULT ' ',
    created_at      TIMESTAMP   NOT NULL    DEFAULT NOW(),
    user_id         INTEGER     NOT NULL    UNIQUE REFERENCES carmate.user(id)
);

CREATE TABLE carmate.propose_scheduled_carpooling (
    id              SERIAL              PRIMARY KEY,
    label           VARCHAR             NOT NULL DEFAULT ' ',
    starting_point  DOUBLE PRECISION[2] NOT NULL,
    destination     DOUBLE PRECISION[2] NOT NULL,
    start_date      DATE                NOT NULL,
    end_date        DATE                NOT NULL,
    start_hour      TIME                NOT NULL,
    days            weekday[7]          NOT NULL,
    passenger_id    INTEGER             NOT NULL REFERENCES carmate.passengers_profile(id),

    /* Only in french country */
    CHECK (starting_point[1] >= 41.3 
        AND starting_point[1] <= 51.1
        AND starting_point[2] >= -5.142 
        AND starting_point[2] <= 9.561),
    CHECK (destination[1] >= 41.3 
        AND destination[1] <= 51.1
        AND destination[2] >= -5.142 
        AND destination[2] <= 9.561)
);

CREATE TABLE carmate.review (
    passenger_id           INTEGER     REFERENCES carmate.passengers_profile(id),
    driver_id               INTEGER     REFERENCES carmate.driver_profile(id),
    economic_driving_rating FLOAT       NOT NULL,
    safe_driving_rating     FLOAT       NOT NULL,
    sociability_rating      FLOAT       NOT NULL,
    review                  TEXT        NOT NULL DEFAULT ' ',
    rating_date             TIMESTAMP   NOT NULL,
    updated_rating_date     TIMESTAMP   NOT NULL,

    PRIMARY KEY(passenger_id, driver_id)
);

CREATE TABLE carmate.carpooling (
    id                  SERIAL              PRIMARY KEY,
    starting_point      DOUBLE PRECISION[2] NOT NULL,
    destination         DOUBLE PRECISION[2] NOT NULL,
    max_passengers      INTEGER             NOT NULL DEFAULT 4,
    price               FLOAT(2)            NOT NULL,
    is_canceled         BOOLEAN             NOT NULL DEFAULT FALSE,
    departure_date_time TIMESTAMP           NOT NULL,
    driver_id           INTEGER             NOT NULL REFERENCES carmate.driver_profile(id),

    /* Only in french country */
    CHECK (starting_point[1] >= 41.3 
        AND starting_point[1] <= 51.1
        AND starting_point[2] >= -5.142 
        AND starting_point[2] <= 9.561),
    CHECK (destination[1] >= 41.3 
        AND destination[1] <= 51.1
        AND destination[2] >= -5.142 
        AND destination[2] <= 9.561)
); 

CREATE TABLE carmate.reserve_carpooling (
    user_id                         INTEGER     NOT NULL    REFERENCES carmate.user(id),
    carpooling_id                   INTEGER     NOT NULL    REFERENCES carmate.carpooling(id),
    passenger_code                  INTEGER     NOT NULL,
    passenger_code_validated        BOOLEAN     NOT NULL    DEFAULT FALSE,
    passenger_code_date_validated   TIMESTAMP               DEFAULT NULL,
    canceled                        BOOLEAN     NOT NULL    DEFAULT FALSE,
    
    PRIMARY KEY(user_id, carpooling_id)
);

CREATE OR REPLACE FUNCTION day_of_week_to_int(day weekday)
RETURNS INTEGER AS
$$
BEGIN
  CASE day
    WHEN 'Monday' THEN RETURN 1;
    WHEN 'Tuesday' THEN RETURN 2;
    WHEN 'Wednesday' THEN RETURN 3;
    WHEN 'Thursday' THEN RETURN 4;
    WHEN 'Friday' THEN RETURN 5;
    WHEN 'Saturday' THEN RETURN 6;
    WHEN 'Sunday' THEN RETURN 7;
    ELSE
      RAISE EXCEPTION 'Invalid day_of_week value: %', day;
  END CASE;
END;
$$
LANGUAGE plpgsql;
CREATE CAST(weekday AS integer) WITH FUNCTION day_of_week_to_int(weekday);
