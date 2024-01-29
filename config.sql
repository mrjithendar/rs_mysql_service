-- select user from mysql.user;
-- drop user shipping;

/* create database if not exist */
create database if not exists cities;

/* Create MYSQL USER and Database if not EXISTS */
create user if not exists shipping IDENTIFIED BY 'RoboShop@1';
GRANT ALL ON cities.* TO 'shipping'@'%';
FLUSH PRIVILEGES;

/* switch to database cities */
use cities;

/* Drop tabe if EXISTS */
DROP TABLE IF EXISTS `cities`;
DROP TABLE IF EXISTS `codes`;

/* Create cities table */
CREATE TABLE `cities` (
  `uuid` int(11) NOT NULL AUTO_INCREMENT,
  `country_code` varchar(2) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `region_idx` (`region`),
  KEY `c_code_idx` (`country_code`),
  FULLTEXT KEY `city_idx` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=6223666 DEFAULT CHARSET=latin1;

/* Create codes table */
CREATE TABLE `codes` (
  `uuid` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(2) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `code_idx` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;