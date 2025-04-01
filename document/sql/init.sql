-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- 主機: localhost
-- 產生時間： 2021 年 09 月 28 日 23:10
-- 伺服器版本: 5.7.32-0ubuntu0.16.04.1
-- PHP 版本： 7.0.33-5+ubuntu16.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `okbom`
--

-- --------------------------------------------------------

--
-- 資料表結構 `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(255) NOT NULL,
  `data` text CHARACTER SET utf8mb4,
  `ip` varchar(45) DEFAULT NULL,
  `agent` varchar(300) DEFAULT NULL,
  `stamp` int(11) DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `sessions`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv`
--

CREATE TABLE IF NOT EXISTS `tbl_adv` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position_id` int(11) NOT NULL,
  `counter` int(11) NOT NULL,
  `exposure` int(11) NOT NULL DEFAULT '0',
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `weight` int(11) NOT NULL DEFAULT '0',
  `theme` varchar(10) DEFAULT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `background` varchar(255) NOT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) NOT NULL,
  `insert_user` int(11) NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`position_id`),
  KEY `uri` (`uri`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_adv`
--

INSERT INTO `tbl_adv` (`id`, `position_id`, `counter`, `exposure`, `status`, `weight`, `theme`, `start_date`, `end_date`, `uri`, `cover`, `background`, `last_ts`, `last_user`, `insert_user`, `insert_ts`) VALUES
(1, 4, 0, 8, 'Enabled', 0, NULL, '2021-06-14 00:08:00', '2021-06-30 00:08:00', '/e/1/usability-testing-workshop', '', '', '2021-06-15 00:09:21', 1, 1, '2021-06-15 00:09:21');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_adv_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- 資料表的匯出資料 `tbl_adv_lang`
--

