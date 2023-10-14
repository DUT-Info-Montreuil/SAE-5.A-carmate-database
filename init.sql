CREATE SCHEMA carmate;

CREATE TABLE carmate.user (
    id                  SERIAL          PRIMARY KEY,
    first_name          VARCHAR(255)    NOT NULL,
    last_name           VARCHAR(255)    NOT NULL,
    email_address       VARCHAR(255)    NOT NULL,
    "password"          BYTEA           NOT NULL,
    profile_picture     VARCHAR(255)    DEFAULT ' ',

    CHECK (LENGTH(first_name) BETWEEN 2 AND 255),
    CHECK (LENGTH(last_name) BETWEEN 2 AND 255),
    CHECK (email_address ~* '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
    UNIQUE(email_address)
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

CREATE TABLE student_license (
    license_img     BYTEA   PRIMARY KEY,
    academic_years  DATE[2]
    user_id         INTEGER REFERENCES carmate.user(id)
);

CREATE TABLE teacher_license (
    license_img BYTEA   PRIMARY KEY,
    user_id     INTEGER REFERENCES carmate.user(id)
);

CREATE TABLE carmate.user_admin (
    "user" INTEGER PRIMARY KEY REFERENCES carmate.user(id)
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
    id              SERIAL  PRIMARY KEY,
    "description"   TEXT    NOT NULL DEFAULT ' ',
    user_id         INTEGER NOT NULL REFERENCES carmate.user(id)
);

CREATE TABLE carmate.driver_license (
    license_img         BYTEA   PRIMARY KEY,
    is_validated        BOOLEAN NOT NULL DEFAULT FALSE,
    license_expiration  DATE    NOT NULL,
    user_id             INTEGER NOT NULL REFERENCES carmate.user(id)
);

CREATE TABLE carmate.passengers_profile (
    id              SERIAL  PRIMARY KEY,
    "description"   TEXT    DEFAULT ' ',
    is_validated    BOOLEAN NOT NULL DEFAULT FALSE,
    user_id         INTEGER NOT NULL REFERENCES carmate.user(id)
);

CREATE TABLE rating (
    passengers_id       INTEGER     REFERENCES carmate.passengers_profile(id),
    driver_id           INTEGER     REFERENCES carmate.driver_profile(id),
    rating              FLOAT       NOT NULL,
    review              TEXT        NOT NULL DEFAULT ' ',
    rating_date         TIMESTAMP   NOT NULL,
    updated_rating_date TIMESTAMP   NOT NULL,

    PRIMARY KEY(passengers_id, driver_id)
);

CREATE TABLE carmate.carpooling (
    id                  SERIAL              PRIMARY KEY,
    starting_point      DOUBLE PRECISION[2] NOT NULL,
    destination         DOUBLE PRECISION[2] NOT NULL,
    max_passagers       INTEGER             NOT NULL DEFAULT 4,
    prise               FLOAT(2)            NOT NULL,
    is_canceled         BOOLEAN             NOT NULL DEFAULT FALSE,
    departure_date_time TIMESTAMP           NOT NULL,
    driver_id           INTEGER             NOT NULL REFERENCES carmate.conductor_profile(id),

    /* Only in french country */
    CHECK (starting_point[1] >= 41.3 AND starting_point[1] <= 51.1
        AND starting_point[2] >= -5.142 AND starting_point[2] <= 9.561),
    CHECK (destination[1] >= 41.3 AND destination[1] <= 51.1
        AND destination[2] >= -5.142 AND destination[2] <= 9.561)
); 

CREATE TABLE carmate.reserve_carpooling (
    user_id                 INTEGER     REFERENCES carmate.user(id),
    carpooling_id           INTEGER     REFERENCES carmate.carpooling(id),
    payment_date            TIMESTAMP   NOT NULL,
    passager_code           INTEGER     NOT NULL,
    passager_code_validated BOOLEAN     NOT NULL DEFAULT FALSE,
    canceled                BOOLEAN     NOT NULL DEFAULT FALSE,
    
    PRIMARY KEY(user_id, carpooling_id),
    UNIQUE(passager_code)
);

CREATE TYPE weekday AS ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
CREATE TABLE carmate.scheduled_carpooling (
    id              SERIAL              PRIMARY KEY,
    starting_point  DOUBLE PRECISION[2] NOT NULL,
    destination     DOUBLE PRECISION[2] NOT NULL,
    moment          TIMESTAMP           NOT NULL,
    days_of_week    weekday[]           NOT NULL,
    user_id         INTEGER             NOT NULL REFERENCES carmate.user(id),

    CHECK (array_length(days_of_week, 1) >= 1 AND array_length(days_of_week, 1) <= 7),
    /* Only in french country */
    CHECK (starting_point[1] >= 41.3 AND starting_point[1] <= 51.1
        AND starting_point[2] >= -5.142 AND starting_point[2] <= 9.561),
    CHECK (destination[1] >= 41.3 AND destination[1] <= 51.1
        AND destination[2] >= -5.142 AND destination[2] <= 9.561)
);
