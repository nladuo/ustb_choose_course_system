-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2015-11-02 12:24:51
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
(1, 'Windows', 'win-32bit-v0.12.rar', 0.12, 'PC版', '修复了人数显示的bug，修改了选课后的显示，修改了课表一直都是2014-2015-3的错误。'),
(2, 'Ubuntu', 'ubuntu-64bit-v0.12.tar.gz', 0.12, 'PC版 64bit(仅在ubuntu14.04-destop-LTS做过测试)使用方法:进入解压后的目录,输入命令:chmod +x ./install.sh & sudo bash ./install.sh & chmod +x USTB选课系统', '修复了人数显示的bug，修改了选课后的显示，修改了课表一直都是2014-2015-3的错误。'),
(3, 'Mac', 'mac-64bit-v0.12.zip', 0.12, 'PC版 clang-64bit（mac版记住密码不管用，尝试解决方法：打开命令行，输入sudo chmod -R 777，然后把程序拖到控制台中，输入电脑root密码，就可以了）（如果实在不行的话，可以联系我。）', '修复了人数显示的bug，修改了选课后的显示，修改了课表一直都是2014-2015-3的错误。'),
(4, 'Android', 'android-v0.20.apk', 0.2, '移动版 (android3.0以上版本)', '新增了将课表添加到桌面的功能，可以添加多人的课表，随时看基友、男友、女友的课程安排。'),
(5, 'iOS', 'ios-qrcode-v1.0.jpg', 1, '移动版 (iOS-8.0以上版本可以运行，下载内容为二维码，手机扫描即可，如果没网。访问可能会卡顿。)', ' ');

-- --------------------------------------------------------

--
-- 表的结构 `message_board`
--

CREATE TABLE IF NOT EXISTS `message_board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `replyer_name` text NOT NULL,
  `content` text NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- 转存表中的数据 `message_board`
--

INSERT INTO `message_board` (`id`, `parent_id`, `nickname`, `replyer_name`, `content`, `time`) VALUES
(1, 0, 'cwc', ' ', 'mac版查询课表标题永远是2014-2015-3。。。。。。。', '2015-09-10 20:17:57'),
(2, 0, 'holo@kuluosi.com', ' ', '被坑来一次。。。\r\n这东西可以强行选课和强行退课。\r\n某物理课因为学生名单是老师指定，不能选。但这软件可以选.但,选了就不能退了。\r\n\r\n不喜欢某物理课，不过夜幸好可以强行退课。', '2015-09-14 11:00:14'),
(3, 1, '管理员', 'cwc', '已修复错误。', '2015-10-10 02:23:07'),
(4, 2, '管理员', 'holo@kuluosi.com', '这个是因为学校的选课系统只在前台做了排错处理，却没有在后台没有做排错处理的缘故。', '2015-10-10 02:24:38'),
(5, 1, 'zxl', 'cwc', '你是陈文聪，嘿嘿', '2015-10-10 22:02:17');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
