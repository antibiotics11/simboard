DROP DATABASE IF EXISTS `board`;
CREATE DATABASE `board`;
USE `board`;

DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `email`         varchar(320)  NOT NULL,
  `name`          varchar(320)  NOT NULL,
  `password`      char(64)      NOT NULL,
  `is_verified`   tinyint(1)    NOT NULL DEFAULT 0,
  `is_closed`     tinyint(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
  `board_id`      int           NOT NULL AUTO_INCREMENT,
  `board_title`   varchar(255)  NOT NULL,
  `admin_email`   varchar(320)  NOT NULL,
  `created_at`    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `is_deleted`    tinyint(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`board_id`),
  FOREIGN KEY (`admin_email`)   REFERENCES `member` (`email`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `board_id`      int           NOT NULL,
  `article_id`    int           NOT NULL AUTO_INCREMENT,
  `article_title` varchar(255)  NOT NULL,
  `author_email`  varchar(320)  NOT NULL,
  `written_at`    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `view_count`    int           NOT NULL DEFAULT 0,
  `content`       text          NOT NULL,
  `is_deleted`    tinyint(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`article_id`),
  FOREIGN KEY (`board_id`)      REFERENCES `board` (`board_id`) ON DELETE CASCADE,
  FOREIGN KEY (`author_email`)  REFERENCES `member` (`email`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `comment_id`    int           NOT NULL AUTO_INCREMENT,
  `article_id`    int           NOT NULL,
  `commenter_email` varchar(320) NOT NULL,
  `comment_content` text         NOT NULL,
  `commented_at`  timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `is_deleted`    tinyint(1)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_id`),
  FOREIGN KEY (`article_id`)    REFERENCES `article` (`article_id`) ON DELETE CASCADE,
  FOREIGN KEY (`commenter_email`)  REFERENCES `member` (`email`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4