INSERT INTO `tbl_adv_lang` (`id`, `lang`, `parent_id`, `title`, `subtitle`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, '易用性測試工作坊', '', '', '2021-06-15 00:09:21', 1, '2021-06-15 00:09:21', 1),
(2, 'en', 1, '易用性測試工作坊', '', '', '2021-06-15 00:09:21', 1, '2021-06-15 00:09:21', 1),
(3, 'tw', 2, '易用性測試工作坊', '', '', '2021-06-15 00:09:56', 1, '2021-06-15 00:09:56', 1),
(4, 'en', 2, '易用性測試工作坊', '', '', '2021-06-15 00:09:56', 1, '2021-06-15 00:09:56', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_adv_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_adv_idx` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_adv_meta`
--

INSERT INTO `tbl_adv_meta` (`id`, `parent_id`, `last_ts`, `k`, `v`) VALUES
(1, 1, '2021-06-15 00:09:21', 'btn_txt', '加入我們'),
(2, 1, '2021-06-15 00:09:21', 'event_id', '1'),
(3, 2, '2021-06-15 00:09:56', 'btn_txt', '加入我們'),
(4, 2, '2021-06-15 00:09:56', 'event_id', '1');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author`
--

CREATE TABLE IF NOT EXISTS `tbl_author` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `online_date` date DEFAULT NULL,
  `cover` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_author`
--

INSERT INTO `tbl_author` (`id`, `status`, `slug`, `online_date`, `cover`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(4, 'Enabled', 'soking', NULL, '/upload/img/2021/05/cf4f13c7d1aea42.png', '2021-05-24 05:06:47', 1, '2021-05-24 05:06:47', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_author_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `slogan` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- 資料表的匯出資料 `tbl_author_lang`
--

INSERT INTO `tbl_author_lang` (`id`, `lang`, `parent_id`, `title`, `slogan`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(7, 'tw', 4, 'Soking', '好喔', '<p>咦</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2021-05-24 05:06:47', 1, '2021-05-24 05:06:47', 1),
(8, 'en', 4, '', '', '<p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2021-05-24 05:06:47', 1, '2021-05-24 05:06:47', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_author_tag` (
  `author_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`author_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_bulletin`
--

CREATE TABLE IF NOT EXISTS `tbl_bulletin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `type` enum('Course','Event') NOT NULL DEFAULT 'Course',
  `row_id` int(11) NOT NULL,
  `online_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `body` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_event_idx` (`row_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_bulletin`
--

INSERT INTO `tbl_bulletin` (`id`, `status`, `type`, `row_id`, `online_ts`, `body`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Event', 2, '2021-08-18 03:34:00', '大家記得上課', '2021-08-18 03:34:36', 7, '2021-08-18 03:34:36', 7);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_collection`
--

CREATE TABLE IF NOT EXISTS `tbl_collection` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `txt_color` varchar(10) NOT NULL DEFAULT 'dark',
  `txt_algin` varchar(10) NOT NULL DEFAULT 'left',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_collection_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_collection_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_contact`
--

CREATE TABLE IF NOT EXISTS `tbl_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('New','Process','Done') NOT NULL DEFAULT 'New',
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(250) CHARACTER SET utf8mb4 DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4,
  `other` text,
  `response` text CHARACTER SET utf8mb4 NOT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) NOT NULL,
  `insert_user` int(11) NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_county`
--

CREATE TABLE IF NOT EXISTS `tbl_county` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `county` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tbl_county` (`county`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_county`
--

INSERT INTO `tbl_county` (`id`, `county`) VALUES
(11, '南投縣'),
(17, '南海諸島'),
(12, '嘉義市'),
(13, '嘉義縣'),
(2, '基隆市'),
(4, '宜蘭縣'),
(19, '屏東縣'),
(10, '彰化縣'),
(3, '新北市'),
(5, '新竹市'),
(6, '新竹縣'),
(7, '桃園市'),
(18, '澎湖縣'),
(9, '臺中市'),
(1, '臺北市'),
(15, '臺南市'),
(20, '臺東縣'),
(21, '花蓮縣'),
(8, '苗栗縣'),
(23, '連江縣'),
(22, '金門縣'),
(14, '雲林縣'),
(16, '高雄市');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_course`
--

CREATE TABLE IF NOT EXISTS `tbl_course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sorter` int(11) NOT NULL DEFAULT '99',
  `cover` varchar(255) DEFAULT NULL,
  `hero` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `title` varchar(512) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '課程名稱',
  `period` int(11) NOT NULL DEFAULT '24',
  `content` text CHARACTER SET utf8mb4 COMMENT '課程內容',
  `total_duration` int(11) DEFAULT NULL COMMENT '課程總長度',
  `student_cnt` int(11) NOT NULL DEFAULT '0',
  `section_cnt` int(11) NOT NULL DEFAULT '0',
  `status` enum('Enabled','Disabled') CHARACTER SET utf8mb4 DEFAULT 'Enabled' COMMENT '課程狀態',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_course`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_course_author`
--

CREATE TABLE IF NOT EXISTS `tbl_course_author` (
  `course_id` int(10) UNSIGNED NOT NULL,
  `author_id` int(10) UNSIGNED NOT NULL,
  `sorter` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`author_id`,`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_course_author`
--

INSERT INTO `tbl_course_author` (`course_id`, `author_id`, `sorter`) VALUES
(40, 4, 0);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_course_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_course_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_course_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_course_related`
--

CREATE TABLE IF NOT EXISTS `tbl_course_related` (
  `course_id` int(10) UNSIGNED NOT NULL,
  `related_id` int(10) UNSIGNED NOT NULL,
  `sorter` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`related_id`,`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_course_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_course_tag` (
  `course_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`course_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_crontab`
--

CREATE TABLE IF NOT EXISTS `tbl_crontab` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `freq` enum('Yearly','Monthly','Daily','Hourly','Minutely') NOT NULL DEFAULT 'Yearly',
  `tally` tinyint(4) NOT NULL,
  `module` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_crontab`
--

INSERT INTO `tbl_crontab` (`id`, `freq`, `tally`, `module`, `method`, `status`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(5, 'Minutely', 5, '\\F3CMS\\fVideo', 'checkJob', 'Enabled', '2017-06-13 11:28:50', 0, '2017-06-13 19:28:50', 0),
(6, 'Minutely', 5, '\\F3CMS\\fPress', 'cronjob', 'Enabled', '2017-06-13 11:28:50', 0, '2017-06-13 19:28:50', 0);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_datehelper`
--

CREATE TABLE IF NOT EXISTS `tbl_datehelper` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_datehelper`
--

INSERT INTO `tbl_datehelper` (`id`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22),
(23),
(24),
(25),
(26),
(27),
(28),
(29),
(30),
(31);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_echelon`
--

CREATE TABLE IF NOT EXISTS `tbl_echelon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `event_id` int(11) NOT NULL,
  `start_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deadline` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `address` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_event_idx` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_echelon`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_enrolled`
--

CREATE TABLE IF NOT EXISTS `tbl_enrolled` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0',
  `order_id` int(11) NOT NULL DEFAULT '0',
  `ticket_id` int(11) DEFAULT NULL,
  `course_id` int(11) NOT NULL DEFAULT '0',
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `certificate` enum('Disabled','Enabled') DEFAULT 'Disabled' COMMENT '可領證書',
  `finishd_section` int(11) NOT NULL DEFAULT '0',
  `hwn_cnt` int(11) NOT NULL DEFAULT '0' COMMENT '作業通知數',
  `spent` int(11) NOT NULL DEFAULT '0' COMMENT '耗費秒數',
  `ps` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `enrolled_unique` (`member_id`,`course_id`),
  KEY `org_id` (`order_id`),
  KEY `member_id` (`member_id`),
  KEY `ticket_idx` (`ticket_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_enrolled`
--

INSERT INTO `tbl_enrolled` (`id`, `member_id`, `order_id`, `ticket_id`, `course_id`, `status`, `certificate`, `finishd_section`, `hwn_cnt`, `spent`, `ps`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(2, 34, 19, 19, 40, 'Enabled', 'Disabled', 1, 0, 0, NULL, '2021-08-24 15:52:20', NULL, '2021-08-24 12:39:34', NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_event`
--

CREATE TABLE IF NOT EXISTS `tbl_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cate_id` int(11) NOT NULL DEFAULT '0',
  `status` enum('Draft','Published','Scheduled','Changed','Offlined') NOT NULL DEFAULT 'Draft',
  `mode` enum('Article','Slide') NOT NULL DEFAULT 'Article',
  `on_top` enum('Yes','No') NOT NULL DEFAULT 'No',
  `sorter` int(11) NOT NULL DEFAULT '99',
  `student_cnt` int(11) NOT NULL DEFAULT '0',
  `slug` varchar(255) NOT NULL,
  `online_date` timestamp NULL DEFAULT NULL,
  `cover` varchar(255) NOT NULL,
  `banner` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_event`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_event_author`
--

CREATE TABLE IF NOT EXISTS `tbl_event_author` (
  `event_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `sorter` int(11) NOT NULL DEFAULT '99',
  PRIMARY KEY (`event_id`,`author_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_event_author`
--

INSERT INTO `tbl_event_author` (`event_id`, `author_id`, `sorter`) VALUES
(1, 4, 0),
(2, 4, 0),
(3, 4, 0);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_event_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_event_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `notice` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `assignment` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `assignment_info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_event_lang`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_event_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_event_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_event_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_event_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_event_tag` (
  `event_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`event_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_footprint`
--

CREATE TABLE IF NOT EXISTS `tbl_footprint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL DEFAULT '0',
  `course_id` int(11) NOT NULL DEFAULT '0',
  `section_id` int(11) NOT NULL DEFAULT '0',
  `finished` enum('Yes','No') DEFAULT 'No',
  `finished_ts` timestamp NULL DEFAULT NULL,
  `current` int(11) NOT NULL DEFAULT '0' COMMENT '當前秒數',
  `spent` int(11) NOT NULL DEFAULT '0' COMMENT '耗費秒數',
  `file` varchar(255) DEFAULT NULL,
  `reply` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `footprint_unique` (`member_id`,`course_id`,`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_footprint`
--

INSERT INTO `tbl_footprint` (`id`, `member_id`, `course_id`, `section_id`, `finished`, `finished_ts`, `current`, `spent`, `file`, `reply`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 34, 40, 1354, 'No', NULL, 114, 1833, NULL, NULL, '2021-08-24 15:36:34', NULL, NULL, NULL),
(2, 34, 40, 1353, 'No', NULL, 11, 91, NULL, NULL, '2021-08-17 10:40:26', NULL, NULL, NULL),
(3, 34, 40, 1355, 'Yes', '2021-08-24 15:52:20', 29, 8592, NULL, NULL, '2021-09-09 14:41:43', NULL, NULL, NULL),
(4, 34, 40, 1356, 'Yes', '2021-09-17 05:19:04', 0, 0, '/upload/img/2021/09/a4c239e5f82027a.webp?png', '我來交作業\r\nagain~~~~', '2021-09-17 05:19:04', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_footprint_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_footprint_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_footprint_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_genus`
--

CREATE TABLE IF NOT EXISTS `tbl_genus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Enabled',
  `sorter` tinyint(4) NOT NULL DEFAULT '0',
  `group` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_genus`
--

INSERT INTO `tbl_genus` (`id`, `status`, `sorter`, `group`, `name`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Disabled', 1, 'course', '線上課程', '', '2021-05-23 17:52:35', 1, '2020-10-30 02:36:34', 1),
(2, 'Disabled', 2, 'course', '實體課程', '', '2021-05-23 17:52:40', 1, '2020-10-30 02:36:50', 1),
(3, 'Enabled', 1, 'press', '影音文章', '', '2020-10-30 03:00:26', 1, '2020-10-30 03:00:26', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_homework`
--

CREATE TABLE IF NOT EXISTS `tbl_homework` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL COMMENT '課程外來鍵',
  `lecture_id` int(11) DEFAULT NULL COMMENT '章節外來鍵',
  `title` varchar(255) DEFAULT NULL,
  `type` enum('file','image') DEFAULT NULL COMMENT '作業類別',
  `uri` varchar(255) DEFAULT NULL COMMENT '作業網址',
  `status` enum('Enabled','Disabled') DEFAULT NULL COMMENT '作業狀態',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_lecture`
--

CREATE TABLE IF NOT EXISTS `tbl_lecture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL COMMENT '課程外來鍵',
  `sorter` int(11) NOT NULL DEFAULT '99',
  `title` varchar(512) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '章節名稱',
  `type` enum('video','sound','ppt') DEFAULT NULL COMMENT '章節類別',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  `status` enum('Enabled','Disabled') DEFAULT NULL COMMENT '章節狀態',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=298 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_lecture`
--

INSERT INTO `tbl_lecture` (`id`, `course_id`, `sorter`, `title`, `type`, `last_ts`, `last_user`, `insert_ts`, `insert_user`, `status`) VALUES
(294, 40, 1, '訪談規劃', NULL, '2021-08-17 10:26:18', 1, '2021-07-28 06:31:55', 1, 'Enabled'),
(295, 0, 1, 'test2', NULL, '2021-07-28 07:43:56', 1, '2021-07-28 07:43:56', 1, 'Enabled'),
(296, 0, 9, 'test2', NULL, '2021-07-28 07:51:59', 1, '2021-07-28 07:51:59', 1, 'Enabled'),
(297, 40, 0, '前言', NULL, '2021-08-17 10:26:03', 1, '2021-07-28 09:00:53', 1, 'Enabled');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media`
--

CREATE TABLE IF NOT EXISTS `tbl_media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `target` enum('Normal','Course','Press','Event') NOT NULL DEFAULT 'Normal',
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `pic` varchar(255) NOT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pid_type` (`parent_id`,`target`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_media`
--

INSERT INTO `tbl_media` (`id`, `parent_id`, `status`, `target`, `slug`, `title`, `pic`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 0, 'Enabled', '', 'RS9R6YSYPDAR7DT4', '上課照片', '/upload/img/2021/08/3afda6db9b8e57a.JPG?JPG', '角色介紹', '2021-08-03 15:41:40', 7, '2021-08-03 15:41:40', 7),
(2, 0, 'Enabled', '', 'https-/drive-google-com/drive/folders/1arrnesw8viwphgwgurmacnmnnclw8wfs', '上課照片', '/upload/img/2021/08/4be8a20c5fec4b3.JPG?JPG', '選擇角色', '2021-08-03 15:44:28', 7, '2021-08-03 15:44:28', 7),
(3, 5, 'Enabled', 'Event', 'HXXMGXSWRCWJ39Y8', 'tetst', '/upload/img/2021/08/f5c374aee468aef.webp?jpg', '', '2021-08-04 05:03:37', 1, '2021-08-04 05:03:37', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_media_meta` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_media_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_media_tag` (
  `media_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`media_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_member`
--

CREATE TABLE IF NOT EXISTS `tbl_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('New','Verified','Invalid') DEFAULT 'New',
  `jobtitle` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `verify_code` varchar(100) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL COMMENT 'user’s email',
  `pwd` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `nickname` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 DEFAULT '//www.gravatar.com/avatar/00000000000000000000000000000000',
  `subscribed` enum('Yes','No') NOT NULL DEFAULT 'No',
  `email` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `realname` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_member`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_member_sns`
--

CREATE TABLE IF NOT EXISTS `tbl_member_sns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `sns_id` varchar(50) DEFAULT NULL,
  `source` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sns_id` (`sns_id`,`source`),
  KEY `member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_member_stats`
--

CREATE TABLE IF NOT EXISTS `tbl_member_stats` (
  `member_id` int(11) NOT NULL,
  `spent` int(11) DEFAULT '0',
  `enrolled` int(11) DEFAULT '0',
  `finished` int(11) DEFAULT '0',
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_menu`
--

CREATE TABLE IF NOT EXISTS `tbl_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `blank` enum('Yes','No') NOT NULL DEFAULT 'No',
  `parent_id` int(11) DEFAULT '0',
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `theme` varchar(30) NOT NULL,
  `color` varchar(30) DEFAULT NULL,
  `icon` varchar(20) DEFAULT NULL,
  `sorter` int(11) NOT NULL DEFAULT '0',
  `cover` varchar(150) DEFAULT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) NOT NULL,
  `insert_user` int(11) NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_menu`
--

INSERT INTO `tbl_menu` (`id`, `status`, `blank`, `parent_id`, `uri`, `theme`, `color`, `icon`, `sorter`, `cover`, `last_ts`, `last_user`, `insert_user`, `insert_ts`) VALUES
(1, 'Enabled', 'No', 0, '/nav', 'Basic', NULL, NULL, 0, '', '2017-01-18 13:09:45', 1, 1, NULL),
(2, 'Enabled', 'No', 0, '/sidebar', 'Basic', NULL, NULL, 1, '', '2015-12-09 02:02:02', 1, 1, NULL),
(4, 'Enabled', 'No', 2, 'about', 'Basic', 'info', NULL, 0, NULL, '2018-08-16 10:58:14', 1, 1, '2018-08-16 10:58:14'),
(5, 'Enabled', 'No', 2, '/404', 'Basic', 'info', NULL, 1, NULL, '2018-08-18 12:03:33', 1, 1, '2018-08-16 10:58:14'),
(9, 'Enabled', 'No', 2, '/contact', 'Basic', 'info', NULL, 2, NULL, '2018-08-18 12:02:05', 1, 1, '2018-08-18 12:02:05'),
(10, 'Enabled', 'No', 1, '/about', 'Basic', 'info', '', 0, NULL, '2021-05-19 09:20:56', 1, 1, '2018-09-28 03:52:10'),
(15, 'Enabled', 'No', 1, '/contact', 'Basic', 'info', '', 5, NULL, '2021-05-19 09:22:34', 1, 1, '2018-09-28 04:54:09'),
(16, 'Enabled', 'No', 0, 'Backend', 'Basic', 'info', NULL, 3, NULL, '2021-05-16 10:45:43', 1, 1, '2021-05-16 10:45:43'),
(17, 'Enabled', 'No', 16, 'cms', 'Basic', 'info', NULL, 0, NULL, '2021-05-16 10:46:29', 1, 1, '2021-05-16 10:46:29'),
(18, 'Enabled', 'No', 16, 'crm', 'Basic', 'info', NULL, 0, NULL, '2021-05-16 10:47:10', 1, 1, '2021-05-16 10:47:10'),
(19, 'Enabled', 'No', 16, 'site', 'Basic', 'info', NULL, 2, NULL, '2021-05-16 10:47:47', 1, 1, '2021-05-16 10:47:47'),
(20, 'Enabled', 'No', 19, 'option/simple', 'Basic', 'info', 'toggle-on', 1, NULL, '2021-05-23 00:29:58', 1, 1, '2021-05-16 10:55:25'),
(21, 'Enabled', 'No', 19, 'menu/simple', 'Basic', 'info', 'sitemap', 2, NULL, '2021-05-17 11:18:31', 1, 1, '2021-05-17 11:18:31'),
(22, 'Enabled', 'No', 19, 'post/list', 'Basic', 'info', 'file-text-o', 0, NULL, '2021-05-17 11:19:11', 1, 1, '2021-05-17 11:19:11'),
(23, 'Enabled', 'No', 19, 'staff/simple', 'Basic', 'info', 'users', 3, NULL, '2021-05-23 00:20:27', 1, 1, '2021-05-17 11:20:14'),
(24, 'Enabled', 'No', 18, 'order/list', 'Basic', 'info', 'ticket', 0, NULL, '2021-05-23 00:25:22', 1, 1, '2021-05-17 11:23:02'),
(25, 'Enabled', 'No', 18, 'contact/simple', 'Basic', 'info', 'phone', 5, NULL, '2021-05-17 11:24:01', 1, 1, '2021-05-17 11:24:01'),
(26, 'Enabled', 'No', 17, 'course/list', 'Basic', 'info', 'usd', 0, NULL, '2021-05-23 00:49:52', 1, 1, '2021-05-17 11:26:09'),
(27, 'Enabled', 'No', 17, 'press/list', 'Basic', 'info', 'rss', 1, NULL, '2021-05-17 11:26:33', 1, 1, '2021-05-17 11:26:33'),
(28, 'Enabled', 'No', 17, 'tag/simple', 'Basic', 'info', 'tag', 6, NULL, '2021-05-17 11:27:10', 1, 1, '2021-05-17 11:27:10'),
(29, 'Enabled', 'No', 17, 'author/list', 'Basic', 'info', 'users', 7, NULL, '2021-05-17 11:27:52', 1, 1, '2021-05-17 11:27:52'),
(30, 'Enabled', 'No', 19, 'media/gallery', 'Basic', 'info', 'photo', 6, NULL, '2021-05-17 11:28:20', 1, 1, '2021-05-17 11:28:20'),
(31, 'Enabled', 'No', 19, 'adv/list', 'Basic', 'info', 'newspaper-o', 5, NULL, '2021-05-17 11:28:46', 1, 1, '2021-05-17 11:28:46'),
(32, 'Enabled', 'No', 12, '/products/tag2', 'Basic', 'info', '', 0, NULL, '2021-05-19 09:09:50', 1, 1, '2021-05-19 09:09:50'),
(33, 'Enabled', 'No', 19, 'meta/list', 'Basic', 'info', 'cog', 7, NULL, '2021-05-23 00:29:41', 1, 1, '2021-05-23 00:17:40'),
(34, 'Enabled', 'No', 19, 'genus/simple', 'Basic', 'info', 'cogs', 8, NULL, '2021-05-23 00:30:19', 1, 1, '2021-05-23 00:18:17'),
(35, 'Enabled', 'No', 19, 'stream/simple', 'Basic', 'info', 'stack-overflow', 9, NULL, '2021-05-23 00:30:29', 1, 1, '2021-05-23 00:18:52'),
(36, 'Enabled', 'No', 19, 'role/simple', 'Basic', 'info', 'sitemap', 4, NULL, '2021-05-23 00:31:31', 1, 1, '2021-05-23 00:22:40'),
(37, 'Enabled', 'No', 18, 'footprint/simple', 'Basic', 'info', 'book', 6, NULL, '2021-05-23 00:23:12', 1, 1, '2021-05-23 00:23:12'),
(38, 'Enabled', 'No', 18, 'enrolled/simple', 'Basic', 'info', 'history', 4, NULL, '2021-05-23 00:32:01', 1, 1, '2021-05-23 00:23:27'),
(39, 'Enabled', 'No', 18, 'member/list', 'Basic', 'info', 'heartbeat', 1, NULL, '2021-05-23 00:34:27', 1, 1, '2021-05-23 00:34:27'),
(40, 'Enabled', 'No', 17, 'event/list', 'Basic', 'info', 'handshake-o', 3, NULL, '2021-05-27 21:12:04', 1, 1, '2021-05-23 21:54:32'),
(41, 'Enabled', 'No', 17, 'echelon/simple', 'Basic', 'info', 'calendar', 2, NULL, '2021-05-27 19:56:46', 1, 1, '2021-05-27 19:55:57'),
(42, 'Enabled', 'No', 18, 'outcome/simple', 'Basic', 'info', 'pencil', 2, NULL, '2021-08-11 03:52:35', 1, 1, '2021-05-29 05:34:43'),
(43, 'Enabled', 'No', 17, 'plan/list', 'Basic', 'info', 'usd', 4, NULL, '2021-06-06 15:33:39', 1, 1, '2021-06-06 15:33:39'),
(44, 'Enabled', 'No', 18, 'message/list', 'Basic', 'info', 'commenting-o', 3, NULL, '2021-08-11 03:51:17', 1, 1, '2021-08-11 03:51:17'),
(45, 'Enabled', 'No', 17, 'bulletin/simple', 'Basic', 'info', 'bullhorn', 5, NULL, '2021-08-11 07:42:11', 1, 1, '2021-08-11 07:41:46');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_menu_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_menu_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `badge` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_menu_lang`
--

INSERT INTO `tbl_menu_lang` (`id`, `lang`, `parent_id`, `title`, `badge`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, '上方導覽', NULL, NULL, '2018-08-16 09:36:49', 1, '2018-08-16 09:36:49', 1),
(2, 'en', 1, 'Nav', NULL, NULL, '2018-08-16 09:36:49', 1, '2018-08-16 09:36:49', 1),
(3, 'en', 2, 'Sidebar', NULL, NULL, '2018-08-16 09:36:49', 1, '2018-08-16 09:36:49', 1),
(4, 'tw', 2, '側邊欄', NULL, NULL, '2018-08-16 09:36:49', 1, '2018-08-16 09:36:49', 1),
(5, 'tw', 4, '關於我們', NULL, NULL, '2018-08-16 09:36:49', 1, '2018-08-16 09:36:49', 1),
(6, 'en', 4, 'About', NULL, NULL, '2018-08-16 09:36:49', 1, '2018-08-16 09:36:49', 1),
(7, 'tw', 5, '404', '', '', '2018-08-18 12:03:33', 1, '2018-08-16 09:36:49', 1),
(8, 'en', 5, '404', '', '', '2018-08-18 12:03:33', 1, '2018-08-16 09:36:49', 1),
(9, 'tw', 9, '聯絡我們', '', '', '2018-08-18 12:02:05', 1, '2018-08-18 12:02:05', 1),
(10, 'en', 9, 'Contact us', '', '', '2018-08-18 12:02:05', 1, '2018-08-18 12:02:05', 1),
(11, 'tw', 10, 'About', '', '', '2021-05-19 09:20:56', 1, '2018-09-28 03:52:10', 1),
(12, 'en', 10, 'HOME', '', '', '2021-05-19 09:20:56', 1, '2018-09-28 03:52:10', 1),
(13, 'tw', 11, 'Studio', '', '', '2021-05-19 09:22:03', 1, '2018-09-28 03:53:32', 1),
(14, 'en', 11, 'SERVICE', '', '', '2021-05-19 09:22:03', 1, '2018-09-28 03:53:32', 1),
(15, 'tw', 12, 'Products', '', '', '2021-05-19 09:09:05', 1, '2018-09-28 04:46:07', 1),
(16, 'en', 12, '', '', '', '2021-05-19 09:09:05', 1, '2018-09-28 04:46:07', 1),
(17, 'tw', 13, 'Gallery', '', '', '2021-05-19 09:22:57', 1, '2018-09-28 04:52:40', 1),
(18, 'en', 13, '', '', '', '2021-05-19 09:22:57', 1, '2018-09-28 04:52:40', 1),
(19, 'tw', 14, 'SHOP', '商店', '', '2018-09-28 05:18:49', 1, '2018-09-28 04:53:29', 1),
(20, 'en', 14, '', '', '', '2018-09-28 04:53:29', 1, '2018-09-28 04:53:29', 1),
(21, 'tw', 15, 'Contact', '', '', '2021-05-19 09:22:34', 1, '2018-09-28 04:54:09', 1),
(22, 'en', 15, '', '', '', '2021-05-19 09:22:34', 1, '2018-09-28 04:54:09', 1),
(23, 'tw', 16, '後台選單', '', '', '2021-05-16 10:45:43', 1, '2021-05-16 10:45:43', 1),
(24, 'en', 16, '', '', '', '2021-05-16 10:45:43', 1, '2021-05-16 10:45:43', 1),
(25, 'tw', 17, '內容管理', '', '', '2021-05-16 10:46:29', 1, '2021-05-16 10:46:29', 1),
(26, 'en', 17, '', '', '', '2021-05-16 10:46:29', 1, '2021-05-16 10:46:29', 1),
(27, 'tw', 18, '客戶管理', '', '', '2021-05-16 10:47:10', 1, '2021-05-16 10:47:10', 1),
(28, 'en', 18, '', '', '', '2021-05-16 10:47:10', 1, '2021-05-16 10:47:10', 1),
(29, 'tw', 19, '網站管理', '', '', '2021-05-16 10:47:47', 1, '2021-05-16 10:47:47', 1),
(30, 'en', 19, '', '', '', '2021-05-16 10:47:47', 1, '2021-05-16 10:47:47', 1),
(31, 'tw', 20, '參數', '', '', '2021-05-23 00:29:58', 1, '2021-05-16 10:55:25', 1),
(32, 'en', 20, '', '', '', '2021-05-23 00:29:58', 1, '2021-05-16 10:55:25', 1),
(33, 'tw', 21, '選單', '', '', '2021-05-17 11:18:31', 1, '2021-05-17 11:18:31', 1),
(34, 'en', 21, '', '', '', '2021-05-17 11:18:31', 1, '2021-05-17 11:18:31', 1),
(35, 'tw', 22, '固定單頁', '', '', '2021-05-17 11:19:11', 1, '2021-05-17 11:19:11', 1),
(36, 'en', 22, '', '', '', '2021-05-17 11:19:11', 1, '2021-05-17 11:19:11', 1),
(37, 'tw', 23, '管理員', '', '', '2021-05-23 00:20:27', 1, '2021-05-17 11:20:14', 1),
(38, 'en', 23, '', '', '', '2021-05-23 00:20:27', 1, '2021-05-17 11:20:14', 1),
(39, 'tw', 24, '訂單', '', '', '2021-05-23 00:25:22', 1, '2021-05-17 11:23:02', 1),
(40, 'en', 24, '', '', '', '2021-05-23 00:25:22', 1, '2021-05-17 11:23:02', 1),
(41, 'tw', 25, '聯絡我們', '', '', '2021-05-17 11:24:01', 1, '2021-05-17 11:24:01', 1),
(42, 'en', 25, '', '', '', '2021-05-17 11:24:01', 1, '2021-05-17 11:24:01', 1),
(43, 'tw', 26, '課程', '', '', '2021-05-23 00:49:52', 1, '2021-05-17 11:26:09', 1),
(44, 'en', 26, '', '', '', '2021-05-23 00:49:52', 1, '2021-05-17 11:26:09', 1),
(45, 'tw', 27, '文章', '', '', '2021-05-17 11:26:33', 1, '2021-05-17 11:26:33', 1),
(46, 'en', 27, '', '', '', '2021-05-17 11:26:33', 1, '2021-05-17 11:26:33', 1),
(47, 'tw', 28, '標籤', '', '', '2021-05-17 11:27:10', 1, '2021-05-17 11:27:10', 1),
(48, 'en', 28, '', '', '', '2021-05-17 11:27:10', 1, '2021-05-17 11:27:10', 1),
(49, 'tw', 29, '作者', '', '', '2021-05-17 11:27:52', 1, '2021-05-17 11:27:52', 1),
(50, 'en', 29, '', '', '', '2021-05-17 11:27:52', 1, '2021-05-17 11:27:52', 1),
(51, 'tw', 30, '圖片', '', '', '2021-05-17 11:28:20', 1, '2021-05-17 11:28:20', 1),
(52, 'en', 30, '', '', '', '2021-05-17 11:28:20', 1, '2021-05-17 11:28:20', 1),
(53, 'tw', 31, '廣告', '', '', '2021-05-17 11:28:46', 1, '2021-05-17 11:28:46', 1),
(54, 'en', 31, '', '', '', '2021-05-17 11:28:46', 1, '2021-05-17 11:28:46', 1),
(55, 'tw', 32, '光罩', '', '', '2021-05-19 09:09:50', 1, '2021-05-19 09:09:50', 1),
(56, 'en', 32, '', '', '', '2021-05-19 09:09:50', 1, '2021-05-19 09:09:50', 1),
(57, 'tw', 33, '後設資料欄位', '', '', '2021-05-23 00:29:41', 1, '2021-05-23 00:17:40', 1),
(58, 'en', 33, '', '', '', '2021-05-23 00:29:41', 1, '2021-05-23 00:17:40', 1),
(59, 'tw', 34, '類型', '', '', '2021-05-23 00:30:19', 1, '2021-05-23 00:18:17', 1),
(60, 'en', 34, '', '', '', '2021-05-23 00:30:19', 1, '2021-05-23 00:18:17', 1),
(61, 'tw', 35, '服務歷程', '', '', '2021-05-23 00:30:29', 1, '2021-05-23 00:18:52', 1),
(62, 'en', 35, '', '', '', '2021-05-23 00:30:29', 1, '2021-05-23 00:18:52', 1),
(63, 'tw', 36, '角色', '', '', '2021-05-23 00:31:31', 1, '2021-05-23 00:22:40', 1),
(64, 'en', 36, '', '', '', '2021-05-23 00:31:31', 1, '2021-05-23 00:22:40', 1),
(65, 'tw', 37, '上課歷程', '', '', '2021-05-23 00:23:12', 1, '2021-05-23 00:23:12', 1),
(66, 'en', 37, '', '', '', '2021-05-23 00:23:12', 1, '2021-05-23 00:23:12', 1),
(67, 'tw', 38, '報名資料', '', '', '2021-05-23 00:32:01', 1, '2021-05-23 00:23:27', 1),
(68, 'en', 38, '', '', '', '2021-05-23 00:32:01', 1, '2021-05-23 00:23:27', 1),
(69, 'tw', 39, '會員', '', '', '2021-05-23 00:34:27', 1, '2021-05-23 00:34:27', 1),
(70, 'en', 39, '', '', '', '2021-05-23 00:34:27', 1, '2021-05-23 00:34:27', 1),
(71, 'tw', 40, '活動', '', '', '2021-05-27 21:12:04', 1, '2021-05-23 21:54:32', 1),
(72, 'en', 40, '', '', '', '2021-05-27 21:12:04', 1, '2021-05-23 21:54:32', 1),
(73, 'tw', 41, '檔期', '', '', '2021-05-27 19:56:46', 1, '2021-05-27 19:55:57', 1),
(74, 'en', 41, '', '', '', '2021-05-27 19:56:46', 1, '2021-05-27 19:55:57', 1),
(75, 'tw', 42, '活動作業', '', '', '2021-08-11 03:52:35', 1, '2021-05-29 05:34:43', 1),
(76, 'en', 42, '', '', '', '2021-08-11 03:52:35', 1, '2021-05-29 05:34:43', 1),
(77, 'tw', 43, '銷售方案', '', '', '2021-06-06 15:33:39', 1, '2021-06-06 15:33:39', 1),
(78, 'en', 43, '', '', '', '2021-06-06 15:33:39', 1, '2021-06-06 15:33:39', 1),
(79, 'tw', 44, '作業討論', '', '', '2021-08-11 03:51:17', 1, '2021-08-11 03:51:17', 1),
(80, 'en', 44, '', '', '', '2021-08-11 03:51:17', 1, '2021-08-11 03:51:17', 1),
(81, 'tw', 45, '公告', '', '', '2021-08-11 07:42:11', 1, '2021-08-11 07:41:46', 1),
(82, 'en', 45, '', '', '', '2021-08-11 07:42:11', 1, '2021-08-11 07:41:46', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_message`
--

CREATE TABLE IF NOT EXISTS `tbl_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `type` enum('Course','Event') NOT NULL DEFAULT 'Event',
  `upper_id` int(11) NOT NULL,
  `row_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `body` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_message`
--

INSERT INTO `tbl_message` (`id`, `status`, `type`, `upper_id`, `row_id`, `member_id`, `teacher_id`, `body`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Event', 1, 1, 34, 0, '第一次發問', '2021-06-12 14:18:26', NULL, '2021-06-12 14:18:26', NULL),
(2, 'Enabled', 'Event', 1, 1, 34, 0, '試試', '2021-07-28 09:09:48', NULL, '2021-07-28 09:09:48', 1),
(3, 'Enabled', 'Course', 1356, 4, 34, 0, 'OK~~~', '2021-09-17 04:37:31', NULL, '2021-09-17 04:37:31', 1),
(4, 'Enabled', 'Course', 1356, 4, 34, 0, '不錯呀', '2021-09-17 04:38:28', 1, '2021-09-17 04:38:28', 1),
(5, 'Enabled', 'Course', 1356, 4, 34, 0, '哈哈哈', '2021-09-17 05:14:48', 1, '2021-09-17 05:14:48', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_message_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_message_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_message_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `fence` varchar(50) DEFAULT NULL,
  `label` varchar(150) DEFAULT NULL,
  `preset` varchar(100) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `input` varchar(20) DEFAULT NULL,
  `option` varchar(20) DEFAULT NULL,
  `sorter` tinyint(4) NOT NULL DEFAULT '10',
  `ps` varchar(250) DEFAULT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_meta`
--

INSERT INTO `tbl_meta` (`id`, `status`, `fence`, `label`, `preset`, `type`, `input`, `option`, `sorter`, `ps`, `last_ts`, `last_user`, `insert_user`, `insert_ts`) VALUES
(1, 'Enabled', 'videouri', 'Youtube 主影片嵌入碼', NULL, 'text', 'text', NULL, 3, '', '2021-05-23 01:29:40', 1, 1, '2020-10-30 03:02:05'),
(2, 'Enabled', 'seo_desc', 'SEO 描述', NULL, 'text', 'paragraph', NULL, 1, '', '2021-05-23 01:28:55', 1, 1, '2021-05-23 01:28:55'),
(3, 'Enabled', 'seo_keyword', 'SEO 關鍵字', NULL, 'text', 'paragraph', NULL, 2, '請以逗號分隔，填入 3~5 組關鍵字，勿使用全形英數', '2021-05-23 01:30:35', 1, 1, '2021-05-23 01:29:34');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_meta_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_meta_tag` (
  `meta_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`meta_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_meta_tag`
--

INSERT INTO `tbl_meta_tag` (`meta_id`, `tag_id`) VALUES
(1, 3),
(2, 3),
(3, 3);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_notice`
--

CREATE TABLE IF NOT EXISTS `tbl_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `type` varchar(30) DEFAULT NULL,
  `uri` varchar(150) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `info` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_notice`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_notice_member`
--

CREATE TABLE IF NOT EXISTS `tbl_notice_member` (
  `notice_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`notice_id`,`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_notice_member`
--

INSERT INTO `tbl_notice_member` (`notice_id`, `member_id`, `seen`) VALUES
(1, 35, 0),
(2, 35, 0),
(3, 35, 0),
(4, 35, 0),
(5, 35, 0),
(6, 35, 0),
(7, 35, 0),
(8, 36, 0),
(9, 34, 0),
(10, 34, 0),
(11, 34, 0);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_notice_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_notice_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_notice_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_option`
--

CREATE TABLE IF NOT EXISTS `tbl_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Enabled',
  `loader` enum('Preload','Demand') NOT NULL DEFAULT 'Demand',
  `group` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_option`
--

INSERT INTO `tbl_option` (`id`, `status`, `loader`, `group`, `name`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Demand', 'page', 'title', 'Demo', '2017-12-27 21:49:32', 1, '2015-12-28 14:43:32', 1),
(2, 'Enabled', 'Demand', 'page', 'keyword', 'key1,key2,key3', '2017-12-28 09:44:23', 1, '2015-12-28 14:44:11', 1),
(4, 'Enabled', 'Demand', 'page', 'img', 'demo.png', '2017-12-27 21:45:11', 1, '2015-12-28 14:46:44', 1),
(5, 'Enabled', 'Preload', 'social', 'facebook_page', 'https://www.facebook.com/', '2015-12-28 18:35:46', 1, '2015-12-28 18:35:46', 1),
(8, 'Enabled', 'Preload', 'default', 'contact_mail', 'sense.info.co@gmail.com', '2016-02-09 06:58:13', 1, '2016-02-01 10:08:41', 1),
(12, 'Enabled', 'Demand', 'page', 'ga', '<script></script>', '2020-10-30 17:14:14', 1, '2016-05-03 07:51:12', 1),
(26, 'Enabled', 'Preload', 'default', 'contact_phone', '+ 33 9 07 45 12 65', '2016-02-09 06:58:13', 1, '2016-02-01 10:08:41', 1),
(27, 'Enabled', 'Preload', 'default', 'contact_address', '42 rue Moulbert 75016 Paris', '2016-02-09 06:58:13', 1, '2016-02-01 10:08:41', 1),
(28, 'Enabled', 'Preload', 'social', 'linkedin_page', 'https://www.linkedin.com/', '2015-12-28 18:35:46', 1, '2015-12-28 18:35:46', 1),
(29, 'Enabled', 'Preload', 'social', 'twitter_page', 'https://twitter.com/', '2015-12-28 18:35:46', 1, '2015-12-28 18:35:46', 1),
(30, 'Enabled', 'Preload', 'default', 'service_mail', 'sense.info.co@gmail.com', '2021-06-10 11:47:03', 1, '2021-06-10 11:47:03', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_outcome`
--

CREATE TABLE IF NOT EXISTS `tbl_outcome` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('New','Replied','Done','Invalid') DEFAULT 'New',
  `event_id` int(11) NOT NULL,
  `echelon_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL DEFAULT '0',
  `ticket_id` int(11) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `reply` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_event_idx` (`event_id`),
  KEY `fk_echelon_idx` (`echelon_id`),
  KEY `ticket_idx` (`ticket_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_outcome`
--

INSERT INTO `tbl_outcome` (`id`, `status`, `event_id`, `echelon_id`, `member_id`, `order_id`, `ticket_id`, `file`, `reply`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'New', 1, 1, 34, 17, 17, '/upload/doc/2021/06/d4b5fe2abb3ce1f.pdf', '第一次回答', '2021-08-23 04:19:32', NULL, '2021-06-10 12:21:31', NULL),
(2, 'New', 2, 4, 35, 18, 18, NULL, '沒有', '2021-08-23 04:19:35', NULL, '2021-08-11 07:19:07', NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_outcome_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_outcome_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text CHARACTER SET utf8mb4,
  PRIMARY KEY (`id`),
  KEY `fk_meta_outcome_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post`
--

CREATE TABLE IF NOT EXISTS `tbl_post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `cover` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_post`
--

INSERT INTO `tbl_post` (`id`, `status`, `slug`, `cover`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(3, 'Enabled', 'about', '/upload/img/2018/08/3c616ae53687302.jpg', '2021-01-09 21:40:44', 1, '2017-01-16 18:07:53', 1),
(5, 'Enabled', 'contact', '', '2018-08-15 00:18:56', 1, '2017-03-25 02:22:21', 1),
(6, 'Enabled', 'privacy', '', '2020-10-29 01:50:53', 1, '2018-08-15 00:21:01', 1),
(8, 'Enabled', 'terms', '', '2020-10-29 01:50:53', 1, '2018-08-15 00:21:01', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_post_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_post_lang`
--

INSERT INTO `tbl_post_lang` (`id`, `lang`, `parent_id`, `title`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 3, '關於我們', '<p>異中經開十學海積為市人飛求難總！國結色好天動來特：起事感。導值遊該一我最市。不酒請了筆動。向就面飛。不老期前，想樣長氣是明到；是於效平，已不而海場同選野。識多所小、子來車路素分，人條這館東程我支新表國試你一育：那學傳苦裡做她保於接親要下樹書用因，必是樓外成足則、為區健之也輕設公局東術；預改人賽；的怎士樹生高痛畫形服年是到參西以單史！她市沒主她相任裡政家童們；年從來立氣司然城再一教險常為：同為商過停苦文環不從，過不賽條如面頭藝的語軍內成時的、生濟處狀過可公苦羅上長家人木人法車品術照長獲其叫……轉氣語；費麼下！好生水他次說們也這子場作這自意康得放形現實力配所，查持小任處人比看嚴系參；就語一引家公法有講氣回。</p><h3>Incididunt ut labore</h3><p>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Ut enim ad minim veniam</h3><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas luctus at sem quis varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Phasellus iaculis magna</h3><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2021-01-09 21:40:44', 1, '2018-08-06 00:55:57', 1),
(2, 'en', 3, 'About Us', '<p>Duis center aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><h3>Incididunt ut labore</h3><p>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Ut enim ad minim veniam</h3><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas luctus at sem quis varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Phasellus iaculis magna</h3><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2021-01-09 21:40:44', 1, '2018-08-06 00:55:57', 1),
(3, 'tw', 5, '聯絡我們~', '<p>中文 ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.<br>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>', '2018-08-15 00:18:56', 1, '2018-08-06 00:55:57', 1),
(4, 'en', 5, 'Contact us~', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.<br>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>', '2018-08-15 00:18:56', 1, '2018-08-06 00:55:57', 1),
(5, 'tw', 6, '隱私權政策', '<p>本《隱私權政策》旨在協助您瞭解本站收集的資訊類型以及收集這些資訊的原因，也說明了您可以如何更新、管理、匯出與刪除資訊。</p><p><br><img src=\"https://f3cms.lo:4433/upload/img/2020/10/29e51687e48c966.png\" class=\"fr-fic fr-dib img-responsive\"></p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2020-10-29 01:50:53', 1, '2018-08-15 00:21:01', 1),
(6, 'en', 6, '', '<p><span style=\"color: rgb(65, 65, 65); font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">本《隱私權政策》旨在協助您瞭解本站收集的資訊類型以及收集這些資訊的原因，也說明了您可以如何更新、管理、匯出與刪除資訊。</span></p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2020-10-29 01:50:53', 1, '2018-08-15 00:21:01', 1),
(7, 'tw', 8, '服務條款', '<p>本《隱私權政策》旨在協助您瞭解本站收集的資訊類型以及收集這些資訊的原因，也說明了您可以如何更新、管理、匯出與刪除資訊。</p><p><br><img src=\"https://f3cms.lo:4433/upload/img/2020/10/29e51687e48c966.png\" class=\"fr-fic fr-dib img-responsive\"></p><p data-f-id=\"pbf\" style=\"text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;\">Powered by <a href=\"https://www.froala.com/wysiwyg-editor?pb=1\" title=\"Froala Editor\">Froala Editor</a></p>', '2018-08-15 00:22:43', 1, '2018-08-15 00:22:43', 1),
(8, 'en', 8, '', '', '2018-08-15 00:22:43', 1, '2018-08-15 00:22:43', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_post_meta` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_press_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_post_tag` (
  `post_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`post_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press`
--

CREATE TABLE IF NOT EXISTS `tbl_press` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Draft','Published','Scheduled','Changed','Offlined') NOT NULL DEFAULT 'Draft',
  `mode` enum('Article','Slide') NOT NULL DEFAULT 'Article',
  `on_homepage` enum('Yes','No') NOT NULL DEFAULT 'No',
  `on_top` enum('Yes','No') NOT NULL DEFAULT 'No',
  `sorter` int(11) NOT NULL DEFAULT '99',
  `cate_id` int(11) DEFAULT NULL,
  `slug` varchar(255) NOT NULL,
  `online_date` timestamp NULL DEFAULT NULL,
  `cover` varchar(255) NOT NULL,
  `banner` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press`

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_author`
--

CREATE TABLE IF NOT EXISTS `tbl_press_author` (
  `press_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `sorter` int(11) NOT NULL DEFAULT '99',
  PRIMARY KEY (`press_id`,`author_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press_author`
--

INSERT INTO `tbl_press_author` (`press_id`, `author_id`, `sorter`) VALUES
(1, 4, 0);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_press_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `keyword` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_press_lang`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_press_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_press_idx` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press_meta`
--

INSERT INTO `tbl_press_meta` (`id`, `parent_id`, `last_ts`, `k`, `v`) VALUES
(33, 1, '2021-08-18 09:09:35', 'seo_desc', 'se'),
(34, 1, '2021-08-18 09:09:35', 'videouri', 'test');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_related`
--

CREATE TABLE IF NOT EXISTS `tbl_press_related` (
  `press_id` int(10) UNSIGNED NOT NULL,
  `related_id` int(10) UNSIGNED NOT NULL,
  `sorter` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`related_id`,`press_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_press_tag` (
  `press_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`press_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press_tag`
--

INSERT INTO `tbl_press_tag` (`press_id`, `tag_id`) VALUES
(1, 4);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_role`
--

CREATE TABLE IF NOT EXISTS `tbl_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `title` varchar(255) DEFAULT NULL,
  `priv` int(11) DEFAULT '0',
  `info` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_role`
--

INSERT INTO `tbl_role` (`id`, `status`, `title`, `priv`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Administrator', 127, 'all:1', '2020-05-25 14:01:20', 1, '2018-01-14 17:58:43', 1),
(2, 'Enabled', 'Market', 24, 'read:1', '2018-05-10 19:42:43', 1, '2018-01-18 03:37:15', 1),
(3, 'Enabled', 'Editor', 35, '', '2018-05-10 19:06:29', 1, '2018-05-10 19:06:29', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_search`
--

CREATE TABLE IF NOT EXISTS `tbl_search` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `status` enum('Disabled','Enabled') NOT NULL DEFAULT 'Disabled',
  `site_id` int(11) DEFAULT NULL,
  `counter` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `info` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_search_press`
--

CREATE TABLE IF NOT EXISTS `tbl_search_press` (
  `press_id` int(11) NOT NULL,
  `search_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_section`
--

CREATE TABLE IF NOT EXISTS `tbl_section` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lecture_id` int(11) DEFAULT NULL COMMENT '章節外來鍵',
  `sorter` int(11) NOT NULL DEFAULT '99',
  `type` enum('video','sound','ppt','homework') CHARACTER SET utf8 DEFAULT NULL COMMENT '小節類別',
  `title` varchar(512) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '小節標題',
  `cover` varchar(255) DEFAULT NULL,
  `assignment` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  `status` enum('Enabled','Disabled') DEFAULT NULL COMMENT '小節狀態',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1357 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_section`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_staff`
--

CREATE TABLE IF NOT EXISTS `tbl_staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('New','Verified','Freeze') DEFAULT 'New',
  `role_id` int(11) NOT NULL DEFAULT '0',
  `account` varchar(45) DEFAULT NULL,
  `pwd` varchar(128) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_staff`
--

INSERT INTO `tbl_staff` (`id`, `status`, `role_id`, `account`, `pwd`, `avatar`, `email`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Verified', 1, 'trevor', '$2y$10$9YlUqm.R3yIZW.SiSF2CyumTDwt/z9dl8jQ55ZCvoYNJAozwbCiCi', NULL, 'shuaib25@gmail.com', '2021-05-24 04:47:32', 1, '2015-08-04 04:41:20', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_staff_sudo`
--

CREATE TABLE IF NOT EXISTS `tbl_staff_sudo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_staff_sudo`
--

INSERT INTO `tbl_staff_sudo` (`id`, `member_id`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(14, 34, '2021-07-12 07:53:20', NULL, '2021-07-12 07:53:20', 1),
(15, 34, '2021-08-04 07:14:41', NULL, '2021-08-04 07:14:41', 7),
(16, 28, '2021-08-10 13:30:43', NULL, '2021-08-10 13:30:43', 7),
(17, 28, '2021-08-11 07:37:17', NULL, '2021-08-11 07:37:17', 7),
(18, 34, '2021-08-11 07:39:32', NULL, '2021-08-11 07:39:32', 1),
(19, 34, '2021-08-11 08:14:34', NULL, '2021-08-11 08:14:34', 7),
(20, 35, '2021-08-18 04:37:49', NULL, '2021-08-18 04:37:49', 7),
(21, 28, '2021-08-18 07:07:08', NULL, '2021-08-18 07:07:08', 7),
(22, 35, '2021-08-20 06:58:45', NULL, '2021-08-20 06:58:45', 7),
(23, 34, '2021-08-24 12:41:49', NULL, '2021-08-24 12:41:49', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_stats_daily`
--

CREATE TABLE IF NOT EXISTS `tbl_stats_daily` (
  `uid` varchar(32) COLLATE latin5_bin NOT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sid` int(11) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `oid` int(11) DEFAULT NULL,
  `ts` timestamp NULL DEFAULT NULL,
  `spent` int(11) NOT NULL,
  PRIMARY KEY (`uid`),
  KEY `sid` (`sid`),
  KEY `cid` (`cid`),
  KEY `mid` (`mid`),
  KEY `oid` (`oid`),
  KEY `ts` (`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=latin5 COLLATE=latin5_bin;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_stats_hourly`
--

CREATE TABLE IF NOT EXISTS `tbl_stats_hourly` (
  `uid` varchar(32) COLLATE latin5_bin NOT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sid` int(11) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `oid` int(11) DEFAULT NULL,
  `ts` timestamp NULL DEFAULT NULL,
  `spent` int(11) NOT NULL,
  PRIMARY KEY (`uid`),
  KEY `sid` (`sid`),
  KEY `cid` (`cid`),
  KEY `mid` (`mid`),
  KEY `oid` (`oid`),
  KEY `ts` (`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=latin5 COLLATE=latin5_bin;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_stats_monthly`
--

CREATE TABLE IF NOT EXISTS `tbl_stats_monthly` (
  `uid` varchar(32) COLLATE latin5_bin NOT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sid` int(11) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `oid` int(11) DEFAULT NULL,
  `ts` timestamp NULL DEFAULT NULL,
  `spent` int(11) NOT NULL,
  PRIMARY KEY (`uid`),
  KEY `sid` (`sid`),
  KEY `cid` (`cid`),
  KEY `mid` (`mid`),
  KEY `oid` (`oid`),
  KEY `ts` (`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=latin5 COLLATE=latin5_bin;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_stream`
--

CREATE TABLE IF NOT EXISTS `tbl_stream` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target` enum('Task','Sudo') NOT NULL DEFAULT 'Sudo',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `content` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_stream`
--

INSERT INTO `tbl_stream` (`id`, `target`, `parent_id`, `status`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(14, 'Sudo', 34, 'Enabled', '登入會員帳號：shuaib25@gmail.com 進行操作', '2021-07-12 07:53:20', 1, '2021-07-12 07:53:20', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag`
--

CREATE TABLE IF NOT EXISTS `tbl_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `charged` enum('Yes','No') NOT NULL DEFAULT 'No',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `counter` int(11) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_tag`
--

INSERT INTO `tbl_tag` (`id`, `status`, `charged`, `parent_id`, `counter`, `slug`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(2, 'Enabled', 'No', 0, NULL, 'tag1', '2018-08-15 15:55:34', 1, '2018-07-31 02:30:03', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_detail`
--

CREATE TABLE IF NOT EXISTS `tbl_tag_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `banner` varchar(255) DEFAULT NULL,
  `info` text,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pid` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_tag_detail`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_lang`
--

CREATE TABLE IF NOT EXISTS `tbl_tag_lang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `alias` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- 資料表的匯出資料 `tbl_tag_lang`
--

INSERT INTO `tbl_tag_lang` (`id`, `lang`, `parent_id`, `title`, `alias`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(3, 'tw', 2, '標籤1', '別名1~~~', NULL, '2018-08-15 15:55:34', 1, '2018-07-31 02:30:03', 1),
(4, 'en', 2, 'tag1', 'alias2', NULL, '2018-08-15 15:55:34', 1, '2018-07-31 02:30:03', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_related`
--

CREATE TABLE IF NOT EXISTS `tbl_tag_related` (
  `related_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_thread`
--

CREATE TABLE IF NOT EXISTS `tbl_thread` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `event_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `body` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_base_thread_idx` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_thread`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_thread_meta`
--

CREATE TABLE IF NOT EXISTS `tbl_thread_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_thread_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_ticket`
--

CREATE TABLE IF NOT EXISTS `tbl_ticket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `plan_id` int(11) DEFAULT NULL,
  `member_id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled','New') NOT NULL DEFAULT 'New',
  `type` enum('Course','Echelon','Topic','Promocode') DEFAULT 'Course',
  `row_id` int(11) NOT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `period` int(11) NOT NULL DEFAULT '24',
  `start_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `screenshot` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ticket_order_idx` (`order_id`),
  KEY `fk_ticket_plan_idx` (`plan_id`),
  KEY `fk_ticket_row_plan_idx` (`row_id`,`type`),
  KEY `fk_member_idx` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_ticket`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_track`
--

CREATE TABLE IF NOT EXISTS `tbl_track` (
  `uid` varchar(32) COLLATE latin5_bin NOT NULL,
  `ts` timestamp NULL DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `spent` int(11) NOT NULL,
  `pos` int(11) NOT NULL,
  PRIMARY KEY (`uid`),
  KEY `sid` (`sid`),
  KEY `cid` (`cid`),
  KEY `mid` (`mid`),
  KEY `ts` (`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=latin5 COLLATE=latin5_bin;

--
-- 資料表的匯出資料 `tbl_track`
--

INSERT INTO `tbl_track` (`uid`, `ts`, `sid`, `cid`, `mid`, `spent`, `pos`) VALUES
('210909224123-34-1355', '2021-09-09 14:41:23', 1355, 40, 34, 10, 9),
('210909224133-34-1355', '2021-09-09 14:41:33', 1355, 40, 34, 10, 19);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_video`
--

CREATE TABLE IF NOT EXISTS `tbl_video` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '原始檔名',
  `origin_uri` varchar(255) DEFAULT NULL COMMENT '原始s3連結',
  `m3u8_uri` varchar(255) DEFAULT NULL COMMENT 'm3u8網址',
  `subtitle_uri` varchar(255) DEFAULT NULL,
  `awsTranscoderJobId` varchar(100) DEFAULT NULL,
  `metadata` text COMMENT '請求內容',
  `preset` varchar(100) DEFAULT NULL COMMENT '設定組',
  `datakey` varchar(255) DEFAULT NULL,
  `video_status` enum('uploaded','tscomplete','readyToTs') DEFAULT NULL COMMENT '影片狀態',
  `status` enum('Enabled','Disabled') DEFAULT NULL COMMENT '影片狀態',
  `duration` int(11) DEFAULT NULL COMMENT '影片長度',
  `course_id` int(11) DEFAULT NULL COMMENT '外來課程id',
  `lecture_id` int(11) DEFAULT NULL COMMENT '外來章節id',
  `section_id` int(11) DEFAULT NULL COMMENT '外來小節id ',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1362 DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_video`
--

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_zipcode`
--

CREATE TABLE IF NOT EXISTS `tbl_zipcode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `county_id` int(11) DEFAULT NULL,
  `zipcode` varchar(3) DEFAULT NULL,
  `town` varchar(20) DEFAULT NULL,
  `county` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zipcode` (`zipcode`),
  KEY `county_id` (`county_id`)
) ENGINE=InnoDB AUTO_INCREMENT=369 DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_zipcode`
--

INSERT INTO `tbl_zipcode` (`id`, `county_id`, `zipcode`, `town`, `county`) VALUES
(1, 1, '100', '中正區', '臺北市'),
(2, 1, '103', '大同區', '臺北市'),
(3, 1, '104', '中山區', '臺北市'),
(4, 1, '105', '松山區', '臺北市'),
(5, 1, '106', '大安區', '臺北市'),
(6, 1, '108', '萬華區', '臺北市'),
(7, 1, '110', '信義區', '臺北市'),
(8, 1, '111', '士林區', '臺北市'),
(9, 1, '112', '北投區', '臺北市'),
(10, 1, '114', '內湖區', '臺北市'),
(11, 1, '115', '南港區', '臺北市'),
(12, 1, '116', '文山區', '臺北市'),
(13, 2, '200', '仁愛區', '基隆市'),
(14, 2, '201', '信義區', '基隆市'),
(15, 2, '202', '中正區', '基隆市'),
(16, 2, '203', '中山區', '基隆市'),
(17, 2, '204', '安樂區', '基隆市'),
(18, 2, '205', '暖暖區', '基隆市'),
(19, 2, '206', '七堵區', '基隆市'),
(20, 3, '207', '萬里區', '新北市'),
(21, 3, '208', '金山區', '新北市'),
(22, 3, '220', '板橋區', '新北市'),
(23, 3, '221', '汐止區', '新北市'),
(24, 3, '222', '深坑區', '新北市'),
(25, 3, '223', '石碇區', '新北市'),
(26, 3, '224', '瑞芳區', '新北市'),
(27, 3, '226', '平溪區', '新北市'),
(28, 3, '227', '雙溪區', '新北市'),
(29, 3, '228', '貢寮區', '新北市'),
(30, 3, '231', '新店區', '新北市'),
(31, 3, '232', '坪林區', '新北市'),
(32, 3, '233', '烏來區', '新北市'),
(33, 3, '234', '永和區', '新北市'),
(34, 3, '235', '中和區', '新北市'),
(35, 3, '236', '土城區', '新北市'),
(36, 3, '237', '三峽區', '新北市'),
(37, 3, '238', '樹林區', '新北市'),
(38, 3, '239', '鶯歌區', '新北市'),
(39, 3, '241', '三重區', '新北市'),
(40, 3, '242', '新莊區', '新北市'),
(41, 3, '243', '泰山區', '新北市'),
(42, 3, '244', '林口區', '新北市'),
(43, 3, '247', '蘆洲區', '新北市'),
(44, 3, '248', '五股區', '新北市'),
(45, 3, '249', '八里區', '新北市'),
(46, 3, '251', '淡水區', '新北市'),
(47, 3, '252', '三芝區', '新北市'),
(48, 3, '253', '石門區', '新北市'),
(49, 4, '260', '宜蘭', '宜蘭縣'),
(50, 4, '261', '頭城', '宜蘭縣'),
(51, 4, '262', '礁溪', '宜蘭縣'),
(52, 4, '263', '壯圍', '宜蘭縣'),
(53, 4, '264', '員山', '宜蘭縣'),
(54, 4, '265', '羅東', '宜蘭縣'),
(55, 4, '266', '三星', '宜蘭縣'),
(56, 4, '267', '大同', '宜蘭縣'),
(57, 4, '268', '五結', '宜蘭縣'),
(58, 4, '269', '冬山', '宜蘭縣'),
(59, 4, '270', '蘇澳', '宜蘭縣'),
(60, 4, '272', '南澳', '宜蘭縣'),
(61, 4, '290', '釣魚臺列嶼', '宜蘭縣'),
(62, 5, '300', '新竹市', '新竹市'),
(63, 6, '302', '竹北', '新竹縣'),
(64, 6, '303', '湖口', '新竹縣'),
(65, 6, '304', '新豐', '新竹縣'),
(66, 6, '305', '新埔', '新竹縣'),
(67, 6, '306', '關西', '新竹縣'),
(68, 6, '307', '芎林', '新竹縣'),
(69, 6, '308', '寶山', '新竹縣'),
(70, 6, '310', '竹東', '新竹縣'),
(71, 6, '311', '五峰', '新竹縣'),
(72, 6, '312', '橫山', '新竹縣'),
(73, 6, '313', '尖石', '新竹縣'),
(74, 6, '314', '北埔', '新竹縣'),
(75, 6, '315', '峨眉', '新竹縣'),
(76, 7, '320', '中壢區', '桃園市'),
(77, 7, '324', '平鎮區', '桃園市'),
(78, 7, '325', '龍潭區', '桃園市'),
(79, 7, '326', '楊梅區', '桃園市'),
(80, 7, '327', '新屋區', '桃園市'),
(81, 7, '328', '觀音區', '桃園市'),
(82, 7, '330', '桃園區', '桃園市'),
(83, 7, '333', '龜山區', '桃園市'),
(84, 7, '334', '八德區', '桃園市'),
(85, 7, '335', '大溪區', '桃園市'),
(86, 7, '336', '復興區', '桃園市'),
(87, 7, '337', '大園區', '桃園市'),
(88, 7, '338', '蘆竹區', '桃園市'),
(89, 8, '350', '竹南', '苗栗縣'),
(90, 8, '351', '頭份', '苗栗縣'),
(91, 8, '352', '三灣', '苗栗縣'),
(92, 8, '353', '南庄', '苗栗縣'),
(93, 8, '354', '獅潭', '苗栗縣'),
(94, 8, '356', '後龍', '苗栗縣'),
(95, 8, '357', '通霄', '苗栗縣'),
(96, 8, '358', '苑裡', '苗栗縣'),
(97, 8, '360', '苗栗', '苗栗縣'),
(98, 8, '361', '造橋', '苗栗縣'),
(99, 8, '362', '頭屋', '苗栗縣'),
(100, 8, '363', '公館', '苗栗縣'),
(101, 8, '364', '大湖', '苗栗縣'),
(102, 8, '365', '泰安', '苗栗縣'),
(103, 8, '366', '銅鑼', '苗栗縣'),
(104, 8, '367', '三義', '苗栗縣'),
(105, 8, '368', '西湖', '苗栗縣'),
(106, 8, '369', '卓蘭', '苗栗縣'),
(107, 9, '400', '中區', '臺中市'),
(108, 9, '401', '東區', '臺中市'),
(109, 9, '402', '南區', '臺中市'),
(110, 9, '403', '西區', '臺中市'),
(111, 9, '404', '北區', '臺中市'),
(112, 9, '406', '北屯區', '臺中市'),
(113, 9, '407', '西屯區', '臺中市'),
(114, 9, '408', '南屯區', '臺中市'),
(115, 9, '411', '太平區', '臺中市'),
(116, 9, '412', '大里區', '臺中市'),
(117, 9, '413', '霧峰區', '臺中市'),
(118, 9, '414', '烏日區', '臺中市'),
(119, 9, '420', '豐原區', '臺中市'),
(120, 9, '421', '后里區', '臺中市'),
(121, 9, '422', '石岡區', '臺中市'),
(122, 9, '423', '東勢區', '臺中市'),
(123, 9, '424', '和平區', '臺中市'),
(124, 9, '426', '新社區', '臺中市'),
(125, 9, '427', '潭子區', '臺中市'),
(126, 9, '428', '大雅區', '臺中市'),
(127, 9, '429', '神岡區', '臺中市'),
(128, 9, '432', '大肚區', '臺中市'),
(129, 9, '433', '沙鹿區', '臺中市'),
(130, 9, '434', '龍井區', '臺中市'),
(131, 9, '435', '梧棲區', '臺中市'),
(132, 9, '436', '清水區', '臺中市'),
(133, 9, '437', '大甲區', '臺中市'),
(134, 9, '438', '外埔區', '臺中市'),
(135, 9, '439', '大安區', '臺中市'),
(136, 10, '500', '彰化', '彰化縣'),
(137, 10, '502', '芬園', '彰化縣'),
(138, 10, '503', '花壇', '彰化縣'),
(139, 10, '504', '秀水', '彰化縣'),
(140, 10, '505', '鹿港', '彰化縣'),
(141, 10, '506', '福興', '彰化縣'),
(142, 10, '507', '線西', '彰化縣'),
(143, 10, '508', '和美', '彰化縣'),
(144, 10, '509', '伸港', '彰化縣'),
(145, 10, '510', '員林', '彰化縣'),
(146, 10, '511', '社頭', '彰化縣'),
(147, 10, '512', '永靖', '彰化縣'),
(148, 10, '513', '埔心', '彰化縣'),
(149, 10, '514', '溪湖', '彰化縣'),
(150, 10, '515', '大村', '彰化縣'),
(151, 10, '516', '埔鹽', '彰化縣'),
(152, 10, '520', '田中', '彰化縣'),
(153, 10, '521', '北斗', '彰化縣'),
(154, 10, '522', '田尾', '彰化縣'),
(155, 10, '523', '埤頭', '彰化縣'),
(156, 10, '524', '溪州', '彰化縣'),
(157, 10, '525', '竹塘', '彰化縣'),
(158, 10, '526', '二林', '彰化縣'),
(159, 10, '527', '大城', '彰化縣'),
(160, 10, '528', '芳苑', '彰化縣'),
(161, 10, '530', '二水', '彰化縣'),
(162, 11, '540', '南投', '南投縣'),
(163, 11, '541', '中寮', '南投縣'),
(164, 11, '542', '草屯', '南投縣'),
(165, 11, '544', '國姓', '南投縣'),
(166, 11, '545', '埔里', '南投縣'),
(167, 11, '546', '仁愛', '南投縣'),
(168, 11, '551', '名間', '南投縣'),
(169, 11, '552', '集集', '南投縣'),
(170, 11, '553', '水里', '南投縣'),
(171, 11, '555', '魚池', '南投縣'),
(172, 11, '556', '信義', '南投縣'),
(173, 11, '557', '竹山', '南投縣'),
(174, 11, '558', '鹿谷', '南投縣'),
(175, 12, '600', '嘉義市', '嘉義市'),
(176, 13, '602', '番路', '嘉義縣'),
(177, 13, '603', '梅山', '嘉義縣'),
(178, 13, '604', '竹崎', '嘉義縣'),
(179, 13, '605', '阿里山', '嘉義縣'),
(180, 13, '606', '中埔', '嘉義縣'),
(181, 13, '607', '大埔', '嘉義縣'),
(182, 13, '608', '水上', '嘉義縣'),
(183, 13, '611', '鹿草', '嘉義縣'),
(184, 13, '612', '太保', '嘉義縣'),
(185, 13, '613', '朴子', '嘉義縣'),
(186, 13, '614', '東石', '嘉義縣'),
(187, 13, '615', '六腳', '嘉義縣'),
(188, 13, '616', '新港', '嘉義縣'),
(189, 13, '621', '民雄', '嘉義縣'),
(190, 13, '622', '大林', '嘉義縣'),
(191, 13, '623', '溪口', '嘉義縣'),
(192, 13, '624', '義竹', '嘉義縣'),
(193, 13, '625', '布袋', '嘉義縣'),
(194, 14, '630', '斗南', '雲林縣'),
(195, 14, '631', '大埤', '雲林縣'),
(196, 14, '632', '虎尾', '雲林縣'),
(197, 14, '633', '土庫', '雲林縣'),
(198, 14, '634', '褒忠', '雲林縣'),
(199, 14, '635', '東勢', '雲林縣'),
(200, 14, '636', '臺西', '雲林縣'),
(201, 14, '637', '崙背', '雲林縣'),
(202, 14, '638', '麥寮', '雲林縣'),
(203, 14, '640', '斗六', '雲林縣'),
(204, 14, '643', '林內', '雲林縣'),
(205, 14, '646', '古坑', '雲林縣'),
(206, 14, '647', '莿桐', '雲林縣'),
(207, 14, '648', '西螺', '雲林縣'),
(208, 14, '649', '二崙', '雲林縣'),
(209, 14, '651', '北港', '雲林縣'),
(210, 14, '652', '水林', '雲林縣'),
(211, 14, '653', '口湖', '雲林縣'),
(212, 14, '654', '四湖', '雲林縣'),
(213, 14, '655', '元長', '雲林縣'),
(214, 15, '700', '中西區', '臺南市'),
(215, 15, '701', '東區', '臺南市'),
(216, 15, '702', '南區', '臺南市'),
(217, 15, '704', '北區', '臺南市'),
(218, 15, '708', '安平區', '臺南市'),
(219, 15, '709', '安南區', '臺南市'),
(220, 15, '710', '永康區', '臺南市'),
(221, 15, '711', '歸仁區', '臺南市'),
(222, 15, '712', '新化區', '臺南市'),
(223, 15, '713', '左鎮區', '臺南市'),
(224, 15, '714', '玉井區', '臺南市'),
(225, 15, '715', '楠西區', '臺南市'),
(226, 15, '716', '南化區', '臺南市'),
(227, 15, '717', '仁德區', '臺南市'),
(228, 15, '718', '關廟區', '臺南市'),
(229, 15, '719', '龍崎區', '臺南市'),
(230, 15, '720', '官田區', '臺南市'),
(231, 15, '721', '麻豆區', '臺南市'),
(232, 15, '722', '佳里區', '臺南市'),
(233, 15, '723', '西港區', '臺南市'),
(234, 15, '724', '七股區', '臺南市'),
(235, 15, '725', '將軍區', '臺南市'),
(236, 15, '726', '學甲區', '臺南市'),
(237, 15, '727', '北門區', '臺南市'),
(238, 15, '730', '新營區', '臺南市'),
(239, 15, '731', '後壁區', '臺南市'),
(240, 15, '732', '白河區', '臺南市'),
(241, 15, '733', '東山區', '臺南市'),
(242, 15, '734', '六甲區', '臺南市'),
(243, 15, '735', '下營區', '臺南市'),
(244, 15, '736', '柳營區', '臺南市'),
(245, 15, '737', '鹽水區', '臺南市'),
(246, 15, '741', '善化區', '臺南市'),
(247, 15, '742', '大內區', '臺南市'),
(248, 15, '743', '山上區', '臺南市'),
(249, 15, '744', '新市區', '臺南市'),
(250, 15, '745', '安定區', '臺南市'),
(251, 16, '800', '新興區', '高雄市'),
(252, 16, '801', '前金區', '高雄市'),
(253, 16, '802', '苓雅區', '高雄市'),
(254, 16, '803', '鹽埕區', '高雄市'),
(255, 16, '804', '鼓山區', '高雄市'),
(256, 16, '805', '旗津區', '高雄市'),
(257, 16, '806', '前鎮區', '高雄市'),
(258, 16, '807', '三民區', '高雄市'),
(259, 16, '811', '楠梓區', '高雄市'),
(260, 16, '812', '小港區', '高雄市'),
(261, 16, '813', '左營區', '高雄市'),
(262, 16, '814', '仁武區', '高雄市'),
(263, 16, '815', '大社區', '高雄市'),
(264, 16, '820', '岡山區', '高雄市'),
(265, 16, '821', '路竹區', '高雄市'),
(266, 16, '822', '阿蓮區', '高雄市'),
(267, 16, '823', '田寮區', '高雄市'),
(268, 16, '824', '燕巢區', '高雄市'),
(269, 16, '825', '橋頭區', '高雄市'),
(270, 16, '826', '梓官區', '高雄市'),
(271, 16, '827', '彌陀區', '高雄市'),
(272, 16, '828', '永安區', '高雄市'),
(273, 16, '829', '湖內區', '高雄市'),
(274, 16, '830', '鳳山區', '高雄市'),
(275, 16, '831', '大寮區', '高雄市'),
(276, 16, '832', '林園區', '高雄市'),
(277, 16, '833', '鳥松區', '高雄市'),
(278, 16, '840', '大樹區', '高雄市'),
(279, 16, '842', '旗山區', '高雄市'),
(280, 16, '843', '美濃區', '高雄市'),
(281, 16, '844', '六龜區', '高雄市'),
(282, 16, '845', '內門區', '高雄市'),
(283, 16, '846', '杉林區', '高雄市'),
(284, 16, '847', '甲仙區', '高雄市'),
(285, 16, '848', '桃源區', '高雄市'),
(286, 16, '849', '那瑪夏區', '高雄市'),
(287, 16, '851', '茂林區', '高雄市'),
(288, 16, '852', '茄萣區', '高雄市'),
(289, 17, '817', '東沙', '南海諸島'),
(290, 17, '819', '南沙', '南海諸島'),
(291, 18, '880', '馬公', '澎湖縣'),
(292, 18, '881', '西嶼', '澎湖縣'),
(293, 18, '882', '望安', '澎湖縣'),
(294, 18, '883', '七美', '澎湖縣'),
(295, 18, '884', '白沙', '澎湖縣'),
(296, 18, '885', '湖西', '澎湖縣'),
(297, 19, '900', '屏東', '屏東縣'),
(298, 19, '901', '三地門', '屏東縣'),
(299, 19, '902', '霧臺', '屏東縣'),
(300, 19, '903', '瑪家', '屏東縣'),
(301, 19, '904', '九如', '屏東縣'),
(302, 19, '905', '里港', '屏東縣'),
(303, 19, '906', '高樹', '屏東縣'),
(304, 19, '907', '鹽埔', '屏東縣'),
(305, 19, '908', '長治', '屏東縣'),
(306, 19, '909', '麟洛', '屏東縣'),
(307, 19, '911', '竹田', '屏東縣'),
(308, 19, '912', '內埔', '屏東縣'),
(309, 19, '913', '萬丹', '屏東縣'),
(310, 19, '920', '潮州', '屏東縣'),
(311, 19, '921', '泰武', '屏東縣'),
(312, 19, '922', '來義', '屏東縣'),
(313, 19, '923', '萬巒', '屏東縣'),
(314, 19, '924', '崁頂', '屏東縣'),
(315, 19, '925', '新埤', '屏東縣'),
(316, 19, '926', '南州', '屏東縣'),
(317, 19, '927', '林邊', '屏東縣'),
(318, 19, '928', '東港', '屏東縣'),
(319, 19, '929', '琉球', '屏東縣'),
(320, 19, '931', '佳冬', '屏東縣'),
(321, 19, '932', '新園', '屏東縣'),
(322, 19, '940', '枋寮', '屏東縣'),
(323, 19, '941', '枋山', '屏東縣'),
(324, 19, '942', '春日', '屏東縣'),
(325, 19, '943', '獅子', '屏東縣'),
(326, 19, '944', '車城', '屏東縣'),
(327, 19, '945', '牡丹', '屏東縣'),
(328, 19, '946', '恆春', '屏東縣'),
(329, 19, '947', '滿州', '屏東縣'),
(330, 20, '950', '臺東', '臺東縣'),
(331, 20, '951', '綠島', '臺東縣'),
(332, 20, '952', '蘭嶼', '臺東縣'),
(333, 20, '953', '延平', '臺東縣'),
(334, 20, '954', '卑南', '臺東縣'),
(335, 20, '955', '鹿野', '臺東縣'),
(336, 20, '956', '關山', '臺東縣'),
(337, 20, '957', '海端', '臺東縣'),
(338, 20, '958', '池上', '臺東縣'),
(339, 20, '959', '東河', '臺東縣'),
(340, 20, '961', '成功', '臺東縣'),
(341, 20, '962', '長濱', '臺東縣'),
(342, 20, '963', '太麻里', '臺東縣'),
(343, 20, '964', '金峰', '臺東縣'),
(344, 20, '965', '大武', '臺東縣'),
(345, 20, '966', '達仁', '臺東縣'),
(346, 21, '970', '花蓮', '花蓮縣'),
(347, 21, '971', '新城', '花蓮縣'),
(348, 21, '972', '秀林', '花蓮縣'),
(349, 21, '973', '吉安', '花蓮縣'),
(350, 21, '974', '壽豐', '花蓮縣'),
(351, 21, '975', '鳳林', '花蓮縣'),
(352, 21, '976', '光復', '花蓮縣'),
(353, 21, '977', '豐濱', '花蓮縣'),
(354, 21, '978', '瑞穗', '花蓮縣'),
(355, 21, '979', '萬榮', '花蓮縣'),
(356, 21, '981', '玉里', '花蓮縣'),
(357, 21, '982', '卓溪', '花蓮縣'),
(358, 21, '983', '富里', '花蓮縣'),
(359, 22, '890', '金沙', '金門縣'),
(360, 22, '891', '金湖', '金門縣'),
(361, 22, '892', '金寧', '金門縣'),
(362, 22, '893', '金城', '金門縣'),
(363, 22, '894', '烈嶼', '金門縣'),
(364, 22, '896', '烏坵', '金門縣'),
(365, 23, '209', '南竿', '連江縣'),
(366, 23, '210', '北竿', '連江縣'),
(367, 23, '211', '莒光', '連江縣'),
(368, 23, '212', '東引', '連江縣');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
