
CREATE TABLE `tbl_role` (
  `id` int(11) NOT NULL,
  `status` enum('Disabled','Enabled') NOT NULL DEFAULT 'Disabled',
  `title` varchar(255) DEFAULT NULL,
  `priv` int(11) NOT NULL DEFAULT '0',
  `info` varchar(255) DEFAULT NULL,
  `last_ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_user` int(11) DEFAULT NULL,
  `insert_ts` timestamp NULL DEFAULT NULL,
  `insert_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `tbl_role`
--
ALTER TABLE `tbl_role`
  ADD PRIMARY KEY (`id`);

--
-- 在匯出的資料表使用 AUTO_INCREMENT
--

--
-- 使用資料表 AUTO_INCREMENT `tbl_role`
--
ALTER TABLE `tbl_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `tbl_staff` ADD `role_id` INT NOT NULL DEFAULT '0' AFTER `status`;

INSERT INTO `tbl_role` (`id`, `status`, `title`, `priv`, `info`, `last_ts`, `last_user`, `insert_ts`, `insert_user`) VALUES
(1, 'Enabled', 'Administrator', 255, 'all:1', '2018-05-11 15:19:30', 1, '2018-01-15 09:58:43', 1),
(2, 'Enabled', 'Market', 24, 'read:1', '2018-05-11 11:42:43', 1, '2018-01-18 19:37:15', 1),
(3, 'Enabled', 'Editor', 35, '', '2018-05-11 11:06:29', 1, '2018-05-11 11:06:29', 1);
