
ALTER TABLE `tbl_draft` CHANGE `target` `target` ENUM('Post','Press','Tag','None','Dictionary') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'None';

UPDATE `tbl_menu_lang` SET `lang` = 'ja' WHERE `lang` = 'jp';


--
-- 資料表結構 `tbl_post_term`
--

DROP TABLE IF EXISTS `tbl_post_term`;
CREATE TABLE IF NOT EXISTS `tbl_post_term` (
  `post_id` int UNSIGNED NOT NULL,
  `term_id` int UNSIGNED NOT NULL,
  `sorter` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
