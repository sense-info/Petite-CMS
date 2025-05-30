-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- 主機： db-mysql-sgp1-18389-do-user-1168107-0.b.db.ondigitalocean.com:25060
-- 產生時間： 2025 年 05 月 26 日 14:19
-- 伺服器版本： 8.0.35
-- PHP 版本： 8.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

--
-- 資料表結構 `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(255) NOT NULL,
  `data` text CHARACTER SET utf8mb4,
  `ip` varchar(45) DEFAULT NULL,
  `agent` varchar(300) DEFAULT NULL,
  `stamp` int DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv`
--

DROP TABLE IF EXISTS `tbl_adv`;
CREATE TABLE IF NOT EXISTS `tbl_adv` (
  `id` int NOT NULL AUTO_INCREMENT,
  `position_id` int NOT NULL,
  `counter` int NOT NULL,
  `exposure` int NOT NULL DEFAULT '0',
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `weight` int NOT NULL DEFAULT '0',
  `theme` varchar(10) DEFAULT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `background` varchar(255) NOT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int NOT NULL,
  `insert_user` int NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`position_id`),
  KEY `uri` (`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv_lang`
--

DROP TABLE IF EXISTS `tbl_adv_lang`;
CREATE TABLE IF NOT EXISTS `tbl_adv_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv_meta`
--

DROP TABLE IF EXISTS `tbl_adv_meta`;
CREATE TABLE IF NOT EXISTS `tbl_adv_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_press_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author`
--

DROP TABLE IF EXISTS `tbl_author`;
CREATE TABLE IF NOT EXISTS `tbl_author` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `online_date` date DEFAULT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  `cover` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author_lang`
--

DROP TABLE IF EXISTS `tbl_author_lang`;
CREATE TABLE IF NOT EXISTS `tbl_author_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `jobtitle` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `slogan` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `summary` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author_tag`
--

DROP TABLE IF EXISTS `tbl_author_tag`;
CREATE TABLE IF NOT EXISTS `tbl_author_tag` (
  `author_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`author_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_book`
--

DROP TABLE IF EXISTS `tbl_book`;
CREATE TABLE IF NOT EXISTS `tbl_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `cate_id` int DEFAULT '0',
  `counter` int DEFAULT '0',
  `exposure` int DEFAULT '0',
  `uri` varchar(255) NOT NULL,
  `cover` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_book_lang`
--

DROP TABLE IF EXISTS `tbl_book_lang`;
CREATE TABLE IF NOT EXISTS `tbl_book_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `alias` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `summary` text CHARACTER SET utf8mb4,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_category`
--

DROP TABLE IF EXISTS `tbl_category`;
CREATE TABLE IF NOT EXISTS `tbl_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Enabled',
  `sorter` tinyint NOT NULL DEFAULT '0',
  `group` varchar(50) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `cover` varchar(100) NOT NULL DEFAULT '',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_category_lang`
--

DROP TABLE IF EXISTS `tbl_category_lang`;
CREATE TABLE IF NOT EXISTS `tbl_category_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(700) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_category_tag`
--

DROP TABLE IF EXISTS `tbl_category_tag`;
CREATE TABLE IF NOT EXISTS `tbl_category_tag` (
  `tag_id` int NOT NULL,
  `category_id` int NOT NULL,
  `sorter` int NOT NULL DEFAULT '99',
  PRIMARY KEY (`category_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_collection`
--

DROP TABLE IF EXISTS `tbl_collection`;
CREATE TABLE IF NOT EXISTS `tbl_collection` (
  `id` int NOT NULL,
  `parent_id` int DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `txt_color` varchar(10) NOT NULL DEFAULT 'dark',
  `txt_algin` varchar(10) NOT NULL DEFAULT 'left',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_collection_lang`
--

DROP TABLE IF EXISTS `tbl_collection_lang`;
CREATE TABLE IF NOT EXISTS `tbl_collection_lang` (
  `id` int NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_contact`
--

DROP TABLE IF EXISTS `tbl_contact`;
CREATE TABLE IF NOT EXISTS `tbl_contact` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('New','Process','Done') NOT NULL DEFAULT 'New',
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text CHARACTER SET utf8mb4 NOT NULL,
  `other` text,
  `response` text CHARACTER SET utf8mb4 NOT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int NOT NULL,
  `insert_user` int NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_dictionary`
--

DROP TABLE IF EXISTS `tbl_dictionary`;
CREATE TABLE IF NOT EXISTS `tbl_dictionary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `cover` varchar(100) NOT NULL DEFAULT '',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_dictionary_lang`
--

DROP TABLE IF EXISTS `tbl_dictionary_lang`;
CREATE TABLE IF NOT EXISTS `tbl_dictionary_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `alias` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `summary` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_doorman`
--

DROP TABLE IF EXISTS `tbl_doorman`;
CREATE TABLE IF NOT EXISTS `tbl_doorman` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `type` enum('Member','Staff','Admin') DEFAULT 'Member',
  `status` enum('New','Invalid') NOT NULL DEFAULT 'New',
  `pwd` varchar(100) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_draft`
--

DROP TABLE IF EXISTS `tbl_draft`;
CREATE TABLE IF NOT EXISTS `tbl_draft` (
  `id` int NOT NULL AUTO_INCREMENT,
  `press_id` int NOT NULL DEFAULT '0' COMMENT '新聞稿 ID',
  `owner_id` int NOT NULL DEFAULT '0' COMMENT '擁有者 ID',
  `status` enum('New','Waiting','Done','Invalid','Used') CHARACTER SET utf8mb4 DEFAULT 'New' COMMENT '草稿狀態',
  `lang` varchar(5) NOT NULL DEFAULT 'tw' COMMENT '語言',
  `method` varchar(50) NOT NULL DEFAULT '' COMMENT 'LLM 函式',
  `intent` text COMMENT '意圖',
  `guideline` text COMMENT '指導方針/原文',
  `content` mediumtext CHARACTER SET utf8mb4 COMMENT '內容',
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '插入時間',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最後更新時間',
  `insert_user` int DEFAULT '0' COMMENT '新增的使用者 ID',
  `last_user` int DEFAULT '0' COMMENT '最後更新的使用者 ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='草稿清單';

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_flash`
--

DROP TABLE IF EXISTS `tbl_flash`;
CREATE TABLE IF NOT EXISTS `tbl_flash` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slug` varchar(32) DEFAULT NULL,
  `press_id` int NOT NULL DEFAULT '0',
  `hit` int NOT NULL DEFAULT '0',
  `exposure` int NOT NULL DEFAULT '0',
  `status` enum('New','Done','Enabled','Disabled') NOT NULL DEFAULT 'New',
  `auto` enum('Yes','No') NOT NULL DEFAULT 'No',
  `genus` int NOT NULL,
  `weight` int NOT NULL DEFAULT '0',
  `reliable` int NOT NULL DEFAULT '0',
  `international` int NOT NULL DEFAULT '0',
  `source` varchar(25) CHARACTER SET utf8mb4 NOT NULL,
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `online_date` timestamp NULL DEFAULT NULL,
  `filename` varchar(20) NOT NULL DEFAULT '',
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int NOT NULL,
  `insert_user` int NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uri` (`uri`) USING BTREE,
  KEY `genus` (`genus`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_flash_lang`
--

DROP TABLE IF EXISTS `tbl_flash_lang`;
CREATE TABLE IF NOT EXISTS `tbl_flash_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `summary` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_flash_meta`
--

DROP TABLE IF EXISTS `tbl_flash_meta`;
CREATE TABLE IF NOT EXISTS `tbl_flash_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_flash_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_flash_raw`
--

DROP TABLE IF EXISTS `tbl_flash_raw`;
CREATE TABLE IF NOT EXISTS `tbl_flash_raw` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `summary` text CHARACTER SET utf8mb4,
  `content` text CHARACTER SET utf8mb4,
  `insert_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pid` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_genus`
--

DROP TABLE IF EXISTS `tbl_genus`;
CREATE TABLE IF NOT EXISTS `tbl_genus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Enabled',
  `sorter` tinyint NOT NULL DEFAULT '0',
  `group` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media`
--

DROP TABLE IF EXISTS `tbl_media`;
CREATE TABLE IF NOT EXISTS `tbl_media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target` enum('Normal','Project') NOT NULL DEFAULT 'Normal',
  `parent_id` int NOT NULL DEFAULT '0',
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `pic` varchar(255) NOT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media_meta`
--

DROP TABLE IF EXISTS `tbl_media_meta`;
CREATE TABLE IF NOT EXISTS `tbl_media_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_media_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media_tag`
--

DROP TABLE IF EXISTS `tbl_media_tag`;
CREATE TABLE IF NOT EXISTS `tbl_media_tag` (
  `media_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`media_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 資料表結構 `tbl_menu`
--

DROP TABLE IF EXISTS `tbl_menu`;
CREATE TABLE IF NOT EXISTS `tbl_menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `blank` enum('Yes','No') NOT NULL DEFAULT 'No',
  `parent_id` int DEFAULT '0',
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `theme` varchar(30) NOT NULL,
  `color` varchar(30) DEFAULT NULL,
  `icon` varchar(20) DEFAULT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  `cover` varchar(150) DEFAULT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int NOT NULL,
  `insert_user` int NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_menu_lang`
--

DROP TABLE IF EXISTS `tbl_menu_lang`;
CREATE TABLE IF NOT EXISTS `tbl_menu_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `badge` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_menu_tag`
--

DROP TABLE IF EXISTS `tbl_menu_tag`;
CREATE TABLE IF NOT EXISTS `tbl_menu_tag` (
  `menu_id` int NOT NULL,
  `tag_id` int NOT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`menu_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_meta`
--

DROP TABLE IF EXISTS `tbl_meta`;
CREATE TABLE IF NOT EXISTS `tbl_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `fence` varchar(50) DEFAULT NULL,
  `label` varchar(150) DEFAULT NULL,
  `preset` varchar(100) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `input` varchar(20) DEFAULT NULL,
  `option` varchar(20) DEFAULT NULL,
  `sorter` tinyint NOT NULL DEFAULT '10',
  `ps` varchar(250) DEFAULT NULL,
  `last_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_meta_tag`
--

DROP TABLE IF EXISTS `tbl_meta_tag`;
CREATE TABLE IF NOT EXISTS `tbl_meta_tag` (
  `meta_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`meta_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_option`
--

DROP TABLE IF EXISTS `tbl_option`;
CREATE TABLE IF NOT EXISTS `tbl_option` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Enabled',
  `loader` enum('Preload','Demand') NOT NULL DEFAULT 'Demand',
  `group` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post`
--

DROP TABLE IF EXISTS `tbl_post`;
CREATE TABLE IF NOT EXISTS `tbl_post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `cover` varchar(255) NOT NULL,
  `layout` varchar(20) DEFAULT 'normal',
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_lang`
--

DROP TABLE IF EXISTS `tbl_post_lang`;
CREATE TABLE IF NOT EXISTS `tbl_post_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `from_ai` enum('No','Yes') NOT NULL DEFAULT 'No',
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_meta`
--

DROP TABLE IF EXISTS `tbl_post_meta`;
CREATE TABLE IF NOT EXISTS `tbl_post_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_press_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_tag`
--

DROP TABLE IF EXISTS `tbl_post_tag`;
CREATE TABLE IF NOT EXISTS `tbl_post_tag` (
  `post_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`post_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press`
--

DROP TABLE IF EXISTS `tbl_press`;
CREATE TABLE IF NOT EXISTS `tbl_press` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cate_id` int NOT NULL DEFAULT '1',
  `layout` int NOT NULL DEFAULT '1',
  `status` enum('Draft','Published','Scheduled','Changed','Offlined') DEFAULT 'Draft',
  `mode` enum('Article','Slide') NOT NULL DEFAULT 'Article',
  `on_homepage` enum('Yes','No') NOT NULL DEFAULT 'No',
  `on_top` enum('Yes','No') NOT NULL DEFAULT 'No',
  `slug` varchar(255) NOT NULL,
  `online_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `sorter` int NOT NULL DEFAULT '99',
  `cover` varchar(255) NOT NULL,
  `banner` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_author`
--

DROP TABLE IF EXISTS `tbl_press_author`;
CREATE TABLE IF NOT EXISTS `tbl_press_author` (
  `press_id` int NOT NULL,
  `author_id` int NOT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`press_id`,`author_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_book`
--

DROP TABLE IF EXISTS `tbl_press_book`;
CREATE TABLE IF NOT EXISTS `tbl_press_book` (
  `press_id` int UNSIGNED NOT NULL,
  `book_id` int UNSIGNED NOT NULL,
  `sorter` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_lang`
--

DROP TABLE IF EXISTS `tbl_press_lang`;
CREATE TABLE IF NOT EXISTS `tbl_press_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `from_ai` enum('No','Yes') NOT NULL DEFAULT 'No',
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(700) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_meta`
--

DROP TABLE IF EXISTS `tbl_press_meta`;
CREATE TABLE IF NOT EXISTS `tbl_press_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text,
  PRIMARY KEY (`id`),
  KEY `fk_meta_press_idx` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_related`
--

DROP TABLE IF EXISTS `tbl_press_related`;
CREATE TABLE IF NOT EXISTS `tbl_press_related` (
  `press_id` int UNSIGNED NOT NULL,
  `related_id` int UNSIGNED NOT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`related_id`,`press_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_tag`
--

DROP TABLE IF EXISTS `tbl_press_tag`;
CREATE TABLE IF NOT EXISTS `tbl_press_tag` (
  `press_id` int NOT NULL,
  `tag_id` int NOT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`press_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_term`
--

DROP TABLE IF EXISTS `tbl_press_term`;
CREATE TABLE IF NOT EXISTS `tbl_press_term` (
  `press_id` int UNSIGNED NOT NULL,
  `term_id` int UNSIGNED NOT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`,`press_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_trace`
--

DROP TABLE IF EXISTS `tbl_press_trace`;
CREATE TABLE IF NOT EXISTS `tbl_press_trace` (
  `id` int NOT NULL AUTO_INCREMENT,
  `press_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `press_id` (`press_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_role`
--

DROP TABLE IF EXISTS `tbl_role`;
CREATE TABLE IF NOT EXISTS `tbl_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `menu_id` int NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `priv` int DEFAULT '0',
  `info` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_search`
--

DROP TABLE IF EXISTS `tbl_search`;
CREATE TABLE IF NOT EXISTS `tbl_search` (
  `id` int NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `status` enum('Disabled','Enabled') NOT NULL DEFAULT 'Disabled',
  `site_id` int DEFAULT NULL,
  `counter` int NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `info` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_search_press`
--

DROP TABLE IF EXISTS `tbl_search_press`;
CREATE TABLE IF NOT EXISTS `tbl_search_press` (
  `press_id` int NOT NULL,
  `search_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_staff`
--

DROP TABLE IF EXISTS `tbl_staff`;
CREATE TABLE IF NOT EXISTS `tbl_staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('New','Verified','Freeze') DEFAULT 'New',
  `needReset` tinyint(1) NOT NULL DEFAULT '0',
  `role_id` int NOT NULL,
  `account` varchar(45) DEFAULT NULL,
  `pwd` varchar(72) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_staff_footmark`
--

DROP TABLE IF EXISTS `tbl_staff_footmark`;
CREATE TABLE IF NOT EXISTS `tbl_staff_footmark` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_staff_sudo`
--

DROP TABLE IF EXISTS `tbl_staff_sudo`;
CREATE TABLE IF NOT EXISTS `tbl_staff_sudo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_stream`
--

DROP TABLE IF EXISTS `tbl_stream`;
CREATE TABLE IF NOT EXISTS `tbl_stream` (
  `id` int NOT NULL AUTO_INCREMENT,
  `target` enum('Task','Sudo','StaffLogin') NOT NULL DEFAULT 'Sudo',
  `parent_id` int NOT NULL DEFAULT '0',
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `content` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_subscription`
--

DROP TABLE IF EXISTS `tbl_subscription`;
CREATE TABLE IF NOT EXISTS `tbl_subscription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('Disabled','Enabled') NOT NULL DEFAULT 'Enabled',
  `lancode` varchar(10) DEFAULT 'tw',
  `name` varchar(255) CHARACTER SET utf8mb4 DEFAULT '',
  `phone` varchar(50) DEFAULT '',
  `email` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_user` int DEFAULT '0',
  `insert_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `insert_user` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag`
--

DROP TABLE IF EXISTS `tbl_tag`;
CREATE TABLE IF NOT EXISTS `tbl_tag` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cate_id` int NOT NULL DEFAULT '0',
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `parent_id` int NOT NULL DEFAULT '0',
  `counter` int DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_lang`
--

DROP TABLE IF EXISTS `tbl_tag_lang`;
CREATE TABLE IF NOT EXISTS `tbl_tag_lang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `alias` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lang_pid` (`lang`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_related`
--

DROP TABLE IF EXISTS `tbl_tag_related`;
CREATE TABLE IF NOT EXISTS `tbl_tag_related` (
  `related_id` int NOT NULL,
  `tag_id` int NOT NULL,
  `sorter` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- 傾印資料表的資料 `tbl_category`
--

INSERT INTO `tbl_category` (`id`, `status`, `sorter`, `group`, `slug`, `cover`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 0, 'press', 'undefined', '', '2025-02-28 10:36:19', 1, '2025-02-19 07:49:26', 1);

--
-- 傾印資料表的資料 `tbl_category_lang`
--

INSERT INTO `tbl_category_lang` (`id`, `lang`, `parent_id`, `title`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, '雜談', '', '2025-02-28 10:36:19', 1, '2025-02-19 07:49:26', 1),
(2, 'en', 1, 'Undefined', '', '2025-02-28 10:36:19', 1, '2025-02-19 07:49:26', 1),
(9, 'jp', 1, '雑談', '', '2025-02-28 10:36:19', 1, '2025-02-28 10:36:19', 1),
(10, 'ko', 1, '잡담', '', '2025-02-28 10:36:19', 1, '2025-02-28 10:36:19', 1);

--
-- 傾印資料表的資料 `tbl_genus`
--

INSERT INTO `tbl_genus` (`id`, `status`, `sorter`, `group`, `name`, `color`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 98, 'course', '線上活動', NULL, '', '2021-11-11 17:25:01', 1, '2020-10-30 02:36:34', 1),
(2, 'Enabled', 99, 'course', '實體活動', NULL, '', '2021-11-11 17:25:11', 1, '2020-10-30 02:36:50', 1),
(3, 'Enabled', 2, 'press', '影音文章', '', '不放首圖、文中有影音', '2024-06-06 03:07:56', 1, '2020-10-30 03:00:26', 1),
(4, 'Enabled', 1, 'press', '一般文章', '', '大版位圖片 + 簡介在前', '2024-06-06 03:07:08', 1, '2021-11-11 14:42:01', 1),
(5, 'Enabled', 3, 'adv', '首頁客戶評語(112x112)', '', '', '2025-03-12 16:16:50', 1, '2023-09-22 05:31:41', 1),
(6, 'Enabled', 1, 'adv', '首頁首屏', '', '左大一\r\n右小二', '2025-03-12 16:15:41', 1, '2025-03-12 16:15:41', 1),
(7, 'Enabled', 2, 'adv', '首頁精選文章', '', '', '2025-03-12 16:16:30', 1, '2025-03-12 16:16:30', 1),
(8, 'Enabled', 0, 'tag', '一般標籤', '', '', '2025-03-21 00:06:44', 1, '2025-03-21 00:06:44', 1),
(9, 'Enabled', 1, 'tag', '大標籤', '', '', '2025-03-21 00:06:53', 1, '2025-03-21 00:06:53', 1);

--
-- 傾印資料表的資料 `tbl_menu`
--

INSERT INTO `tbl_menu` (`id`, `status`, `blank`, `parent_id`, `uri`, `theme`, `color`, `icon`, `sorter`, `cover`, `last_ts`, `last_user`, `insert_user`, `insert_ts`) VALUES
(1, 'Enabled', 'No', 0, '/nav', 'Basic', NULL, NULL, 0, '', '2017-01-17 13:09:45', 1, 1, '2021-09-20 01:14:24'),
(2, 'Enabled', 'No', 0, '/sidebar', 'Basic', NULL, NULL, 1, '', '2015-12-08 02:02:02', 1, 1, '2021-09-20 01:14:24'),
(4, 'Enabled', 'No', 2, 'about', 'Basic', 'info', NULL, 0, NULL, '2018-08-15 10:58:14', 1, 1, '2018-08-15 10:58:14'),
(5, 'Enabled', 'No', 2, '/s/privacy', 'Basic', 'info', '', 1, NULL, '2025-02-28 10:50:23', 1, 1, '2018-08-15 10:58:14'),
(9, 'Enabled', 'No', 2, '/contact', 'Basic', 'info', '', 2, NULL, '2025-02-28 10:50:46', 1, 1, '2018-08-17 12:02:05'),
(10, 'Enabled', 'No', 1, '/about', 'Basic', 'info', '', 0, NULL, '2025-02-28 10:51:00', 1, 1, '2018-09-27 03:52:10'),
(15, 'Enabled', 'No', 1, '/contact', 'Basic', 'info', '', 4, NULL, '2025-02-28 10:46:42', 1, 1, '2018-09-27 04:54:09'),
(16, 'Enabled', 'No', 0, 'Backend', 'Basic', 'info', NULL, 3, NULL, '2021-05-15 10:45:43', 1, 1, '2021-05-15 10:45:43'),
(17, 'Enabled', 'No', 16, 'cms', 'Basic', 'info', NULL, 0, NULL, '2021-05-15 10:46:29', 1, 1, '2021-05-15 10:46:29'),
(18, 'Enabled', 'No', 16, 'crm', 'Basic', 'info', NULL, 0, NULL, '2021-05-15 10:47:10', 1, 1, '2021-05-15 10:47:10'),
(19, 'Enabled', 'No', 16, 'site', 'Basic', 'info', NULL, 2, NULL, '2021-05-15 10:47:47', 1, 1, '2021-05-15 10:47:47'),
(21, 'Enabled', 'No', 19, 'menu/simple', 'Basic', 'info', 'sitemap', 1, NULL, '2023-06-12 21:01:05', 1, 1, '2021-05-16 11:18:31'),
(22, 'Enabled', 'No', 19, 'post/list', 'Basic', 'info', 'file-text-o', 0, NULL, '2021-05-16 11:19:11', 1, 1, '2021-05-16 11:19:11'),
(23, 'Enabled', 'No', 19, 'staff/simple', 'Basic', 'info', 'users', 2, NULL, '2023-06-12 21:01:05', 1, 1, '2021-05-16 11:20:14'),
(25, 'Enabled', 'No', 18, 'contact/simple', 'Basic', 'info', 'phone', 0, NULL, '2023-06-13 14:13:48', 1, 1, '2021-05-16 11:24:01'),
(27, 'Enabled', 'No', 17, 'press/list', 'Basic', 'info', 'rss', 0, NULL, '2021-09-22 08:37:49', 1, 1, '2021-05-16 11:26:33'),
(29, 'Enabled', 'No', 17, 'dashboard/collections', 'Basic', 'info', 'cogs', 5, NULL, '2025-02-21 08:15:26', 1, 1, '2021-05-16 11:27:52'),
(31, 'Enabled', 'No', 19, 'adv/list', 'Basic', 'info', 'newspaper-o', 3, NULL, '2023-06-12 21:01:05', 1, 1, '2021-05-16 11:28:46'),
(35, 'Enabled', 'No', 18, 'stream/simple', 'Basic', 'info', 'stack-overflow', 4, NULL, '2023-06-13 14:13:42', 1, 1, '2021-05-22 00:18:52'),
(36, 'Enabled', 'No', 19, 'dashboard/advanced', 'Basic', 'info', 'cogs', 5, NULL, '2023-06-12 21:08:11', 1, 1, '2021-05-22 00:22:40'),
(39, 'Disabled', 'No', 18, 'user/simple', 'Basic', 'info', 'heartbeat', 5, NULL, '2024-02-13 17:34:48', 1, 1, '2021-05-22 00:34:27'),
(40, 'Enabled', 'No', 18, 'customer/simple', '', NULL, 'user', 2, NULL, '2024-02-13 17:35:41', 1, 1, '2024-02-13 17:34:36'),
(41, 'Disabled', 'No', 18, 'project/simple', '', NULL, 'usd', 1, NULL, '2025-02-19 07:48:19', 1, 1, '2024-02-13 17:37:03'),
(42, 'Enabled', 'No', 18, 'invoice/simple', '', NULL, 'ticket', 3, NULL, '2024-02-13 17:40:12', 1, 1, '2024-02-13 17:40:12'),
(43, 'Enabled', 'No', 17, 'dictionary/list', '', NULL, 'wikipedia-w', 2, NULL, '2025-02-19 07:46:12', 1, 1, '2025-02-19 07:46:12'),
(44, 'Enabled', 'No', 17, 'book/list', '', NULL, 'book', 3, NULL, '2025-02-19 07:47:08', 1, 1, '2025-02-19 07:47:08'),
(45, 'Enabled', 'No', 1, '/category/junior-wayfarer', '', NULL, '', 2, NULL, '2025-02-28 10:45:15', 1, 1, '2025-02-19 08:39:04'),
(46, 'Enabled', 'No', 1, '/category/senior-wayfarer', '', NULL, '', 3, NULL, '2025-02-28 10:46:20', 1, 1, '2025-02-21 08:16:57'),
(47, 'Enabled', 'No', 1, '/category/game-hypothesis', '', NULL, '', 1, NULL, '2025-02-28 10:44:22', 1, 1, '2025-02-21 19:05:27'),
(48, 'Enabled', 'No', 17, 'draft/list', '', NULL, 'pencil', 1, NULL, '2025-04-01 05:19:01', 1, 1, '2025-02-27 19:04:04'),
(49, 'Enabled', 'No', 17, 'flash/list', '', NULL, 'flash', 4, NULL, '2025-02-27 19:04:45', 1, 1, '2025-02-27 19:04:45');

--
-- 傾印資料表的資料 `tbl_menu_lang`
--

INSERT INTO `tbl_menu_lang` (`id`, `lang`, `parent_id`, `title`, `badge`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, '上方導覽', NULL, NULL, '2018-08-15 09:36:49', 1, '2018-08-15 09:36:49', 1),
(2, 'en', 1, 'Nav', NULL, NULL, '2018-08-15 09:36:49', 1, '2018-08-15 09:36:49', 1),
(3, 'en', 2, 'Sidebar', NULL, NULL, '2018-08-15 09:36:49', 1, '2018-08-15 09:36:49', 1),
(4, 'tw', 2, '側邊欄', NULL, NULL, '2018-08-15 09:36:49', 1, '2018-08-15 09:36:49', 1),
(5, 'tw', 4, '關於我們', NULL, NULL, '2018-08-15 09:36:49', 1, '2018-08-15 09:36:49', 1),
(6, 'en', 4, 'About', NULL, NULL, '2018-08-15 09:36:49', 1, '2018-08-15 09:36:49', 1),
(7, 'tw', 5, '隱私權政策', '', '', '2025-02-28 10:50:23', 1, '2018-08-15 09:36:49', 1),
(8, 'en', 5, 'Privacy', '', '', '2025-02-28 10:50:23', 1, '2018-08-15 09:36:49', 1),
(9, 'tw', 9, '聯絡我們', '', '', '2025-02-28 10:50:46', 1, '2018-08-17 12:02:05', 1),
(10, 'en', 9, 'Contact us', '', '', '2025-02-28 10:50:46', 1, '2018-08-17 12:02:05', 1),
(11, 'tw', 10, '關於我們', '', '', '2025-02-28 10:51:00', 1, '2018-09-27 03:52:10', 1),
(12, 'en', 10, 'About us', '', '', '2025-02-28 10:51:00', 1, '2018-09-27 03:52:10', 1),
(21, 'tw', 15, '聯絡我們', '', '', '2025-02-28 10:46:42', 1, '2018-09-27 04:54:09', 1),
(22, 'en', 15, 'Contact us', '', '', '2025-02-28 10:46:42', 1, '2018-09-27 04:54:09', 1),
(23, 'tw', 16, '後台選單', '', '', '2021-05-15 10:45:43', 1, '2021-05-15 10:45:43', 1),
(24, 'en', 16, '', '', '', '2021-05-15 10:45:43', 1, '2021-05-15 10:45:43', 1),
(25, 'tw', 17, '內容管理', '', '', '2021-05-15 10:46:29', 1, '2021-05-15 10:46:29', 1),
(26, 'en', 17, '', '', '', '2021-05-15 10:46:29', 1, '2021-05-15 10:46:29', 1),
(27, 'tw', 18, '客戶管理', '', '', '2021-05-15 10:47:10', 1, '2021-05-15 10:47:10', 1),
(28, 'en', 18, '', '', '', '2021-05-15 10:47:10', 1, '2021-05-15 10:47:10', 1),
(29, 'tw', 19, '網站管理', '', '', '2021-05-15 10:47:47', 1, '2021-05-15 10:47:47', 1),
(30, 'en', 19, '', '', '', '2021-05-15 10:47:47', 1, '2021-05-15 10:47:47', 1),
(33, 'tw', 21, '選單', '', '', '2021-05-16 11:18:31', 1, '2021-05-16 11:18:31', 1),
(34, 'en', 21, '', '', '', '2021-05-16 11:18:31', 1, '2021-05-16 11:18:31', 1),
(35, 'tw', 22, '固定單頁', '', '', '2021-05-16 11:19:11', 1, '2021-05-16 11:19:11', 1),
(36, 'en', 22, '', '', '', '2021-05-16 11:19:11', 1, '2021-05-16 11:19:11', 1),
(37, 'tw', 23, '管理員', '', '', '2021-05-22 00:20:27', 1, '2021-05-16 11:20:14', 1),
(38, 'en', 23, '', '', '', '2021-05-22 00:20:27', 1, '2021-05-16 11:20:14', 1),
(41, 'tw', 25, '聯絡我們', '', '', '2021-05-16 11:24:01', 1, '2021-05-16 11:24:01', 1),
(42, 'en', 25, '', '', '', '2021-05-16 11:24:01', 1, '2021-05-16 11:24:01', 1),
(45, 'tw', 27, '文章', '', '', '2021-05-16 11:26:33', 1, '2021-05-16 11:26:33', 1),
(46, 'en', 27, '', '', '', '2021-05-16 11:26:33', 1, '2021-05-16 11:26:33', 1),
(47, 'tw', 28, '標籤', '', '', '2021-05-16 11:27:10', 1, '2021-05-16 11:27:10', 1),
(48, 'en', 28, '', '', '', '2021-05-16 11:27:10', 1, '2021-05-16 11:27:10', 1),
(49, 'tw', 29, '集合管理', '', '', '2025-02-21 08:15:26', 1, '2021-05-16 11:27:52', 1),
(50, 'en', 29, '', '', '', '2025-02-21 08:15:26', 1, '2021-05-16 11:27:52', 1),
(53, 'tw', 31, '廣告', '', '', '2021-05-16 11:28:46', 1, '2021-05-16 11:28:46', 1),
(54, 'en', 31, '', '', '', '2021-05-16 11:28:46', 1, '2021-05-16 11:28:46', 1),
(61, 'tw', 35, '服務歷程', '', '', '2023-06-12 21:00:12', 1, '2021-05-22 00:18:52', 1),
(62, 'en', 35, '', '', '', '2023-06-12 21:00:12', 1, '2021-05-22 00:18:52', 1),
(63, 'tw', 36, '進階', '', '', '2023-06-12 20:52:08', 1, '2021-05-22 00:22:40', 1),
(64, 'en', 36, '', '', '', '2023-06-12 20:52:08', 1, '2021-05-22 00:22:40', 1),
(69, 'tw', 39, '使用者', '', '', '2024-02-13 17:34:48', 1, '2021-05-22 00:34:27', 1),
(70, 'en', 39, '', '', '', '2024-02-13 17:34:48', 1, '2021-05-22 00:34:27', 1),
(71, 'tw', 40, '客戶', '', '', '2024-02-13 17:35:41', 1, '2024-02-13 17:34:36', 1),
(72, 'en', 40, '', '', '', '2024-02-13 17:35:41', 1, '2024-02-13 17:34:36', 1),
(73, 'tw', 41, '專案', '', '', '2025-02-19 07:48:19', 1, '2024-02-13 17:37:03', 1),
(74, 'en', 41, '', '', '', '2025-02-19 07:48:19', 1, '2024-02-13 17:37:03', 1),
(75, 'tw', 42, '發票', '', '', '2024-02-13 17:40:12', 1, '2024-02-13 17:40:12', 1),
(76, 'en', 42, '', '', '', '2024-02-13 17:40:12', 1, '2024-02-13 17:40:12', 1),
(77, 'tw', 43, '詞彙表', '', '', '2025-02-19 07:46:12', 1, '2025-02-19 07:46:12', 1),
(78, 'en', 43, '', '', '', '2025-02-19 07:46:12', 1, '2025-02-19 07:46:12', 1),
(79, 'tw', 44, '推薦書目', '', '', '2025-02-19 07:47:08', 1, '2025-02-19 07:47:08', 1),
(80, 'en', 44, '', '', '', '2025-02-19 07:47:08', 1, '2025-02-19 07:47:08', 1),
(81, 'tw', 45, '開拓行者', '', '', '2025-02-28 10:45:15', 1, '2025-02-19 08:39:04', 1),
(82, 'en', 45, 'Junior Wayfarer', '', '', '2025-02-28 10:45:15', 1, '2025-02-19 08:39:04', 1),
(83, 'tw', 46, '歷練行者', '', '', '2025-02-28 10:46:20', 1, '2025-02-21 08:16:57', 1),
(84, 'en', 46, 'Senior Wayfarer', '', '', '2025-02-28 10:46:20', 1, '2025-02-21 08:16:57', 1),
(85, 'tw', 47, '遊戲假說', '', '', '2025-02-28 10:44:22', 1, '2025-02-21 19:05:27', 1),
(86, 'en', 47, 'Game Hypothesis', '', '', '2025-02-28 10:44:22', 1, '2025-02-21 19:05:27', 1),
(87, 'tw', 48, 'AI幫手', '', '', '2025-04-01 05:19:01', 1, '2025-02-27 19:04:04', 1),
(88, 'en', 48, '', '', '', '2025-04-01 05:19:01', 1, '2025-02-27 19:04:04', 1),
(89, 'tw', 49, '外站文章', '', '', '2025-02-27 19:04:45', 1, '2025-02-27 19:04:45', 1),
(90, 'en', 49, '', '', '', '2025-02-27 19:04:45', 1, '2025-02-27 19:04:45', 1),
(91, 'jp', 10, 'About us', '', '', '2025-02-28 10:51:00', 1, '2025-02-28 10:43:44', 1),
(92, 'ko', 10, 'About us', '', '', '2025-02-28 10:51:00', 1, '2025-02-28 10:43:44', 1),
(93, 'jp', 47, 'ゲーム仮説', '', '', '2025-02-28 10:44:22', 1, '2025-02-28 10:44:22', 1),
(94, 'ko', 47, '게임 가설', '', '', '2025-02-28 10:44:22', 1, '2025-02-28 10:44:22', 1),
(95, 'jp', 45, '開拓者', '', '', '2025-02-28 10:45:15', 1, '2025-02-28 10:45:15', 1),
(96, 'ko', 45, '개척자', '', '', '2025-02-28 10:45:15', 1, '2025-02-28 10:45:15', 1),
(97, 'jp', 46, '歴練者', '', '', '2025-02-28 10:46:20', 1, '2025-02-28 10:46:20', 1),
(98, 'ko', 46, '경험자', '', '', '2025-02-28 10:46:20', 1, '2025-02-28 10:46:20', 1),
(99, 'jp', 15, 'Contact us', '', '', '2025-02-28 10:46:42', 1, '2025-02-28 10:46:42', 1),
(100, 'ko', 15, 'Contact us', '', '', '2025-02-28 10:46:42', 1, '2025-02-28 10:46:42', 1),
(101, 'jp', 5, 'プライバシーポリシー', '', '', '2025-02-28 10:50:23', 1, '2025-02-28 10:50:23', 1),
(102, 'ko', 5, '개인정보 처리방침', '', '', '2025-02-28 10:50:23', 1, '2025-02-28 10:50:23', 1),
(103, 'jp', 9, 'Contact us', '', '', '2025-02-28 10:50:46', 1, '2025-02-28 10:50:46', 1),
(104, 'ko', 9, 'Contact us', '', '', '2025-02-28 10:50:46', 1, '2025-02-28 10:50:46', 1),
(105, 'jp', 48, '', '', '', '2025-04-01 05:19:01', 1, '2025-04-01 05:19:01', 1),
(106, 'ko', 48, '', '', '', '2025-04-01 05:19:01', 1, '2025-04-01 05:19:01', 1);

--
-- 傾印資料表的資料 `tbl_meta`
--

INSERT INTO `tbl_meta` (`id`, `status`, `fence`, `label`, `preset`, `type`, `input`, `option`, `sorter`, `ps`, `last_ts`, `last_user`, `insert_user`, `insert_ts`) VALUES
(5, 'Enabled', 'seo_desc', 'SEO 描述', NULL, 'text', 'paragraph', NULL, 3, '', '2022-04-14 09:37:20', 1, 1, '2021-07-04 06:20:11'),
(6, 'Enabled', 'seo_keyword', 'SEO 關鍵字', NULL, 'text', 'paragraph', NULL, 4, '以英文逗號( , )間隔 ', '2022-04-14 09:37:31', 1, 1, '2021-07-04 06:26:12'),
(11, 'Enabled', 'btn_txt', 'CTA 文字', NULL, 'text', 'text', NULL, 10, '簡潔有力', '2022-08-05 15:52:44', 1, 1, '2022-08-05 15:52:44');

--
-- 傾印資料表的資料 `tbl_option`
--

INSERT INTO `tbl_option` (`id`, `status`, `loader`, `group`, `name`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Demand', 'page', 'title', 'Demo', '2018-11-06 02:56:04', 1, '2015-12-29 06:43:32', 1),
(2, 'Enabled', 'Demand', 'page', 'keyword', 'Demo', '2018-11-06 03:16:03', 1, '2015-12-29 06:44:11', 1),
(4, 'Enabled', 'Demand', 'page', 'img', 'https://lifetrainee.org/media/social-img', '2018-11-06 03:20:47', 1, '2015-12-29 06:46:44', 1),
(5, 'Enabled', 'Preload', 'social', 'facebook_page', 'https://www.facebook.com/', '2015-12-29 10:35:46', 1, '2015-12-29 10:35:46', 1),
(8, 'Enabled', 'Preload', 'default', 'contact_mail', 'support@lifetrainee.org', '2025-03-03 03:55:48', 1, '2016-02-02 02:08:41', 1),
(12, 'Enabled', 'Demand', 'page', 'ga', 'G-8PNTJRQXKR', '2025-03-03 03:11:39', 1, '2016-05-03 23:51:12', 1),
(26, 'Enabled', 'Preload', 'default', 'contact_phone', '+971', '2025-03-03 03:56:05', 1, '2016-02-02 02:08:41', 1),
(27, 'Enabled', 'Preload', 'default', 'contact_address', 'Dubai', '2025-03-03 03:56:17', 1, '2016-02-02 02:08:41', 1),
(28, 'Enabled', 'Preload', 'social', 'linkedin_page', 'https://www.linkedin.com/', '2015-12-29 10:35:46', 1, '2015-12-29 10:35:46', 1),
(29, 'Enabled', 'Preload', 'social', 'twitter_page', 'https://twitter.com/', '2015-12-29 10:35:46', 1, '2015-12-29 10:35:46', 1),
(30, 'Enabled', 'Demand', 'page', 'desc', 'Demo', '2018-11-06 03:15:26', 1, '2018-11-06 03:15:26', 1);

--
-- 傾印資料表的資料 `tbl_role`
--

INSERT INTO `tbl_role` (`id`, `status`, `menu_id`, `title`, `priv`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 16, 'Administrator', 255, '基本內容管理\r\n進階內容管理\r\n行銷管理\r\n紀錄管理', '2021-11-22 13:02:56', 1, '2018-01-13 17:58:43', 1),
(2, 'Enabled', 16, '進階', 7, '基本內容管理\r\n進階內容管理\r\n行銷管理', '2021-11-22 13:01:50', 1, '2018-01-17 03:37:15', 1),
(3, 'Enabled', 16, '一般', 5, '基本內容管理\r\n行銷管理', '2021-11-22 13:04:55', 1, '2021-11-09 06:07:15', 11);

--
-- 傾印資料表的資料 `tbl_staff`
--

INSERT INTO `tbl_staff` (`id`, `status`, `needReset`, `role_id`, `account`, `pwd`, `email`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Verified', 0, 1, 'trevor', '$2y$10$c2cRVuh4wXIkaFP7l/mR8O4v49LT8.Q//5ujmxupkc2dprf7HQmxq', 'trevor@sense-ino.co', '2017-04-02 02:01:05', 1, '2015-08-04 12:41:20', 1);


COMMIT;


