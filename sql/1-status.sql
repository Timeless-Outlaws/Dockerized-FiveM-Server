USE redemrp;
CREATE TABLE `status` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL DEFAULT '0',
	`charid` INT(11) NOT NULL DEFAULT 0,
	`status` VARCHAR(255) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=100
;
