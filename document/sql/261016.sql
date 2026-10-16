
ALTER TABLE `tbl_draft` CHANGE `target` `target` ENUM('Post','Press','Tag','None','Dictionary') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'None';
