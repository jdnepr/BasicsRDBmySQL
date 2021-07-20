DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

-- users
-- profiles
-- communities
-- communities_users
-- friendship
-- messages
-- posts
-- likes 
-- media

/*
Primary key: pk_(name of the field)
Foreign key: fk_(first letters of the table)_(name of the field)
*/

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

ALTER TABLE `profiles` ADD CONSTRAINT fk_prof_user_id FOREIGN KEY (user_id) REFERENCES users(id);

-- community table, contains name of the community. Versioned
CREATE TABLE communities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    community_name VARCHAR(100) NOT NULL UNIQUE COMMENT "Name of the community",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

-- relation table for groups and users. Versioned
CREATE TABLE communities_users (
	community_id INT UNSIGNED NOT NULL COMMENT "community identifier",
	user_id INT UNSIGNED NOT NULL COMMENT "community identifier",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the row was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the row was updated"
);

ALTER TABLE communities_users ADD CONSTRAINT pk_communities_users PRIMARY KEY (user_id, community_id);
ALTER TABLE communities_users ADD CONSTRAINT fk_com_us_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_com_us_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

-- describes relations of friends/followers. Not versioned
CREATE TABLE friendship(
	user_id INT UNSIGNED NOT NULL COMMENT "primary user identifier",
    friend_id INT UNSIGNED NOT NULL COMMENT "friend user identifier",
    `status` VARCHAR(100) NOT NULL COMMENT "type of friendship",
    requested_at DATETIME DEFAULT NOW() COMMENT "date and time when request for freindship was sent",
    confirmed_at DATETIME COMMENT "time when request for friendship was accepted"
);

ALTER TABLE friendship ADD CONSTRAINT pk_friendship PRIMARY KEY (user_id, friend_id);
ALTER TABLE friendship ADD CONSTRAINT fk_fr_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_fr_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

-- table of messages between users. Versioned
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
ALTER TABLE messages ADD CONSTRAINT fk_msgs_sender_id FOREIGN KEY (sender_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_msgs_receiver_id FOREIGN KEY (receiver_id) REFERENCES users(id);

-- table for posts created by a user or a community
CREATE TABLE posts(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "row identifier",
    user_id INT UNSIGNED NOT NULL COMMENT "identifier of a user who created post",
    community_id INT UNSIGNED NOT NULL COMMENT "identifier of a community which created post",
    post_text VARCHAR(2000) NOT NULL COMMENT "text of the post",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the post was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the post was updated"
);
ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id) REFERENCES users(id); 
ALTER TABLE posts ADD CONSTRAINT fk_posts_community_id FOREIGN KEY (community_id) REFERENCES communities(id); 

-- table for likes for posts/mediafiles
CREATE TABLE likes(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "like identifier",
	entity_id INT UNSIGNED NOT NULL COMMENT "object which is liked",
    entity_type_id INT UNSIGNED NOT NULL COMMENT "type of the object that was liked", -- check dictionary table `entity_itypes`
    like_type_id INT UNSIGNED NOT NULL COMMENT "type of the like - smile, heart, simple like, sad, angry",
    from_user_id INT UNSIGNED NOT NULL COMMENT "user or community identifier that liked the object",
	like_created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the post was created",
    like_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the post was updated"
);

-- dictionary table which is used to identify entity - profile, media file, post
CREATE TABLE entity_types (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    entity_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO entity_types VALUES
	(1, "profiles"),
    (2, "media_files"),
    (3, "posts");

ALTER TABLE likes ADD CONSTRAINT fk_l_entity_type_id FOREIGN KEY (entity_type_id) REFERENCES entity_types(id);

-- dictionary table which is used to identify likes
CREATE TABLE like_types (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    like_name VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO like_types VALUES
	(1, "like"),
    (2, "smile"),
    (3, "cry"),
    (4, "angry"),
    (5, "heart");

ALTER TABLE likes ADD CONSTRAINT fk_l_like_type_id FOREIGN KEY (like_type_id) REFERENCES like_types(id);

CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "media identifier",
    media_type_id INT UNSIGNED NOT NULL COMMENT "media type identifier",
    meta_data JSON NOT NULL COMMENT "file description",
    file_path VARCHAR(1000) NOT NULL COMMENT "path to the mediafile on storage",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the post was created"
);

-- dictionary table which is used to identify media type - picture, audio, video
CREATE TABLE media_types (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
    media_type_name VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO media_types VALUES
	(1, "picture"),
    (2, "audio"),
    (3, "video");
    
ALTER TABLE media ADD CONSTRAINT fk_med_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);

-- describes relations of posts and mediafiles. M to N. Not versioned
CREATE TABLE posts_media(
	post_id INT UNSIGNED NOT NULL COMMENT "post identifier",
    media_id INT UNSIGNED NOT NULL COMMENT "media identifier",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the relation was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the relation was updated"
);

ALTER TABLE posts_media ADD CONSTRAINT pk_posts_media PRIMARY KEY (post_id, media_id);
ALTER TABLE posts_media ADD CONSTRAINT fk_pst_md_post_id FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE posts_media ADD CONSTRAINT fk_pst_md_media_id FOREIGN KEY (media_id) REFERENCES media(id);

-- describes relations of messages and mediafiles. M to N. Not versioned
CREATE TABLE messages_media(
	message_id INT UNSIGNED NOT NULL COMMENT "post identifier",
    media_id INT UNSIGNED NOT NULL COMMENT "media identifier",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Date & time when the relation was created",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Date & time when the relation was updated"
);

ALTER TABLE messages_media ADD CONSTRAINT pk_messages_media PRIMARY KEY (message_id, media_id);
ALTER TABLE messages_media ADD CONSTRAINT fk_msg_md_message_id FOREIGN KEY (message_id) REFERENCES messages(id);
ALTER TABLE messages_media ADD CONSTRAINT fk_msg_md_media_id FOREIGN KEY (media_id) REFERENCES media(id);


SHOW TABLES;

