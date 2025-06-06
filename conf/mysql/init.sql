
--
-- 資料庫： `target_db`
--
CREATE DATABASE IF NOT EXISTS `target_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `target_db`;


-- --------------------------------------------------------

--
-- 資料表結構 `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(255) NOT NULL,
  `data` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `agent` varchar(300) DEFAULT NULL,
  `stamp` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `sessions`
--

INSERT INTO `sessions` (`session_id`, `data`, `ip`, `agent`, `stamp`) VALUES
('d9c07cabb1d7377b5be84ca249e03400', 'csrf|s:27:\"1ugxbqojkkcp0.2kjskf3dszacs\";cs|a:3:{s:4:\"name\";s:5:\"admin\";s:2:\"id\";s:1:\"1\";s:9:\"has_login\";i:1;}', '172.18.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36 FirePHP/0.7.4', 1534745917);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv`
--

CREATE TABLE `tbl_adv` (
  `id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `counter` int(11) NOT NULL,
  `exposure` int(11) NOT NULL DEFAULT 0,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `weight` int(11) NOT NULL DEFAULT 0,
  `theme` varchar(10) DEFAULT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `cover` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `background` varchar(255) NOT NULL,
  `last_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_user` int(11) NOT NULL,
  `insert_user` int(11) NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_adv_lang`
--

CREATE TABLE `tbl_adv_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author`
--

CREATE TABLE `tbl_author` (
  `id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `online_date` date DEFAULT NULL,
  `cover` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_author`
--

INSERT INTO `tbl_author` (`id`, `status`, `slug`, `online_date`, `cover`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'author1', NULL, '/upload/img/2018/08/1a6aaf4112188f5.png', '2018-08-17 01:13:29', 1, '2018-08-13 20:07:21', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author_lang`
--

CREATE TABLE `tbl_author_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `slogan` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- 資料表的匯出資料 `tbl_author_lang`
--

INSERT INTO `tbl_author_lang` (`id`, `lang`, `parent_id`, `title`, `slogan`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, '作者1+1', '我也很無奈', '<p>夷</p>', '2018-08-17 01:13:29', 1, '2018-08-13 20:07:21', 1),
(2, 'en', 1, 'author1', 'orz', '<p>en</p>', '2018-08-17 01:13:29', 1, '2018-08-13 20:07:21', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_author_tag`
--

