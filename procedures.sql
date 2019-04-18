delimiter $$

CREATE DEFINER=`freecrm`@`localhost` PROCEDURE `CheckChildrenOrg`(p_organizationID int)
BEGIN
	DECLARE X,Y,Z int;
	DECLARE ukupniPopis NVARCHAR (1000);
	DECLARE trenutniPopis NVARCHAR (100);
	DROP TABLE IF EXISTS popis;
	DROP TABLE IF EXISTS popis1;
	DROP TABLE IF EXISTS popis2;
	SET ukupniPopis=p_organizationID;
	CREATE TEMPORARY TABLE popis1 SELECT id FROM torganizations WHERE parent = p_organizationID;
	CREATE TEMPORARY TABLE popis SELECT id FROM torganizations WHERE parent = p_organizationID;
	CREATE TEMPORARY TABLE popis2 SELECT id FROM torganizations WHERE parent = p_organizationID; 
	SELECT COUNT(*) FROM popis INTO X;
	WHILE X>0 DO
		DELETE FROM popis2;
		INSERT INTO popis2 SELECT id FROM torganizations WHERE parent in (SELECT id FROM popis1);
		SELECT COUNT(*) FROM popis2 INTO X;
		DELETE FROM popis1;
		INSERT INTO popis1 SELECT id FROM popis2;
		INSERT INTO popis SELECT id FROM popis2;
	END WHILE;
	INSERT INTO popis (id) VALUES (p_organizationID);
	SELECT * FROM popis WHERE status=1;
END$$


delimiter $$

CREATE DEFINER=`freecrmdb`@`localhost` PROCEDURE `CheckLogin`(IN `p_userName` VARCHAR(25), IN `p_password` VARCHAR(25))
BEGIN
SELECT tusers.id, userName, firstName, lastName, tusers.role, troles.role, tusers.salutation, tsalutation.salutation, tusers.organization, torganizations.name FROM tusers 
INNER JOIN troles on (tusers.role = troles.id)
INNER JOIN tsalutation on (tusers.salutation = tsalutation.id)
INNER JOIN torganizations on (tusers.organization = torganizations.id)
WHERE tusers.userName = p_userName AND tusers.password = p_password AND tusers.status=1;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteContact`(p_contact int, p_modifiedBy int)
BEGIN
	UPDATE IGNORE tcontacts SET `status`=0, `modifiedBy`=p_modifiedBy, `dateModified`=NOW() WHERE `id` = p_contact;
	SELECT ROW_COUNT();
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteCustomer`(p_customer int, p_modifiedBy int)
BEGIN
	UPDATE IGNORE tcustomers SET `status`=0, `modifiedBy`=p_modifiedBy, `dateModified`=NOW() WHERE `id` = p_customer;
	SELECT ROW_COUNT();
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeletePAS`(p_pas int, p_modifiedBy int)
BEGIN
	UPDATE IGNORE tpas SET `status`=0, `modifiedBy`=p_modifiedBy, `dateModified`=NOW() WHERE `id` = p_pas;
	SELECT ROW_COUNT();
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetChildCustomers`(p_parent int)
BEGIN
	DECLARE X int;
	DROP TABLE IF EXISTS popis;
	DROP TABLE IF EXISTS popis1;
	DROP TABLE IF EXISTS popis2;
	CREATE TEMPORARY TABLE popis1 SELECT id FROM tcustomers WHERE parent = p_parent;
	CREATE TEMPORARY TABLE popis SELECT id FROM tcustomers WHERE parent = p_parent;
	CREATE TEMPORARY TABLE popis2 SELECT id FROM tcustomers WHERE parent = p_parent; 
	SELECT COUNT(*) FROM popis INTO X;
	WHILE X>0 DO
		DELETE FROM popis2;
		INSERT INTO popis2 SELECT id FROM tcustomers WHERE parent in (SELECT id FROM popis1);
		SELECT COUNT(*) FROM popis2 INTO X;
		DELETE FROM popis1;
		INSERT INTO popis1 SELECT id FROM popis2;
		INSERT INTO popis SELECT id FROM popis2;
	END WHILE;
	
	SELECT id, name, description FROM tcustomers WHERE status=1 AND id IN (SELECT id FROM popis);
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetContact`(p_id int)
BEGIN
SET @sqlStatement=CONCAT(
'SELECT tcontacts.id AS contact, tcontacts.firstName, tcontacts.middleName, tcontacts.lastName, tcontacts.positionDescription,
COALESCE(tcontacts.customerID,"0") AS customerID, COALESCE(tcustomers.name,"None") AS customerName, tcontacts.organizationID, torganizations.name AS organization,  
tcontacts.email1, tcontacts.email1Desc, tcontacts.email2, tcontacts.email2Desc,
tcontacts.phone1, tcontacts.phone1Desc, tcontacts.phone2, tcontacts.phone2Desc, tcontacts.phone3, tcontacts.phone3Desc,
tcontacts.createdBy, created_by.firstName AS createdFirstName, created_by.lastName AS createdLastName, 
tcontacts.modifiedBy, modified_by.firstName AS modifiedFirstName, modified_by.lastName AS modifiedLastName,
tcontacts.dateModified, tcontacts.dateCreated, tcontacts.description, tcontacts.status 
FROM tcontacts
LEFT OUTER JOIN tcustomers ON tcustomers.id = tcontacts.customerID
INNER JOIN torganizations ON tcontacts.organizationID=torganizations.id
INNER JOIN tusers AS modified_by ON tcontacts.modifiedBy=modified_by.id
INNER JOIN tusers AS created_by ON tcontacts.createdBy=created_by.id
WHERE
tcontacts.id=',p_id,' AND tcontacts.status=1');

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;  


END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetContactByCustomer`(p_customerID int)
BEGIN
	SELECT id, firstName, middleName, lastName, positionDescription FROM tcontacts WHERE customerID = p_customerID AND status=1;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetContactsSales`(p_contact int)
BEGIN

SELECT 	tsales.id AS salesID, tsalesstatus.name AS salesStatus, 
		tsales.description, tsales.value FROM tsales
INNER JOIN tsalesstatus ON salesStatusID=tsalesstatus.id
WHERE tsales.contact = p_contact;

END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomer`(p_id int)
BEGIN

