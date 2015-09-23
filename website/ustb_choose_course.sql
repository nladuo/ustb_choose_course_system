-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2015-08-28 11:37:24
-- 服务器版本: 5.5.44-0ubuntu0.14.04.1
-- PHP 版本: 5.5.9-1ubuntu4.11

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
(1, 'Windows', NULL, 0.1, 'PC版', NULL),
(2, 'Ubuntu', 'ubuntu-64bit-v0.10.tar.gz', 0.1, 'PC版 64bit(仅在ubuntu14.04-destop-LTS做过测试)使用方法:进入解压后的目录,输入命令:chmod +x ./install.sh & sudo bash ./install.sh & chmod +x USTB选课系统', '0.10版本发布'),
(3, 'Mac', NULL, 0.1, 'PC版 clang-64bit（mac版记住密码不管用，尝试解决方法：打开命令行，输入sudo chmod -R 777，然后把程序拖到控制台中，输入电脑root密码，就可以了）（如果实在不行的话，可以联系我。）', NULL),
(4, 'Android', NULL, 0, '移动版(正在完善中)', NULL),
(5, 'iOS', NULL, 0, '移动版(正在完善中)', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `message_board`
--

CREATE TABLE IF NOT EXISTS `message_board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nickname` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
