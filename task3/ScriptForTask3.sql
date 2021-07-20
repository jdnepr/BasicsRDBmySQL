DROP DATABASE IF EXISTS social_nw;
CREATE DATABASE social_nw;
USE social_nw;

-- users
-- profiles
-- communitites
-- communitites_users
-- friendship
-- messages
-- posts
-- likes 

-- user table, contains authorisation infromation (except passwords). Versioned
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    email VARCHAR(100) NOT NULL UNIQUE COMMENT "E-Mail address",
    phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Phone number",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

-- profile table, contains personal user data. Versioned
CREATE TABLE `profiles` (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    user_id INT UNSIGNED NOT NULL UNIQUE COMMENT "external key: user id",
	first_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Person's name",
	last_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Person's surname",
    gender CHAR(1) NOT NULL COMMENT "Gender",
    birthday DATE COMMENT "Date of birth",
    city VARCHAR(100) COMMENT "City where the person lives",
    country VARCHAR(100) COMMENT "Country where the person lives",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);

-- Community table, contains name of the community. Versioned
CREATE TABLE communities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    community_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Name of the community",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

-- Relation table for groups and users. Versioned
CREATE TABLE communities_users (
	community_id INT UNSIGNED NOT NULL COMMENT "community identifier",
	user_id INT UNSIGNED NOT NULL COMMENT "community identifier",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

ALTER TABLE communities_users ADD CONSTRAINT pk_communities_users PRIMARY KEY (user_id, community_id);
ALTER TABLE communities_users ADD CONSTRAINT fk_com_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

-- Describes relations of friends/followers. Not versioned
CREATE TABLE friendship(
	user_id INT UNSIGNED NOT NULL COMMENT "community identifier",
    friend_id INT UNSIGNED NOT NULL COMMENT "community identifier",
    `status` VARCHAR(100) NOT NULL COMMENT "type of friendship",
    requested_at DATETIME DEFAULT NOW() COMMENT "date and time when request for freindship was sent",
    confirmed_at DATETIME COMMENT "time when request for friendship was accepted"
);

ALTER TABLE friendship ADD CONSTRAINT pk_friendship PRIMARY KEY (user_id, friend_id);
ALTER TABLE friendship ADD CONSTRAINT fk_fr_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_fr_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

-- Table of messages between users. Versioned
CREATE TABLE messages(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
	`text` VARCHAR(255) COMMENT "",
	sender_id INT UNSIGNED NOT NULL COMMENT "sender identifier",
    receiver_id INT UNSIGNED NOT NULL COMMENT "receiver identifier",
	sent_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the message was sent",
    receiverd_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the message was received",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the message was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the message was updated"
);
ALTER TABLE messages ADD CONSTRAINT fk_sender_id FOREIGN KEY (sender_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_receiver_id FOREIGN KEY (receiver_id) REFERENCES users(id);

-- table for posts created by a user or a community
CREATE TABLE posts(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    creator_id INT UNSIGNED NOT NULL COMMENT "community identifier",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the post was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the post was updated"
);
ALTER TABLE posts ADD CONSTRAINT fk_creator_id FOREIGN KEY (creator_id) REFERENCES users(id); 
-- or REFERENCES communities(id); -> is it possible to have reference from either of the tables?

-- table for likes of posts/mediafiles
CREATE TABLE likes(
	object_id INT UNSIGNED NOT NULL COMMENT "object which is liked",
    user_id INT UNSIGNED NOT NULL COMMENT "user or community identifier that liked the object",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the post was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the post was updated"
);

ALTER TABLE likes ADD CONSTRAINT fk_user_liked_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE likes ADD CONSTRAINT fk_post_id FOREIGN KEY (object_id) REFERENCES posts(id);



SHOW TABLES;




-- user
-- profile
-- community
-- messages