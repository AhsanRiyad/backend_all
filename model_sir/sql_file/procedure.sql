DELIMITER $$
CREATE OR REPLACE DEFINER=`root`@`localhost` PROCEDURE `REGISTRATION`(   IN 'first_name' VARCHAR(100) ,  IN 'last_name' VARCHAR(100) ,  IN 'gender' VARCHAR(100) ,  IN 'institution_id' VARCHAR(100) ,  IN 'nid_or_passport' VARCHAR(100) ,  IN 'fathers_name' VARCHAR(100) ,  IN 'mother_name' VARCHAR(100) ,  IN 'spouse_name' VARCHAR(100) ,  IN 'number_of_children' INT ,  IN 'present_line_1' VARCHAR(100) ,  IN 'present_line_2' VARCHAR(100) ,  IN 'present_city_or_district' VARCHAR(100) ,  IN 'present_post_code' VARCHAR(100) ,  IN 'parmanent_line_1' VARCHAR(100) ,  IN 'parmanent_line_2' VARCHAR(100) ,  IN 'parmanent_post_code' VARCHAR(100) ,  IN 'parmanent_country' VARCHAR(100) ,  IN 'parmanent_city_or_district' VARCHAR(100) ,  IN 'profession' VARCHAR(100) ,  IN 'designation' VARCHAR(100) ,  IN 'email' VARCHAR(100) ,  IN 'blood_group' VARCHAR(100) ,  IN 'type' VARCHAR(100)  )



INSERT INTO `users`(`first_name`, `middle_name`, `last_name`, `gender`, `membership_number`, `institution_id`, `nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `present_line_1`, `present_line_2`, `present_city_or_district`, `present_post_code`, `present_country`, `parmanent_line_1`, `parmanent_line_2`, `parmanent_post_code`, `parmanent_country`, `parmanent_city_or_district`, `profession`, `designation`, `email`, `blood_group`, `type`) VALUES  ( first_name , middle_name , last_name , gender , institution_id , nid_or_passport , fathers_name , mother_name , spouse_name , number_of_children , present_line_1 , present_line_2 , present_city_or_district , present_post_code , parmanent_line_1 , parmanent_line_2 , parmanent_post_code , parmanent_country , parmanent_city_or_district , profession , designation , email , blood_group , type  ) ; 






$$
DELIMITER ;






-- login

DELIMITER $$
CREATE OR REPLACE DEFINER=`root`@`localhost` PROCEDURE `LOGIN`(IN `EMAIL1` VARCHAR(100), IN `PASSWORD1` VARCHAR(100), OUT `STATUS` VARCHAR(100))
BEGIN
DECLARE UID INT(3); 
SET UID = 0 ;
SELECT COUNT(*) INTO UID FROM USERS WHERE `EMAIL`=EMAIL1 AND `PASSWORD`=PASSWORD1 LIMIT 1 ;   

SELECT UID;

IF UID>0
THEN 
SET STATUS="YES" ;

ELSE 
SET STATUS="NO";

END IF ;

END$$
DELIMITER ;


-- registration

DELIMITER $$
CREATE OR REPLACE DEFINER=`root`@`localhost` PROCEDURE `REGISTRATION`(IN `EMAIL1` VARCHAR(100), IN `PASSWORD1` VARCHAR(100), OUT `STATUS` VARCHAR(100))
BEGIN
DECLARE UID INT(3); 
SET UID = 0 ;
SELECT COUNT(*) INTO UID FROM USERS WHERE `EMAIL`=EMAIL1 AND `PASSWORD`=PASSWORD1 LIMIT 1 ;   

SELECT UID;

IF UID>0
THEN 
SET STATUS="YES" ;

ELSE 
SET STATUS="NO";

END IF ;

END$$
DELIMITER ;





-- test
DELIMITER $$
CREATE OR REPLACE DEFINER=`root`@`localhost` PROCEDURE `PROC_TEST`(INOUT `EMAIL1` VARCHAR(100))
BEGIN
DECLARE UID INT(3); 
SET UID = 0 ;
SELECT COUNT(*) INTO UID FROM USERS WHERE `EMAIL`=EMAIL1 ;   

SELECT UID;

IF UID>0
THEN 
SET EMAIL1="YES" ;

ELSE 
SET EMAIL1="NO";

END IF ;

END$$
DELIMITER ;