CREATE TABLE `tbl_author_tag` (
  `author_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_author_tag`
--

INSERT INTO `tbl_author_tag` (`author_id`, `tag_id`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_collection`
--

CREATE TABLE `tbl_collection` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `txt_color` varchar(10) NOT NULL DEFAULT 'dark',
  `txt_algin` varchar(10) NOT NULL DEFAULT 'left',
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_collection_lang`
--

CREATE TABLE `tbl_collection_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_contact`
--

CREATE TABLE `tbl_contact` (
  `id` int(11) NOT NULL,
  `status` enum('New','Process','Done') NOT NULL DEFAULT 'New',
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text CHARACTER SET utf8mb4 NOT NULL,
  `other` text DEFAULT NULL,
  `response` text CHARACTER SET utf8mb4 NOT NULL,
  `last_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_user` int(11) NOT NULL,
  `insert_user` int(11) NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_dictionary`
--

CREATE TABLE `tbl_dictionary` (
  `id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_dictionary_lang`
--

CREATE TABLE `tbl_dictionary_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media`
--

CREATE TABLE `tbl_media` (
  `id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `pic` varchar(255) NOT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_media`
--

INSERT INTO `tbl_media` (`id`, `status`, `slug`, `title`, `pic`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'about', 'Hero Cover for AboutUs', '/upload/img/2018/08/091dec75a2b9dca.jpg', '', '2018-08-17 01:13:58', 1, '2018-08-13 22:27:20', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media_meta`
--

CREATE TABLE `tbl_media_meta` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `k` varchar(50) DEFAULT NULL,
  `v` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_media_tag`
--

CREATE TABLE `tbl_media_tag` (
  `media_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_menu`
--

CREATE TABLE `tbl_menu` (
  `id` int(11) NOT NULL,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Disabled',
  `parent_id` int(11) DEFAULT 0,
  `uri` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `theme` varchar(30) NOT NULL,
  `color` varchar(30) DEFAULT NULL,
  `sorter` int(11) NOT NULL DEFAULT 0,
  `cover` varchar(150) DEFAULT NULL,
  `last_ts` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_user` int(11) NOT NULL,
  `insert_user` int(11) NOT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_menu`
--

INSERT INTO `tbl_menu` (`id`, `status`, `parent_id`, `uri`, `theme`, `color`, `sorter`, `cover`, `last_ts`, `last_user`, `insert_user`, `insert_ts`) VALUES
(1, 'Enabled', 0, '/nav', 'Basic', NULL, 0, '', '2017-01-19 05:09:45', 1, 1, NULL),
(2, 'Enabled', 0, '/sidebar', 'Basic', NULL, 1, '', '2015-12-09 18:02:02', 1, 1, NULL),
(4, 'Enabled', 2, 'about', 'Basic', 'info', 0, NULL, '2018-08-17 02:58:14', 1, 1, '2018-08-17 02:58:14'),
(5, 'Enabled', 2, '/404', 'Basic', 'info', 1, NULL, '2018-08-19 04:03:33', 1, 1, '2018-08-17 02:58:14'),
(9, 'Enabled', 2, '/contact', 'Basic', 'info', 2, NULL, '2018-08-19 04:02:05', 1, 1, '2018-08-19 04:02:05');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_menu_lang`
--

CREATE TABLE `tbl_menu_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `badge` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_menu_lang`
--

INSERT INTO `tbl_menu_lang` (`id`, `lang`, `parent_id`, `title`, `badge`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, '上方導覽', NULL, NULL, '2018-08-17 01:36:49', 1, '2018-08-17 01:36:49', 1),
(2, 'en', 1, 'Nav', NULL, NULL, '2018-08-17 01:36:49', 1, '2018-08-17 01:36:49', 1),
(3, 'en', 2, 'Sidebar', NULL, NULL, '2018-08-17 01:36:49', 1, '2018-08-17 01:36:49', 1),
(4, 'tw', 2, '側邊欄', NULL, NULL, '2018-08-17 01:36:49', 1, '2018-08-17 01:36:49', 1),
(5, 'tw', 4, '關於我們', NULL, NULL, '2018-08-17 01:36:49', 1, '2018-08-17 01:36:49', 1),
(6, 'en', 4, 'About', NULL, NULL, '2018-08-17 01:36:49', 1, '2018-08-17 01:36:49', 1),
(7, 'tw', 5, '404', '', '', '2018-08-19 04:03:33', 1, '2018-08-17 01:36:49', 1),
(8, 'en', 5, '404', '', '', '2018-08-19 04:03:33', 1, '2018-08-17 01:36:49', 1),
(9, 'tw', 9, '聯絡我們', '', '', '2018-08-19 04:02:05', 1, '2018-08-19 04:02:05', 1),
(10, 'en', 9, 'Contact us', '', '', '2018-08-19 04:02:05', 1, '2018-08-19 04:02:05', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_option`
--

CREATE TABLE `tbl_option` (
  `id` int(11) NOT NULL,
  `status` enum('Enabled','Disabled') NOT NULL DEFAULT 'Enabled',
  `loader` enum('Preload','Demand') NOT NULL DEFAULT 'Demand',
  `group` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_option`
--

INSERT INTO `tbl_option` (`id`, `status`, `loader`, `group`, `name`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Demand', 'page', 'title', 'F3CMS DEMO', '2017-12-28 13:49:32', 1, '2015-12-29 06:43:32', 1),
(2, 'Enabled', 'Demand', 'page', 'keyword', 'key1,key2,key3', '2017-12-29 01:44:23', 1, '2015-12-29 06:44:11', 1),
(4, 'Enabled', 'Demand', 'page', 'img', 'demo.png', '2017-12-28 13:45:11', 1, '2015-12-29 06:46:44', 1),
(5, 'Enabled', 'Preload', 'social', 'facebook_page', 'https://www.facebook.com/', '2015-12-29 10:35:46', 1, '2015-12-29 10:35:46', 1),
(8, 'Enabled', 'Preload', 'default', 'contact_mail', 'sense.info.co@gmail.com', '2016-02-09 22:58:13', 1, '2016-02-02 02:08:41', 1),
(12, 'Enabled', 'Demand', 'page', 'ga', '<script></script>', '2018-08-08 18:58:41', 1, '2016-05-03 23:51:12', 1),
(26, 'Enabled', 'Preload', 'default', 'contact_phone', '+ 33 9 07 45 12 65', '2016-02-09 22:58:13', 1, '2016-02-02 02:08:41', 1),
(27, 'Enabled', 'Preload', 'default', 'contact_address', '42 rue Moulbert 75016 Paris', '2016-02-09 22:58:13', 1, '2016-02-02 02:08:41', 1),
(28, 'Enabled', 'Preload', 'social', 'linkedin_page', 'https://www.linkedin.com/', '2015-12-29 10:35:46', 1, '2015-12-29 10:35:46', 1),
(29, 'Enabled', 'Preload', 'social', 'twitter_page', 'https://twitter.com/', '2015-12-29 10:35:46', 1, '2015-12-29 10:35:46', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post`
--

CREATE TABLE `tbl_post` (
  `id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `slug` varchar(255) NOT NULL,
  `cover` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_post`
--

INSERT INTO `tbl_post` (`id`, `status`, `slug`, `cover`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(3, 'Enabled', 'about', '/upload/img/2018/08/3c616ae53687302.jpg', '2018-08-19 13:51:32', 1, '2017-01-17 10:07:53', 1),
(5, 'Enabled', 'contact', '', '2018-08-15 16:18:56', 1, '2017-03-25 18:22:21', 1),
(6, 'Enabled', 'privacy', '', '2018-08-15 16:21:01', 1, '2018-08-15 16:21:01', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_lang`
--

CREATE TABLE `tbl_post_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_post_lang`
--

INSERT INTO `tbl_post_lang` (`id`, `lang`, `parent_id`, `title`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 3, '關於我們', '<p>異中經開十學海積為市人飛求難總！國結色好天動來特：起事感。導值遊該一我最市。不酒請了筆動。向就面飛。不老期前，想樣長氣是明到；是於效平，已不而海場同選野。識多所小、子來車路素分，人條這館東程我支新表國試你一育：那學傳苦裡做她保於接親要下樹書用因，必是樓外成足則、為區健之也輕設公局東術；預改人賽；的怎士樹生高痛畫形服年是到參西以單史！她市沒主她相任裡政家童們；年從來立氣司然城再一教險常為：同為商過停苦文環不從，過不賽條如面頭藝的語軍內成時的、生濟處狀過可公苦羅上長家人木人法車品術照長獲其叫……轉氣語；費麼下！好生水他次說們也這子場作這自意康得放形現實力配所，查持小任處人比看嚴系參；就語一引家公法有講氣回。</p><h3>Incididunt ut labore</h3><p>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Ut enim ad minim veniam</h3><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas luctus at sem quis varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Phasellus iaculis magna</h3><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '2018-08-19 13:51:32', 1, '2018-08-06 16:55:57', 1),
(2, 'en', 3, 'About Us', '<p>Duis center aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><h3>Incididunt ut labore</h3><p>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Ut enim ad minim veniam</h3><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas luctus at sem quis varius. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus iaculis magna sagittis elit sagittis, at hendrerit lorem venenatis. Morbi accumsan iaculis blandit. Cras ultrices hendrerit nisl.</p><h3>Phasellus iaculis magna</h3><p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '2018-08-19 13:51:32', 1, '2018-08-06 16:55:57', 1),
(3, 'tw', 5, '聯絡我們~', '<p>中文 ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.<br>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>', '2018-08-15 16:18:56', 1, '2018-08-06 16:55:57', 1),
(4, 'en', 5, 'Contact us~', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.<br>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>', '2018-08-15 16:18:56', 1, '2018-08-06 16:55:57', 1),
(5, 'tw', 6, '隱私權政策', '<p>本《隱私權政策》旨在協助您瞭解本站收集的資訊類型以及收集這些資訊的原因，也說明了您可以如何更新、管理、匯出與刪除資訊。</p>', '2018-08-15 16:21:01', 1, '2018-08-15 16:21:01', 1),
(6, 'en', 6, '', '', '2018-08-15 16:21:01', 1, '2018-08-15 16:21:01', 1),
(7, 'tw', 7, 'tmp', '', '2018-08-15 16:22:43', 1, '2018-08-15 16:22:43', 1),
(8, 'en', 7, '', '', '2018-08-15 16:22:43', 1, '2018-08-15 16:22:43', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_meta`
--

CREATE TABLE `tbl_post_meta` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `k` varchar(50) DEFAULT NULL,
  `v` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_post_tag`
--

CREATE TABLE `tbl_post_tag` (
  `post_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press`
--

CREATE TABLE `tbl_press` (
  `id` int(11) NOT NULL,
  `status` enum('Draft','Published','Scheduled','Changed','Offlined') NOT NULL DEFAULT 'Draft',
  `mode` enum('Article','Slide') NOT NULL DEFAULT 'Article',
  `on_homepage` enum('Yes','No') NOT NULL DEFAULT 'No',
  `on_top` enum('Yes','No') NOT NULL DEFAULT 'No',
  `slug` varchar(255) NOT NULL,
  `online_date` date NOT NULL,
  `cover` varchar(255) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press`
--

INSERT INTO `tbl_press` (`id`, `status`, `mode`, `on_homepage`, `on_top`, `slug`, `online_date`, `cover`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(2, 'Published', 'Article', 'No', 'No', 'twbwood-com', '0000-00-00', '/upload/img/2018/08/666601b99690dbb.png', '2018-08-20 06:09:50', 1, '2018-08-20 06:02:39', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_author`
--

CREATE TABLE `tbl_press_author` (
  `press_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press_author`
--

INSERT INTO `tbl_press_author` (`press_id`, `author_id`) VALUES
(2, 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_lang`
--

CREATE TABLE `tbl_press_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `keyword` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 資料表的匯出資料 `tbl_press_lang`
--

INSERT INTO `tbl_press_lang` (`id`, `lang`, `parent_id`, `title`, `keyword`, `info`, `content`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 2, 'twbwood.com', NULL, NULL, '<p><img src=\"http://f3cms.lo:8080/upload/img/2018/08/aa58335331bc8ad.png\" class=\"fr-fic fr-dib img-responsive\"></p>', '2018-08-20 06:09:50', 1, '2018-08-20 06:02:39', 1),
(2, 'en', 2, 'twbwood.com', NULL, NULL, '', '2018-08-20 06:09:50', 1, '2018-08-20 06:02:39', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_meta`
--

CREATE TABLE `tbl_press_meta` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `k` varchar(50) DEFAULT NULL,
  `v` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press_meta`
--

INSERT INTO `tbl_press_meta` (`id`, `parent_id`, `last_ts`, `k`, `v`) VALUES
(1, 2, '2018-08-20 06:09:50', 'seo_title', 'seo');

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_related`
--

CREATE TABLE `tbl_press_related` (
  `press_id` int(10) UNSIGNED NOT NULL,
  `related_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_press_tag`
--

CREATE TABLE `tbl_press_tag` (
  `press_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_press_tag`
--

INSERT INTO `tbl_press_tag` (`press_id`, `tag_id`) VALUES
(2, 2);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_search`
--

CREATE TABLE `tbl_search` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `status` enum('Disabled','Enabled') NOT NULL DEFAULT 'Disabled',
  `site_id` int(11) DEFAULT NULL,
  `counter` int(11) NOT NULL DEFAULT 0,
  `title` varchar(255) DEFAULT NULL,
  `info` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_search_press`
--

CREATE TABLE `tbl_search_press` (
  `press_id` int(11) NOT NULL,
  `search_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_staff`
--

CREATE TABLE `tbl_staff` (
  `id` int(11) NOT NULL,
  `status` enum('New','Verified','Freeze') DEFAULT 'New',
  `account` varchar(45) DEFAULT NULL,
  `pwd` varchar(45) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_staff`
--

INSERT INTO `tbl_staff` (`id`, `status`, `account`, `pwd`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Verified', 'admin', '81dc9bdb52d04dc20036dbd8313ed055', '2017-04-02 10:01:05', 1, '2015-08-04 20:41:20', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag`
--

CREATE TABLE `tbl_tag` (
  `id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled') DEFAULT 'Disabled',
  `parent_id` int(11) NOT NULL DEFAULT 0,
  `counter` int(11) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `tbl_tag`
--

INSERT INTO `tbl_tag` (`id`, `status`, `parent_id`, `counter`, `slug`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(2, 'Enabled', 0, NULL, 'tag1', '2018-08-16 07:55:34', 1, '2018-07-31 18:30:03', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_lang`
--

CREATE TABLE `tbl_tag_lang` (
  `id` int(11) NOT NULL,
  `lang` varchar(5) NOT NULL DEFAULT 'tw',
  `parent_id` int(11) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `alias` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `info` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT current_timestamp(),
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- 資料表的匯出資料 `tbl_tag_lang`
--

INSERT INTO `tbl_tag_lang` (`id`, `lang`, `parent_id`, `title`, `alias`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'tw', 1, 'tag1', NULL, NULL, '2018-07-31 18:05:49', NULL, NULL, NULL),
(2, 'en', 1, 'tag1', NULL, NULL, '2018-07-31 18:05:49', NULL, NULL, NULL),
(3, 'tw', 2, '標籤1', '別名1~~~', NULL, '2018-08-16 07:55:34', 1, '2018-07-31 18:30:03', 1),
(4, 'en', 2, 'tag1', 'alias2', NULL, '2018-08-16 07:55:34', 1, '2018-07-31 18:30:03', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `tbl_tag_related`
--

CREATE TABLE `tbl_tag_related` (
  `related_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- 資料表索引 `tbl_adv`
--
ALTER TABLE `tbl_adv`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`position_id`),
  ADD KEY `uri` (`uri`);

--
-- 資料表索引 `tbl_adv_lang`
--
ALTER TABLE `tbl_adv_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_author`
--
ALTER TABLE `tbl_author`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_author_lang`
--
ALTER TABLE `tbl_author_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_author_tag`
--
ALTER TABLE `tbl_author_tag`
  ADD PRIMARY KEY (`author_id`,`tag_id`);

--
-- 資料表索引 `tbl_collection`
--
ALTER TABLE `tbl_collection`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `parent_id` (`parent_id`);

--
-- 資料表索引 `tbl_collection_lang`
--
ALTER TABLE `tbl_collection_lang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_contact`
--
ALTER TABLE `tbl_contact`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_dictionary`
--
ALTER TABLE `tbl_dictionary`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_dictionary_lang`
--
ALTER TABLE `tbl_dictionary_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_media`
--
ALTER TABLE `tbl_media`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_media_meta`
--
ALTER TABLE `tbl_media_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_meta_media_idx` (`parent_id`);

--
-- 資料表索引 `tbl_media_tag`
--
ALTER TABLE `tbl_media_tag`
  ADD PRIMARY KEY (`media_id`,`tag_id`);

--
-- 資料表索引 `tbl_menu`
--
ALTER TABLE `tbl_menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- 資料表索引 `tbl_menu_lang`
--
ALTER TABLE `tbl_menu_lang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_option`
--
ALTER TABLE `tbl_option`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group` (`group`);

--
-- 資料表索引 `tbl_post`
--
ALTER TABLE `tbl_post`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_post_lang`
--
ALTER TABLE `tbl_post_lang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_post_meta`
--
ALTER TABLE `tbl_post_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_meta_press_idx` (`parent_id`);

--
-- 資料表索引 `tbl_post_tag`
--
ALTER TABLE `tbl_post_tag`
  ADD PRIMARY KEY (`post_id`,`tag_id`);

--
-- 資料表索引 `tbl_press`
--
ALTER TABLE `tbl_press`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_press_author`
--
ALTER TABLE `tbl_press_author`
  ADD PRIMARY KEY (`press_id`,`author_id`) USING BTREE;

--
-- 資料表索引 `tbl_press_lang`
--
ALTER TABLE `tbl_press_lang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lang_pid` (`lang`,`parent_id`);

--
-- 資料表索引 `tbl_press_meta`
--
ALTER TABLE `tbl_press_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_meta_press_idx` (`parent_id`);

--
-- 資料表索引 `tbl_press_related`
--
ALTER TABLE `tbl_press_related`
  ADD PRIMARY KEY (`related_id`,`press_id`);

--
-- 資料表索引 `tbl_press_tag`
--
ALTER TABLE `tbl_press_tag`
  ADD PRIMARY KEY (`press_id`,`tag_id`);

--
-- 資料表索引 `tbl_staff`
--
ALTER TABLE `tbl_staff`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_tag`
--
ALTER TABLE `tbl_tag`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `tbl_tag_lang`
--
ALTER TABLE `tbl_tag_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lang_pid` (`lang`,`parent_id`);

--
-- 在匯出的資料表使用 AUTO_INCREMENT
--

--
-- 使用資料表 AUTO_INCREMENT `tbl_adv`
--
ALTER TABLE `tbl_adv`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `tbl_adv_lang`
--
ALTER TABLE `tbl_adv_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `tbl_author`
--
ALTER TABLE `tbl_author`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用資料表 AUTO_INCREMENT `tbl_author_lang`
--
ALTER TABLE `tbl_author_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用資料表 AUTO_INCREMENT `tbl_contact`
--
ALTER TABLE `tbl_contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `tbl_dictionary`
--
ALTER TABLE `tbl_dictionary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `tbl_dictionary_lang`
--
ALTER TABLE `tbl_dictionary_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `tbl_media`
--
ALTER TABLE `tbl_media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用資料表 AUTO_INCREMENT `tbl_menu`
--
ALTER TABLE `tbl_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用資料表 AUTO_INCREMENT `tbl_menu_lang`
--
ALTER TABLE `tbl_menu_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用資料表 AUTO_INCREMENT `tbl_option`
--
ALTER TABLE `tbl_option`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- 使用資料表 AUTO_INCREMENT `tbl_post`
--
ALTER TABLE `tbl_post`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用資料表 AUTO_INCREMENT `tbl_post_lang`
--
ALTER TABLE `tbl_post_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用資料表 AUTO_INCREMENT `tbl_press`
--
ALTER TABLE `tbl_press`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用資料表 AUTO_INCREMENT `tbl_press_lang`
--
ALTER TABLE `tbl_press_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用資料表 AUTO_INCREMENT `tbl_press_meta`
--
ALTER TABLE `tbl_press_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用資料表 AUTO_INCREMENT `tbl_staff`
--
ALTER TABLE `tbl_staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用資料表 AUTO_INCREMENT `tbl_tag`
--
ALTER TABLE `tbl_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用資料表 AUTO_INCREMENT `tbl_tag_lang`
--
ALTER TABLE `tbl_tag_lang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;


ALTER TABLE `tbl_menu` ADD `blank` ENUM('No', 'Yes') NOT NULL DEFAULT 'No' AFTER `status`;

ALTER TABLE `tbl_media` ADD `target` ENUM('Normal', 'Press') NOT NULL DEFAULT 'Normal' AFTER `status`, ADD `parent_id` INT NOT NULL DEFAULT '0' AFTER `target`;


ALTER TABLE `tbl_press_author` ADD `sorter` INT NOT NULL DEFAULT '0' AFTER `author_id`;
ALTER TABLE `tbl_press_related` ADD `sorter` INT NOT NULL DEFAULT '0' AFTER `related_id`;
ALTER TABLE `tbl_press` ADD `banner` varchar(255) NULL AFTER `cover`;


ALTER TABLE `tbl_press` CHANGE `online_date` `online_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `tbl_author` ADD `sorter` INT NOT NULL DEFAULT '0' AFTER `online_date`;

ALTER TABLE `tbl_press` ADD `sorter` INT NOT NULL DEFAULT '99' AFTER `online_date`;


--
-- 資料表結構 `tbl_author_meta`
--

CREATE TABLE `tbl_author_meta` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `k` varchar(50) DEFAULT NULL,
  `v` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `tbl_author_meta`
--
ALTER TABLE `tbl_author_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_meta_author_idx` (`parent_id`);

--
-- 在匯出的資料表使用 AUTO_INCREMENT
--

--
-- 使用資料表 AUTO_INCREMENT `tbl_author_meta`
--
ALTER TABLE `tbl_author_meta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
