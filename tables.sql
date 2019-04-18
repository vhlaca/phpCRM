delimiter $$

CREATE TABLE `tcontacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(25) CHARACTER SET utf8 NOT NULL,
  `middleName` varchar(25) CHARACTER SET utf8 NOT NULL,
  `lastName` varchar(25) CHARACTER SET utf8 NOT NULL,
  `positionDescription` varchar(100) CHARACTER SET utf8 NOT NULL,
  `customerID` int(11) DEFAULT NULL,
  `email1` varchar(50) CHARACTER SET utf8 NOT NULL,
  `email1Desc` varchar(10) CHARACTER SET utf8 NOT NULL,
  `email2` varchar(50) CHARACTER SET utf8 NOT NULL,
  `email2Desc` varchar(10) CHARACTER SET utf8 NOT NULL,
  `phone1` varchar(20) CHARACTER SET utf8 NOT NULL,
  `phone1Desc` varchar(10) CHARACTER SET utf8 NOT NULL,
  `phone2` varchar(20) CHARACTER SET utf8 NOT NULL,
  `phone2Desc` varchar(10) CHARACTER SET utf8 NOT NULL,
  `phone3` varchar(20) CHARACTER SET utf8 NOT NULL,
  `phone3Desc` varchar(10) CHARACTER SET utf8 NOT NULL,
  `description` varchar(200) CHARACTER SET utf8 NOT NULL,
  `createdBy` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateCreated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) NOT NULL DEFAULT '1',
  `organizationID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customerID` (`customerID`),
  KEY `createdBy` (`createdBy`),
  KEY `modifiedBy` (`modifiedBy`),
  KEY `organizationID` (`organizationID`),
  CONSTRAINT `tcontacts_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `tcustomers` (`id`),
  CONSTRAINT `tcontacts_ibfk_2` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`),
  CONSTRAINT `tcontacts_ibfk_3` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`),
  CONSTRAINT `tcontacts_ibfk_4` FOREIGN KEY (`organizationID`) REFERENCES `torganizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


delimiter $$

CREATE TABLE `tcustomers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) CHARACTER SET utf8 NOT NULL,
  `description` varchar(200) CHARACTER SET utf8 NOT NULL,
  `webSite` varchar(50) CHARACTER SET utf8 NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8 NOT NULL,
  `address` varchar(30) CHARACTER SET utf8 NOT NULL,
  `city` varchar(50) CHARACTER SET utf8 NOT NULL,
  `state` varchar(20) CHARACTER SET utf8 NOT NULL,
  `country` varchar(50) CHARACTER SET utf8 NOT NULL,
  `parent` int(11) DEFAULT NULL,
  `organizationID` int(11) NOT NULL,
  `logo` varchar(50) CHARACTER SET utf8 NOT NULL,
  `createdBy` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateCreated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) NOT NULL,
  `entity_person` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `parent` (`parent`),
  KEY `createdBy` (`createdBy`),
  KEY `modifiedBy` (`modifiedBy`),
  KEY `organizationID` (`organizationID`),
  CONSTRAINT `tcustomers_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `tcustomers` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `tcustomers_ibfk_3` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`),
  CONSTRAINT `tcustomers_ibfk_4` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


delimiter $$

CREATE TABLE `torganizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) CHARACTER SET utf8 NOT NULL,
  `description` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `webSite` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `address` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `city` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `state` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `country` varchar(45) CHARACTER SET utf8 DEFAULT 'Croatia',
  `parent` int(11) DEFAULT NULL,
  `logo` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `modifiedBy` int(11) DEFAULT NULL,
  `dateModified` timestamp NULL DEFAULT NULL,
  `dateCreated` timestamp NULL DEFAULT NULL,
  `status` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `createdBy` (`createdBy`),
  KEY `modifiedBy` (`modifiedBy`),
  CONSTRAINT `torganizations_ibfk_2` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`),
  CONSTRAINT `torganizations_ibfk_3` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


delimiter $$

