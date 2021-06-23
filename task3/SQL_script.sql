DROP DATABASE IF EXISTS social_nw;
CREATE DATABASE social_nw;
USE social_nw;

-- user table, contains authorisation infromation (except passwords). Versioning included
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    email VARCHAR(100) NOT NULL UNIQUE COMMENT "E-Mail address",
    phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Phone number",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

-- profile table, contains personal user data. Versioning included
CREATE TABLE profile (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    user_id INT UNSIGNED NOT NULL COMMENT "external key: user id",
	first_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Person's name",
	last_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Person's surname",
    gender CHAR(1) NOT NULL COMMENT "Gender",
    birthday DATE COMMENT "Date of birth",
    city VARCHAR(100) COMMENT "City where the person lives",
    country VARCHAR(100) COMMENT "Country where the person lives",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

SELECT CURRENT_TIMESTAMP;

-- user
-- profile
-- community
-- messages