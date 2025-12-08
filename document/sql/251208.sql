
ALTER TABLE `tbl_draft` ADD `target` ENUM('Post','Press','Tag','None') NOT NULL DEFAULT 'None' AFTER `press_id`;
ALTER TABLE `tbl_draft` CHANGE `press_id` `row_id` INT(11) NOT NULL DEFAULT '0' COMMENT '目標 ID';

UPDATE `tbl_draft` SET `target` = 'Press' WHERE `row_id` != 0;