CREATE TABLE `tpas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `createdBy` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateModified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) NOT NULL,
  `organizationID` int(11) NOT NULL,
  `product_service_both` int(11) DEFAULT NULL COMMENT '0 product, 1 service, 2 both',
  PRIMARY KEY (`id`),
  KEY `tpas_fk1_createdBy_idx` (`createdBy`),
  KEY `tpas_fk2_modifiedBy_idx` (`modifiedBy`),
  KEY `tpas_fk2_organization_idx` (`organizationID`),
  CONSTRAINT `tpas_fk1_createdBy` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tpas_fk2_modifiedBy` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tpas_fk3_organization` FOREIGN KEY (`organizationID`) REFERENCES `torganizations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `tpascontent` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idPas` int(11) NOT NULL,
  `contains` int(11) NOT NULL,
  `quantity` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tpasContent_fk_idPas_idx` (`idPas`),
  KEY `tpasContent_fk_contains_idx` (`contains`),
  CONSTRAINT `tpasContent_fk_contains` FOREIGN KEY (`contains`) REFERENCES `tpas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tpasContent_fk_idPas` FOREIGN KEY (`idPas`) REFERENCES `tpas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


delimiter $$

CREATE TABLE `troles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(20) DEFAULT NULL,
  `organizationID` int(11) DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `modifiedBy` int(11) DEFAULT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateCreated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modifiedBy` (`modifiedBy`),
  KEY `createdBy` (`createdBy`),
  CONSTRAINT `troles_ibfk_1` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`),
  CONSTRAINT `troles_ibfk_2` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `tsales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer` int(11) NOT NULL,
  `contact` int(11) DEFAULT NULL,
  `salesStatusID` int(11) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `pasID` int(11) NOT NULL,
  `value` decimal(10,0) DEFAULT NULL,
  `createdBy` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateModified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `tsakes_fk_customer_idx` (`customer`),
  KEY `tsales_fk_salesStatus_idx` (`salesStatusID`),
  KEY `tsales_fk_pas_idx` (`pasID`),
  KEY `tsales_fk_createdBy_idx` (`createdBy`),
  KEY `tsales_fk_modifiedBy_idx` (`modifiedBy`),
  KEY `tsales_fk_contact_idx` (`contact`),
  CONSTRAINT `tsales_fk_contact` FOREIGN KEY (`contact`) REFERENCES `tcontacts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tsales_fk_createdBy` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tsales_fk_customer` FOREIGN KEY (`customer`) REFERENCES `tcustomers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tsales_fk_modifiedBy` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tsales_fk_pas` FOREIGN KEY (`pasID`) REFERENCES `tpas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tsales_fk_salesStatus` FOREIGN KEY (`salesStatusID`) REFERENCES `tsalesstatus` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `tsalesstatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8$$


delimiter $$

CREATE TABLE `tsalutation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `salutation` varchar(20) CHARACTER SET ucs2 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


delimiter $$

CREATE TABLE `tusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `firstName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastName` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role` int(11) DEFAULT NULL,
  `salutation` int(11) DEFAULT NULL,
  `organization` int(11) DEFAULT NULL,
  `GOD` tinyint(4) DEFAULT NULL,
  `password` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  `createdBy` int(11) DEFAULT NULL,
  `modifiedBy` int(11) DEFAULT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dateCreated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `secretQuestion` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `secretAnswer` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userName` (`userName`),
  KEY `organization` (`organization`),
  KEY `salutation` (`salutation`),
  KEY `role` (`role`),
  KEY `createdBy` (`createdBy`),
  KEY `modifiedBy` (`modifiedBy`),
  KEY `status` (`status`),
  CONSTRAINT `tusers_ibfk_1` FOREIGN KEY (`organization`) REFERENCES `torganizations` (`id`),
  CONSTRAINT `tusers_ibfk_2` FOREIGN KEY (`role`) REFERENCES `troles` (`id`),
  CONSTRAINT `tusers_ibfk_3` FOREIGN KEY (`salutation`) REFERENCES `tsalutation` (`id`),
  CONSTRAINT `tusers_ibfk_4` FOREIGN KEY (`status`) REFERENCES `tuserstatus` (`id`),
  CONSTRAINT `tusers_ibfk_5` FOREIGN KEY (`createdBy`) REFERENCES `tusers` (`id`),
  CONSTRAINT `tusers_ibfk_6` FOREIGN KEY (`modifiedBy`) REFERENCES `tusers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


delimiter $$

CREATE TABLE `tuserstatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(20) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci$$


