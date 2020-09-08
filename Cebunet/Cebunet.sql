-- phpMyAdmin SQL Dump
-- version 4.1.10
-- http://www.phpmyadmin.net
--
-- Host: 45.32.125.199
-- Generation Time: Sep 08, 2020 at 01:45 AM
-- Server version: 10.1.45-MariaDB-0+deb9u1
-- PHP Version: 5.6.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `wagovpn`
--

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id_from` int(11) NOT NULL,
  `user_id_to` int(11) NOT NULL,
  `content` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_unread` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `message_info`
--

CREATE TABLE IF NOT EXISTS `message_info` (
  `info` varchar(500) NOT NULL,
  `show_info` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`info`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `message_info`
--

INSERT INTO `message_info` (`info`, `show_info`) VALUES
('Using torrent on non-torrent servers is prohibited.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `private-vouchers`
--

CREATE TABLE IF NOT EXISTS `private-vouchers` (
  `code_name` varchar(50) NOT NULL,
  `user_id` int(100) NOT NULL,
  `reseller_id` int(100) NOT NULL,
  `is_used` int(1) NOT NULL,
  `date_used` varchar(50) NOT NULL,
  `time_stamp` text NOT NULL,
  `duration` bigint(50) NOT NULL DEFAULT '0',
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `server_list`
--

CREATE TABLE IF NOT EXISTS `server_list` (
  `server_id` int(255) NOT NULL AUTO_INCREMENT,
  `server_name` varchar(25) NOT NULL,
  `server_ip` varchar(20) NOT NULL,
  `server_category` enum('premium','vip','proxy') NOT NULL DEFAULT 'premium',
  `server_tcp` varchar(15) NOT NULL DEFAULT 'tcp1',
  `server_parser` varchar(255) NOT NULL,
  `status` int(10) NOT NULL,
  PRIMARY KEY (`server_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `value` text NOT NULL,
  `title` text NOT NULL,
  `placeholder` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `name`, `value`, `title`, `placeholder`) VALUES
(1, 'site_name', 'WaGo-G VPN', 'Site Name', 'Site Name'),
(2, 'home_title', 'WELCOME TO WaGo-G VPN', 'Home Title', 'Home Title'),
(3, 'home_message', 'Hello Welcome To WaGo-G VPN', 'Home Message (HTML DISABLED) Warning: Fix homepage with wysiwyg', 'Home Message'),
(4, 'home_theme', 'success', 'Home Theme', 'default | primary | success | info | warning | danger | blue | teal | orange | red'),
(5, 'brand_color', 'yellow', 'Brand Color', 'Color Code'),
(6, 'link_color', 'blue', 'Link Color', 'Color Code'),
(7, 'google_ads', 'Login using your existing account, if you''re not registered contact our team to assist you.', 'Google Ads Code', 'Google Ads Code'),
(8, 'is_maintenance', '0', 'Maintenance Mode (Freeze Accounts)', 'Set value to 1 to freeze all account, otherwise set to 0.');

-- --------------------------------------------------------

--
-- Table structure for table `site_options`
--

CREATE TABLE IF NOT EXISTS `site_options` (
  `email_validation` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `site_options`
--

INSERT INTO `site_options` (`email_validation`) VALUES
(0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(30) NOT NULL DEFAULT '',
  `user_pass` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(50) NOT NULL DEFAULT '',
  `full_name` varchar(50) NOT NULL,
  `regdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ipaddress` varchar(50) NOT NULL DEFAULT '0.0.0.0',
  `lastlogin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `code` varchar(10) NOT NULL,
  `is_validated` tinyint(1) NOT NULL DEFAULT '0',
  `is_vip` tinyint(1) NOT NULL DEFAULT '0',
  `duration` bigint(50) NOT NULL DEFAULT '0',
  `is_reseller` tinyint(1) NOT NULL DEFAULT '0',
  `credits` int(20) NOT NULL DEFAULT '0',
  `upline` int(10) NOT NULL DEFAULT '1',
  `location` text NOT NULL,
  `payment` text NOT NULL,
  `contact` text NOT NULL,
  `frozen` tinyint(1) NOT NULL,
  `vip_duration` bigint(50) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  `is_connected` tinyint(1) NOT NULL DEFAULT '0',
  `user_rank` enum('Admin','Sub Admin','Reseller','Sub Reseller','Client') NOT NULL DEFAULT 'Client',
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `private_duration` bigint(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `user_id` (`user_id`),
  KEY `user_email_2` (`user_email`),
  FULLTEXT KEY `user_email` (`user_email`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2422 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `user_pass`, `user_email`, `full_name`, `regdate`, `ipaddress`, `lastlogin`, `is_active`, `code`, `is_validated`, `is_vip`, `duration`, `is_reseller`, `credits`, `upline`, `location`, `payment`, `contact`, `frozen`, `vip_duration`, `is_admin`, `is_connected`, `user_rank`, `is_private`, `private_duration`) VALUES
(1, 'admin', 'wagovpn', 'admin@wagovpn', 'Super Administrator', '2018-04-21 06:52:22', '178.128.111.213', '2018-09-16 00:39:48', 1, '', 1, 0, 6076980, 0, 99999, 1, 'PH', 'Any', '', 0, 9507660, 1, 0, 'Admin', 1, 5184000),
(2267, 'administrator', 'xdcbdev', 'dev@wagovpn', 'Adminstrator', '2018-06-19 12:23:08', '', '2018-09-13 04:34:56', 1, '', 1, 0, 30603600, 9, 1000000, 1, 'PH', '', '', 0, 33195600, 0, 0, 'Admin', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vip-vouchers`
--

CREATE TABLE IF NOT EXISTS `vip-vouchers` (
  `code_name` varchar(50) NOT NULL,
  `user_id` int(100) NOT NULL,
  `reseller_id` int(100) NOT NULL,
  `is_used` int(1) NOT NULL,
  `date_used` varchar(50) NOT NULL,
  `time_stamp` text NOT NULL,
  `vip_duration` bigint(50) NOT NULL DEFAULT '0',
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE IF NOT EXISTS `vouchers` (
  `code_name` varchar(50) NOT NULL,
  `user_id` int(100) NOT NULL,
  `reseller_id` int(100) NOT NULL,
  `is_used` int(1) NOT NULL,
  `date_used` varchar(50) NOT NULL,
  `time_stamp` text NOT NULL,
  `duration` bigint(50) NOT NULL DEFAULT '0',
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
