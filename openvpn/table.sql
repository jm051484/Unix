SET sql_mode = '';
SET GLOBAL sql_mode = '';
UPDATE mysql.user SET plugin="" WHERE User='root'; -- fixed both; unix_socket - ubuntu default
CREATE DATABASE IF NOT EXISTS openvpn;
USE openvpn;
CREATE TABLE IF NOT EXISTS `user` (
    `user_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
    `user_online` tinyint(1) NOT NULL DEFAULT '0',
PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
CREATE TABLE IF NOT EXISTS `log` (
    `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `user_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
    `log_trusted_ip` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
    `log_trusted_port` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
    `log_remote_ip` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
    `log_remote_port` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
    `log_start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `log_end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    `log_received` float NOT NULL DEFAULT '0',
    `log_send` float NOT NULL DEFAULT '0',
PRIMARY KEY (`log_id`),
KEY `user_id` (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;