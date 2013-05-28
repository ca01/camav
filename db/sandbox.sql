-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 28, 2013 at 11:04 PM
-- Server version: 5.5.29
-- PHP Version: 5.4.6-1ubuntu1.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `sandbox`
--

-- --------------------------------------------------------

--
-- Table structure for table `activetasks_av`
--

CREATE TABLE IF NOT EXISTS `activetasks_av` (
  `actaav_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `actaav_md5` varchar(32) NOT NULL,
  `actaav_sha1` varchar(40) NOT NULL DEFAULT '',
  `actaav_sha256` varchar(64) NOT NULL,
  `actaav_filename` varchar(256) NOT NULL,
  `actaav_filesize` int(11) DEFAULT NULL,
  `actaav_firstSeen` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actaav_filetype_id` int(10) unsigned NOT NULL DEFAULT '0',
  `actaav_path` varchar(256) DEFAULT NULL,
  `actaav_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `actaav_inserttime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actaav_procstarttime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actaav_endtime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `actaav_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`actaav_id`),
  KEY `FK_samples_1` (`actaav_filetype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `antivirus`
--

CREATE TABLE IF NOT EXISTS `antivirus` (
  `av_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `av_name` varchar(45) NOT NULL DEFAULT '',
  `av_active` varchar(45) NOT NULL DEFAULT '0',
  `av_ShowName` varchar(45) NOT NULL DEFAULT '',
  `av_version` varchar(45) NOT NULL,
  `av_lastUpdate` varchar(45) NOT NULL,
  PRIMARY KEY (`av_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `antivirus`
--

INSERT INTO `antivirus` (`av_id`, `av_name`, `av_active`, `av_ShowName`, `av_version`, `av_lastUpdate`) VALUES
(1, 'ClamWin', '1', 'ClamWin', '0.97', '24/10/2011'),
(2, 'F-Secure', '1', 'F-Secure', '9.01', '24/10/2011'),
(3, 'Avast', '1', 'Avast', '4.8', '24/10/2011');

-- --------------------------------------------------------

--
-- Table structure for table `detection`
--

CREATE TABLE IF NOT EXISTS `detection` (
  `det_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `det_sam_id` int(10) unsigned NOT NULL DEFAULT '0',
  `det_av_id` int(10) unsigned NOT NULL DEFAULT '0',
  `det_name` varchar(50) NOT NULL DEFAULT '',
  `det_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `det_av_update` date NOT NULL DEFAULT '0000-00-00',
  `det_result` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`det_id`),
  KEY `FK_detection_1` (`det_sam_id`),
  KEY `FK_detection_2` (`det_av_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `filetypes`
--

CREATE TABLE IF NOT EXISTS `filetypes` (
  `ft_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ft_name` varchar(45) NOT NULL,
  PRIMARY KEY (`ft_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `filetypes`
--

INSERT INTO `filetypes` (`ft_id`, `ft_name`) VALUES
(1, 'other'),
(2, 'exe'),
(3, 'dll');

-- --------------------------------------------------------

--
-- Table structure for table `queue`
--

CREATE TABLE IF NOT EXISTS `queue` (
  `que_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `que_md5` varchar(32) NOT NULL,
  `que_sha1` varchar(40) NOT NULL,
  `que_filename` varchar(256) NOT NULL,
  `que_filesize` int(11) NOT NULL,
  `que_timequeue` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `que_timeout` int(10) unsigned NOT NULL,
  `que_priority` tinyint(3) unsigned NOT NULL,
  `que_uid` int(10) unsigned NOT NULL,
  `que_ip` int(10) unsigned NOT NULL,
  `que_task_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `que_locked` int(1) NOT NULL,
  PRIMARY KEY (`que_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `samples`
--

CREATE TABLE IF NOT EXISTS `samples` (
  `sam_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sam_md5` varchar(32) NOT NULL,
  `sam_sha1` varchar(40) NOT NULL DEFAULT '',
  `sam_sha256` varchar(64) NOT NULL,
  `sam_filename` varchar(256) NOT NULL,
  `sam_filesize` int(11) DEFAULT NULL,
  `sam_firstSeen` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sam_filetype_id` int(10) unsigned NOT NULL DEFAULT '0',
  `sam_path` varchar(256) DEFAULT NULL,
  `sam_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  PRIMARY KEY (`sam_id`),
  KEY `FK_samples_1` (`sam_filetype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `usr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `usr_login` varchar(45) NOT NULL DEFAULT '',
  `usr_password` varchar(45) NOT NULL DEFAULT '',
  `usr_email` varchar(150) NOT NULL DEFAULT '',
  `usr_ip` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`usr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activetasks_av`
--
ALTER TABLE `activetasks_av`
  ADD CONSTRAINT `FK_activetasks_av_1` FOREIGN KEY (`actaav_filetype_id`) REFERENCES `filetypes` (`ft_id`);

--
-- Constraints for table `detection`
--
ALTER TABLE `detection`
  ADD CONSTRAINT `FK_detection_1` FOREIGN KEY (`det_sam_id`) REFERENCES `samples` (`sam_id`),
  ADD CONSTRAINT `FK_detection_2` FOREIGN KEY (`det_av_id`) REFERENCES `antivirus` (`av_id`);

--
-- Constraints for table `samples`
--
ALTER TABLE `samples`
  ADD CONSTRAINT `FK_samples_1` FOREIGN KEY (`sam_filetype_id`) REFERENCES `filetypes` (`ft_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