SET @sqlStatement=CONCAT(
'SELECT tcustomers.id AS customer, tcustomers.name, tcustomers.description, tcustomers.webSite, tcustomers.phone, 
tcustomers.address, tcustomers.city, tcustomers.state, tcustomers.country,
tcustomers.parent, parent.name AS parentName, tcustomers.organizationID, torganizations.name AS organization, tcustomers.logo, 
tcustomers.createdBy, created_by.firstName AS createdFirstName, created_by.lastName AS createdLastName, 
tcustomers.modifiedBy, modified_by.firstName AS modifiedFirstName, modified_by.lastName AS modifiedLastName,
tcustomers.dateModified, tcustomers.dateCreated, tcustomers.status, tcustomers.entity_person
FROM tcustomers
LEFT OUTER JOIN tcustomers AS parent ON tcustomers.parent = parent.id
INNER JOIN torganizations ON tcustomers.organizationID=torganizations.id
INNER JOIN tusers AS modified_by ON tcustomers.modifiedBy=modified_by.id
INNER JOIN tusers AS created_by ON tcustomers.createdBy=created_by.id
WHERE
tcustomers.id=',p_id,' AND tcustomers.status=1');

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;  

END$$


delimiter $$

CREATE DEFINER=`freecrmdb`@`localhost` PROCEDURE `GetCustomersShortAll`()
BEGIN
	SELECT id, name, description FROM tcustomers WHERE status=1 ORDER BY id;

END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrganizationsShortAll`()
BEGIN
	SELECT id, name FROM torganizations WHERE status=1 ORDER BY id;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPAS`(p_id int)
BEGIN
SET @sqlStatement=CONCAT(
'SELECT tpas.id AS pas, tpas.name, tpas.description, tpas.product_service_both as p_s_b,
tpas.createdBy, created_by.firstName AS createdFirstName, created_by.lastName AS createdLastName, 
tpas.modifiedBy, modified_by.firstName AS modifiedFirstName, modified_by.lastName AS modifiedLastName,
tpas.dateModified, tpas.dateCreated, tpas.status, tpas.organizationID, torganizations.name AS organization
FROM tpas
INNER JOIN torganizations ON tpas.organizationID=torganizations.id
INNER JOIN tusers AS modified_by ON tpas.modifiedBy=modified_by.id
INNER JOIN tusers AS created_by ON tpas.createdBy=created_by.id
WHERE
tpas.id=',p_id,' AND tpas.status=1');

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPASContainedIn`(p_pas int)
BEGIN
	DECLARE X int;
	DROP TABLE IF EXISTS popis;
	DROP TABLE IF EXISTS popis1;
	DROP TABLE IF EXISTS popis2;
	CREATE TEMPORARY TABLE popis SELECT idPas FROM tpascontent WHERE tpascontent.contains = p_pas;
	CREATE TEMPORARY TABLE popis1 SELECT idPas FROM tpascontent WHERE tpascontent.contains = p_pas;
	CREATE TEMPORARY TABLE popis2 SELECT idPas FROM tpascontent WHERE tpascontent.contains = p_pas;
	SELECT COUNT(*) FROM popis INTO X;
	WHILE X>0 DO
		DELETE FROM popis2;
		INSERT INTO popis2 SELECT idPas FROM tpascontent WHERE tpascontent.contains IN (SELECT idPas FROM popis1);
		SELECT COUNT(*) FROM popis2 INTO X;
		DELETE FROM popis1;
		INSERT INTO popis1 SELECT idPas FROM popis2;
		INSERT INTO popis SELECT idPas FROM popis2;
	END WHILE;
	
	SELECT id, name, description FROM tpas WHERE status=1 AND id IN (SELECT idPas FROM popis);
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPASContent`(p_pas int)
BEGIN
SELECT tpascontent.contains, contains.name AS content, contains.description AS contentDescription, tpascontent.quantity
FROM tpascontent
INNER JOIN tpas AS contains ON tpascontent.contains = contains.id
WHERE tpascontent.idPas = p_pas AND contains.status=1;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSales`(p_sales int, p_contact int, p_customer int)
BEGIN
	IF p_contact=0 AND p_customer!=0 THEN
		SELECT tsales.id AS sales, tsales.salesStatusID, tsalesstatus.name AS statusName, tsales.description, tsales.pasID, 
		tpas.name AS pasName, tsales.value, CONCAT(tusers.firstName," ",tusers.lastName) as modificationBy, tsales.dateModified 
		FROM tsales
		INNER JOIN tsalesstatus ON tsales.salesStatusID=tsalesstatus.id
		INNER JOIN tusers ON tsales.modifiedBy=tusers.id
		INNER JOIN tpas ON tsales.pasID = tpas.id
		WHERE tsales.id=p_sales AND tsales.customer=p_customer;
	ELSEIF p_contact!=0 AND p_customer=0 THEN
		SELECT tsales.id AS sales, tsales.salesStatusID, tsalesstatus.name AS statusName, tsales.description, tsales.pasID, 
		tpas.name AS pasName, tsales.value, CONCAT(tusers.firstName," ",tusers.lastName) as modificationBy, tsales.dateModified 
		FROM tsales
		INNER JOIN tsalesstatus ON tsales.salesStatusID=tsalesstatus.id
		INNER JOIN tusers ON tsales.modifiedBy=tusers.id
		INNER JOIN tpas ON tsales.pasID = tpas.id
		WHERE tsales.id=p_sales AND tsales.contact=p_contact;
	ELSEIF p_contact!=0 AND p_customer!=0 THEN
		SELECT tsales.id AS sales, tsales.salesStatusID, tsalesstatus.name AS statusName, tsales.description, tsales.pasID, 
		tpas.name AS pasName, tsales.value, CONCAT(tusers.firstName," ",tusers.lastName) as modificationBy, tsales.dateModified 
		FROM tsales
		INNER JOIN tsalesstatus ON tsales.salesStatusID=tsalesstatus.id
		INNER JOIN tusers ON tsales.modifiedBy=tusers.id
		INNER JOIN tpas ON tsales.pasID = tpas.id
		WHERE tsales.id=p_sales AND tsales.contact=p_contact AND tsales.customer=p_customer;
	END IF;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSalesStatus`()
BEGIN
	SELECT id, name FROM tsalesstatus ORDER BY id;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertContact`(p_firstName varchar(25), p_middleName varchar(25), p_lastName varchar(25), 
p_positionDescription varchar(100), p_description varchar(200), p_customer int, p_organizationID int,
p_email1Desc varchar(10), p_email1 varchar(50),
p_email2Desc varchar(10), p_email2 varchar(50),
p_phone1Desc varchar(10), p_phone1 varchar(20),
p_phone2Desc varchar(10), p_phone2 varchar(20),
p_phone3Desc varchar(10), p_phone3 varchar(20),
p_modifiedBy int)
BEGIN
	if p_customer=0 THEN SET p_customer=null; END if;
	INSERT INTO tcontacts(
		firstName, middleName, lastName, 
		positionDescription, description, customerID, organizationID,
		email1Desc, email1, email2Desc, email2,
		phone1Desc, phone1, phone2Desc, phone2, phone3Desc, phone3,
		createdBy, modifiedBy, dateModified, dateCreated, status 
	) 
	VALUES (
		p_firstName, p_middleName, p_lastName, 
		p_positionDescription, p_description, p_customer, p_organizationID,
		p_email1Desc, p_email1, p_email2Desc, p_email2,
		p_phone1Desc, p_phone1, p_phone2Desc, p_phone2, p_phone3Desc, p_phone3,
		p_modifiedBy, p_modifiedBy, NOW(), NOW(),1);
	SELECT LAST_INSERT_ID() as intRecordKey;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertCustomer`(p_name varchar(25),p_description varchar(200),p_webSite varchar(50),p_phone varchar(20),p_address varchar(30),p_city varchar(50),p_state varchar(20),p_country varchar(50),p_parent int,p_organizationID int,p_entity_person int, p_modifiedBy int)
BEGIN
if p_parent=0 THEN SET p_parent=null; END if;

INSERT INTO tcustomers(name ,description,webSite,phone,address,city,state,country,parent,organizationID,entity_person, modifiedBy, createdBy, dateModified, dateCreated, status) 
VALUES (p_name ,p_description,p_webSite,p_phone,p_address,p_city,p_state,p_country,p_parent,p_organizationID,p_entity_person, p_modifiedBy, p_modifiedBy, NOW(), NOW(),1);

SELECT LAST_INSERT_ID() as intRecordKey;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPAS`(p_name varchar(25),p_description varchar(200),p_p_s_b varchar(50), p_organizationID int, p_modifiedBy int)
BEGIN
	INSERT INTO tpas(
		name, description, product_service_both, organizationID,
		createdBy, modifiedBy, dateModified, dateCreated, status 
	) 
	VALUES (
		p_name, p_description, p_p_s_b, p_organizationID,
		p_modifiedBy, p_modifiedBy, NOW(), NOW(),1);
	SELECT LAST_INSERT_ID() as intRecordKey;
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPASContent`(p_content TEXT)
BEGIN
	DECLARE commaPosition INT;
	DECLARE operatingText TEXT;
	DECLARE idPas VARCHAR(25);
	DECLARE contains VARCHAR(25);	
	DECLARE quantity VARCHAR(25);
	DECLARE result INT;
	DECLARE resultTemp INT;
	SET result=1;
	
	IF INSTR(p_content,";")!=0 THEN
		REPEAT
		
			SET operatingText=SUBSTRING(p_content,2,INSTR(p_content,";")-3);

			SET commaPosition=INSTR(operatingText,",");
			SET idPas= SUBSTRING(operatingText,1,commaPosition-1);
			SET operatingText=SUBSTRING(operatingText,commaPosition+1);

			set commaPosition=INSTR(operatingText,",");
			SET contains= SUBSTRING(operatingText,1,commaPosition-1);
			SET operatingText=SUBSTRING(operatingText,commaPosition+1);
			
			SET quantity= operatingText;
			
			SELECT SavePASContent(idPas,contains,quantity) INTO resultTemp;
			
			SET result = result*resultTemp;

			SET p_content= SUBSTRING(p_content,INSTR(p_content,";")+1);
		
		UNTIL INSTR(p_content,";")=0
		END REPEAT;
	END IF;
	SET operatingText=SUBSTRING(p_content,2,LENGTH(p_content)-2);
	SET commaPosition=INSTR(operatingText,",");
	SET idPas= SUBSTRING(operatingText,1,commaPosition-1);
	SET operatingText=SUBSTRING(operatingText,commaPosition+1);

	set commaPosition=INSTR(operatingText,",");
	SET contains= SUBSTRING(operatingText,1,commaPosition-1);
	SET operatingText=SUBSTRING(operatingText,commaPosition+1);
	
	SET quantity= operatingText;
	
	SELECT SavePASContent(idPas,contains,quantity) INTO resultTemp;
	
	SET result = result*resultTemp;

	SELECT result;

END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveContact`(
p_contact int, p_firstName varchar(25), p_middleName varchar(25), p_lastName varchar(25), 
p_positionDescription varchar(100), p_description varchar(200), p_customer int, p_organizationID int,
p_email1Desc varchar(10), p_email1 varchar(50),
p_email2Desc varchar(10), p_email2 varchar(50),
p_phone1Desc varchar(10), p_phone1 varchar(20),
p_phone2Desc varchar(10), p_phone2 varchar(20),
p_phone3Desc varchar(10), p_phone3 varchar(20),
p_modifiedBy int
)
BEGIN
	if p_customer=0 THEN SET p_customer=null; END if;
	UPDATE IGNORE tcontacts SET firstName = p_firstName, middleName = p_middleName, lastName = p_lastName, 
	positionDescription = p_positionDescription, description = p_description, customerID = p_customer, organizationID = p_organizationID,
	email1Desc = p_email1Desc, email1 = p_email1,
	email2Desc = p_email2Desc, email2 = p_email2,
	phone1Desc = p_phone1Desc, phone1 = p_phone1,
	phone2Desc = p_phone2Desc, phone2 = p_phone2,
	phone3Desc = p_phone3Desc, phone3 = p_phone3,
	modifiedBy=p_modifiedBy, dateModified=NOW()
	WHERE id= p_contact;
	SELECT ROW_COUNT();
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SaveCustomer`(p_customer int,p_name varchar(25),p_description varchar(200),p_webSite varchar(50),p_phone varchar(20),p_address varchar(30),p_city varchar(50),p_state varchar(20),p_country varchar(50),p_parent int,p_organizationID int,p_entity_person int, p_modifiedBy int)
BEGIN
	/*SHOW ERRORS LIMIT 1;*/
	if p_parent=0 THEN SET p_parent=null; END if;
	UPDATE IGNORE tcustomers SET name=p_name, description=p_description, webSite=p_webSite, phone=p_phone, address=p_address, 
	city=p_city, state=p_state, country=p_country, parent=p_parent, organizationID=p_organizationID, 
	entity_person= p_entity_person, modifiedBy=p_modifiedBy, dateModified=NOW()
	WHERE id=p_customer;
	SELECT ROW_COUNT();
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SavePAS`(p_pas int,p_name varchar(25),p_description varchar(200),p_p_s_b varchar(50), p_organizationID int, p_modifiedBy int)
BEGIN
	UPDATE IGNORE tpas SET name=p_name, description=p_description, product_service_both=p_p_s_b, organizationID=p_organizationID, 
	modifiedBy=p_modifiedBy, dateModified=NOW()
	WHERE id=p_pas;
	SELECT ROW_COUNT();
END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchAllContactsForOne`(IN `p_searching` VARCHAR(25))
    NO SQL
BEGIN
IF p_searching="" THEN
SET @sqlStatement=CONCAT(
'SELECT tcontacts.id AS contact, tcontacts.firstName, tcontacts.lastName, tcontacts.positionDescription, tcontacts.description FROM tcontacts
WHERE
status=1 ORDER BY contact');

ELSE
SET @sqlStatement=CONCAT(
'SELECT tcontacts.id AS contact, tcontacts.firstName, tcontacts.lastName, tcontacts.positionDescription, tcontacts.description FROM tcontacts
LEFT OUTER JOIN tcustomers ON tcontacts.customerID = tcustomers.id
WHERE
(tcontacts.firstName LIKE \'%',p_searching,'%\' OR
tcontacts.lastName LIKE \'%',p_searching,'%\' OR
tcontacts.positionDescription LIKE \'%',p_searching,'%\' OR
tcontacts.description LIKE \'%',p_searching,'%\' OR
tcontacts.phone1 LIKE \'%',p_searching,'%\' OR
tcontacts.phone2 LIKE \'%',p_searching,'%\' OR
tcontacts.phone3 LIKE \'%',p_searching,'%\' OR
tcontacts.email1 LIKE \'%',p_searching,'%\' OR
tcontacts.email2 LIKE \'%',p_searching,'%\' OR
tcontacts.description LIKE \'%',p_searching,'%\' OR
tcustomers.name LIKE \'%',p_searching,'%\' OR
tcustomers.description LIKE \'%',p_searching,'%\') AND tcontacts.status=1 ORDER BY contact');
END IF;

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;  


END$$


delimiter $$

CREATE DEFINER=`freecrmdb`@`localhost` PROCEDURE `SearchAllCustomersForOne`(IN `p_searching` VARCHAR(25))
    NO SQL
BEGIN

IF p_searching="" THEN
SET @sqlStatement=CONCAT(
'SELECT tcustomers.id AS customer, tcustomers.name, tcustomers.description FROM tcustomers
WHERE
status=1 ORDER BY customer');

ELSE
SET @sqlStatement=CONCAT(
'SELECT tcustomers.id AS customer, tcustomers.name, tcustomers.description FROM tcustomers
WHERE
(tcustomers.name LIKE \'%',p_searching,'%\' OR
tcustomers.description LIKE \'%',p_searching,'%\' OR
tcustomers.website LIKE \'%',p_searching,'%\' OR
tcustomers.phone LIKE \'%',p_searching,'%\' OR
tcustomers.address LIKE \'%',p_searching,'%\' OR
tcustomers.city LIKE \'%',p_searching,'%\' OR
tcustomers.state LIKE \'%',p_searching,'%\') AND status=1 ORDER BY customer');
END IF;

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;  

END$$


delimiter $$

CREATE DEFINER=`freecrmdb`@`localhost` PROCEDURE `SearchAllForOne`(IN `p_searching` VARCHAR(25))
    NO SQL
BEGIN


SET @sqlStatement=CONCAT(
'(SELECT tcontacts.id AS contact, tcontacts.customerID AS customer, null as name, tcontacts.firstName, tcontacts.middleName, tcontacts.lastName, tcontacts.description FROM tcontacts
WHERE
(tcontacts.firstName LIKE \'%',p_searching,'%\' OR
tcontacts.middleName LIKE \'%',p_searching,'%\' OR
tcontacts.lastName LIKE \'%',p_searching,'%\' OR
tcontacts.positionDescription LIKE \'%',p_searching,'%\' OR
tcontacts.description LIKE \'%',p_searching,'%\' OR
tcontacts.email1 LIKE \'%',p_searching,'%\' OR
tcontacts.email2 LIKE \'%',p_searching,'%\' OR
tcontacts.phone1 LIKE \'%',p_searching,'%\' OR
tcontacts.phone2 LIKE \'%',p_searching,'%\' OR
tcontacts.phone3 LIKE \'%',p_searching,'%\') AND status=1)
UNION 
(SELECT null,tcustomers.id, tcustomers.name, null, null, null, tcustomers.description FROM tcustomers
WHERE
(tcustomers.name LIKE \'%',p_searching,'%\' OR
tcustomers.description LIKE \'%',p_searching,'%\' OR
tcustomers.website LIKE \'%',p_searching,'%\' OR
tcustomers.phone LIKE \'%',p_searching,'%\' OR
tcustomers.address LIKE \'%',p_searching,'%\' OR
tcustomers.city LIKE \'%',p_searching,'%\' OR
tcustomers.state LIKE \'%',p_searching,'%\') AND status=1) ORDER BY customer, contact');

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;  

END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchPAS`(IN `p_searching` VARCHAR(25))
BEGIN
IF p_searching="" THEN
	SET @sqlStatement=CONCAT(
	'SELECT tpas.id AS pas, tpas.name, tpas.description FROM TPAS
	WHERE
	status=1');
ELSE
	SET @sqlStatement=CONCAT(
	'SELECT tpas.id AS pas, tpas.name, tpas.description FROM TPAS
	WHERE
	(tpas.name LIKE \'%',p_searching,'%\' OR
	tpas.description LIKE \'%',p_searching,'%\')
	AND status=1');
END IF;

PREPARE stmt1 FROM @sqlStatement;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1; 


END$$


delimiter $$

CREATE DEFINER=`root`@`localhost` FUNCTION `SavePASContent`(p_idPas VARCHAR(25),p_contains VARCHAR(25),p_quantity VARCHAR(25)) RETURNS int(11)
BEGIN
	DECLARE p_return INT;
	DECLARE p_count INT;
	IF p_quantity="0" THEN
		DELETE FROM tpascontent WHERE idPas=p_idPas AND contains=p_contains;
	ELSE
		SELECT COUNT(*) FROM tpascontent WHERE idPas=p_idPas AND contains=p_contains INTO p_count;
		IF p_count=0 THEN
			INSERT INTO tpascontent(idPas, contains, quantity) 
			VALUES (p_idPas,p_contains,p_quantity);
		ELSE
			UPDATE IGNORE tpascontent SET quantity = p_quantity WHERE idPas=p_idPas AND contains=p_contains;
		END IF;
	END IF;

	RETURN ROW_COUNT();
END$$


