-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2015-10-10 14:13:17
-- 服务器版本: 5.5.44-0ubuntu0.14.04.1
-- PHP 版本: 5.5.9-1ubuntu4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `ustb_choose_course`
--

-- --------------------------------------------------------

--
-- 表的结构 `app`
--

CREATE TABLE IF NOT EXISTS `app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(100) NOT NULL,
  `app_name` varchar(100) DEFAULT NULL,
  `version` double NOT NULL,
  `note` text,
  `update_note` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- 转存表中的数据 `app`
--

INSERT INTO `app` (`id`, `type_name`, `app_name`, `version`, `note`, `update_note`) VALUES
(1, 'Windows', NULL, 0.5, 'PC版', NULL),
(2, 'Linux', 'ustb_choose_course_ubuntu-64bit-v0.50.tar.gz', 0.5, 'PC版 64bit(仅在ubuntu14.04-destop-LTS做过测试)使用方法:进入解压后的目录,输入命令:chmod +x ./install.sh & sudo bash ./install.sh & chmod +x USTB选课系统', NULL),
(3, 'Mac', NULL, 0.5, 'PC版', NULL),
(4, 'Android', NULL, 0, '移动版', NULL),
(5, 'iOS', NULL, 0, '移动版', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `message_board`
--

CREATE TABLE IF NOT EXISTS `message_board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `replyer_name` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `message_board`
--

INSERT INTO `message_board` (`id`, `parent_id`, `nickname`, `replyer_name`, `content`, `time`) VALUES
(1, 0, 'kalen', '  ', '哈哈哈', '2015-10-10 10:36:25'),
(2, 0, '98989', '  ', 'iuiui', '2015-10-10 11:29:53'),
(3, 0, 'dsa', '  ', 'sds', '2015-10-10 12:08:27'),
(4, 1, '倒萨倒萨', 'kalen', '啦啦', '2015-10-10 13:41:20'),
(5, 4, '啦啦爱', '倒萨倒萨', '哈哈', '2015-10-10 13:46:14'),
(6, 1, '3242', 'kalen', '98989', '2015-10-10 13:55:51');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
