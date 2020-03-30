-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2020 at 05:09 PM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `intern_project`
--

DELIMITER $$
--
-- Procedures
--
CREATE  PROCEDURE `count_request` (OUT `verification_request1` VARCHAR(100), OUT `change_request1` VARCHAR(100))  BEGIN
       
select count(*) into verification_request1 from all_info_together ai where   email_verification_status = 'verified' and status = 'new';
           
select count(*) into change_request1 from all_info_together ai where  status = 'approved' and change_request = 'requested' and type = 'user';

  
            
END$$

CREATE  PROCEDURE `current_photo` (IN `upload_link` VARCHAR(500), IN `email1` VARCHAR(100), OUT `existing_link` VARCHAR(500))  BEGIN


Select recent_photo into existing_link from user_uploads where email = email1 ;


if existing_link = NULL
then 

set existing_link = 'not_set' ; 

end if;


update user_uploads set recent_photo = upload_link where email = email1 ; 



END$$

CREATE  PROCEDURE `email_verification_otp` (IN `email1` VARCHAR(100), IN `otp1` VARCHAR(100), IN `purpose` VARCHAR(100), OUT `result` VARCHAR(100))  BEGIN

DECLARE count int(5);

if purpose = 'verify_email_otp'
then
select count(*) into count from verification_info where email = email1 and otp = otp1  ; 

if count >0 
then
update verification_info set email_verification_status = 'verified' where email = email1 ; 
set result = 'email_verified' ; 
else
set result = 'invalid_otp';
end if ;

elseif purpose = 'send_otp'
then

update verification_info set otp = otp1 where email = email1 ;

set result = 'otp_sent';

end if;




END$$

CREATE  PROCEDURE `login` (IN `email1` VARCHAR(500), IN `password1` VARCHAR(100), OUT `result` VARCHAR(500))  BEGIN

DECLARE i int(3);
DECLARE type1 varchar(100);

select count(*) into i from users_registration where email = email1 and password = password1;


if i < 1 
then
set result = 'NO' ; 
else
SELECT type into type1 FROM verification_info vi WHERE vi.email = email1;

IF type1 = 'user'
THEN
set result = 'YES_USER' ;
ELSEIF type1 = 'admin'
THEN
SET result = 'YES_ADMIN';
END IF;

end if;


END$$

CREATE  PROCEDURE `old_photo` (IN `upload_link` VARCHAR(500), IN `email1` VARCHAR(100), OUT `existing_link` VARCHAR(500))  BEGIN


Select old_photo into existing_link from user_uploads where email = email1 ;


if existing_link = NULL
then 

set existing_link = 'not_set' ; 

end if;


update user_uploads set old_photo = upload_link where email = email1 ; 



END$$

CREATE  PROCEDURE `REGISTRATION` (IN `email1` VARCHAR(100), IN `first_name1` VARCHAR(100), IN `last_name1` VARCHAR(100), IN `mobile1` VARCHAR(20), IN `institution_id1` VARCHAR(100), IN `password1` VARCHAR(100), IN `otp1` VARCHAR(100), IN `who_is_doing_registration` VARCHAR(100), OUT `result` VARCHAR(100))  BEGIN

DECLARE UID INT(3); 
DECLARE mem_number int(10);
SET UID = 0 ;
SELECT COUNT(*) INTO UID FROM users_registration  WHERE EMAIL=lower(email1) ;   

SELECT UID;

IF UID>0
THEN 

SET result="NO";

ELSE 

INSERT INTO users_registration (email,first_name,last_name,mobile,institution_id,password,registration_date,membership_number) VALUES (email1,first_name1,last_name1, mobile1,institution_id1,password1,NOW(), 1000);

INSERT INTO verification_info (email,otp,status,type,visibility,completeness) VALUES (email1, otp1,'not_verified', 'user', 'full_name,institution_id,membership_number' , 60);

INSERT INTO users_info (email) VALUES (email1);
INSERT INTO users_address (email) VALUES (email1);
INSERT INTO privacy (email) VALUES (email1);
INSERT INTO data_log (email) VALUES (email1);

INSERT INTO user_uploads (email , recent_photo , old_photo) VALUES (email1 , 'not_set' , 'not_set');



if who_is_doing_registration = 'admin'
THEN

select max(ai.membership_number) into mem_number from all_info_together ai ;

UPDATE all_info_together ai set ai.membership_number = mem_number + 1 where ai.email = email1;

UPDATE all_info_together ai set STATUS = 'approved' where ai.email = email1;

end IF;


SET result="YES";



END IF ;


END$$

CREATE  PROCEDURE `update_profile_address` (IN `id1` INT(100), IN `last_verified_info1` VARCHAR(1000), IN `present_line11` VARCHAR(100), IN `present_district1` VARCHAR(100), IN `present_post_code1` INT(100), IN `present_country1` VARCHAR(200), IN `permanent_line11` VARCHAR(100), IN `permanent_district1` VARCHAR(100), IN `permanent_post_code1` INT(100), IN `permanent_country1` VARCHAR(200), IN `permanent_post_office_name1` VARCHAR(200), IN `permanent_police_station1` VARCHAR(100), IN `present_post_office_name1` VARCHAR(100), IN `present_police_station1` INT(100), IN `second_citizenship_country1` VARCHAR(200), OUT `result` VARCHAR(100))  BEGIN
DECLARE count int(5);

DECLARE verification_status varchar(100);
DECLARE change_req_status varchar(100);
DECLARE user_type varchar(100);



select status into verification_status from all_info_together where id = id1;
select change_request into change_req_status from all_info_together where id = id1;
select type into user_type from all_info_together where id = id1;


update all_info_together set  present_line1 = present_line11, present_district = present_district1, present_post_code = present_post_code1 , present_country = present_country1 , parmanent_line1 = permanent_line11 , parmanent_district = permanent_district1, parmanent_post_code = permanent_post_code1 , parmanent_country = permanent_country1, parmanent_post_office_name = permanent_post_office_name1, parmanent_police_station=permanent_police_station1, present_post_office_name=present_post_office_name1, present_police_station=present_police_station1, second_citizenship_country=second_citizenship_country1 where id = id1 ;



IF verification_status = 'approved' and user_type !='admin'
THEN

if change_req_status = 'not_requested' OR change_req_status = 'approved'
then

UPDATE all_info_together set change_request = 'requested' , last_verified_info = last_verified_info1 , all_info_together.change_request_time = NOW() WHERE id = id1;
ELSE
UPDATE all_info_together set change_request = 'requested' , all_info_together.change_request_time = NOW() WHERE id = id1;
end IF;
end IF;



set result = 'success' ;


END$$

CREATE  PROCEDURE `update_profile_basic` (IN `id1` INT(100), IN `last_verified_info1` VARCHAR(1000), IN `first_name1` VARCHAR(100), IN `last_name1` VARCHAR(100), IN `name_bangla1` VARCHAR(200) CHARSET utf8, IN `mobile1` VARCHAR(100), IN `institution_id1` VARCHAR(100), IN `blood_group1` VARCHAR(100), IN `religion1` VARCHAR(100), IN `nid_or_passport1` VARCHAR(200), IN `dob1` VARCHAR(200), OUT `result` VARCHAR(100))  BEGIN

DECLARE count int(5);


DECLARE verification_status varchar(100);
DECLARE change_req_status varchar(100);
DECLARE user_type varchar(100);


select status into verification_status from all_info_together where id = id1;
select change_request into change_req_status from all_info_together where id = id1;
select type into user_type from all_info_together where id = id1;


update all_info_together set  nid_or_passport = nid_or_passport1, date_of_birth = dob1 , blood_group = blood_group1, religion = religion1 where id = id1 ;

update all_info_together set first_name = first_name1 , last_name = last_name1 , name_bangla = name_bangla1 , mobile = mobile1 , institution_id = institution_id1  where id = id1 ;



IF verification_status = 'approved' and user_type !='admin'
THEN

if change_req_status = 'not_requested' OR change_req_status = 'approved'
then

UPDATE all_info_together set change_request = 'requested' , last_verified_info = last_verified_info1 , all_info_together.change_request_time = NOW() WHERE id = id1;
ELSE
UPDATE all_info_together set change_request = 'requested' , all_info_together.change_request_time = NOW() WHERE id = id1;
end IF;
end IF;

set result = 'success' ;

END$$

CREATE  PROCEDURE `update_profile_email` (IN `id1` VARCHAR(100), IN `email1` VARCHAR(100), IN `email2` VARCHAR(100), IN `otp1` VARCHAR(100), OUT `result` VARCHAR(100))  BEGIN

DECLARE count int(5);

select COUNT(*) into count from verification_info WHERE email = email1 and otp = otp1;

if count = 0
THEN
set result = 'invalid_otp';
else 

UPDATE verification_info SET email_verification_status = 'verified' WHERE email = email1;

UPDATE all_info_together set email = email2 WHERE email = email1;

UPDATE user_photos set email = email2 WHERE email = email1;

UPDATE privacy set email = email2 WHERE email = email1;
UPDATE data_log set email = email2 WHERE email = email1;


set result = 'success';

END IF;

if otp1 = 'change_email_for_admin'
THEN
select COUNT(*) into count from all_info_together ai where ai.email = email1;

if count = 0
THEN
UPDATE users_address set email = email2 WHERE email = email1;
UPDATE users_info set email = email2 WHERE email = email1;
UPDATE users_registration set email = email2 WHERE email = email1;
UPDATE user_photos set email = email2 WHERE email = email1;
UPDATE user_uploads set email = email2 WHERE email = email1;
UPDATE verification_info set email = email2 WHERE email = email1;

set result = 'email_updated';

else
set result = 'email_already_used';

END IF;

END IF;

END$$

CREATE  PROCEDURE `update_profile_forgot_password` (IN `email1` VARCHAR(100), IN `forgot_password_crypto1` VARCHAR(500), IN `purpose` VARCHAR(100), OUT `result` VARCHAR(100))  BEGIN

DECLARE count int(5);

if purpose = 'generate_crypto'
then
select count(*) into count from all_info_together where email = email1 ; 

if count >0 
then
update all_info_together set forgot_password_crypto = forgot_password_crypto1 where email = email1 ; 
set result = 'crypto_added' ; 
else
set result = 'no_email_found';
end if ;

elseif purpose = 'crypto_check'
then
select count(*) into count from all_info_together where email = email1 and forgot_password_crypto = forgot_password_crypto1 ;
if count > 0
then
set result = 'allow';
else
set result = 'invalid_link';
end if;

end if;





END$$

CREATE  PROCEDURE `update_profile_password` (IN `id1` VARCHAR(100), IN `password1` VARCHAR(500), OUT `result` VARCHAR(100))  BEGIN

DECLARE count int(5);


update all_info_together set password = password1 where id = id1 ;


set result = 'success' ;

END$$

CREATE  PROCEDURE `update_profile_personal` (IN `id1` VARCHAR(100), IN `last_verified_info1` VARCHAR(1000), IN `fathers_name1` VARCHAR(100), IN `mothers_name1` VARCHAR(100), IN `spouse_name1` VARCHAR(100), IN `number_of_children1` INT(100), IN `profession1` VARCHAR(100), IN `workplace_or_institution1` VARCHAR(200), IN `designation1` VARCHAR(200), OUT `result` VARCHAR(100))  BEGIN

DECLARE count int(5);

DECLARE verification_status varchar(100);
DECLARE change_req_status varchar(100);
DECLARE user_type varchar(100);

select status into verification_status from all_info_together where id = id1;
select change_request into change_req_status from all_info_together where id = id1;
select type into user_type FROM all_info_together WHERE id = id1;


update all_info_together set  fathers_name = fathers_name1, mother_name = mothers_name1 , spouse_name = spouse_name1, number_of_children = number_of_children1 , profession = profession1 , institution = workplace_or_institution1 , designation = designation1 where id = id1 ;


IF verification_status = 'approved' and user_type !='admin'
THEN

if change_req_status = 'not_requested' OR change_req_status = 'approved'
then

UPDATE all_info_together set change_request = 'requested' , last_verified_info = last_verified_info1 , all_info_together.change_request_time = NOW() WHERE id = id1;
ELSE
UPDATE all_info_together set change_request = 'requested' , all_info_together.change_request_time = NOW() WHERE id = id1;
end IF;
end IF;




set result = 'success' ;

END$$

CREATE  PROCEDURE `upload_photo` (IN `purpose` VARCHAR(100), IN `upload_link` VARCHAR(500), IN `email1` VARCHAR(100), IN `id1` INT(100), OUT `existing_link` VARCHAR(500), OUT `result` VARCHAR(100))  BEGIN


if purpose = 'recent_photo'
then
Select recent_photo into existing_link from all_info_together where email = email1 ;
update all_info_together set recent_photo = upload_link where id = id1 ;


ELSEIF purpose = 'old_photo'
then
select old_photo into existing_link from all_info_together ai where ai.id = id1;
update all_info_together set old_photo = upload_link where email = email1;
elseif purpose = 'group_photo'
then
insert into user_photos (email , group_photo) values (email1 , upload_link); 
end if;

SET result = 'success';


END$$

CREATE  PROCEDURE `user_request` (IN `id1` INT(100), OUT `result` VARCHAR(100))  BEGIN
DECLARE count , mem_num int(5);

select ai.membership_number into mem_num from all_info_together ai WHERE ai.id = id1;

UPDATE all_info_together ai SET ai.status ='approved' , ai.completeness = 100   WHERE id = id1 ;

if mem_num = 1000
THEN

SELECT max(membership_number) into count from all_info_together ;
-- SELECT COUNT(*) int count FROM verification_info WHERE status = 'approved' ; 

UPDATE all_info_together ai SET ai.membership_number = count+1   WHERE id = id1 ;

END IF;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_options`
--

CREATE TABLE `admin_options` (
  `admin_options_id` int(100) NOT NULL,
  `institution_id_label` varchar(100) NOT NULL DEFAULT 'Institution Id'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin_options`
--

INSERT INTO `admin_options` (`admin_options_id`, `institution_id_label`) VALUES
(1, 'College ID');

-- --------------------------------------------------------

--
-- Table structure for table `all_info_together`
--

CREATE TABLE `all_info_together` (
  `email` varchar(100) DEFAULT NULL,
  `id` int(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `name_bangla` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `mobile` varchar(200) DEFAULT NULL,
  `institution_id` varchar(100) DEFAULT NULL,
  `password` varchar(500) DEFAULT NULL,
  `registration_date` datetime(6) DEFAULT NULL,
  `membership_number` int(255) DEFAULT 0,
  `gender` varchar(100) DEFAULT NULL,
  `nid_or_passport` varchar(100) DEFAULT NULL,
  `fathers_name` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `spouse_name` varchar(100) DEFAULT NULL,
  `number_of_children` varchar(100) DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `institution` varchar(100) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `religion` varchar(200) DEFAULT NULL,
  `present_line1` varchar(300) DEFAULT NULL,
  `present_line2` varchar(300) DEFAULT NULL,
  `present_district` varchar(100) DEFAULT NULL,
  `present_police_station` varchar(200) DEFAULT NULL,
  `present_post_office_name` varchar(200) DEFAULT NULL,
  `present_post_code` varchar(100) DEFAULT NULL,
  `present_country` varchar(100) DEFAULT NULL,
  `parmanent_line1` varchar(300) DEFAULT NULL,
  `parmanent_line2` varchar(300) DEFAULT NULL,
  `parmanent_police_station` varchar(200) DEFAULT NULL,
  `parmanent_district` varchar(100) DEFAULT NULL,
  `parmanent_post_office_name` varchar(200) DEFAULT NULL,
  `parmanent_post_code` varchar(100) DEFAULT NULL,
  `parmanent_country` varchar(100) DEFAULT NULL,
  `second_citizenship_country` varchar(100) DEFAULT NULL,
  `otp` varchar(100) DEFAULT NULL,
  `forgot_password_crypto` varchar(500) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'new',
  `email_verification_status` varchar(100) DEFAULT 'not_verified',
  `change_request` varchar(100) NOT NULL DEFAULT 'not_requested',
  `change_request_time` datetime(6) DEFAULT NULL,
  `type` varchar(20) DEFAULT 'user',
  `visibility` varchar(1000) DEFAULT NULL,
  `completeness` varchar(10) DEFAULT NULL,
  `recent_photo` varchar(400) DEFAULT 'not_set',
  `old_photo` varchar(400) DEFAULT 'not_set',
  `timestamp` timestamp(6) NULL DEFAULT NULL,
  `membership_fee` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `all_info_together`
--

INSERT INTO `all_info_together` (`email`, `id`, `full_name`, `name_bangla`, `first_name`, `last_name`, `mobile`, `institution_id`, `password`, `registration_date`, `membership_number`, `gender`, `nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `date_of_birth`, `religion`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `second_citizenship_country`, `otp`, `forgot_password_crypto`, `status`, `email_verification_status`, `change_request`, `change_request_time`, `type`, `visibility`, `completeness`, `recent_photo`, `old_photo`, `timestamp`, `membership_fee`) VALUES
('noblesoma@gmail.com', 3062, NULL, 'গোলাম মোহাম্মদ', 'GHOLAM MOHAMMED', NULL, '1748700100', '927081', 'e10adc3949ba59abbe56e057f20f883e', NULL, 1, NULL, '7520707500812', 'MOHAMMED GOLAM SERWAR', 'AMINA JANNAT', 'ROKEYA SIDDIQUA', '2', 'ENGINEER', 'CHIEF ENGINEER', NULL, 'O+', NULL, NULL, 'FLAT-401,HOUSE-46,ROAD-4/A,DHANMONDI R/A, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'KHOWNICA,HAZIPOR MONDOLPARA CHAUMUHANI, NOAKHALI,BANGLADESH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mukul_74@yahoo.com', 3063, NULL, 'গোলাম মইন‌ উদ্দিন ', 'GOLAM MOINUDDIN', NULL, '01743 101826', '929229', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, NULL, '4617179504', 'LATE NASIR HOSSAIN', 'LATE NOOR JAHAN BEGUM ', 'REHANA AFROZ', '1', 'SERVICE', 'ASSISTANT MANAGER (HOSPITALITY SERVICES)', 'BRB HOSPITALS LTD.', 'O+', NULL, NULL, '19/A, B.C.C ROAD,THATARI BAZAR DHAKA-1203', NULL, NULL, NULL, NULL, NULL, NULL, '19/A, B.C.C ROAD,THATARI BAZAR DHAKA-1203', NULL, NULL, 'DHAKA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('reliance.eng.bd@gmail.com', 3064, NULL, 'হাসান আহমেদ খান সজল', 'HASAN AHAMED KHAN(SAZAL)', NULL, '01620 120013', '925069', 'e10adc3949ba59abbe56e057f20f883e', NULL, 3, NULL, '19761317938245100', 'A.K.ALI AHAMED HKAN', 'SALEHA BEGUM', 'FATIMA-TUJ-JAHRA SHANTA', 'NILL', 'ENGINEERING AND CONSULTANCY', 'CEO', 'RELIANCE ENGINEERING &TRADING', 'B+', NULL, NULL, 'HOUSE#11,ROAD#09,BLOCK#D,BANASREE,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE#, KHAN BARI,VILL:AITHADI MATHAVANGA,P.O: MOHONPUR-3641,P.S:MATLOB(NORTH),DIST:CHANDPUR', NULL, NULL, 'CHANDPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('quamrul.m@gmail.com', 3065, NULL, 'কামরুল মোহাম্মদ মানজু্র', 'QUAMRUL MOHAMMED MANJUR', NULL, '1713062492', '929109', 'e10adc3949ba59abbe56e057f20f883e', NULL, 4, NULL, '19752696653254800', 'LATE MD.MANJUR AL RAHMAN', 'MST. KAMRUN NESSA', 'SHARIA MUSTARY', '2', 'SERVICE', 'SR.GM', NULL, 'O+', NULL, NULL, '42 WEST CHOWDHURYPARA (FLAT-6/A),HAJIPARA, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, '42 WEST CHOWDHURYPARA (FLAT-6/A),HAJIPARA, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('dip30th@yahoo.com', 3066, NULL, 'ইফতেখারুল আলম', 'IFTEKHARUL ALAM', NULL, '1715391919', '927088', 'e10adc3949ba59abbe56e057f20f883e', NULL, 5, NULL, '2695045906439', 'KHURSHEDUL ALAM', 'GULSHAN AKHTER', 'SULTANA SUMYA AKHTER', '2', 'MARINER', NULL, NULL, 'O+', NULL, NULL, '291/1 SOUTH PAIKPARA, MIRPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '291/1 SOUTH PAIKPARA, MIRPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('valenTinep80@yahoo.com', 3067, NULL, 'পিটার ভ্যালেন্টাইন রোডিকেস ', 'PETER VALENTINE RODRIQUES', NULL, '01977 088268', '929214', 'e10adc3949ba59abbe56e057f20f883e', NULL, 6, NULL, '9564110303', 'ALEXIUS RODRIQUES', 'LATE BERNADETT RODRIQUES', 'DIMPLE MARIANA RODRIQUES', '2', 'BUSINESS', 'PROPRIETOR', 'VALENTINE\'S COLLECTION', 'O+', NULL, NULL, '8/7,HOLY CROSS COLLEGE ROAD, TEIKUNIPARA TEJGAON DHAKA-1215', NULL, NULL, NULL, NULL, NULL, NULL, 'AS ABO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1930040628', 3068, NULL, 'মোহাম্মদ আজিজুর রহমান ', 'MOHAMMAD AZIZUR RAHMAN', NULL, '1930040628', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 7, NULL, '19752612935424500', 'MD.FAZLUL HAQUE', 'ROWSHAN ARA BEGUM', NULL, NULL, 'JOURANALIST', NULL, NULL, NULL, NULL, NULL, 'FLAT# 2/606, EASTERN RAINBOW TOWER 41/34, PURANA PALTON,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'FLAT# 2/606, EASTERN RAINBOW TOWER 41/34, PURANA PALTON,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('rinsarker@gmail.com', 3069, NULL, 'রিনকু মারসাল সরকার', 'RINKU MARSAL SARKER', NULL, '01715 024603', '929508', 'e10adc3949ba59abbe56e057f20f883e', NULL, 8, NULL, '2699039523192', 'LATE AUGUSTINE S. SARKER', 'LATE CYNTHIA SARKER', 'SILVIA LEONI SARKER', '2', 'BUSINESS', 'PROPRIETOR', 'L. B. ELECTRONICS', 'B+', NULL, NULL, '63,TAJGKUNI PARA, TAJGOAN DHAKAPO. 1215', NULL, NULL, NULL, NULL, NULL, NULL, '63,TAJGKUNI PARA, TAJGOAN DHAKAPO. 1215', NULL, NULL, 'BARISAL', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('edwinranjan@gmail.com', 3070, NULL, 'ইডিন রঞ্জান হিরা ', 'EDWIN RANJAN HIRA', NULL, '1811410155', '929262', 'e10adc3949ba59abbe56e057f20f883e', NULL, 9, NULL, '4174460040', 'LATE HARENDRA NATH HIRA', 'MARIA HIRA', 'JULIET LIMA HIRA', '2', 'BUSINESS', 'DIRECTOR', NULL, 'AB+', NULL, NULL, '\"DOM-INNO RDDE\" FLAT#B2,398 NEW ESKATON ROAD ,RAMNA,DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL:BAMIANCLAR, P.O.JALIRPAR,P.S. MUKSEDPUR, DIST. GOPALGONG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('monarchtradingbd@gmail.com', 3071, NULL, 'এমডি নাসির উদ্দীন ', 'MD. NASIR UDDIN PARASH', NULL, '01757 629494', '929416', 'e10adc3949ba59abbe56e057f20f883e', NULL, 10, NULL, '1.97427E+16', 'TAZUL HUDA', 'TAHERA KHANAM', 'NAJNIN SHAMIM', '2', 'BUSINESS', 'MANAGING PARTNER', 'BENFIX TECHNOLOGY', 'O+', NULL, NULL, '55/B,EAST RAJA BAZAR TEJGAON, DHAKA-1215', NULL, NULL, NULL, NULL, NULL, NULL, '55/B,EAST RAJA BAZAR TEJGAON, DHAKA-1215', NULL, NULL, 'BRAHMANBARIA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('asif686947@gmail.com, asif@pragatiinsurance.com', 3072, NULL, 'আহমেদ আসিফ ', 'AHMED ASIF', NULL, '1719686947', '929201', 'e10adc3949ba59abbe56e057f20f883e', NULL, 11, NULL, '8694363709', 'RAFIQUL ALAM', 'FIROZA BEGUM', 'NASRIN NAHAR ERA', '2', 'PRIVATE SERVICE', 'VICE PRESIDENT', 'PRAGATI INSURANCE LTD.', 'B+', NULL, NULL, 'GOLDEN VISION, 2ND FLOOR. 14.R.K. MISSION ROAD, GOPIBAGH, DHAKA-1203', NULL, NULL, NULL, NULL, NULL, NULL, 'GOLDEN VISION, 2ND FLOOR. 14.R.K. MISSION ROAD, GOPIBAGH, DHAKA-1203', NULL, NULL, 'BAGERHAT', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('awayform99@gmail.com', 3073, NULL, 'প্রিন্স হ্যামলেট হাল্দার', 'PRINCE HAMLET HALDER', NULL, '1787177965', '925074', 'e10adc3949ba59abbe56e057f20f883e', NULL, 12, NULL, '6.92631E+12', 'KAMOL HALDER', 'JHARNA HALDER', 'EVA POLIN SARKAR', '2', 'SERVICE', 'DIVISIONAL MANAGER', NULL, 'B+', NULL, NULL, 'KALLANY, PHILIP SHARONI, CHRISTIANPARA ANANDAPUR SAVAR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL P.O: BAGDHA, PS:-AGAILYHARA DIST:-BARISAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mabashar1975@gmail.com', 3074, NULL, 'মোহাম্মদ আবুল বাসার', 'MOHAMMED ABUL BASHAR', NULL, '1714094167', '928381', 'e10adc3949ba59abbe56e057f20f883e', NULL, 13, NULL, '2.69165E+12', 'ABDUL JALIL BARATI', 'REZIA BEGUM', 'KONIKA', '2', 'SERVICE', 'DSVP', NULL, 'O+', NULL, NULL, '7/1, NORTH ROAD (VOTAR GOLI) FLAT NO-A-1 (1ST FLOOR), DHANMONDI, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL:SAYEDBOSTA P.O+PS-DAMODYA, DIST:SHARIATPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tarazia@gmail.com', 3075, NULL, 'এ কে এম মুজাহিদুল ইসলাম ', 'PROF. DR. A.K.M. MUZAHIDUL ISLAM', NULL, '01754 165915', '923037', 'e10adc3949ba59abbe56e057f20f883e', NULL, 14, NULL, NULL, 'LATE-TAMIZ UDDIN AHAMED', 'MRS. RAZIA AHMED', 'DR. SHAMSUNNAHAR KHANAM', '2', 'TEACHING', 'PROFESSOR', 'UNITED INTERNATIONAL UNIRSITY (UIU)', 'B+', NULL, NULL, 'MIRPUR DOSH,R#06,H#1053', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SHARIATPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('1962418325', 3076, NULL, 'আরিফুর রহমান ডিক্ছন', 'ARIFUR RAHAMAN DIXON', NULL, '1962418325', '929285', 'e10adc3949ba59abbe56e057f20f883e', NULL, 15, NULL, '1918832815', 'MD. HOSSAIN', 'MRS. KAWSARI BEGUM', NULL, '1', 'BUSINESS', NULL, NULL, 'B+', NULL, NULL, '9/1 RAGHU NATH DAS LANE KALTABAZAR, DHAKA- 1100', NULL, NULL, NULL, NULL, NULL, NULL, '9/1 RAGHU NATH DAS LANE KALTABAZAR, DHAKA- 1100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('rahmanimtiazur@gmail.com', 3077, NULL, 'ইমতিয়াজুর রহমান', 'IMTIAZUR RAHMAN', NULL, '17130350381', '925086', 'e10adc3949ba59abbe56e057f20f883e', NULL, 16, NULL, NULL, 'MOSTAFIZUR RAHAMAN', 'JANNAT ARA BEGUM', 'TANIA SULTANA', '3', 'CHARTERED ACC', 'CFO', NULL, 'A+', NULL, NULL, 'H# 97 BL-B, ROAD-5 ,NIKETON, GULSHAN', NULL, NULL, NULL, NULL, NULL, NULL, '78/A KAKRAIL, ROMNA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mhsohel@hotmail.com', 3078, NULL, 'এমডি মাহমুদুল হাসান সোহেল ', 'MD. MAHMUDUL HASSAN SOHEL', NULL, '1777662633', '925049', 'e10adc3949ba59abbe56e057f20f883e', NULL, 17, NULL, '1900807205', 'MD.ABDUL HANNAN MIAH', 'MOHSENA BEGUM', 'MASUMA KHANAM', '2', 'BUSINESS', 'SELF EMPLOYED', NULL, 'o-', NULL, NULL, 'VILL- DASERKANDI (EAST PARA), P.O- DASERKANDI P.S- KHILGAON, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL- DASERKANDI (EAST PARA), P.O- DASERKANDI P.S- KHILGAON, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('harunbiman2014@gmail.com', 3079, NULL, 'এমডি হারুন-ইউআর রশিদ ', 'MD.HARUN -UR- RASHID', NULL, '1817666861', '928397', 'e10adc3949ba59abbe56e057f20f883e', NULL, 18, NULL, '5078794640', 'SHIRAJUL ISLAM', 'MOST. MOKUL KHANOM', 'MRS. SUMONA SULTANA', '2', 'SERVICE', 'ADMIN SUP. BIMAN BANGLADESH AIRLINES', NULL, 'A+', NULL, NULL, '106- MOLLARTAK, ASHKONA, DAKSHINKHAN, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, '106- MOLLARTAK, ASHKONA, DAKSHINKHAN, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('lithu2116@gmail.com', 3080, NULL, 'মোর্শেদ কামাল ', 'MORSHED KAMAL', NULL, '1939907920', '924069', 'e10adc3949ba59abbe56e057f20f883e', NULL, 19, NULL, '9566047206', 'MD. MOJIBUL HUQUE', 'RAZIA AKTER', 'RICTA SIDDIQUA', '0', 'PRIVATE SERVICE', 'EXECUTI DIRECTOR', NULL, 'B+', NULL, NULL, '333, NORTH GORAN, P.S. KHILGAON, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, '333, NORTH GORAN, P.S. KHILGAON, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('akdsagar@gmail.com', 3081, NULL, 'অশিম কুমার দাস', 'ASHIM KUMAR DAS', NULL, '1783354747', '929442', 'e10adc3949ba59abbe56e057f20f883e', NULL, 20, NULL, '1.97427E+16', 'JATIN DAS', 'PUSHPA DAS', 'TUMPADAS', '2', 'SERVICE', 'DEPUTY REGISTAR', NULL, 'A+', NULL, NULL, 'DEPT. OF MESS COMMUNICATION & JOURNALIAM, UNIRSITY OF DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'FLAT B4,133 TEYKUNI PARA , TEYGOAN DHAHA ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('bablupb2007@yahoo.com', 3082, NULL, 'আবুল বাসার মোঃ শাহেদুল হক ', 'ABUL BASHAR MOHAMMED SHAHIDUL HAQUE', NULL, '1711351542', '924013', 'e10adc3949ba59abbe56e057f20f883e', NULL, 21, NULL, '1.97561E+16', 'AL HAJ MD.EMAM UDDIN', 'SALEHA KHATUN', 'SHIWLEE AKTER ', '1', 'BANKER', 'ASSISTANT VICE PRESIDENT', NULL, 'O+', NULL, NULL, 'FLAT #D5, BAGANBARI, TOWER, 503/6, MALIBAG BAGANBARI, MALIBAG, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-PO+PS- FULBARIA, DIST- MYMENSINGH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('asifhchy@gmail.com', 3083, NULL, 'আসিফ হোসেন চৌধুরী', 'ASIF HOSSAIN CHOWDHURY ', NULL, '61480 161826', '926067', 'e10adc3949ba59abbe56e057f20f883e', NULL, 22, NULL, '3724182054', 'FAROOK HOSSAIN CHOWDHURY', 'NAZMA CHOWDHURY', 'ROKSANA TARANNUM', '2', 'BANKER', 'SAVP (SR. ASSTT. VICE PRESIDENT)', 'MIDLAND BANK LTD', 'O+', NULL, NULL, '42/3 NCW SKATON, MULTIPLAN LAGOOM DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL. SIKANDI, P.S- HARIRAMPUR DIST- MANIKGONJ', NULL, NULL, 'MANIKGONJ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shaiful@larougefashions.com', 3084, NULL, 'শাইফুল ইসলাম', 'SHAIFUL ISLAM', NULL, '1713215068', '928370', 'e10adc3949ba59abbe56e057f20f883e', NULL, 23, NULL, '8206164074', 'LATE. SULTAN AHMED', 'LATE. PERU VANO BEGUM', 'ANJUM ARA SHILA', '2', 'BUSINESS', 'MANAGING DIRECTOR', NULL, 'O+', NULL, NULL, 'HOUSE#09,ROAD#12, SECTOR#10,UTTARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: GOSHAIRHAT. DIST:SHARIOTPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('anisur_74@yahoo.com', 3085, NULL, 'আনিসুর রহমান', 'ANISUR RAHMAN', NULL, '01972 044916', '929218', 'e10adc3949ba59abbe56e057f20f883e', NULL, 24, NULL, '1.97493E+16', 'AMIR HOSSAIN', 'HAOA BEGUM', 'JANNAT ARA ZAFOR RUBINA', '1', 'BUSINESS', 'MANAGING DIRECTOR', 'J.A.R.TRADE INTERNATIONAL', 'A+', NULL, NULL, 'HOUSE NO-32(4B) ROAD NO. 03, SECTOR-10, UTTARA MODEL TWON,DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: GOHAIL BARI, P.O. NAGBARI , P.S. SAKHIPUR DIST. TANGAIL', NULL, NULL, 'TANGAIL', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('cosmosgiftgalleey@gmail.com', 3086, NULL, 'মো: লুৎফর রহমান ', 'MD.LUTFOR RAHAMAN', NULL, '1819227035', '929234', 'e10adc3949ba59abbe56e057f20f883e', NULL, 25, NULL, '3.3232E+12', 'LATE.FAZLURRAHMAN', 'MRS.TOSIA BEGUM', 'SARMIN SULTANA', '1', 'BUSINESS', 'MANAGING DIRECTOR', NULL, 'B+', NULL, NULL, '5/2 TISTAGATE, TONGI, GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, '5/2 TISTAGATE, TONGI, GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('aaishltd@gmail.com', 3087, NULL, 'ড: আশিস কুমার চক্রবর্তী', 'DR. ASHIS KUMAR CHAKRABORTY', NULL, '1841372647', '923103', 'e10adc3949ba59abbe56e057f20f883e', NULL, 26, NULL, NULL, 'ASHUTOSH CHAKRABORTY', 'PUSPA CHAKRABORTY', 'NITA CHAKRABORTY', '1', 'PHYSICIAN', 'MD.UMCH,DHAKA', '02-9120426', 'O+', NULL, NULL, 'FLAT NO:5A, SHAPTAK GONDOLA APARI.11 ABBAS GARDEN, MOHAKHALI, DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: UCHALIAPARA, P:S: SARAIL UPAZILLA: SARAIL, DIST:BRAHMANBARIA-3430', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('kiransun2003@gmail.com', 3088, NULL, 'আবদুল কুদ্দুস কিরন ', 'ABDUL QUDDUS KIRAN', NULL, '01718 887447', '929069', 'e10adc3949ba59abbe56e057f20f883e', NULL, 27, NULL, '8667020765', 'ABDUL LATIF', 'NURUN NAHAR', 'NASRIN ABTOR POLY', '1', 'PRIVATE SERVICE', 'MANAGING (a&f)', NULL, 'B-', NULL, NULL, '32/E MAYABANON, 31/B FLAT, SABUJBAGH, BASHABOO, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-KRISNAPUR, P.S- SADAR SOUTH KALIR BABAR , COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zpsukhan@gmail.com', 3089, NULL, 'ড: জাহিদ পারভেজ সুখন ', 'DR. ZAHID PARZ SUKHAN', NULL, '1617888618', '924073', 'e10adc3949ba59abbe56e057f20f883e', NULL, 28, NULL, '1.97551E+16', 'ERSHAD ALI', 'JAHANARA AKHTER', 'MST. SHOHELY JANNAT', '2', 'SERVICE', 'SR.AQUACULTUR SPECIALIST', NULL, 'O+', NULL, NULL, 'H#3, FLAT #5A, R#4, BLOCK#F BANANI, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL. BALLA, P.O. BALLA.BAZAR P.S KALIHATI, DIST TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('nadimbd2000@yahoo.com', 3090, NULL, 'নাদিম আহমেদ চৌধুরী', 'NADIM AHMED CHOUDHURY', NULL, '1713443057', '922004', 'e10adc3949ba59abbe56e057f20f883e', NULL, 29, NULL, '8239468500', 'HUSSAIN AHMED CHOWDHURY', 'MOMATAZ BEGUM', 'NOVIANTI ADRIAL', '0', 'BUSINESS', 'MANAGING DIRECTOR', NULL, 'O+', NULL, NULL, 'HOUSE 33 ROAD 14 SECTOR 14 UTTARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'JOYPASHA, KULAWA, MOULVIBAZAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('azgar07@gmail.com', 3091, NULL, 'সাইদ আলী আজগার', 'SYED ALI AZGAR ', NULL, '1819400401', '924061', 'e10adc3949ba59abbe56e057f20f883e', NULL, 30, NULL, NULL, 'LATE SYED ALI AKBAR', 'LUTFA BEGUM', 'NOURIN TANIA', '2', 'GOVT ENGINEER', 'SYSTEM ANALYST', NULL, 'B+', NULL, NULL, 'D-9/4 T&T OFFICER\'S QUARTERS MOGHBAZAR DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'SYEDA SALIMA MANZIL, PAIKPARA BRAHMANBARIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('forkan4961@yahoo.cpm', 3092, NULL, 'লেফটেন্যান্ট কর্নেল সৈয়দ ফরকান উদ্দিন', 'LIEUTENANT CORONEL SYED FORKAN UDDIN', NULL, '1769004961', '922133', 'e10adc3949ba59abbe56e057f20f883e', NULL, 31, NULL, NULL, 'SYED ABUL BASAR', 'FERDOUSI BEGUM', 'SUMONA CHOWDHURY', '1', 'BD ARMY', 'LIEUTENANT COLLONEL', NULL, 'A+', NULL, NULL, 'ARMY AVIATION GROUP,DHAKA CANT', NULL, NULL, NULL, NULL, NULL, NULL, 'RAWSHAN BHABON\' 5 NORTH GORAN KHILGAN SHIPANI BAG, ROAD-18, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('smaruf.habib@gmail.com', 3093, NULL, 'সাইদ মারুফ হাবিব ', 'SYED MARUF HABIB', NULL, '1552363580', '921096', 'e10adc3949ba59abbe56e057f20f883e', NULL, 32, NULL, '3251090589', 'SYED HABIBUR RAHMAN', 'MUNIRA BEGUM', 'MARIA AHMED', '2', 'BANKER', 'SENIOR PRINCIPAL OFFICER', NULL, 'A+', NULL, NULL, 'E-36 SOUTH BONASREE GORAM DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'E-36 SOUTH BONASREE GORAM DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('syed.fatema@yahoo.com', 3094, NULL, 'মুহাম্মাদ সাইদ হোসেন', 'MOHAMMAD SYED HOSSAIN', NULL, '01948 096276', '924043', 'e10adc3949ba59abbe56e057f20f883e', NULL, 33, NULL, '2.69426E+12', 'LATE MOHAMMED ABDUL', 'FAZILATUNNESA', 'SHAHARA AKTER', '2', NULL, NULL, NULL, 'B+', NULL, NULL, 'HOUSE-02,LANE NO-02, BLOCK-B, MIRPUR-10, DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, 'MOHALLAH-MULLAK MAZIR KANDI WARD NO-09,P.O SHATNAL  ', NULL, NULL, 'CHANDPUR ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('abdullahalam71@gmail.com', 3095, NULL, 'আবদুল্লা আলম', 'ABDULLAH ALAM', NULL, '1711322945', '927001', 'e10adc3949ba59abbe56e057f20f883e', NULL, 34, NULL, '1933564161', 'AKRAM HOSSAIN', 'KHALEDA HOSSAIN', 'DR. REZWANA ISLAM', '2', 'SERVICE', 'COO', NULL, 'B+', NULL, NULL, '65/1 , WEST RAZABAZAR, DHAKA -1215', NULL, NULL, NULL, NULL, NULL, NULL, '65/1 , WEST RAZABAZAR, DHAKA -1215', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mizanur.rahman@yahoo.com', 3096, NULL, 'মুহাম্মদ মিজানুর রাহমান ', 'MOHAMMAD MIZANUR RAHAMAN', NULL, '1730050097', '925052', 'e10adc3949ba59abbe56e057f20f883e', NULL, 35, NULL, '6894043881', 'MOHAMMAD ALI ', 'MOMOTAZ BEGUM', 'LIZA KHANDAKAR', '3', 'PRIVATE SERVICE', 'SENIOR SOCIAL COMPLIANCE', NULL, 'AB+', NULL, NULL, 'FLAT-A6, HOUSE-245, ROAD 6/C, BLOCK-B, BASHUNDHARA R/A, BARIDHARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'FLAT-A6, HOUSE-245, ROAD 6/C, BLOCK-B, BASHUNDHARA R/A, BARIDHARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('riponkumarroy@gmail.com', 3097, NULL, 'রিপন কুমার রায়', 'RIPON KUMAR ROY ', NULL, '1926138056', '922106', 'e10adc3949ba59abbe56e057f20f883e', NULL, 36, NULL, '1.59412E+12', 'RANADA KANTA ROY ', 'SHEFALI ROY', 'MOUSUMI ROY', '2', 'SERVICE', 'EXECUTI ENGINEER', NULL, 'A+', NULL, NULL, 'DAULATPUR HOMNA DIST -COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, 'DAULATPUR HOMNA DIST -COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('anmziaulislam@yahoo.com', 3098, NULL, 'এএনএম জিয়াউল ইসলাম মীঠু', 'ANM ZIAUL ISLAM MITHU', NULL, '1730781304', '927087', 'e10adc3949ba59abbe56e057f20f883e', NULL, 37, NULL, '2.6955E+12', 'MD ABDUR ROUF', 'ANWARA BEGUM', 'TANGINA KHANAM', '1', 'PRIVATE SERVICE', 'CEO', NULL, 'A+', NULL, NULL, 'HOUSE# 80, FLAT#3C ROAD#11A(NEW), DHANMONDI R/A DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE# 80, FLAT#3C ROAD#11A(NEW), DHANMONDI R/A DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mamun161275@gmail.com', 3099, NULL, 'আবদুল্লাহ আল মামুন', 'ENGR. ABDULLAH AL MAMUN', NULL, '1819406364', '924135', 'e10adc3949ba59abbe56e057f20f883e', NULL, 38, NULL, '2373591680', 'ABUL HASSAIN', 'BEGUM MUJIBUN NAHAR', 'MOSHREH JAHAN', '2', 'ENGINEER', 'MANAGING DIRECTOR', NULL, 'AB+', NULL, NULL, 'ROAD#28,HOUSE#366,NEW DOSH MOHAKHALI', NULL, NULL, NULL, NULL, NULL, NULL, 'ROAD#28,HOUSE#366,NEW DOSH MOHAKHALI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('manir90@yahoo.com', 3100, NULL, 'মো: মনিরুল হক', 'MD MANIRUL HAQUE', NULL, '01730 013948', '924077', 'e10adc3949ba59abbe56e057f20f883e', NULL, 39, NULL, '3739058851', 'LATE MD RAFIZ UDDIN', 'LATE MRS. JOBEDA KHATUN', 'KAZI MITHELA HAQUE', '2', 'GOVT SERVICE', 'PROJECT DIRECTOR', 'RAJUK', 'O+', NULL, NULL, 'FLAT-203,HOUSE-05,ROAD-17,BLOCK-C,BANANI,DHAKA-1213', NULL, NULL, NULL, NULL, NULL, NULL, '28/1,KC NAG ROAD, AMLAPARA', NULL, NULL, 'NARSINGDI', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sajol74@gmail.com', 3101, NULL, 'মো: মোস্তাফিজুর রহমান, সজল ', 'MD. MOSTAFIZUR RAHMAN SAJOL', NULL, '1819843824', '921018', 'e10adc3949ba59abbe56e057f20f883e', NULL, 40, NULL, '6419239170', 'LATE MD. ABDUS SOBHAN', 'MRS. SURAIYA BEGUM', 'FARIHA YASMIN', NULL, 'BANKER', NULL, 'KRISHI BANK', 'A+', NULL, NULL, '19/1 LAKE CIRCUS, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'KALIBARI (TITUMIR SARAK), P.O. + DIST.: THAKURGAON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1715703316', 3102, NULL, 'পলাশ উইলিয়াম বোটলেরো', 'PALASH WILLIAM BOTLERO', NULL, '1715703316', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 41, NULL, '5528706343', 'JARMAN BOTLERO', 'RAGINA ROZARIO', 'SUKLA GLORIA ROZARIO', '2', 'TEACHING', 'SENIOR LECTURER', NULL, 'O+', NULL, NULL, '66/A MONIPURI PARA, TEJGAON, DHAKA-1215', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-KAMALK PUR, P.O-SAVAR DIST-DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('rokonsikder26@gmail.com', 3103, NULL, 'মোহাম্মাদ রোকনুজ্জামান', 'MOHAMMAD ROKONUZZAMAN', NULL, '1718587981', '928163', 'e10adc3949ba59abbe56e057f20f883e', NULL, 42, NULL, '1913313712', 'MOHAMMAD MOSLEM UDDIN', 'JAHANARA BEGUM', 'SYEDA MAHAJABEEN NABI', '3', 'BANKER', 'JOINT DIRECTOR', NULL, 'AB+', NULL, NULL, '16,RANKIN STREET, LATIF TOWER WARI,DHAKA-1203', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-APOR,POST-HARIDIA,P.S-LOUHAJANG, MUNSHIGONJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('taponrozario2015@gmail.com', 3104, NULL, 'টেপন জেমস রোজারিও', 'TAPON JAMES ROZARIO', NULL, '01729 098874', '929173', 'e10adc3949ba59abbe56e057f20f883e', NULL, 43, NULL, '1929107637', 'TUNU JOGAFAST ROZARIO', 'IRINE ROZARIO', 'SHIPRA ANNY ROZARIO', '2', 'BANKER', 'ASSISTANT VICE PRESIDENT AND HEAD OF DIVISION', 'MERCANTILE BANK LTD', 'B+', NULL, NULL, '55/D, WEST TEJTORI BAZAR TEJGOAN ,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '55/D, WEST TEJTORI BAZAR TEJGOAN ,DHAKA', NULL, NULL, 'DHAKA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tponigues73@gmail.com', 3105, NULL, 'টিউটর পিটার রদ্রিগেজ', 'TUTUL PETER RODRIGUES', NULL, '1718287487', '9284849', 'e10adc3949ba59abbe56e057f20f883e', NULL, 44, NULL, '3.3135E+12', 'KETU FRANCIS RODRIGUES', 'ELITA ROZARIO', 'CARMEL ROZARIO', '2', 'SERVICE', 'TREASURER', NULL, 'B+', NULL, NULL, 'NORTE DAMO COLLEGE, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-PANJORA,POST-NAGARI,P.S-KAUGONG, DIST-GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('kashem@silvapharma.com', 3106, NULL, 'মাহমুদ আবুল কাশেম', 'MOHAMMAD ABUL KASHEM', NULL, NULL, '922123', 'e10adc3949ba59abbe56e057f20f883e', NULL, 45, NULL, '5507478278', 'MOHAMMAD SERAJUL HOQUE', 'SAKINA KHATAM', 'AMINA SULTANA', '2', 'PRIVATE JOB', 'DEPUTY MANAGER(HR)', NULL, 'B+', NULL, NULL, '165, DHANMONDI , DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-MAIJCHARA P.O-CHARCHANGA P.S-HATIYA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('oliullah.caab@yahoo.com', 3107, NULL, 'মোহাম্মদ অলি উল্লাহ', 'Mohammad Oli Ullah (Jewel)', NULL, '1913979710', '921035', 'e10adc3949ba59abbe56e057f20f883e', NULL, 46, NULL, '7773486902', 'MOHAMMAD ABDUL WADUD', 'JAMILA AKTER', 'MAHMUDA AKTER', '2', 'SERVICE', 'SENIOR COMMUNICATION ENGINEER', 'CAAB', 'AB+', NULL, NULL, 'HOUSE # 113, DAKSHINPARA, DAKSHINKHAN, WARD-48, DHAKA NORTH', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE # 113, DAKSHINPARA, DAKSHINKHAN, WARD-48, DHAKA NORTH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mohmmadmahboobkhan@gmail.com', 3108, NULL, 'মুহম্মদ মাহবুব খান', 'MOHAMMAD MAHBOOB KHAN', NULL, '1680276059', '925100', 'e10adc3949ba59abbe56e057f20f883e', NULL, 47, NULL, NULL, 'MOHAMMAD HOSSAIN KHAN', 'MUSAMMAT SUMSUNNAHAR', 'MUSAMMAT HASINA AKTER', '2', 'BUSINESS', 'DI RECTOR', NULL, 'A+', NULL, NULL, '570/2 SENPARA, PARBATA KAFRUL, DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-KHODAIDHULY POST BAKSHIMUL P.S.BURICHONG DIST-COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shibuk50dmc@gmail.com', 3109, NULL, 'শিবাপদ চক্রবর্তী ', 'SHIBAPADA CHAKRABARTY', NULL, '01927 114515', '921120', 'e10adc3949ba59abbe56e057f20f883e', NULL, 48, NULL, '1.97426E+16', 'GURUPADA CHAKRABARTY', 'ARATI CHAKRABARTY', 'SHIULI BISWAS', '2', 'PHYSICIAN', 'SENIOR CONSULTANT CARDIOLOGIST', 'GREEN LIFE HOSPITAL, GREEN ROAD, DHAKA', 'A-', NULL, NULL, 'FLAT-5A, RAHMAN CASTEL, HOME -163, RA-4, BLOCK-B, BASANDHARA R/A', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-RAMCHANDRAPUR P/S-MURADNAGAR, DIST-COMILLA', NULL, NULL, 'COMILLA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('uzzwalc@yahoo.com', 3110, NULL, 'উজ্জ্বল চৌধুরী ', 'UZZWAL CHOWDHURY ', NULL, '1712221708', '9204089', 'e10adc3949ba59abbe56e057f20f883e', NULL, 49, NULL, '1.97515E+16', 'SANTOSH BHUSHAN CHY', 'REKHA CHY', 'DIPA MOHAJAN', '2', 'GOVT SERVICE', 'UPAZILA ENGINEER', NULL, 'A+', NULL, NULL, 'COMILLA SADAR DEKSIN UPAZILA COMPLEX ,COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-KADAMTALI, P.O-KHONDAKERPARA THANA-RANGUNIA DIST-CHITTAGONG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('titas75@yahoo.com', 3111, NULL, 'ভিনসেন্ট টিটাস রোজারিও ', 'VINCENT TITAS ROZARIO', NULL, '1711181616', '927115', 'e10adc3949ba59abbe56e057f20f883e', NULL, 50, NULL, '5073196825', 'ALEXANDER ROZARIO', 'HELEN ROZARIO', 'RUNICA CHITRA ROZARIO', '3', 'TEACHING', 'ASS.PROFESSOR', NULL, 'A+', NULL, NULL, '140, BARO MAGH BAZAR DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, '140, BARO MAGH BAZAR DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zahirdhaka@yahoo.com', 3112, NULL, 'ডঃ মুহাম্মদ জহিরুল ইসলাম ', 'DR. MOHAMMAD ZAHIRUI ISLAM', NULL, '1716918918', '921059', 'e10adc3949ba59abbe56e057f20f883e', NULL, 51, NULL, '1.22131E+12', 'MD. ABU BAKAR', 'OFIA BEGUM', 'DR. SHAILA SULTANA JHUMA', '2', 'DOCTOR', 'JUNIOR CONSULTANT', NULL, 'B+', NULL, NULL, '40 CENTRAL ROAD, MOIJDEE HOUSING ESTATE, NOAKHALI', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-MOHIUDDINNAGAR, UNION: SULTANPUR, DIST-BRAHMANBRAIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('afmperz@gmail.com', 3113, NULL, 'ডঃ আবু ফয়সাল মো পারভেজ', 'DR. ABU FAISAL MD. PERZ', NULL, '1712025076', '922063', 'e10adc3949ba59abbe56e057f20f883e', NULL, 52, NULL, '2.9247E+12', 'JALALUDDIN AHMED', 'ZINNAT AFZA', 'MALEKA AL RAZI', '2', 'GOVT SERVICE', 'ASST. PROFESSOR', NULL, 'A+', NULL, NULL, 'DEPT OF PEDIATRICS, FARIDPUR MEDICAL COLLEGE, FARIDPUR', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-JHIRARPAR P.O-LOHAJHURI THANA-KATHIADI, DIST-KISHORGANJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ripon_1405_2006_@yahoo.com', 3114, NULL, 'রিপন রয়', 'RIPON ROY ', NULL, '1713114493', '925104', 'e10adc3949ba59abbe56e057f20f883e', NULL, 53, NULL, '2.69635E+12', 'RANJIT KUMAR ROY', 'PRATIMA ROY', 'BINA RANI SAHA', '2', 'PRIVATE SERVICE', 'M.M', NULL, 'O+', NULL, NULL, 'F-11/D 35 MIRPUR ROAD, SUKONNA TOWER, DHANMONDI-DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '675 ROY UILLA KALAI SREE PARA, BRAHMANBARIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('edward@ctimpex.com', 3115, NULL, 'ইডওয়ার্ড তরুন রয় ', 'EDWARD TARUN ROY', NULL, '1713213657', '925003', 'e10adc3949ba59abbe56e057f20f883e', NULL, 54, NULL, '7756692120', 'TIMOTHY S.K ROY', 'APARAJITA ROY', 'MARYAN ROY', '2', 'BUSINESS', NULL, NULL, 'B+', NULL, NULL, '1295, EAST MONIPUR, FLAT-7/B, BEGUM ROKEYA SHARONI,MIRPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL+P.O: BISHARKANDI , PS: BANARIPARA DIST: BARISAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mukbulurmustazir@gmail.com', 3116, NULL, 'মকবুল রহমান মুস্তাজির', 'MUKBULUR RAHMAN MUSTAZIR', NULL, '1610002929', '929251', 'e10adc3949ba59abbe56e057f20f883e', NULL, 55, NULL, '5094886123', 'HABIBUR RAHMAN MUSTAZIR', 'MOKBULA MOSTAZIR', 'TAHMINA FERDOUS', '2', 'PRIVATE SERVICE', 'CLUSTER MANAGER', 'BANGLADESH LTD.', 'A+', NULL, NULL, '18, PURANA PALTAN LINE, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, '18, PURANA PALTAN LINE, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('adv.avimallick@gmail.com', 3117, NULL, 'আভিরাম মল্লিক', 'ADV. AVIRAM MALLICK', NULL, '1741119550', '926071', 'e10adc3949ba59abbe56e057f20f883e', NULL, 56, NULL, '5.91844E+12', 'LATE NIBARAN CHANDRA MALLICK', 'LATE SUKHA RANI MALLICK', 'SHIPRA MALLICK', '1', 'LAWYER', 'ASST. PUBLIC PROSECUTOR', NULL, 'O+', NULL, NULL, '38-40, COURT HOUSE STREET, HENU VILA (2ND FLOOR), RM-309,DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-SONAKANDA, P.O- HASHARA P.S-SREENAGAR. DIST -MUNSHIGONJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zana251205@yahoo.com', 3118, NULL, 'হারুন.এম রশিদ', 'HARUN .M. RASHID', NULL, '1711902097', '928316', 'e10adc3949ba59abbe56e057f20f883e', NULL, 57, NULL, '3.3231E+12', 'ABDUR RAHAMAN', 'EEROSA BEGUM', NULL, NULL, 'BUSINESS', 'CEO', NULL, 'A+', NULL, NULL, 'STATION ROAD, TANGI, GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, 'STATION ROAD, TANGI, GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mnislam76@gmail.com', 3119, NULL, 'মুহাম্মদ নূরুল ইসলাম ', 'MOHAMMAD NURUL ISLAM', NULL, '01714 174585', '926030', 'e10adc3949ba59abbe56e057f20f883e', NULL, 58, NULL, '8238604402', 'MD.SERAJUL ISLAM', 'SALEHA BEGUM', 'FARIDA YEASMIN CHOWDHORY', '3', 'SERVICE (BANKER)', 'EXECUTI VICE PRESIDENT & HEAD OF BRANCH', 'SOUTHEAST BANK LTD., GULSHAN BRANCH', 'B+', NULL, NULL, 'SOUTHEAST BANK LTD. GULSHAN BRANCH, &GULSHAN ANUE , DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-CHOTO SHALGHAR, P.O: BARO SHALGHAR P.S DEVIDWAR, DIST-COMILLA', NULL, NULL, 'CUMILLA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('luajfaisal@yahoo.com', 3120, NULL, 'এম লাউজ ফয়সাল খান', 'M. LUAZ FAISAL KHAN', NULL, '1777707766', '924036', 'e10adc3949ba59abbe56e057f20f883e', NULL, 59, NULL, '7308730477', 'LATE KHALILUR RAHMAN KHAN', 'MA AZIZA  KHANAM', 'WAHIDA ISLAM', '1', 'PRIVATE SERVICE', NULL, NULL, 'A+', NULL, NULL, 'HOUSE# 322, LANE# 05, DOSH BARIDHARA, DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE# 322, LANE# 05, DOSH BARIDHARA, DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('kabir.mithu@gmail.com', 3121, NULL, 'আবু জাফর মুহাম্মদ শাহনাওয়াজ ', 'ABU ZAFAR MOHAMMAD SHAHNAWAZ', NULL, '1710910191', '922098', 'e10adc3949ba59abbe56e057f20f883e', NULL, 60, NULL, '6867898865', 'MOHAMMAD SHAKHAWAT ULLAH', 'ANOWARA BEGUM', 'FARIA AKTHER', '2', 'SERVICE', 'EXECUTI ENGINEER', NULL, 'O+', NULL, NULL, 'NAGAR SWARNALI, FLAT#A-4, 8/2 WEST MALIBAG DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, 'NAGAR SWARNALI, FLAT#A-4, 8/2 WEST MALIBAG DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('hasan.sarwardi@gmail.com', 3122, NULL, 'মুহাম্মাদ হাসান উল হক', 'MUHAMMAD HASAN UL HAQUE', NULL, '1978058888', '928329', 'e10adc3949ba59abbe56e057f20f883e', NULL, 61, NULL, '2.69426E+12', 'LATE ATAUL HAQUE', 'ANWARA BEGUM', 'MST.NURUNNAHAR', '0', 'VOCAL ARTIST', 'BAND LENDER', NULL, NULL, NULL, NULL, '201, SHANTIBAG, MALEKA GARDEN', NULL, NULL, NULL, NULL, NULL, NULL, '38 K.R. ROAD, LALBAG, POSTA DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1711568688', 3123, NULL, 'মোঃ খলিল উল্লাহ সুজন ', 'MD. KHALIL ULLAH (SUZON)', NULL, '1711568688', '928334', 'e10adc3949ba59abbe56e057f20f883e', NULL, 62, NULL, '1932142506', 'MD. BASHIR UDDIN', 'ROKEYA ZOHORA', 'TASNIN KHAN AKHI', '2', 'BUSINESS', NULL, NULL, 'A+', NULL, NULL, '222/1, MALIBAG, FLAT-D/8, UREKA HOMES, MALIBAG, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '222/1, MALIBAG, FLAT-D/8, UREKA HOMES, MALIBAG, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mahmud.hosain@gmail.com', 3124, NULL, 'মাহমুদ হোসেন স্মিথ ', 'MAHMUD HOSAIN (SMITH)', NULL, '1711891002', '923074', 'e10adc3949ba59abbe56e057f20f883e', NULL, 63, NULL, NULL, 'T.M. ROKAN UDDIN', 'DIC AFROZE BEGUM', 'KHADIJA', '2', 'SERVICE', 'MANAGER', NULL, 'B+', NULL, NULL, 'H#27, RD# 5, NIKUNJA-1, KHILKHET, DHAKA-1229', NULL, NULL, NULL, NULL, NULL, NULL, '3/10 NANDI PARA, KHILGAON, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('joshuaflight@gmail.com', 3125, NULL, 'নূরুল ইসলাম ভুঁইয়া', 'NURUL ISLAM BHUIYAN', NULL, '1712955462', '923071', 'e10adc3949ba59abbe56e057f20f883e', NULL, 64, NULL, '2.69372E+11', 'ABDULLA BHUIYAN', 'KHALEDA BEGUM', 'TASMINA AKTER', '1', 'PILOT', NULL, NULL, 'O+', NULL, NULL, 'HOUSE# 16, ROAD 9, NIKUNJA-2, KHILKHET, DHAKA-1229', NULL, NULL, NULL, NULL, NULL, NULL, 'RAJDIA,SERAJDIKHAN MUNSHIGONJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mamun@mtrixs.com', 3126, NULL, 'এমডি মামুন উর রশিদ ', 'MOHAMMAD MAMUN UR RASHID', NULL, '1610004190', '924042', 'e10adc3949ba59abbe56e057f20f883e', NULL, 65, NULL, NULL, 'MD MOSHARRAF HOSSAIN', 'GULSHAN ARA BEGUM', 'SYEDA MAHABUBA KOWSER ', '3', 'BUSINESS', 'MANAGING DIRECTOR', 'MATRIX', 'O+', NULL, NULL, '2,NORTH BASHABO, DHAKA, 1214', NULL, NULL, NULL, NULL, NULL, NULL, '2,NORTH BASHABO, DHAKA, 1214', NULL, NULL, 'FARIDPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mahbubhtl@gmail.com', 3127, NULL, 'মোঃ মাহবুব উল আলম', 'MOHAMMED MAHBUB-UI-ALAM', NULL, '01779 595403', '924045', 'e10adc3949ba59abbe56e057f20f883e', NULL, 66, NULL, NULL, 'MD. EMDADUL HAQUE', 'M.NAHAR', 'ARRINA BEGUM', '1', 'SERVICE', 'MANAGER', 'PARAMOUNT GROUP', 'AB-', NULL, NULL, '462,  SOUTH GORAN, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, '462,  SOUTH GORAN, DHAKA-1219', NULL, NULL, 'NARSINGDI', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('touhid.irfan@gmail.com', 3128, NULL, 'মুহাম্মদ তৌহিদ ইরফান', 'MOHAMMAD TOUHID IRFAN', NULL, '1819253404', '927011', 'e10adc3949ba59abbe56e057f20f883e', NULL, 67, NULL, '4622951244', 'LATE BASHARAT ALI', 'LUTFUN NAHAR ALI', NULL, '2', 'SERVICE', NULL, NULL, 'A+', NULL, NULL, 'MOHANANDA APT#B2, 233/2 MODHUBAZAR ROAD#10,WEST DHANMONDI, DHAKA 1209', NULL, NULL, NULL, NULL, NULL, NULL, 'MOHANANDA APT#B2, 233/2 MODHUBAZAR ROAD#10,WEST DHANMONDI, DHAKA 1209', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('md.shafiq1174@gmail.com', 3129, NULL, 'মুহাম্মদ শফিকুর রহমান ', 'MOHAMMAD SHAFIQUR RAHMAN', NULL, '1783499738', '924026', 'e10adc3949ba59abbe56e057f20f883e', NULL, 68, NULL, '1.97427E+16', 'LATE FAZLUR RAHMAN', 'MOST. SUFIA AKHTER BANU', 'AZMIRA JAHAN', NULL, 'BANKER', 'SENIOR PRINCIPAL OFFICER', NULL, 'A+', NULL, NULL, '77/B, MERADIA, BANASREE BLOCK-G, FLAT NO-B-8, KHILGAON, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-HAMIDPUR, P.O-NANDINA, P.S-DIST-JAMALPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('smgferdous@gmail.com', 3130, NULL, 'এস এম গোলাম ফেরদৌস', 'S.M GHOLAM FERDOUS', NULL, NULL, '924053', 'e10adc3949ba59abbe56e057f20f883e', NULL, 69, NULL, '4601285085', 'M.A. GHANI', 'SALEHA GHANI', 'JANNATUL NAIMA FERDOUS', '2', 'MARINER', 'CHIEF ENGINEER', NULL, 'A+', NULL, NULL, 'FLAT-602, EASTERN MAHAL SHEDNESWERY ROAD, RAMNA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE# 508,ROAD-31, SOUTH GORAN DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mohibur_tauhid@yahoo.com', 3131, NULL, 'মুহাম্মাদ মহিবুর রহমান (তৌহীদ)', 'MOHAMMAD MOHIBUR RAHMAN(TAUHID)', NULL, '1711146579', '928179', 'e10adc3949ba59abbe56e057f20f883e', NULL, 70, NULL, NULL, 'MD. MOQSUD ALI HOWLADER', 'MONOWARA BEGUM', 'MUSLAMA AKTHER', '2', 'SERVICE', 'FAUP(SIBL)', NULL, 'B+', NULL, NULL, '250/A, NORTH SHAHJAHANPUR (5TH FLOOR), DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '250/A, NORTH SHAHJAHANPUR (5TH FLOOR), DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('anwarulghani@yahoo.com', 3132, NULL, 'মুহাম্মদ আনোয়ারুল গণি', 'MOHAMMAD ANWARUL GHANI', NULL, '1911323711', '921097', 'e10adc3949ba59abbe56e057f20f883e', NULL, 71, NULL, '2.69481E+12', 'AZIZUL HAQUE BHUYAN', 'BEGUM SUFIA AKTHER KHANAM', 'MASUMA KHATUN', '2', 'TEACHING', NULL, NULL, 'B+', NULL, NULL, 'HOUSE-194, ROAD-9/4, E-BLOCK, SOUTH BANASREE, KHILGAON, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '746, MONIPUR, MIRPUR-2, DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('smbabar07@gmail.com', 3133, NULL, 'এস এম মুস্তাফা জালাল', 'S.M . MUSTAFA JALAL', NULL, '1913480591', '923063', 'e10adc3949ba59abbe56e057f20f883e', NULL, 72, NULL, '2.69683E+12', 'LATE. MD.LOKUAR HAKIM', 'MRS. HASINA HAKIM', 'MRS.NIGHAT ARA', '0', 'BUSINESS', 'EXECUTI DIRECTOR', NULL, 'B+', NULL, NULL, 'SUIT # 1109(11TH FLOOR) MOTIJHEAL -A  dhaka-1000', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-DUWYIA, P.O-MANIKHER, UP-GOPALGONJ, DIST-GOPALGONJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ainulh5@gmail.com', 3134, NULL, 'মোহাম্মদ আইনুল হক', 'MOHAMMAD AINUL HAQUE', NULL, '1730727384', '922108', 'e10adc3949ba59abbe56e057f20f883e', NULL, 73, NULL, '7300190191', 'LATE MD. MOZAMMEL HAQUE', 'AZIZA KHATUN', 'SAIRA JALIL', '1', 'SERVICE', 'VP', NULL, 'AB+', NULL, NULL, 'HOUSE# 233/A, ROAD # 6, KHILGAON, TILPA PARA, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE# 233/A, ROAD # 6, KHILGAON, TILPA PARA, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('azizur31bh@gmail.com', 3135, NULL, 'এমডি আজিজুর রহমান টিপু ', 'MD. AZIZUR RAHMAN TIPU', NULL, '1714288217', '921077', 'e10adc3949ba59abbe56e057f20f883e', NULL, 74, NULL, '2369483876', 'MD.MUSLEH UDDIN', 'TAHERUN NESA', 'DR. FARHANA HOQUE', '2', 'MARINER', 'CHIEF ENGINEER', NULL, 'A+', NULL, NULL, '56/2, NORTH BASHABOO, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, '56/2, NORTH BASHABOO, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zakir.khan@dewhirst.com', 3136, NULL, 'মুহাম্মদ জাকির হোসেন খান', 'MUHAMMAD ZAKIR HOSSAIN KHAN', NULL, '1713044818', '922065', 'e10adc3949ba59abbe56e057f20f883e', NULL, 75, NULL, NULL, 'MUHAMMAD KHALIL KHAN', 'ANWARA BEGUM', 'NASREEN ISLAM KHAN', '3', 'SERVICE', 'DIRECTOR', NULL, 'A+', NULL, NULL, '151 3/C WEST RAMPURA WAPDA ROAD, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, '151 3/C WEST RAMPURA WAPDA ROAD, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('rashek_750@yahoo.com', 3137, NULL, 'রাসেক আহমেদ ', 'RASHEK AHMED', NULL, '1819101005', '922084', 'e10adc3949ba59abbe56e057f20f883e', NULL, 76, NULL, NULL, 'LATE ALI AHMED', 'LATE MOMTAZ BEGUM', 'DR.TAHMINA BINTE MATIN', '2', 'MARINER', 'CHIEF HPL', NULL, 'O+', NULL, NULL, '449, ZONE : A, KHILGAON (3RD FLR)', NULL, NULL, NULL, NULL, NULL, NULL, '449, ZONE : A, KHILGAON (3RD FLR)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sajalmmc@gmail.com', 3138, NULL, 'মোহাম্মদ মনজুর হাসান মামুন', 'MOHAMMAD MONJUR HASAN MAMUN', NULL, '1715011637', '922057', 'e10adc3949ba59abbe56e057f20f883e', NULL, 77, NULL, '9.31956E+12', 'LATE. MOHAMMED AKKAS ALI', 'MRS. MONORA BEGUM', 'DR. KANIZ FATAMA KHAN', '2', 'DOCTOR', 'MEDICAL OFFICER,SOPD', 'DMCH', NULL, NULL, NULL, 'HOUSE-SHONKO, 13 FLAT-A-2, OFFICERS QUATIAR , PILKHANA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE-1, LANK-2, ROAD-1,DAKKHINGAON, POST- BASABO, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('dr_abu_obaida@yahoo.com', 3139, NULL, 'ডঃ আবু সালেহ এমডি আবু ওবায়দা', 'DR.ABU SALEH MD. ABU OBAIDA', NULL, '1817036222', '924058', 'e10adc3949ba59abbe56e057f20f883e', NULL, 78, NULL, NULL, 'MD. KHALED BHUIYAN', 'JAHAN ARA BEGUM', 'DR. LUBNA JAHAN', '3', 'DOCTOR', 'NEUROSURGEON', NULL, 'B+', NULL, NULL, 'DEPTOF NERO, 4TH FLOOR, BLOCK -C, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, 'KHALED MONJIL, COLLEGE ROAD, MAIJDEE BAZAR, NOKHILI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('drmnh2003@gmail.com', 3140, NULL, 'ডঃ মুহাম্মদ নজরুল হোসেন ', 'DR. MOHAMMAD NAZRUL HOSSAIN', NULL, '1819496333', '925080', 'e10adc3949ba59abbe56e057f20f883e', NULL, 79, NULL, NULL, 'MOHAMMD TOFAZZAL HOSSAIN', 'MRS SALEHA AKTER KHANAM', 'DR. ISRAT ZERIN EVA', '2', 'NEUROSURGEON', 'ASSOCIATE PROFESSOR HOD', NULL, 'B+', NULL, NULL, 'HOUSE-51, ROAD# LAKE DRI ROAD, SECTOR-07, UTTARA , DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'DIST- NOAKHALI, P.O-MAIYDEE COURT, THANA- SUDARAM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shibabadc@gmail.com', 3141, NULL, 'শিবেন্দ্র নারায়ণ গুপ', 'SHIBENDRA NARAYAN GOPE', NULL, '02-9553291', '922122', 'e10adc3949ba59abbe56e057f20f883e', NULL, 80, NULL, '1.97593E+16', 'MADAN MOHAN GOPE', 'BITHIKA RANI GOPE', 'ANZANA RANI GHOSH', '2', 'GOVT SERVICE', 'DEPUTY CHIEF ENGINEER', NULL, 'AB+', NULL, NULL, 'BADC, KRISHI BHABAN, 49-51, DILKUSHA C/A DHAKA- 1000', NULL, NULL, NULL, NULL, NULL, NULL, 'SMRITY BHABAN , SATHI CINEMA ROAD, MADHUPUR LOST OFFICE 2 UPAZILA-MADHUPUR, DIST-TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000');
INSERT INTO `all_info_together` (`email`, `id`, `full_name`, `name_bangla`, `first_name`, `last_name`, `mobile`, `institution_id`, `password`, `registration_date`, `membership_number`, `gender`, `nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `date_of_birth`, `religion`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `second_citizenship_country`, `otp`, `forgot_password_crypto`, `status`, `email_verification_status`, `change_request`, `change_request_time`, `type`, `visibility`, `completeness`, `recent_photo`, `old_photo`, `timestamp`, `membership_fee`) VALUES
('manzur_hossain@yahoo.com', 3142, NULL, 'মাহমুদ মানজুর হোসেন', 'MOHAMMAD MANZUR HOSSAIN', NULL, '61434287195', '923031', 'e10adc3949ba59abbe56e057f20f883e', NULL, 81, NULL, '3.31369E+12', 'LATE GIAS UDDIN AHMED ', 'LATE AMULA KHATUN', 'SHAHANA HOQ', '2', 'ENGINEER', 'RESEARCH FELLOW', NULL, 'O+', NULL, NULL, '2015, SHREDFONT ST, WILAGPATH, NSW 2194, AUSTRALIA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL+ PO- TARGAON, P.O- KAPASIA, DIST GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sumon2376@yahoo.com', 3143, NULL, 'এমডি আমিনুর রহমান', 'MD. AMINUR RAHMAN', NULL, '1730013926', '925047', 'e10adc3949ba59abbe56e057f20f883e', NULL, 82, NULL, '2.69481E+12', 'MD. HAFIZUR RAHMAN BHUIYAN', 'LATE MRS. KAMRUNNESSA', 'SYEDA JESMINA PERVIN', '2', 'GOVT SERVICE', 'ENGINEER (CIVIL)', NULL, 'B+', NULL, NULL, '78, KALLYANPUR, MAIN ROAD, MIRPUR, DHAKA- 1207', NULL, NULL, NULL, NULL, NULL, NULL, 'AKUA BOARD GHAR, MYMENSINAH SADAR, MYMENSINAH, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ariful.islam@metlife.com.bd', 3144, NULL, 'মাহমুদ আরিফুল ইসলাম ', 'MOHAMMAD ARIFUL ISLAM', NULL, '1709632850', '922090', 'e10adc3949ba59abbe56e057f20f883e', NULL, 83, NULL, '2.69481E+12', 'LATE ABDUS SATTAR MIAN', 'FERDOUS ARA BEGUM', 'NADIRA BEGUM', '2', 'PRIVATE SERVICE', 'MANAGER', NULL, 'B+', NULL, NULL, 'FLAT# 4B, CITADEL BAULIANA, 8/1- A, PALLABI , MIRPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'AVA NIR, MASTERPARA, MADHUPUR, TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mirza927043@gmail.com', 3145, NULL, 'মিরজা গোলাম নবী', 'MIRZA GOLAM NABI', NULL, '01712 722522', '927043', 'e10adc3949ba59abbe56e057f20f883e', NULL, 84, NULL, '6869852852', 'LATE MIRZA ISRAIL', 'ANOWARA KHANAM', 'FARIA HOSSAIN', '2', 'BUSINESS', 'MD', 'TM SOURCING', 'B+', NULL, NULL, 'H-81 R-17 S-14 UTTARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL+POST- KUMULLI NAMDAR UPOZILA+ZILA-TANGAIL', NULL, NULL, 'TANGAIL', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('nasimulhyder@gmail.com', 3146, NULL, 'এবি নাসিমুল হাইদার ', 'A B M NASIMUL HYDER', NULL, '1787136930', '924112', 'e10adc3949ba59abbe56e057f20f883e', NULL, 85, NULL, NULL, 'LATE HYDER ALI TALUKDER', 'SOFIA HYDER', 'AMENA JAMAL BITHI', '3', 'SERVICE', 'GM', NULL, 'B+', NULL, NULL, 'H-12, R-14, SEC-12, UTTARA , DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL- ADABARY P.O- HABLA PS-MIRZAPUR DIST-TANGAIL  BANGLADESH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('rassel007@gmail.com', 3147, NULL, 'মুহাম্মদ আবু নাসির ভুইয়া ', 'MOHAMMAD ABU NASER BHUIYAN', NULL, '1713040948', '925025', 'e10adc3949ba59abbe56e057f20f883e', NULL, 86, NULL, '2.6114E+12', 'MOHAMMAD ABUL HOSSAIN BHUIYAN', 'MRS HAZERA BEGUM', 'FARZANA FERDOUS', '2', 'PRIVATE SERVICE', 'SENIOR VICE PRESIDENT', NULL, 'A+', NULL, NULL, 'FLAT -3B, HOUSE# 5, ROAD#7, SEC#5 UTARRA , DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: THANKI MOHERA, POST ARMOISTA, THANA: DELDUAR, DIST: TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('saif5163@yahoo.com', 3148, NULL, 'মুহাম্মদ সাঈফুর রহমান', 'MOHAMMAD SAIFUR RAHMAN (SHUMON)', NULL, '01712 081605', '921051', 'e10adc3949ba59abbe56e057f20f883e', NULL, 87, NULL, NULL, 'LATE SHAMSUR RAHMAN', 'SHIRIN RAHMAN', 'AFROJA SHEWLY', '2', 'GOVT SERVICE', 'LIEUTENANT COLONEL', 'BANGLADESH ARMY', 'B+', NULL, NULL, '6A, PORSHI, MOINUL ROAD, DHAKA CANT', NULL, NULL, NULL, NULL, NULL, NULL, 'SHANTINER, GHASHIPARA, DINAJPUR', NULL, NULL, 'DINAJPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sah@dem.dk', 3149, NULL, 'সঞ্জীব বসির আহম্মেদ', 'SANJIB BASHIR AHMED', NULL, '1733785168', '927055', 'e10adc3949ba59abbe56e057f20f883e', NULL, 88, NULL, '1004381024', 'MOMEN AHMAD', 'MAHELA AHMAD', 'TOUHIDA TASNIMA', '1', 'IT CONSULTANT', 'IT CONSULTANT', NULL, 'O+', NULL, NULL, 'HOUSE 133, ROAD-1, BARIDHARA DOHS DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: CHEORA, CHODDOGRAM, COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('dr.mahbub@gmail.com', 3150, NULL, 'মহাব্বুর রহমহান', 'MAHBUBUR RAHMAN ', NULL, '1730026064', '922105', 'e10adc3949ba59abbe56e057f20f883e', NULL, 89, NULL, '4622749036', 'M A SHAHID', 'KHAIRUNNESA', 'ROZINA BEGUM', '2', 'SERVICE', 'VICE PRESIDENT', NULL, 'A+', NULL, NULL, 'BEACON BUSINESS POINT, 9/B/2, TOYENBEE CIRCULAR ROAD, MOTIJHEEL, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'KACHUSDI, MIRPUR BAZAR, BAHUBAL, HALIGANJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shohag_bcsrr@yahoo.com', 3151, NULL, 'মুহাম্মাদ আনওয়ার হোসেন সোহাগ', 'MOHAMMAD ANWAR HOSSAIN SHOHAG', NULL, '9122524', '928112', 'e10adc3949ba59abbe56e057f20f883e', NULL, 90, NULL, '1.92671E+12', 'ALHAJJ MOHAMMAD GHULAM ALI', 'ALHAJJ ZARINA KHATUN', 'AYESHA SIDDIQUA NWS', '2', 'GOVT SERVICE', 'ASS. PROFESSOR', NULL, 'A+', NULL, NULL, '7/13, BAILY SQUARE OFFICERS QUARTER, RAMNA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'ALI VILA, WEST MATUAIL. JATRABARI, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ashrafahammed1974@gmail.com', 3152, NULL, 'ডঃ আশরাফ উদ্দীন আহমদ', 'DR, ASRAF UDDIN AHMED', NULL, '1913164722', '922068', 'e10adc3949ba59abbe56e057f20f883e', NULL, 91, NULL, '4607088574', 'ABDUR RAZZAK', 'SALMA BEGUM', 'DR. SARWAT AFRINA AKTER', '2', 'DOCTOR', 'CONSULTANT', NULL, 'A-', NULL, NULL, 'BIJOY RAKEEN CITY, A-8, T-1, 06-03, SECTION-14, MIRPUR', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-OSMANPUR, PS-BANGALPARA, DS-AUSTAGRAM, DIST- KISHOREGANT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mushriq2007@gmail.com', 3153, NULL, 'মুশফিক উল কায়য়ুম', 'MUSHFIQ UL QUAYOOM', NULL, '1912132132', '927066', 'e10adc3949ba59abbe56e057f20f883e', NULL, 92, NULL, '9100509455', 'M.A QUAYOOM', 'MANZURA QUAYOOM', 'AMINA AKTHER', '3', 'SERVICE', 'DIRECTOR & CEO', NULL, 'O+', NULL, NULL, '21, LAKE DRI ROAD, SECTOR-7, UTTARA, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, '21, LAKE DRI ROAD, SECTOR-7, UTTARA, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('921116', 3154, NULL, 'ডঃ তানভীর আহমেদ চৌধুরী ', 'DR.TANVIR AHMED CHOWDHURY', NULL, NULL, '921116', 'e10adc3949ba59abbe56e057f20f883e', NULL, 93, NULL, NULL, 'LATE SHARFUDDIN AHMED', 'ROKEYA BEGUM', 'NASSA AKTHER', '2', 'PHYSICIAN', 'ASS. DIRCTOR', NULL, 'A+', NULL, NULL, '44/1, NORTH MUGDAPARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '44/1, NORTH MUGDAPARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('arifur@gmail.com', 3155, NULL, 'মোহাম্মদ আরিফুর রহমান ', 'MOHAMMAD ARIFUR RAHMAN', NULL, '1712143983', '924064', 'e10adc3949ba59abbe56e057f20f883e', NULL, 94, NULL, '1.97527E+16', 'LATE MD.ATAUR RAHMAN', 'SHAMSUN NAHAR', 'UMMAY HABIBA', '0', 'TEACHING', 'LECTURER', NULL, 'B+', NULL, NULL, 'ATP# 13/G, 52 PURANA PALTAN LINE, DHAKA- 1000', NULL, NULL, NULL, NULL, NULL, NULL, 'ATP# 13/G, 52 PURANA PALTAN LINE, DHAKA- 1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mizandtex@gmail.com', 3156, NULL, 'মিজানুর রহমান', 'MIZANUR RAHMAN', NULL, '183561165', '924009', 'e10adc3949ba59abbe56e057f20f883e', NULL, 95, NULL, NULL, 'MD.SULTAN MIA', 'AFIA KHATUN', 'RAFIYA AKTER', '2', 'BUSINESS', 'PROPRIETOR', NULL, 'B+', NULL, NULL, 'H# 32,R# 18, SECTOR# 13,UTTARA', NULL, NULL, NULL, NULL, NULL, NULL, 'ATATION ROAD NUTUN BAZAR, HOLDING-159, TONGI, GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mrahmanmukul_@yahoo.com', 3157, NULL, 'মুহাম্মদ হাবিবুর রহমান মুকুল', 'MUHAMMAD HABIBUR RAHMAN MUKUL', NULL, '1712201255', '925053', 'e10adc3949ba59abbe56e057f20f883e', NULL, 96, NULL, '1.97433E+16', 'LATE ABDUR RAHIM', 'MRS HALIMA BEGUM', 'MRS FATEMA BEGUM SWEETY', '1', 'GOVT SERVICE', 'SENIOR OFFICER', NULL, 'O+', NULL, NULL, 'E-KADAM / 02, BRRI R/A GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-NANDIRPARA POST-MUKSHUDPUR P/S- SHERPUR SADAR, DIST-SHERPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('rafiqul_dream@yahoo.com', 3158, NULL, 'আ ক ম রফিকুল আলম', 'AKM RAFIQUL ALAM', NULL, '1720159416', '928330', 'e10adc3949ba59abbe56e057f20f883e', NULL, 97, NULL, '2612980855448', 'MD. SHAHJAHAN BHUIYAN', 'AYESHA KHATUN', 'SABRINA KHONDOKER', '2', 'BCS-TEACHER', 'ASSOCIATE PROFESSOR', NULL, 'O+', NULL, NULL, 'FLAT- I/13, ORIENTAL LOG CABIN, 32, MIRPUR ROAD, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('iqbalasif1975@yahoo.com', 3159, NULL, 'মুহাম্মাদ আসিফ ইকবাল', 'MUHAMMAD ASIF IQBAL', NULL, '1819297623', '924016', 'e10adc3949ba59abbe56e057f20f883e', NULL, 98, NULL, '4177441963', 'MD. BAHAUDDIN BHUIYAN', 'NURUN NAHAR', 'ROWNAK JAHAN', '2', 'BANKER', 'VP', NULL, 'B+', NULL, NULL, '68/1, WEST RAZABAZAR', NULL, NULL, NULL, NULL, NULL, NULL, '68/1, WEST RAZABAZAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shahidurosmani@gmail.com', 3160, NULL, 'সাহিদুর রহমান ওসমানী', 'SAHIDUR RAHMAN OSMANI', NULL, '1711587938', '926037', 'e10adc3949ba59abbe56e057f20f883e', NULL, 99, NULL, NULL, 'LATE MIZANUR RAHMAN OSMANI', 'SYDA AFIA KHATUN', 'SURAYA BINTE MAHBUB', '3', 'GOVT SERVICE', NULL, NULL, 'A+', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NOWAGAON, SARIAL.B.BARIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1740907288', 3161, NULL, 'রিয়াজ আহমেদ', 'REAZ AHMED', NULL, '1740907288', '923006', 'e10adc3949ba59abbe56e057f20f883e', NULL, 100, NULL, '5542732218', 'ABDUR RAHMAN', 'SHAMIM ARA', NULL, '3', 'BUSINESS', NULL, NULL, 'B+', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('dmrh2010@gmail.com', 3162, NULL, 'ডঃ মোঃ রিয়াদ হাসান', 'DR. MD. RIAD HASAN ', NULL, '1819202031', '921115', 'e10adc3949ba59abbe56e057f20f883e', NULL, 101, NULL, '9132802449', 'A.H.MNAZMUL HUQ', 'FATEMA BEGUM', 'DR. SHAHANA PARVIN', '2', 'PHYSICIAN', 'DIABETS CONSULTANT', NULL, 'A+', NULL, NULL, '275, NORTH SHAHJAHANPUR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, '275, NORTH SHAHJAHANPUR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sanowar75@gmail.com', 3163, NULL, 'এমডি সানোয়ার হোসেন', 'MD. SANOWAR HOSSAIN', NULL, '1819210623', '926003', 'e10adc3949ba59abbe56e057f20f883e', NULL, 102, NULL, '2.69666E+12', 'LATE MD.OBAIDUL HAQUE', 'FEROZA BEGUM', 'OWAIS HOSSAIN SURAIN', '1', 'SERVICE', 'SPECIALIST ADMIN', NULL, 'A+', NULL, NULL, '1/ F-4, MIRBAGH, MOGBAZAR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, '1/ F-4, MIRBAGH, MOGBAZAR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mehedimasud@gmail.com', 3164, NULL, 'ডঃ মেহেদী মাসুদ ', 'DR. MEHEDI MASUD RUBENCE', NULL, '1711486268', '921004', 'e10adc3949ba59abbe56e057f20f883e', NULL, 103, NULL, NULL, 'MD. ALTAF UDDIN', 'SULTANA ZAKIA', 'DR. NASRIN NARGIS', '2', 'DOCTOR', 'ANAESTHESIA', NULL, 'O+', NULL, NULL, 'APT-B2, HOME-05, ROAD-06, SECTOR-11,UTTARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'APT-B2, HOME-05, ROAD-06, SECTOR-11,UTTARA, DHAKA', NULL, NULL, 'Mymensingh', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('hedayeta@yahoo.com', 3165, NULL, 'ডঃ মুহাম্মদ হেদায়েত আলী খান', 'DR. MOHAMMAD HEDAYET ALI KHAN', NULL, '01711 980697', '925026', 'e10adc3949ba59abbe56e057f20f883e', NULL, 104, NULL, '1.97535E+16', 'MOHAMMAD SIRAJUL HOQUE KHAN', 'MRS. LUTFONNESA BEGUM', 'DR. MANSURA AKTER PANNA', '3', 'PLASTIC SURGEON', 'ASSOCIATE PROFESSOR', 'Sheikh Hasina National Institute of Burn and Plastic Surgery', 'B+', NULL, NULL, 'FLAT-12/13, NEW CIRCUIT HOUSE, ESKATON GARDEN, ROAD, ISKATAN DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-GUNOHER, PO:NARIKHIR, THANA-MUKSUDPUR, DIST-GOPALGONJ', NULL, NULL, 'GOPALGANJ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('a.kabirripon@gmail.com', 3166, NULL, 'এমডি আহসান কবির', 'MD. AHSAN KABIR', NULL, '1670073971', '926048', 'e10adc3949ba59abbe56e057f20f883e', NULL, 105, NULL, '1933443440', 'MD HASAN ALI KHAN', 'MST. SURAYEA PARVIN', 'NURENNAHAR RUBI', '2', 'GOVT SERVICE', NULL, NULL, 'A+', NULL, NULL, 'UPAZILA-ACCOUNT OFFICER, BAUPHAL, PATVAKHALI', NULL, NULL, NULL, NULL, NULL, NULL, '7, AL-HERA SCHOOL, COLLEGE ROAD, PATUAKHALI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('chapal010805@gmail.com', 3167, NULL, 'আবু সাঈদ মাহমুদ', 'ABU SAYEED MAHMUD', NULL, '1711505193', '922138', 'e10adc3949ba59abbe56e057f20f883e', NULL, 106, NULL, '1.97527E+16', 'MD. GHULAM MOSTAFA', 'ANIS KHATUN', 'DR HASINA BEGUM', '1', 'PRIVATE SERVICE', 'SALES MANAGER', 'MetLife', 'B+', NULL, NULL, 'MOUCHACK APARTMENT, FLAT#D, 19/B, WEST MALIBAGH, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, 'MOUCHACK APARTMENT, FLAT#D, 19/B, WEST MALIBAGH, DHAKA-1217', NULL, NULL, 'Cumilla', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('enampwd@gmail.com', 3168, NULL, 'এমডি এনামুল হক', 'MD. ENAMUL HUQUE', NULL, '1712128064', '921144', 'e10adc3949ba59abbe56e057f20f883e', NULL, 107, NULL, '2.69362E+12', 'MD. SHAMSUL HUQUE', 'RUSHIA BEGUM', 'DR. MAHRUFA HUQ', '2', 'GOVT SERVICE', 'DEPUTY SECRETARY', NULL, 'A+', NULL, NULL, 'H-298, R-4, MIRPUR DOSH, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HOLDING-122, WARD-9, SHNTIBUG, KALAPARA POURASAVA, PATUAKHALI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ashokadsita@gmail.com', 3169, NULL, 'অশোক কুমার চক্রবর্তী', 'ASHOK KUMAR CHAKRABORTY', NULL, '1755677522', '921009', 'e10adc3949ba59abbe56e057f20f883e', NULL, 108, NULL, '5055846769', 'LATE BADAL CHAKSABORTY', 'SANDLYA CHAKSABORTY', 'CHAYANIKA CHAKSABORTY', '2', 'PRIVATE SERVICE', NULL, NULL, 'O+', NULL, NULL, 'HOUSE# 338, ROAD# 05, MIRPUR DOSH, PALLABI, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'TRIBERI HOUSE, UTTAR BALUBARI, DINAJPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1711149583', 3170, NULL, 'মুহাম্মদ হাফিজুর রহমান ', 'MOHAMMAD HAFIZUR RAHMAN', NULL, '1711149583', '924021', 'e10adc3949ba59abbe56e057f20f883e', NULL, 109, NULL, '2.69683E+12', 'MOHAMMAD AZHARUL ISLAM', 'HAFIZA AKTER', 'JANNATUL FERDOSE', '2', 'DOCTOR', 'SENIOR MEDICAL OFFICER', NULL, 'B+', NULL, NULL, '58/34/E-1, NORTH MUGDA, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-CHIAAJANI, THANA +PO:DEWANGONJ, JAMALPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1715044474', 3171, NULL, 'ফারসিম মান্নান মোহাম্মদী', 'FARSEEM MANNAN MOHAMMEDY', NULL, '1715044474', '927007', 'e10adc3949ba59abbe56e057f20f883e', NULL, 110, NULL, '6895355938', 'M.A MANNAN', 'HOSNE ARA MANNAN', 'FARHANA MANNAN', '2', 'TEACHING', 'PROFESSOR', NULL, 'A+', NULL, NULL, 'BONOLATA 200WEST MONIPUR, MIRPUR-1,DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, 'BONOLATA 200WEST MONIPUR, MIRPUR-1,DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zrkhanbuet@gmail.com', 3172, NULL, 'মোঃজিয়াউর রহমান খান ', 'MD. ZIAUR RAHMAN KHAN', NULL, NULL, '92', 'e10adc3949ba59abbe56e057f20f883e', NULL, 111, NULL, NULL, 'MD. REZAURRAHMAN KHAN', 'NAZME ARA ZOHRA KHATUN', 'FATEMATUZ ZAHURA', '1', 'TEACHING', 'PROFESSOR', NULL, 'O+', NULL, NULL, 'H#4, R#34, BLOCK-TA, SEC-6, MIRPUR, DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, 'H#4, R#34, BLOCK-TA, SEC-6, MIRPUR, DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tanvir.ibrahim@gmail.com', 3173, NULL, 'তানভীর ইব্রাহিম ', 'TANVIR IBRAHIM', NULL, '01711 500313', '927112', 'e10adc3949ba59abbe56e057f20f883e', NULL, 112, NULL, '6850019651', 'M.I.M HOWLADER', 'FIROZA AKTER', 'SAMIA IESMIN CHOWDHURY', '1', 'SERVICE/BUSINESS', 'CHEIEF EXECUTI OFFICER', 'SERVICE SOLUTIONS PVT. LTD.', 'B+', NULL, NULL, 'APT-3/A, HOUSE-09, ROAD-06, SECTOR-07, UTTARA, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, 'APT-3/A, HOUSE-09, ROAD-06, SECTOR-07, UTTARA, DHAKA-1230', NULL, NULL, 'CUMILLA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('quamruladmn@yahoo.com', 3174, NULL, 'এমডি কামরুল আহসান তালুকদার', 'MD. QUAMRUL AHSAN TALUKDAR', NULL, '1318360003', '924030', 'e10adc3949ba59abbe56e057f20f883e', NULL, 113, NULL, NULL, 'MD. ABDUR RASHID TALUKDER', 'RASHIDA BEGUM', 'ABEDA SULTANA', '2', 'GOVT SERVICE', 'DEPUTY SECRETARY', NULL, NULL, NULL, NULL, '20/C, NEW ESKATON, 3RD FLOOR, GAUR NAGOR, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: GAUR NAGOR, POST: FAKIRBARI, THANA: MORROLGONJ DIST-BAGERHAT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('djoybd@gmail.com', 3175, NULL, 'ধনঞ্জয় কুমার দাস ', 'DHANANJOY KUMAR DAS', NULL, '1919162162', '927042', 'e10adc3949ba59abbe56e057f20f883e', NULL, 114, NULL, '1.97527E+16', 'DAKSIHNA RANJAN DAS', 'KAJOL RANI DAS', 'JALLY SUTRADHAR', '1', 'GOVT SERVICE', 'DEPUTY SECRETARY', NULL, 'A+', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'E-G CENTER, 69 SWAMIBAG, DHAKA 1203', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('jhammituhin@yahoo.com', 3176, NULL, 'মোহাম্মদ হোসাইন', 'MOHAMMAD HUSSAIN', NULL, '1680653646', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 115, NULL, NULL, 'MD. AMZAD HUSSAIN MIAH', 'ZAKIA SULTANA', 'FAHMIOM SULTANA', '2', 'GOVT SERVICE', 'DEPUTY SECRETARY', NULL, 'AB+', NULL, NULL, '5, CIRCUS HOUSE ROAD, RAMANA, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, '108, LAKE CUCUS KALABAGAN, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('hmmnpol@gmail.com', 3177, NULL, 'এমডি হুমায়ূন কবির', 'MD. HUMAYOUN KABIR', NULL, '1713111002', '924044', 'e10adc3949ba59abbe56e057f20f883e', NULL, 116, NULL, NULL, 'HD. ABDULLAH AKAND', 'LATE SURIYA AKTER', 'LIMA AKTER', '3', 'GOVT SERVICE', 'SP. PBI', NULL, 'AB-', NULL, NULL, '10-C, RAMANA POLIC COMPLEX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('syedshukurali@gmail.com', 3178, NULL, 'সৈয়দ শুকুর আলী শুভ', 'SYED SHUKUR ALI SUVO', NULL, '1552318806', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 117, NULL, '1902905148', 'SYED RUSTOM ALI', 'SYEDA SHAHIDA BEGUM', 'JABUN NAHER JANI', '2', 'JOURNALISM', 'DEPUTY CHIEF REPORTER', NULL, 'B+', NULL, NULL, 'HOUSE-94/A, MIDDLE PIRER BAG, MIRPUR, DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: PATGATI, POST: PATGATI, UPAZILA: TUNGIPARA, DIST: GOPALGANJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mahfuzsujan@gmail.com', 3179, NULL, 'মুহাম্মদ মাহফুজুর রহমান', 'MOHAMMAD MAHFUZUR RAHMAN ', NULL, '17473332221', '921087', 'e10adc3949ba59abbe56e057f20f883e', NULL, 118, NULL, NULL, 'MOHAMMAD MATIUR RAHMAN', 'RASHIDA BEGUM', 'FARHANA ALAM', '2', 'SVP, CITY BANK', NULL, NULL, 'B+', NULL, NULL, 'C-4, RASHID VILLA, 31/A, NEW ESKATON, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, '78, SHARAT GUPTA ROAD, NARINDA, DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('maksudursohel@gmail.com', 3180, NULL, 'ডঃ মাকসুদুর রহমান', 'DR. MAKSUDUR RAHMAN', NULL, '1711892403', '926081', 'e10adc3949ba59abbe56e057f20f883e', NULL, 119, NULL, '1.97427E+16', 'MD MATIAR RAHMAN', 'MRS MARJINA RAHMAN', 'DR. SOFIA AKHTER', '2', 'DOCTOR', 'PEDIATRICS', NULL, 'A+', NULL, NULL, 'FLAT-AB/5, HOUSE-45, LAKE DEI ROAD, SECTOR-7, UTTARA-1230', NULL, NULL, NULL, NULL, NULL, NULL, 'FLAT-AB/5, HOUSE-45, LAKE DEI ROAD, SECTOR-7, UTTARA-1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zhr1111@gmail.com', 3181, NULL, 'জাকির হোসেন ', 'ZAKIR HOSSAIN', NULL, '71878567401', '929220', 'e10adc3949ba59abbe56e057f20f883e', NULL, 120, NULL, '2.69165E+12', 'MOHAMMAD BELAYET HOSSAIN', 'ROKEYA HOSSAIN', 'REHLA HAFIZ HIMA', '2', 'ACCOUNTANT', NULL, NULL, 'B+', NULL, NULL, '172-90, HIGHLAND A, APT-62, JAMICA, NY - 11432, USA', NULL, NULL, NULL, NULL, NULL, NULL, 'EAST ADALAT PARA, GREENROAD, TANGAIL, BANGLADESH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sghose74@hotmail.com', 3182, NULL, 'সুমন ঘোষ', 'SUMON GHOSE', NULL, '1713443058', '921088', 'e10adc3949ba59abbe56e057f20f883e', NULL, 121, NULL, '4157674575', 'SAMARESH CHANDRA GHOSE', 'INDIRA GHOSE', 'TAPATI PAUL', '2', 'SERVICE', NULL, NULL, 'A+', NULL, NULL, 'HOUSE-21, ROAD-13, SECTOR-13, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'AID ROAD, KALIBARIA, GAIBANDHA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('juwelthermax@gmail.com', 3183, NULL, 'মুহাম্মাদ মইন উদ্দিন মজুমদার ', 'MOHAMMAD MOIN UDDIN MOJUMDER (JEWEL)', NULL, '1713145350', '9240', 'e10adc3949ba59abbe56e057f20f883e', NULL, 122, NULL, '7348255816', 'MD ABDUR RASHID MOJUMDER', 'DELWARA BEGUM', 'NAWSABA RAHMAN RUHI', '4', 'TEXTILE ENGINEER', 'SENIOR GENERAL MANAGER', 'THERMAX COLOUR COTTON LTD.', 'O+', NULL, NULL, 'THERMAX GROUP FAMILY QUARTER, KANARDI, SHIBPUR, NORSINGDI', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE NO-26, ROAD-5, MANNAN BEGICHE, KONAPERA, PERADOGAIR, MATUAIL, JATREBARI', NULL, NULL, 'CHANDPUR ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zulker@braincabin.com', 3184, NULL, 'সোহেল আহমদ জুলকার ', 'SOHEL AHMED ZULKER', NULL, '17789864346', '921016', 'e10adc3949ba59abbe56e057f20f883e', NULL, 123, NULL, NULL, 'AKM SHAMSUDDIN', 'HASINA AKTHAR', 'ISRAT MEHTAZ', '1', 'SOFTWARE ', 'SOFTWARE ARCHITECT', NULL, 'A+', NULL, NULL, '1402-615, BELMONT ST, NEW WESTMINSTER, V3M6A1,BRITISH COLUMBI, CANADA', NULL, NULL, NULL, NULL, NULL, NULL, '1402-615, BELMONT ST, NEW WESTMINSTER, V3M6A1,BRITISH COLUMBI, CANADA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sthissue@gmail.com', 3185, NULL, 'তারেক হাসান খান ', 'TAREQ HASAN KHAN', NULL, '1911326464', '927076', 'e10adc3949ba59abbe56e057f20f883e', NULL, 124, NULL, '8231041719', 'ABDUS SALAM KHAN', 'HAMIDA JERIN KHAN', 'FARJANA JERIN KHAN', '1', 'PRIVATE SERVICE', 'MANAGER', NULL, 'AB+', NULL, NULL, '158,NORTH IBRAHIMPUR, MOMIN SARONY, DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, '158,NORTH IBRAHIMPUR, MOMIN SARONY, DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mrbinkamal@gmail.com', 3186, NULL, 'মুহাম্মাদ রাশেদ বিন কামাল', 'MOHAMMAD RASHED BIN KAMAL', NULL, '1914128092', '927096', 'e10adc3949ba59abbe56e057f20f883e', NULL, 125, NULL, '9561420861', 'LATE Z M KAMAL', 'MONOARA BEGUM', 'AFROJA BEGUM', '2', 'MARINE OFFICER', 'CAPTAIN', NULL, 'A+', NULL, NULL, 'HOUSE-116, FLAT-A/5, GREEN EMERALD, ROAD #9A, DHANMONDI', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE-116, FLAT-A/5, GREEN EMERALD, ROAD #9A, DHANMONDI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ashiq25bd@yahoo.com', 3187, NULL, 'আশিক মাহমুদ খান', 'ASHIQ MAHMOOD KHAN', NULL, '4.91767E+12', '9240', 'e10adc3949ba59abbe56e057f20f883e', NULL, 126, NULL, NULL, 'ABU ZAFAR KHAN', 'ARFA KHANAM', 'TASNUVA NASRIN', '1', 'ARCHITECT', NULL, NULL, NULL, NULL, NULL, 'HOLLANDWEG-19, 25421, PINNEBERG, GERMANY', NULL, NULL, NULL, NULL, NULL, NULL, 'HOLLANDWEG-19, 25421, PINNEBERG, GERMANY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('hanurrrashosagar74@gmail.com', 3188, NULL, 'ডঃ হারুন অর রাশিদ সাগর ', 'DR. HARUN OR RASHID SAGAR', NULL, '1727236101', '924105', 'e10adc3949ba59abbe56e057f20f883e', NULL, 127, NULL, '1.31451E+12', 'LATE MOHAMMAD KALIM ULLAH', 'MRS LUTFUNNAHAR', 'MRS HANI HAKIM', '2', 'PHYSICIAN', 'DIRECTOR', NULL, 'B+', NULL, NULL, 'FLAT-3/B,ST-205,ROAD-06, BLOCK-B, BASHUNDHARA R/A', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL:MADANERGOW, P.O:CHAWDRA, P.S-FARIDGONJ, DIST-CHANDRA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('reazimam@safiaappmels.com', 3189, NULL, 'রিয়াজ তৌফিক ইমাম', 'REAZ TOWFIQ IMAM', NULL, '1917042859', '928104', 'e10adc3949ba59abbe56e057f20f883e', NULL, 128, NULL, NULL, 'LATE SALAH UDDIN AHMED', 'HASINA BEGUM', 'HAUIDA AKTHER', '2', 'BUSINESS', 'CHAIRMAN', NULL, 'B+', NULL, NULL, '18/19 GARDEN ROAD. KAWRAN BAZAR, DHAKA, FLAT-D-303', NULL, NULL, NULL, NULL, NULL, NULL, '18/19 GARDEN ROAD. KAWRAN BAZAR, DHAKA, FLAT-D-303', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1716191504', 3190, NULL, 'ডঃ আশিস কুমার ঘোষ', 'DR. ASHISH KUMAR GHOSH', NULL, '1716191504', '926029', 'e10adc3949ba59abbe56e057f20f883e', NULL, 129, NULL, '5.91941E+12', 'GURU DAS GHOSH', 'DAYA GHOSH', 'DR. SOMITA RANI SARKER', '2', 'PHYSICIAN', 'M.B.B.S', NULL, 'O+', NULL, NULL, '43/44, KULUTOLA,KATHERPUL, SUTRAPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL+P.O: ABDULLAPUR, P.B -TONGIBARI, DIST- MUNSHIGONJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('obaidulhm@gmail.com', 3191, NULL, 'মোহাম্মদ ওবায়দুল হক মাহমুদ', 'MUHAMMAD OBAIDUL HAQUE MAHMUD', NULL, '01715 842815', '923026', 'e10adc3949ba59abbe56e057f20f883e', NULL, 130, NULL, '7339290657', 'MUHAMMAD ABDUL WAHED', 'MEHERUNNESA', 'FATEMA KHATUN', '2', 'PRIVATE SERVICE', 'DEPUTY GENERAL MANAGER', 'MIR CONCRETE PRODUCTS LTD.', 'A+', NULL, NULL, 'HOUSE # B-147, ROAD # 22, D.O.H.S. MOHAKHALI, DHAKA 1206', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE # J-11/1, COLLEGE ROAD, BANK COLONY, SAVAR, DHAKA 1340', NULL, NULL, 'DHAKA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('927033', 3192, NULL, 'শাহ আব্দুল তারিক', 'SHAH ABDUL TARIQUE', NULL, NULL, '927033', 'e10adc3949ba59abbe56e057f20f883e', NULL, 131, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('eakhwanimpex@yahoo.com', 3193, NULL, 'মোহাম্মদ নাজিম ', 'MOHAMMED NAZIM', NULL, '1920302030', '929004', 'e10adc3949ba59abbe56e057f20f883e', NULL, 132, NULL, NULL, 'LATE HAZI ABDUL HAI', 'KAUSARI BEGUM', 'SHAHINA NAZIM', '2', 'BUSINESS', NULL, NULL, 'A+', NULL, NULL, 'NAZIM & BROTHER\'S 6/7 JUMRAIL LEN, ARMANI TOLA, DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, '4/1 JINDABAHAR 2LANE, DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('javaalsikder@meghnagroup.biz', 3194, NULL, 'এমডি সাহ জামাল সিকদার', 'MD. SHAH JAMAL SIKDER', NULL, '1709657490', '925056', 'e10adc3949ba59abbe56e057f20f883e', NULL, 133, NULL, '4191844853', 'MD.SHAH JAHAN SIKDER', 'NUR JAHAN BEGUM', 'SHAKILA JAHAN', '4', 'SERVICE', 'SENIOR GENERAL MANAGER', NULL, 'O+', NULL, NULL, 'FLAT-4/A, HOUSE- 5/B, NEW CIRCULAR ROAD , MOGHBAZAR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, 'DOPA BARI ROAD, MASIMOUR, PIRISPUR-8500', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('abbujan@gmail.com', 3195, NULL, 'মুহাম্মদ মমুন অর রাশিদ ', 'MOHAMMAD MAMUN AR RASHID', NULL, '1730087208', '923008', 'e10adc3949ba59abbe56e057f20f883e', NULL, 134, NULL, NULL, 'MOHAMMAD ABU MUSA', 'SURAIYA BEGUM', 'SHAIFUN NAHAR LINA', '1', 'PRIVATE SERVICE', 'HR MANAGER', NULL, 'O+', NULL, NULL, 'FLAT 4-B, HOUSE76, ROAD-19, SECTOR14, UTTARA, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, '38 EAST BOKSHA NAGAR, MAIN ROAD, WARD 3, SANULIA, DEMRA, DHAKA-1361', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('boshirul.haque74@gmail.com', 3196, NULL, 'বশিরুল হক ', 'BOSHIRUL HAQUE', NULL, '1674386054', '925045', 'e10adc3949ba59abbe56e057f20f883e', NULL, 135, NULL, '6867580547', 'SERAJUL HAQUE', 'JAEDA BEGUM', 'PEHANA PARVIN', '3', 'SERVICE', 'SAUP', NULL, 'A+', NULL, NULL, '33/K-4, 33/KHG, MAYAKANON, SABIJBAGH, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-LOUCHONPUR, P.O-BAKHARNAGAR,BAZAR, P.S-RAIPURA, DIST-NARSINGDI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('r_faizur1@yahoo.com', 3197, NULL, 'একে এম ফয়জুর রহমান ', 'AKM FAIZUR RAHMAN', NULL, '1911367920', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 136, NULL, NULL, 'MD AMBAR ALI', 'MRS FATEMA BEGUM', 'SYEDA RIZWANA BEGUM', '2', 'BUSINESS', 'OWNER', NULL, 'O+', NULL, NULL, '5, SIDDHESWARI, BUILDING, ANONNA, FLAT -121B,MOUCHAK, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '5, SIDDHESWARI, BUILDING, ANONNA, FLAT -121B,MOUCHAK, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('926049', 3198, NULL, 'মোহাম্মদ মাজেদুল হক', 'MOHAMMED MAZEDUL HAQUE', NULL, '926049', '926049', 'e10adc3949ba59abbe56e057f20f883e', NULL, 137, NULL, ' ', 'MD FAZLUL HAQUE', 'MSTNURJAHAN BEGUM', NULL, NULL, 'SERVICE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-KASIMA, P.O-GILABARI, P.S-ISLAMPUR, DIST-JAMALPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('srsazu@gmail.com', 3199, NULL, 'মহাম্মদ সাজ্জাদ হোসেন', 'MOHAMMAD SAZZAD HOSSAIN', NULL, '1711181109', '928', 'e10adc3949ba59abbe56e057f20f883e', NULL, 138, NULL, '2.69544E+12', 'MD. TAMIZ UDDIN', 'SHAMSUN NAHAR', 'TANVIA ROSELIN SULTANA', '2', 'JOURNALISM', 'NEWS EDITOR', NULL, 'B+', NULL, NULL, '32/9/7, SHAH ALI LANE, SULTANGANJ, RAYER BAZAR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '85/K/1, KB ISMAIL ROAD, BOLASHPUR, MYMENSINGH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('badrul_um@yahoo.com', 3200, NULL, 'খন্দকার বদরুল আলম ', 'KHANDAKAR BADRUL ALAM', NULL, '1879830255', '927052', 'e10adc3949ba59abbe56e057f20f883e', NULL, 139, NULL, NULL, 'KHAUDALLAR ABDUL QUADER', 'MRS HAFIZA KHATUN', 'MRS NAJMUN NAHER', '0', 'PRIVATE SERVICE', 'MANAGER', NULL, 'A+', NULL, NULL, '440, ASHKONA, MOSID ROAD, (3RD FLOOR)  ASHIIONA, DALLHSHI KHAN,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'ISLAMPUR BAZAR JAMU MOSJID ROAD, ISLAMPUR. LAMAL PUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ashishsarker@gmail.com', 3201, NULL, 'আশিস কুমার সরকার', 'ASHISH KUMAR SARKER', NULL, '1714329191', '924095', 'e10adc3949ba59abbe56e057f20f883e', NULL, 140, NULL, '5083842673', 'JITENDRA CHANDRA SARKER', 'BINA RANI SARKER', 'SANCHITA RANI SRKER', '1', 'BUSINESS', 'MANAGING DIRECTOR', NULL, 'A+', NULL, NULL, '148/1 B, MADHU BAZAR, WAST DHANMONDI, ROAD NO 19, DHAKA-1209', NULL, NULL, NULL, NULL, NULL, NULL, 'JHANJAIL BAZAR, JASIR JHANJALI NETTROKONA-2412', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('Khokoncom@gmail.Com', 3202, NULL, 'আতাউর রহমান খোকন', 'ATAUR RAHMAN KHOKON', NULL, '01817 036561', '921093', 'e10adc3949ba59abbe56e057f20f883e', NULL, 141, NULL, NULL, 'MOHAMMED HAFIZULLAH', 'KHURSHIDA BEGUM', 'KASMERY NOOR BOBY', '2', 'BSC ENGINEER IN TESTILE (BUTEX)', 'GENERAL MANAGER', 'NORTHERN TOSRIFA GROUP', 'B+', NULL, NULL, '21, NARINDA LANE, DHAKA-1210', NULL, NULL, NULL, NULL, NULL, NULL, '21, NARINDA LANE, DHAKA-1210', NULL, NULL, 'DHAKA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tikzhasan@yahoo.com', 3203, NULL, 'শেখ মুহাম্মাদ মাহমুদুল হাসান ', 'SHEIK MUHAMMAD MAHMUDUL HASAN', NULL, '1711378327', '929228', 'e10adc3949ba59abbe56e057f20f883e', NULL, 142, NULL, NULL, 'LATE MD. JALAL UDDIN', 'MRS HASNAHENA', 'KAMRUN NAHAR', '0', 'ACCOUNTANT', 'G.M', NULL, 'A+', NULL, NULL, 'H# 33, R# 8, SECTOR-3, UTTARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'H# 33, R# 8, SECTOR-3, UTTARA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('atiqzaman25121975@gmail.com', 3204, NULL, 'জি এম আতিকুজ্জামান', 'G.M. ATIQUZZAMAN', NULL, '1756221091', '928309', 'e10adc3949ba59abbe56e057f20f883e', NULL, 143, NULL, '6.71588E+12', 'MD.ABDUS SOBHAN GAZI', 'MEHER NIGAR SULTANA', 'SABIHA NUSRAT', '2', 'SERVICE', 'SENIOR MANAGER', NULL, 'O+', NULL, NULL, '47, SHANTIDHARA, ROAD-5, SIGHBOARAD, NARAYANGONJ BISHWA ROAD', NULL, NULL, NULL, NULL, NULL, NULL, '47, SHANTIDHARA, ROAD-5, SIGHBOARAD, NARAYANGONJ BISHWA ROAD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('nazmul.haq@bb.org.bd', 3205, NULL, 'মুহাম্মদ নাজমুল হক ', 'MUHAMMAD NAZMUL HAQUE', NULL, '1816741409', '924050', 'e10adc3949ba59abbe56e057f20f883e', NULL, 144, NULL, NULL, 'MUHAMMAD NURUL HAQUE', 'JOYMAT NESSA', 'AFROZA BEGUM', '2', 'SERVICE', 'JOINT DIRECTOR', NULL, 'O+', NULL, NULL, 'FLAT-KA-2, BBTAQUATER MIRPUR-2. DHAKA-1216', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-PO-KURSHI PARA, UPAZILLA-ISWARGONJ, DIST-MAYMANSHING', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('nasiddiqui.bpdb@gmail.com', 3206, NULL, 'নূর আলম সিদ্দিকী ', 'NOORE ALAM SIDDIQUI', NULL, '01710 797615', '923067', 'e10adc3949ba59abbe56e057f20f883e', NULL, 145, NULL, '2.6964E+12', 'SIDDIQUL ISLAM', 'REHANA SIDDIQUE', 'MST. MARUFA SULTANA', '2', 'SERVICE', 'EXECUTI ENGINEER', 'BANGLADESH POWER DELOPMENT BOARD', 'B+', NULL, NULL, 'H#CHOLTALI, FLAT-301,PDB OFFICERS, QUARTER, 1 SOUTH MUGDA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'C/O- SIDDIQUL ISLAM, POST- PAKSHI. P.S- ISHWARDI, DIST-PABNA', NULL, NULL, 'PABNA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('m.asarker@yahoo.com', 3207, NULL, 'মোহাম্মদ আলী সরকার', 'MOHAMMAD ALI SARKER', NULL, '1720025559', '928318', 'e10adc3949ba59abbe56e057f20f883e', NULL, 146, NULL, '6895473343', 'ABDUL HAI SARKER', 'RASHIDA BEGUM', 'SAEMA SULTANA', '0', 'GOVT SERVICE', 'DEPUTY DIRECTOR', NULL, 'A+', NULL, NULL, 'B-5/9 BAILYSQUARE OFFICERS QUARTER BAILY ROAD, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, '117, SHANTIBAGH, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('bsrimunir@yahoo.com', 3208, NULL, 'এমডি মনির হোসেন', 'MD. MUNIR HOSSAIN ', NULL, '1711846853', '925082', 'e10adc3949ba59abbe56e057f20f883e', NULL, 147, NULL, '1.97576E+16', 'LATE ABDUL GHANI', 'MRS. ZAHURA KHANAM', 'MRS. NURZAHAN BEGUM', '2', 'GOVT SERVICE', 'SSO', NULL, 'O+', NULL, NULL, 'BANGLADESH SUGAR CROP RESEARCH INS. POST - ISHWARDI, PS-ISHWARDI, DIST -PABNA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-RAHAMAN COLONY, POST-ISHWARDI,DIST-PABNA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('anisur.rahman38@gmail.com', 3209, NULL, 'মুহাম্মদ আনিসুর রহমান ', 'MOHAMMAD ANISUR RAHMAN', NULL, '1918901389', '928317', 'e10adc3949ba59abbe56e057f20f883e', NULL, 148, NULL, '1.97526E+16', 'MOHAMMUD ANSAR UDDIAN', 'LATE SHAHANARA BEGUM', 'SHAHANA AKTER MUKTI', '2', 'POLICE', 'S.P', NULL, 'A+', NULL, NULL, '1-2 TEJTURI BAZAR, FARMGATE, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-RATNOPUR, P.O- AGAILJHARA, DIST-BARISAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tomal14bd@yahoo.com', 3210, NULL, 'শরীফ আহমেদ সাইফ', 'SHARIF AHMED SAIF', NULL, '1710971997', '923066', 'e10adc3949ba59abbe56e057f20f883e', NULL, 149, NULL, '2.69665E+12', 'SAIFUDDIN AHMED', 'MAHMUDA SAIF', 'NUSRAT ALAM', '1', 'MECHANICAL ENGINEER', 'MANAGE- MECHANICAL ENGG', NULL, 'A+', NULL, NULL, '160, BARA MOGH BAZAR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, '160, BARA MOGH BAZAR, DHAKA-1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('abdulgofur068877@gmail.com', 3211, NULL, 'ডঃ আব্দুল গফুর', 'DR. ABDUL GOFUR', NULL, '01714 068877', '926041', 'e10adc3949ba59abbe56e057f20f883e', NULL, 150, NULL, '5.61281E+12', 'LATE MD ARSHED ALI', 'MRS. LALJAN BEGUM', 'DR. HASINA MOMTAJ', '2', 'DENTISTRY', 'ASSISTANT PROFESSOR', 'SYLHET MAG OSMANI MEDICAL COLLEGE', 'O+', NULL, NULL, '1311, KA K.M DAS LANE, GOLAPBAG, DHAKA-1203', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-JOGATIER, P.O- MALUCHI, T.O-HARIRAMPUR, DIST -MANIKGONJ', NULL, NULL, 'MANIKGONJ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('jahid.13s@hotmail.com', 3212, NULL, 'এমডি জাহিদুল ইসলাম খান', 'MD. JAHIDUL ISLAM KHAN', NULL, '01711 167134', '922017', 'e10adc3949ba59abbe56e057f20f883e', NULL, 151, NULL, '2.69481E+12', 'ABDUL JABBAR KHAN', 'JOHRA BEGUM', 'JANNATUL FERDOUS', '1', 'GOVT. SERVICE', 'EXECUTI ENGINEER', 'PUBLIC WORKS DEPARTMENT (PWD)', 'A-', NULL, NULL, 'FLAT-4, HOUSE-2, PWD OFFICERS QUARTER, DHANMONDI, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HAZI AHMED ALI ROAD,VILL-MASUMPUR, THANA-SIRAJGONJ, DIST-SIRAJGONJ', NULL, NULL, 'SIRAJGONJ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('babujhuma92@gmail.com', 3213, NULL, 'এমডি মাহফুজুর রহমান', 'MD. MAHFUZER RAHMAN', NULL, '1711125214', '922111', 'e10adc3949ba59abbe56e057f20f883e', NULL, 152, NULL, '1012865216', 'MD MOKBULAR RAHMAN', 'LATE MASTUR RAIHAMA', 'SURAIYA AKTER', '1', 'GOVT SERVICE', 'LIEUTENANT COLLONEL', NULL, 'O+', NULL, NULL, 'HOUSE- 1090, ROAD-6A, A-8, MIRPUR DOSH', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-DAVID COMPANY PARA P.O & DIST GAIBANDHA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('noorsayeed29@gmail.com', 3214, NULL, 'নূর মাসুদ হাসান ', 'NOOR MASUD HASSAN', NULL, '1718270076', '923111', 'e10adc3949ba59abbe56e057f20f883e', NULL, 153, NULL, NULL, 'NURUL HAQUE KHAN', 'MONOWARA BEGUM', 'JANNATUL FERDOUS', '1', 'BUSINESS', NULL, NULL, 'B+', NULL, NULL, '97/5 SHANTINAGAR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '97/5 SHANTINAGAR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1717147011', 3215, NULL, 'মুফতার আহমেদ সোহাগ', 'MOFTER AHMED SOHAG', NULL, '1717147011', '928103', 'e10adc3949ba59abbe56e057f20f883e', NULL, 154, NULL, '1.92671E+12', 'MOSTAQ AHMED', 'LATE AKTER JAHAN', 'SHAH RUHILA MAHBUB MISHU', '2', 'LAWYER', NULL, NULL, NULL, NULL, NULL, '316 NORTH CHARTHA, SADAR, COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, '316 NORTH CHARTHA, SADAR, COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('hasandhali@gmail.com', 3216, NULL, 'এস এম হাসানুল ইসলাম ঢালি', 'SM HASHANUL ISLAM DHALI', NULL, '1780177282', '929083', 'e10adc3949ba59abbe56e057f20f883e', NULL, 155, NULL, '1.97427E+16', 'MD. NAZRUL ISLAM DHALI', 'MRS. HALIMA ISLAM', 'SHEULY AKTER', '2', 'PRIVATE JOB', 'FINANCIAL ADNSER', NULL, 'O+', NULL, NULL, '1/A NORTH MASARTAKE, P.S- SOBUJBAG, P.O- BASABO, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, '1/A NORTH MASARTAKE, P.S- SOBUJBAG, P.O- BASABO, DHAKA-1214', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('oe74@yahoo.com', 3217, NULL, 'ফজলে ইলাহী চৌধুরী ওভী ', 'FAZLE ELAHI CHOWDHURY OE', NULL, '17122958851', '925081', 'e10adc3949ba59abbe56e057f20f883e', NULL, 156, NULL, '1.97859E+16', 'HUMAYAN KABIR ', 'MAHBUBA KHATUN', 'JHUMUR AHMED', '2', 'TEACHING', 'ASS. PROFESSOR', NULL, 'B+', NULL, NULL, '34-36 NANDALAL DATTA LANE , FLAT- 2B, DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL & POST-MAZIDPUR DOYHATA , P.S- SREENAGAR, DIST-MUNSHIGANJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shawonfcma@gmail.com', 3218, NULL, 'এস এম শাওন মাহমুদ', 'S M SHAWON MAHMUD', NULL, NULL, '925078', 'e10adc3949ba59abbe56e057f20f883e', NULL, 157, NULL, NULL, 'S M NURUNNABI', 'MAHMUDA BEGUM', 'MST. SAFINUS SULTANA', '2', 'FCMA', 'CFO', NULL, NULL, NULL, NULL, 'RUPAYAN Z.A TOWER, F#6, 115, SHANTINAGAR  DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VAID ROAD LIAIBANDHA-5700', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sayed13143@gmail.com', 3219, NULL, 'মুহাম্মদ সাঈদ আলী', 'Md. Sayed Ali', NULL, '-9583991', '925023', 'e10adc3949ba59abbe56e057f20f883e', NULL, 158, NULL, '1.97584E+16', 'Md. Nurul Islam', 'Mrs. Anwara Islam', 'Mrs Jebunnesa Akter', '2', 'Gornment Service', 'Deputy Secretary', NULL, 'B+', NULL, NULL, 'Deputy Secretary, Ministry of Youth and Sports, Building# 7, Room#514, Bangladesh Secretariat, Dhaka', NULL, NULL, NULL, NULL, NULL, NULL, 'Village: Singjuri, Post: Bhatgram, Upazila: Mirzapur, District: Tangail', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shamim77bd@yahoo.com', 3220, NULL, 'এস এম শাহীদুল আলম', 'S.M SHAHIDUL ALAM', NULL, '01711 955990', '926032', 'e10adc3949ba59abbe56e057f20f883e', NULL, 159, NULL, '9.3198E+12', 'MD. HAFIZUR RAHMAN ', 'MOST. AYESHA BEGUM', 'ANISA AKHTER', '2', 'GOVT. SERVICE', 'SUPERINTENDING ENGINEER', 'BADC', 'B+', NULL, NULL, 'BADC SECH BHABAN, TALTOLA, BANANI, BOGURA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-GILABARI, PO-SUNNA, UPAZILA-BASHAIL, DIST-TANGAIL', NULL, NULL, 'TANGAIL', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mokammelh@gmail.com', 3221, NULL, 'এ কে এম মোকাম্মেল হক ', 'A. K. M. MOKAMMEL HAQUE (SUJAN)', NULL, '1521313989', '927039', 'e10adc3949ba59abbe56e057f20f883e', NULL, 160, NULL, '2.69165E+12', 'A. K. M. NURUL HAQUE', 'ASHRAFUN NESSA', 'MOSS. RINE AKTER', '1', 'SERVICE', 'M & E MANAGER ', NULL, 'B+', NULL, NULL, 'APT NO-10H, CONCORD EMPORLL-253, ELEPHENT ROAD, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'P.O+P.S-NALITALARI, DIST, SHAPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('saifulpr@yahoo.com', 3222, NULL, 'মুহাম্মদ সাইফুল ইসলাম', 'MOHAMMAD SAIFUL ISLAM', NULL, '01959 920019', '923092', 'e10adc3949ba59abbe56e057f20f883e', NULL, 161, NULL, NULL, 'MOHAMMAD NAZIM UDDIN', 'MS. SALEHA AKTHER', 'RASHEDA PARVIN', '3', 'SERVICE', 'GENERAL MANAGER', 'ARISTOPHARMA LTD.', 'AB+', NULL, NULL, 'H#33, R# 04, SECTOR-12, UTTARA. DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-GILABARI, PO-SUNNA, UPAZILA-BASHAIL, DIST-TANGAIL', NULL, NULL, 'TANGAIL', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000');
INSERT INTO `all_info_together` (`email`, `id`, `full_name`, `name_bangla`, `first_name`, `last_name`, `mobile`, `institution_id`, `password`, `registration_date`, `membership_number`, `gender`, `nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `date_of_birth`, `religion`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `second_citizenship_country`, `otp`, `forgot_password_crypto`, `status`, `email_verification_status`, `change_request`, `change_request_time`, `type`, `visibility`, `completeness`, `recent_photo`, `old_photo`, `timestamp`, `membership_fee`) VALUES
('mogaronkdnlsl@gmail.com', 3223, NULL, 'ডঃ মোঃ মোবারক হোসেন', 'DR.MD. MOBARAK HOSSAIN', NULL, '1552329511', '922036', 'e10adc3949ba59abbe56e057f20f883e', NULL, 162, NULL, NULL, 'ABDUL GOFUR', 'FIROZA BEGUM', 'DR. KAMRUNEHER', '0', 'PHYSICIAN', 'CONSULTANT', NULL, 'A-', NULL, NULL, 'KARIM TOWER, S.S.K ROAD, FENNI', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-MADDHAM KACHAR, P.O- MD. ALI, BAZAR, FENNI SADAR, FENNI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('aminulm30@gmail.com', 3224, NULL, 'ডাঃ মোহাম্মদ আমিনুল ইসলাম', 'DR. MOHAMMAD AMINUL ISLAM', NULL, '1711207365', '923085', 'e10adc3949ba59abbe56e057f20f883e', NULL, 163, NULL, '1.97461E+16', 'MD. NURUL ISLAM', 'MRS. AMBIA KHATUN', 'SHAHANAJ AKTAR', '2', 'DOCTOR', 'UROLOGIST', NULL, 'A+', NULL, NULL, 'FLAT-8/E, TAIMUR EXCEL TOWER, 82/A, GANGA DAS GHOHA ROAD, TOWN HALL, MAYMANSHING', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-DHIP-PAGLA, POST- +T-PAGLA,DIST-MAYMANSH-INGH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mushfiq@thakral-bd.com', 3225, NULL, 'মুহাম্মদ মুশফিকুর রহমান', 'MOHAMMAD MUSHFIQUR RAHMAN', NULL, '01713 092434', '923079', 'e10adc3949ba59abbe56e057f20f883e', NULL, 164, NULL, '3282476682', 'ASHEQUR RAHMAN', 'MONOWARA BEGUM', 'HASINA AKTHER', '2', 'PRIVATE SERVICE', 'DEPUTY GENERAL MANAGER', 'TRUST SOLUTIONS PRIVATE LIMITED', 'O+', NULL, NULL, 'H#311 2ND FLOOR, ULON ROAD, WEST RAMPURA, DHAKA-1219', NULL, NULL, NULL, NULL, NULL, NULL, 'H#311 2ND FLOOR, ULON ROAD, WEST RAMPURA, DHAKA-1219', NULL, NULL, 'CHANDPUR ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('asad.goldsmiths@gmail.com', 3226, NULL, 'এ এস এম আসাদুজ্জামান', 'A.S.M ASADUZZAMAN', NULL, '1985890157', '927013', 'e10adc3949ba59abbe56e057f20f883e', NULL, 165, NULL, NULL, 'MOHAMMAD ABDUL AZIZ', 'MUKTARA AZIZ', 'MEHNAZ TABASSUM MONA', '1', 'TEACHING', 'ASSOCIATE PROFESSOR ', 'DHAKA UNIRSITY', 'AB+', NULL, NULL, 'F# 6A, H#5/7, BLOCK-A, LALMATIA, MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, 'F# 6A, H#5/7, BLOCK-A, LALMATIA, MOHAMMADPUR, DHAKA-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zaman.shams@yahoo.com', 3227, NULL, NULL, 'A.A.M.M. SHAMSUZZAMAN (SHAMS)', NULL, '1713004646', '921065', 'e10adc3949ba59abbe56e057f20f883e', NULL, 166, NULL, NULL, 'S. M. A. MANNAN', 'SHAMSUNNAHAR MANNAN', 'DR. SURAIA NASRIN', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '200'),
('awbariuk@yahoo.com', 3228, NULL, NULL, 'AHMED WASIMUL BARI', NULL, '0064220 964667', '922013', 'e10adc3949ba59abbe56e057f20f883e', NULL, 167, NULL, NULL, 'FAIZUL BARI', 'SALEHA BEGUM', 'AZREEN KARIM', '1', 'LIFE COACH, IMAGE CONSULTANT, AGRO BUSINESS', 'FOUNDER, MD AND CEO', 'WSDA NEW ZEALAND LTD.; WSDA ASIA PACIFIC LTD, 4TH IR AGRO', 'O+', NULL, NULL, 'H # 46, R # 12, BARI VILLA, SHAKERTAK, MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, 'H # 46, R # 12, BARI VILLA, SHAKERTAK, MOHAMMADPUR, DHAKA-1207', NULL, NULL, 'NOAKHALI', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ruponroy@gmail.com', 3229, NULL, NULL, 'RUPON ROY', NULL, '61401296119', '929224', 'e10adc3949ba59abbe56e057f20f883e', NULL, 168, NULL, NULL, 'SAMIR ROY', 'AVA ROY', NULL, '2', 'FINANCE', 'COMMERCIAL FIN. MANAGER', NULL, 'A+', NULL, NULL, '4110-16 PARKES ROAD, ARTARMON, NSW - 2064, AUSTRALIA', NULL, NULL, NULL, NULL, NULL, NULL, '41 ZILLA SCHOOL ROAD, MYMENSINGH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('929072', 3230, NULL, 'টি এম মোজাহিদুল ইসলাম', 'T M MOZAHEDUL ISLAM', NULL, NULL, '929072', 'e10adc3949ba59abbe56e057f20f883e', NULL, 169, NULL, NULL, 'MOHAMMAD SHARAFAT ULLAH', 'MOBASHAWRA BEGUM', 'FARjANA MOZAHED', '2', 'GOVT. SERVICE', 'SUPERINDENT OF POLLICE', NULL, 'A+', NULL, NULL, 'HOUSE NO-124 ,ROAD NO-7 , BLOCK-D ,BASHUNDHARA R/A, DHAKA (4TH FLOOR)', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE NO-124 ,ROAD NO-7 , BLOCK-D ,BASHUNDHARA R/A, DHAKA (4TH FLOOR)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('SAROJKNATH@YAHOO.COM', 3231, NULL, 'সরোজ কুমার নাথ', 'SAROJ KUMAR NATH', NULL, '1714107912', '928110', 'e10adc3949ba59abbe56e057f20f883e', NULL, 170, NULL, NULL, 'HARINARAYAN NATH', 'SABITA NATH', 'SHYAMOLI RANI NATH', '2', 'SERVICE ', 'DEPUTY SECRETERY', NULL, 'B+', NULL, NULL, '92 GOVT. OFFICER\'S QUARTERS AZIMPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'PATARHAT, MEHENDIGONJ, BARISHAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ahadadmn@gmail.com', 3232, NULL, 'মোহাম্মদ আবদুল আহাদ', 'MOHAMMAD ABDUL AHAD', NULL, '1703505030', '922032', 'e10adc3949ba59abbe56e057f20f883e', NULL, 171, NULL, '197591411800723', 'MD. MONSER ALI MONDAL', 'MOFIZAN BEGUM', 'NAHID AFROZ SULTANA', '1', 'SERVICE', 'DCC DEPUTY COMMISSIONER', NULL, NULL, NULL, NULL, 'OFFICE OF DEPUTY COMMISSIONER, SUNAMGANJ', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: HAZRAPUKUR, PS: MOHADEVPUR, DIST: NAOGAON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('samad359292@gmail.com', 3233, NULL, 'ডাঃআব্দুস সামাদ আজাদ ', 'DR. ABDUS SAMAD AZAD', NULL, '01711353592 ; 01742917270', '923020', 'e10adc3949ba59abbe56e057f20f883e', NULL, 172, NULL, '6826011655249', 'LATE MD DABIR UDDIN BHUIYAN', 'LATE SAHERA KHATUN', 'DR. ZOHRA KHATUN MINU', '2', 'SERVICE ,', 'CARDIOLOGIST', NULL, 'o+', NULL, NULL, '14/10, IQBAL ROAD ,FLAT #8A ,MOHAMMADPUR,DHAKA -1207', NULL, NULL, NULL, NULL, NULL, NULL, '14/10, IQBAL ROAD ,FLAT #8A ,MOHAMMADPUR,DHAKA -1207', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('litongomes51@gmail.com', 3234, NULL, 'লিটন গমেজ', 'LITON GOMES', NULL, '1819224920', '929036', 'e10adc3949ba59abbe56e057f20f883e', NULL, 173, NULL, '478524364', 'LATE PATRICK GOMES', 'JOANNA GOMES', 'SONGITA GREGORY', '2', 'BUSINESS', 'PROPRIETOR', NULL, 'AB+', NULL, NULL, '154/1,3- B MONIPURI PARA,TEJGOAN ,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'CHANDIPUR,JONAIL ,BORAI GRAM ,NATORE ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1839979152', 3235, NULL, 'মোহাম্মদ খাইরুল কবীর মজুমদার দুলাল', 'MOHAMMAD KHAIRUL KABIR MAZUMDER DULAL', NULL, '0178111252, 01839979152', '929033', 'e10adc3949ba59abbe56e057f20f883e', NULL, 174, NULL, '8229845493', 'LATE MD ATAUR RAHMAN MAZUMDER', 'LATE SAJEDA BEGUM MAZUMDER', 'MST. AYESHA AKTER MAZUMDER', '3', 'PRIVATE SERVICE', 'HEAD OF SALES', NULL, 'A+\r\n', NULL, NULL, 'A.K POULTRY & HATCHERY LTD,HASHEM MANSION,JUBLEE ROAD_BASURHAT,COMPANIGONJ,COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-SATBARIA,P.O-KADOIR BAZAR,P.S-CHOUDDAGRAM,DIST-COMILLA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('8.8182E+12', 3236, NULL, 'মোহাম্মদ জহিরুল কাইউম (পাভেল)', 'MOHAMMAD JAHIRUL QUAYUM (PAL)', NULL, '8801819254099, 32466194705  8801819254099', '921083', 'e10adc3949ba59abbe56e057f20f883e', NULL, 175, NULL, NULL, 'ABDUL QUAYUM', 'NARGIS AKHTER', 'REBECCA QUYAYUM', '2', 'GOVT SERVICE', 'DEPUTY SECRETARY', 'BANGLADESH EMBASSY, BRUSSELS', 'B+', NULL, NULL, 'HOUSE 26/C, ROAD 20, SECTOR 03, UTTARA, DHAKA 1230', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE 26/C, ROAD 20, SECTOR 03, UTTARA, DHAKA 1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tansif@hotmail.com', 3237, NULL, 'মোহাম্মদ তানসিফ দানেশ ', 'MUHAMMED TANSIF DANESH', NULL, '1713032634', '925034', 'e10adc3949ba59abbe56e057f20f883e', NULL, 176, NULL, NULL, 'MUHAMMED FARUQUE DANESH', 'HENA SAMSUN NAHAR', 'DILSHAD ARA', '2', 'PRIVATE JOB', 'MANAGER- ADMIN', 'ANANTA COMPANIES', 'B+', NULL, NULL, 'HOUSE: 26,(3RD FLOOR), ROAD: 12, SECTOR: 13, UTTARA, DHAKA-1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DINAJPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('hmshah76@yahoo.com', 3238, NULL, NULL, 'ENGR. MOHAMMAD SHAHADAT HOSSAIN', NULL, '1711238919', '921042', 'e10adc3949ba59abbe56e057f20f883e', NULL, 177, NULL, '5957883662', 'Mohammad Mojibur Rahman', 'Jamila Begum', 'Rubaya Nahar Chowdhury', '2', 'Engineer', 'Manager', NULL, 'O+', NULL, NULL, '61, Jalal Uddin Sarani, South Ajampur, Ajampur, Dakshin Khan, Dhaka-1230', NULL, NULL, NULL, NULL, NULL, NULL, '61, Jalal Uddin Sarani, South Ajampur, Ajampur, Dakshin Khan, Dhaka-1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('928', 3239, NULL, 'রনজিত চন্দ্র সাহা\r\n', 'SAHA RANJIT CHANDRA', NULL, NULL, '928', 'e10adc3949ba59abbe56e057f20f883e', NULL, 178, NULL, NULL, 'LATE CHETON NATH SAHA', 'KIRON BALA SAHA', 'SANTRI ROY', '3', 'LEGAL', 'CEO', NULL, 'A+\r\n', NULL, NULL, 'SINGAPORE', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL+P.O JADHUNATHPUR THANA- DHANBARI-TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('d.c.baroi836@gmail.com', 3240, NULL, 'দুলাল চন্দ্র বাড়ৈ', 'DULAL CHANDRA BAROI', NULL, NULL, '928210', 'e10adc3949ba59abbe56e057f20f883e', NULL, 179, NULL, NULL, ' HARIPADA CHANDRA BAROI', 'SARODA BAROI', 'PUSPA MONDAL', '2', 'LAW FIRMJOB', 'CLIENT RELATIONSHIP MANAGER', NULL, 'B+', NULL, NULL, '6A BEATTY ROAD # 04-01, SINGAPORE - 209946', NULL, NULL, NULL, NULL, NULL, NULL, 'VILLAGE - BETHUA, POST - PAK MUKSHUDPUN, PS - DOHAR, DIST - DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('asdcoasta@yahoo.com', 3241, NULL, 'আশিশ বনিফেস ডি\'কোসতা', 'ASHISH BONIFACE D\'COSTA', NULL, '9362641', '929270', 'e10adc3949ba59abbe56e057f20f883e', NULL, 180, NULL, NULL, 'CHRISTOPHER D\'COSTA', 'ROMANA D\'COSTA', 'DIANA GOMEZ', '1', NULL, NULL, NULL, 'O-', NULL, NULL, '84/1 KAKRAIL, RAMNA DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('anupam.uos@gmail.com', 3242, NULL, 'প্রকৌ. অনুপম দত্ত।', 'Engr. Anupam Datta.', NULL, '8.8171E+12', '922001', 'e10adc3949ba59abbe56e057f20f883e', NULL, 181, NULL, '4163121355', 'Nani Gopal Datta', 'Shipra Datta', 'Pallabi Sarker', '1', 'service', 'Deputy General Manager', NULL, 'B+', NULL, NULL, 'Deputy General Manager, Karnaphuli Gas Distribution Company Ltd., 137/A CDA Anue, Sholashahar, Chattogram.', NULL, NULL, NULL, NULL, NULL, NULL, 'Village-South Daulat Pur, Upazila-Fulgazi, Dist.-Feni.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('rbsattar@gmail.com', 3243, NULL, 'রিফাত বিন সাত্তার', 'Reefat Bin Sattar', NULL, '1777763988', '920729', 'e10adc3949ba59abbe56e057f20f883e', NULL, 182, NULL, '2.61955E+12', 'Late Dr AKM Golam Sattar', 'Ms Suraiya Sattar', 'Irene Basher Reefat', '2', 'Service cum Chess Player', 'Director-Program Delopment and Quality', 'Sa the Children International Bangladesh', 'A+', NULL, NULL, 'H 29 (9th floor) , Rd 18, Sector 3, Uttara, Dhaka 1230', NULL, NULL, NULL, NULL, NULL, NULL, 'H 106, Rd 15, Sector 11, Uttara, Dhaka 1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('mehaboobkabir2015@gmail.com', 3244, NULL, NULL, 'Mehaboob Kabir', NULL, '8.8187E+12', '929026', 'e10adc3949ba59abbe56e057f20f883e', NULL, 183, NULL, '1.97327E+16', 'Ramzan Ali', 'Delowara Begum', NULL, '1', 'Private Service', 'Business Delopment Coordinator', NULL, 'B+', NULL, NULL, 'House-15, Road-8, Gulshan 1, Dhaka-1212', NULL, NULL, NULL, NULL, NULL, NULL, 'Vill- Baraipara, Post- Malkhanagar, Thana-Sirajdhikhan, District-Munshiganj', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('shahnewaz1124@gmail.com', 3245, NULL, NULL, 'Mohammad Shahnewaz Hossain Khan', NULL, '8.8177E+12', '921090', 'e10adc3949ba59abbe56e057f20f883e', NULL, 184, NULL, '8200519794', 'Mohammad Farid Hossain Khan', 'Fatema Khatun', 'Parn Sultana', '4', 'Military service', 'Lieutenant colonel', NULL, 'B+', NULL, NULL, 'Plot 620, Road 20, Block A, khilgaon, Dhaka 1219', NULL, NULL, NULL, NULL, NULL, NULL, 'Plot 620, Road 20, Block A, khilgaon, Dhaka 1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('rezaul.hassan@gmail.com', 3246, NULL, 'এ বি এম রেজাউল হাসান', 'ABM Rezaul Hassan', NULL, '1819491340', '926058', 'e10adc3949ba59abbe56e057f20f883e', NULL, 185, NULL, '2.6995E+12', 'Abul Bashar', 'Rokeya Begum', NULL, '1', 'Banker', 'Head Risk & Controls', NULL, 'AB+', NULL, NULL, 'Apt A8, House 10, Road 4, Sector 4, Uttara, Dhaka 1230', NULL, NULL, NULL, NULL, NULL, NULL, 'Apt A8, House 10, Road 4, Sector 4, Uttara, Dhaka 1230', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('shahednsu@gmail.com', 3247, NULL, 'মোহাম্মদ শাহেদ চৌধুরী', 'Mohammad Shahed Chowdhury', NULL, '61433202177', '924060', 'e10adc3949ba59abbe56e057f20f883e', NULL, 186, NULL, '123456', 'Bazlus Sobhan Chowdhury', 'Dilruba Chowdhury', 'Jewela Nasrin', '1', 'Physician', NULL, NULL, 'A+', NULL, NULL, '58 Berehan Anue, Thornlie WA', NULL, NULL, NULL, NULL, NULL, NULL, '396 Malibagh Chowdhurypara, Dhaka', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('sabbir_doc@yahoo.com', 3248, NULL, 'মোহাম্মদ সাব্বির হায়দার', 'Mohammad Sabbir Haider', NULL, '1819293607', '922047', 'e10adc3949ba59abbe56e057f20f883e', NULL, 187, NULL, '2.69165E+12', 'M M Haider', 'Zaida Khatun', 'Tasruma Sharmeen Chowdhury', '2', 'Gornment service', NULL, NULL, 'AB+', NULL, NULL, '28, North Dhanmondi Kalabagan, Dhaka-1205', NULL, NULL, NULL, NULL, NULL, NULL, '28, North Dhanmondi Kalabagan, Dhaka-1205', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('ifti12bd@yahoo.com', 3249, NULL, 'ইফতেখার হাসনাইন', 'IFTEKHAR HASNAIN', NULL, '6.1452E+11', '922112', 'e10adc3949ba59abbe56e057f20f883e', NULL, 188, NULL, '2815869900', 'SHAHIDUL ISLAM', 'MAFRUHA ISLAM', 'SHARMIN MAHBUB LOPA', '2', 'MARINE ENGINEER', 'CHIEF ENGINEER', NULL, 'A+', NULL, NULL, 'UNIT 18/83-85 AUCKLAND STREET, GLADSTONE CENTRAL, QLD 4680, AUSTRALIA', NULL, NULL, NULL, NULL, NULL, NULL, 'DOMAX JAMILA DREAM, 431/B (4TH FLOOR), KHILGAON CHOWDHURYPARA, DHAKA - 1219, BANGLADESH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('1715615225', 3250, NULL, 'শরীফ মোঃ আলমগীর ', 'SHARIF MOHAMMED ALAMGIR', NULL, '01715615225, 01920145581', '928338', 'e10adc3949ba59abbe56e057f20f883e', NULL, 189, NULL, '2612935362452', 'MOHAMMED ABDUL MALEQUE', 'REJIA BEGUM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: NOAGAON, P.O: CHHAYASUTI, P.S: KULIARCHAR, DIST: KISHORGANJ', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: NOAGAON, P.O: CHHAYASUTI, P.S: KULIARCHAR, DIST: KISHORGANJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('khossain2010@gmail.com', 3251, NULL, 'মোহাম্মদ খালেদ হোসেন', 'Mohammad Khaled Hossain', NULL, '1712122826', '921103', 'e10adc3949ba59abbe56e057f20f883e', NULL, 190, NULL, '2804427744', 'Md Iqbal hossain', 'Ms Khaled’s begum', 'Ms Nurun Nahar khanam', '2', 'Banker', 'Assistant Vice President', NULL, 'O+', NULL, NULL, 'House-15/road-14/section-10/block-c/mirpur,Dhaka', NULL, NULL, NULL, NULL, NULL, NULL, 'House-15/road-14/section-10/block-c/mirpur,Dhaka', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('tipu@gvfashion-asia.com', 3252, NULL, 'রাশেদ মিনহাজ টিপু', 'RASHED MINHAZ TIPU', NULL, '01711 345645', '929440', 'e10adc3949ba59abbe56e057f20f883e', NULL, 191, NULL, '2827490091', 'Badsha Miah', 'Lutfunnessa Begum', 'Farjana Akhter Emu', '2', 'PRIVATE SERVICE', 'MANAGER', 'GV FASHION ASIA LTD', 'O-', NULL, NULL, 'House#10 (4th floor), Road# 10, Gulshan#1, Dhaka-121212', NULL, NULL, NULL, NULL, NULL, NULL, 'Holding No#289/2 (lutfa House), Yousuf School Bazrapur, Cumilla Sadar, Cumilla', NULL, NULL, 'CUMILLA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('prodip2076@gmail.com', 3253, NULL, 'প্রদীপ কুমার কর্মকার', 'PRODIP KUMAR KARMAKAR', NULL, '1718263600', '925029', 'e10adc3949ba59abbe56e057f20f883e', NULL, 192, NULL, '5500445985', 'NITTANONDA KARMAKAR', 'JOSNA RANI KARMAKAR', 'MOUSUMI ROY', '2', 'TEACHER', 'SENIOR TEACHER of ENGLISH', NULL, 'O+', NULL, NULL, '29/A, PROSANNA PODDER LANE, TANTI BAZAR, DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, '29/A, PROSANNA PODDER LANE, TANTI BAZAR, DHAKA-1100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('mehalashki@gmail.com', 3254, NULL, 'মেহবুব আলম শাকিল', 'MEHBOOB ALAM SHAKIL', NULL, '1739999943', '921036', 'e10adc3949ba59abbe56e057f20f883e', NULL, 193, NULL, '5959028225', 'SHAMSUL ALAM', 'HASINA ALAM', 'REHANA MEHBOOB', '2', 'MARINER', 'CAPTAIN', NULL, 'O+', NULL, NULL, 'FLAT-E3, 110 CENTRAL ROAD, DHANMONDI, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, 'FLAT-E3, 110 CENTRAL ROAD, DHANMONDI, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('ashiqur.rahman2701@gmail.com', 3255, NULL, 'আশেকুর রহমান', 'Ashequr Rahman', NULL, '12132631092', '924037', 'e10adc3949ba59abbe56e057f20f883e', NULL, 194, NULL, '2.69641E+12', 'Abdur Rahman Sarkar', 'Anwara Begum', 'Nazmun Nahar', '0', 'Sales Manager', 'Assistant Manager, Sales', NULL, 'B+', NULL, NULL, '122 S. Alexandria A. Los Angeles, CA 90004, USA', NULL, NULL, NULL, NULL, NULL, NULL, 'House-12, Block-D, A-5, Section-6, Pallabi, Dhaka-1216', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('mostafaaim@gmail.com', 3256, NULL, 'এ. আই. এম. মোস্তাফা', 'A. I. M. MOSTAFA', NULL, '1713199826', '929247', 'e10adc3949ba59abbe56e057f20f883e', NULL, 195, NULL, NULL, 'NOOR NABI', 'FATEMA BEGUM', 'SHAHANA MAHJABEEN', '2', 'BANKER', 'SENIOR VICE PRESIDENT & HEAD OF BRANCH OPERATION & CONTROL DIVISION', 'NRBC BANK', 'O+', NULL, NULL, 'FLAT # 4A, HOUSE # 18/1, ROAD # 11, MOHAMMADI HOUSING SOCIETY, MOHAMMADPUR', NULL, NULL, NULL, NULL, NULL, NULL, 'FLAT # 4A, HOUSE # 18/1, ROAD # 11, MOHAMMADI HOUSING SOCIETY, MOHAMMADPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('majabbar968@gmail.com', 3257, NULL, 'মুহাম্মদ আবদুল জাব্বার', 'MUHAMMAD ABDUL JABBAR', NULL, '01914874968, 01777792167', '925037', 'e10adc3949ba59abbe56e057f20f883e', NULL, 196, NULL, '1.97627E+16', 'MUHAMMAD ABDUL QAHAR', 'ROWSHAN ARA BEGUM', 'SHAILA SHARMIN', '1', 'PRIVATE SERVICE', 'FIRST ASSTT. VICE PRESIDENT', NULL, 'B+', NULL, NULL, 'BANK ASIA LTD. CONSUMER FINANCE, RETAIL BANKING, 2 HADI MANSION, DILKUSHA, DHAKA-1000', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL. & POST - SULTANPUR, PS % DIST. - BRAHMANBARIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('pallab010176@gmail.com', 3258, NULL, 'প্রসেঞ্জিৎ সাহা', 'PRASENJIT SAHA', NULL, '+1 639 998 7338', '928', 'e10adc3949ba59abbe56e057f20f883e', NULL, 197, NULL, '123', 'AKSHAYA KUMAR SAHA', 'ADARINI SHETH', 'MITU BHOUMIK', '1', 'Private Service', NULL, NULL, 'B+', NULL, NULL, '2518 7th street , Saskatoon, Saskatchewan, Canada', NULL, NULL, NULL, NULL, NULL, NULL, '150/1, Kabi Gobindo Das Road, Gazipur City Corporation, Gazipur- 1700.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('csabeg@gmail.com', 3259, NULL, 'চৌধুরী সাইফুল আলম বেগ ( পাপন )', 'Chowdhury Saiful Alam Beg', NULL, '61416943709', '921095', 'e10adc3949ba59abbe56e057f20f883e', NULL, 198, NULL, '921095', 'Chowdhury Rezaul Alam Beg', 'Mrs Shaheen Akhter', 'Mrs Maleka Alam Deepa', '2', 'Specialist General Practitioner', 'Dr', NULL, 'A+', NULL, NULL, '17 Shetland Anue, Dubbo, NSW-2830', NULL, NULL, NULL, NULL, NULL, NULL, '17 Shetland Anue, Dubbo, NSW-2830', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('mithubiswas015@gmail.com', 3260, NULL, 'মৃনাল কান্তি বিশ্বাস (মিঠু)', 'MRINAL KANTI BISWAS (MITHU)', NULL, '1711108669', '928200', 'e10adc3949ba59abbe56e057f20f883e', NULL, 199, NULL, '19746125208163050', 'NALINI RANJAN BISWAS', 'SUCHITRA BISWAS', 'CHANDANA RANI BISWAS', '1', 'GOVT. SERVICE', 'JOINT REGISTER (ADMIN)', NULL, 'A+', NULL, NULL, 'SAMABAY BHABAN, DPT. OF CO-OPERATIS, F-10, CIVIC SECTOR, SHER-E-BANGLA NAGAR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL - MACHKANDI, P.O. - TUTHAMENDRA, P.S. - GOPALGANJ SADAR, DIST - GOPALGANJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('8.8182E+12', 3261, NULL, 'মামুন পাঠান ', 'MAMUN PATHAN', NULL, '8.8182E+12', '924019', 'e10adc3949ba59abbe56e057f20f883e', NULL, 200, NULL, '1904484613', 'ALI AKBAR PATHAN', 'SURIA BEGUM', 'AFROJA PATHAN', '3', 'TEACHING ', NULL, NULL, 'O+', NULL, NULL, '14-3/B , MITALI HOUSING ,SOUTH KAFRUL , DHAKA CANTONMENT .', NULL, NULL, NULL, NULL, NULL, NULL, 'NORTH KAZI KASBA ,P.O- MIRKADEM, THANA + DIST - MUNSHIGANJ .', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('donny511r@gmail.com', 3262, NULL, 'ডেণী দাস', 'DANNY DAS', NULL, '904-312-9736', '929281', 'e10adc3949ba59abbe56e057f20f883e', NULL, 201, NULL, '2692986583353', 'LATE RATAN DAS', 'LATE APARNA DAS', 'ETHEL RINA HALDER', '1', 'PRIVATE SERVICE', 'CLERK', NULL, 'B+', NULL, NULL, '380 WIER ROAD APT#16 SANBERNARDINO,CA,92408 USA', NULL, NULL, NULL, NULL, NULL, NULL, '16/A EAST RAJABAZAR TEJGOAN,DHAKA BANGLADESH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('kbdalamin@yahoo.com', 3263, NULL, 'মোহাম্মাদ আল-আমিন', 'MUHAMMAD AL-AMIN', NULL, '01714 095926', '923084', 'e10adc3949ba59abbe56e057f20f883e', NULL, 202, NULL, '7334330516', 'SHAHJAHAN ALI', 'MRS. REZIA BEGUM', 'SHAMIMA NASRIN', '2', 'PRIVATE SERVICE', 'MARKETING MANAGER, SEED', 'NATIONAL AGRICARE IMPORT & EXPORT LIMITED.', 'B+', NULL, NULL, '634, NORTH KAFRUL, DHAKA CANTONMENT, DHAKA-1206', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: PINGNA, POST: PINGNA, UPZILA: SARISHABARI, DIST: JAMALPUR', NULL, NULL, 'JAMALPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('taneemaziz@gmail.com', 3264, NULL, '\r\nতানিম আজিজ খান', 'TANEEM AZIZ KHAN', NULL, '01911-350500,01611350500', '929298', 'e10adc3949ba59abbe56e057f20f883e', NULL, 203, NULL, '2696352216576', 'LATE TAWFIQ AZIZ KHAN', 'LATE SURAIYA BEGUM', NULL, NULL, 'JOURNALIST', 'MANAGING EDITOR', NULL, 'B+', NULL, NULL, '278/2, ELEPHANT ROAD, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, '278/2, ELEPHANT ROAD, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('saiful.hamid72@gmail.com', 3265, NULL, 'সাইফুল হামিদ', 'SAIFUL HAMID', NULL, '1715255153', '929287', 'e10adc3949ba59abbe56e057f20f883e', NULL, 204, NULL, '2691650132560', 'MD.SALEHIN', 'FEROZA BEGUM', 'NADIA NOON RIMA', '2', 'SERVICE', 'SAVP,PREMIER BANK LTD', NULL, 'B+', NULL, NULL, '40,AL-AMIN ROAD,  GREEN ROAD DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '40,AL-AMIN ROAD, GREEN ROAD DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mahossain1375@yahoo.com', 3266, NULL, 'মুহাম্মদ আলমগীর হোসেন ', 'MOHAMMAD ALAMGIR HOSSAIN', NULL, '01740 594056', '929205', 'e10adc3949ba59abbe56e057f20f883e', NULL, 205, NULL, '2611265203395', 'LATE MOHAMMAD MOFIZ UDDIN', 'MISSES SOFIA BEGUM', 'SHOMSAT BEGUM', '2', 'GOVT SERVICE', 'AREA RATIONING OFFICER', 'DHAKA RATIONING OFFICE', 'O+', NULL, NULL, 'VILLAGE -KAMARGOP, DEMRA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILLAGE -KAMARGOP, DEMRA, DHAKA', NULL, NULL, 'DHAKA', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('ashiqzahin@yahoo.com', 3267, NULL, 'মোহাম্মদ আশিকুর রহমান ', 'MOHAMMAD ASHIQUR RAHMAN', NULL, '1716612274', '929020', 'e10adc3949ba59abbe56e057f20f883e', NULL, 206, NULL, '8231947865', 'MOHAMMAD MAHBUBUR RAHMAN', 'ROKEYA KHATUN', 'SYEEDA ROMANA ISLAM', '1', 'SERVICE', 'MANAGER (FA&T)', NULL, 'O+', NULL, NULL, '30/7, SHER SHAH SURI ROAD, 4TH FLOOR, 4-B, MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, '30/7, SHER SHAH SURI ROAD, 4TH FLOOR, 4-B, MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('pial44@yahoo.com', 3268, NULL, NULL, 'MUHAMMAD FAHIM REZA', NULL, '1713083090', '923081', 'e10adc3949ba59abbe56e057f20f883e', NULL, 207, NULL, NULL, 'MD FAHIM REZA', 'JAHANARA RAHMAN', 'SUSHILA', '2', 'PRIVATE SERVICE', 'CREATI DIRECTOR', NULL, 'O+', NULL, NULL, 'HOUSE-534, RANIA ANUE  BLOCK-F, BASHUNDHARA R/A, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '157, BILASDI,NARSHINGDI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('mazaman1727s@gmail.com', 3269, NULL, 'মোহাম্মদ আসাদুজ্জামান', 'MOHAMMED ASADUZZAMAN', NULL, '01823 034987', '925061', 'e10adc3949ba59abbe56e057f20f883e', NULL, 208, NULL, NULL, 'MOHAMMED FAZLUL KARIM', 'HALIMA AKTER KHATUN', 'SHAMIMA NAZ', '2', 'DEFENSE SERVICE (BANGLADESH NAVY)', 'LIEUTENANT COMMANDER', 'BANGLADESH NAVY', 'O+', NULL, NULL, 'TRAINING CO-ORDINATING OFFICER (TCO), BNS SHAHEED MOAZZAM, KAPTAI, RANGAMATI', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: SAFISREE, P.O. KAPASIA, P.S. KAPASIA, DISTRICT: GAZIPUR', NULL, NULL, 'GAZIPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('MOFASSEL@GMAIL.COM', 3270, NULL, NULL, 'DR MOFASSEL UDDIN AHEMD', NULL, '1819131717', '921053', 'e10adc3949ba59abbe56e057f20f883e', NULL, 209, NULL, '3276088980', 'DR GIAS UDDIN AHMED', 'RASHIDA BEGUM', 'DR FARZANA RAHMAN', '1', 'CARDIAC SURGEON', 'CONSULTANT', 'RASHIDA BEGUM', 'A+', NULL, NULL, 'GA-86, MIDDLE BADDA, GULSHAN LINK ROAD, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'GA-86, MIDDLE BADDA, GULSHAN LINK ROAD, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('salahuddin02/2@gmail.com', 3271, NULL, 'সালাউদ্দিন আহমেদ', 'SALAHUDDIN AHMED', NULL, '1977046553', '929043', 'e10adc3949ba59abbe56e057f20f883e', NULL, 210, NULL, NULL, 'SHAHABUDDIN AHMED', 'ZINAT BEGUM', 'HOSNEARA BEGUM', '2', 'PRIVATE JOB', NULL, NULL, 'B+', NULL, NULL, 'FEROZA VIEW, FLAT NO-C/2,63,SANTINAGAR NAYA PALTON,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '83/A,DISTILARY ROAD,GANDARIA,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shubharthi@gmail.com', 3272, NULL, 'ডাঃ. শুভার্থি কর', 'DR. SHUBHARTHI KAR', NULL, NULL, '922049', 'e10adc3949ba59abbe56e057f20f883e', NULL, 211, NULL, NULL, 'LATE- BIDHU BHUSHAN KAR', 'MRS ASITA KAR', 'DR DEBALEENA DAS GUPTA', '2', NULL, NULL, NULL, 'B+', NULL, NULL, 'PROTIKKHA 2ND FLOOR,SHYLET-3100', NULL, NULL, NULL, NULL, NULL, NULL, 'KALIBARI,CROSS ROAD,HABIGANJ-3300', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('roybk1973@gmail.com', 3273, NULL, NULL, 'BISWHAJIT KUMAR ROY', NULL, '01759 903074', '929059', 'e10adc3949ba59abbe56e057f20f883e', NULL, 212, NULL, '1938892278', 'LATE NIRMAL KUMAR ROY', 'LATE NEETA ROY', 'MITA CHAKRABARTY', '1', 'MEDICAL EXECUTI', 'AREA MANAGER', 'LABAID PHARMACEUTICALS LTD.', 'A+', NULL, NULL, '45/12, NORTH CHASARA, NARAYANGANJ', NULL, NULL, NULL, NULL, NULL, NULL, '45/12, NORTH CHASARA, NARAYANGANJ', NULL, NULL, 'NARAYANGANJ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('Ahmedmonsur@gmail.com', 3274, NULL, 'মনসুর আহমেদ', 'MONSUR AHMED', NULL, '61406029206', '924031', 'e10adc3949ba59abbe56e057f20f883e', NULL, 213, NULL, NULL, 'MD ABDUR RAQUIB', 'KULSUM KHANOM', 'MAFTUHA ROB', '2', 'JOB', 'IT CONSULTANT', NULL, 'A+', NULL, NULL, '7 HOOPER ROAD, EDMONDSON PARK, NSW 2174, AUSTRALIA', NULL, NULL, NULL, NULL, NULL, NULL, 'WARD-4,MAGURA,KULAURA, UTTAR BAZAR,MOULOVIBAZAR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('milton.peris@kochne-nagel.com', 3275, NULL, NULL, 'MILTON MAKBATH PERIS', NULL, '1729072049', '929415', 'e10adc3949ba59abbe56e057f20f883e', NULL, 214, NULL, '3728165261', 'CELESTIN PERIS', 'KARUNA MARIA PERIS', 'MUKTA COSTA', '2', 'PRIVATE SERVICE', 'MANAGER -HR', NULL, '0+', NULL, NULL, 'SHAILAN MANSION ,86,TEJKUNIPARA , FLAT -6A ,TEJGAON , DHAKA-1215', NULL, NULL, NULL, NULL, NULL, NULL, '51/2 , SOUTH BEGUN BARI ,TEJGAON ,DHAKA-1208', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('panna.peris@gmail.com', 3276, NULL, NULL, 'ANIMATIUS PANNA PERIS', NULL, '01733 400146', '929271', 'e10adc3949ba59abbe56e057f20f883e', NULL, 215, NULL, '8229389666', 'FRANCIS PERIS (LATE)', 'VIOLET TERESA GOMES', 'PATRICIA TONIMA DAS', '2', 'IT PROFESSIONAL', 'FULL STACK WEB DELOPER', 'DIBARATRI ICT LTD. (www.dibaratrionline.com)', 'B+', NULL, NULL, '186/1 TEJKUNIPARA,FARMGATE TEJGAON,DHAKA-1215', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL:PANJORA,  P.O:NAGORI, P.S:KALIGONJ, DIST:GAZIPUR', NULL, NULL, 'GAZIPUR', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('james.collins@juati-bd.com', 3277, NULL, NULL, 'JAMES COLLINS GOMES', NULL, '1729094729', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 216, NULL, NULL, 'H. FRANCIS GOMES', 'JULIANA GOMES', 'EVA GOMES', '2', 'BUSINESS', 'MD', NULL, 'AB+', NULL, NULL, '67, TEJKUNIPARA, TEJGAON, DHAKA - 1215 / CAMELLIA  APARTMENT BUILRINA, APT - B2', NULL, NULL, NULL, NULL, NULL, NULL, '26, PROTAP DAS LANE, ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1819140593', 3278, NULL, 'জয়ন্ত ভ্যালেরিয়ান রোজারিও ', 'JOYANTO LERIAN ROZARIO', NULL, '1819140593', '929269', 'e10adc3949ba59abbe56e057f20f883e', NULL, 217, NULL, NULL, 'CYRIL ROZARIO', 'HELEN ROZARIO', 'LINDA GOMES', '2', 'SERVICE', NULL, NULL, 'O+', NULL, NULL, '19 TEJKUNIPARA, TEJGAON, DHAKA -1215', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: DHNUM, P.O. NAGOR, P.S: KALIGONJ, DIST: GOPALPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('azim51800@gmail.com', 3279, NULL, NULL, 'LT. CON. AMIRUL AZIM ', NULL, '1720542975', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 218, NULL, NULL, 'LATE A.W.V NURUL AZIM', 'LATE MASUDA BEGUM', 'MRS. SHAMIMA TASNIM', '1', 'GOVT SERVICE', 'LT COL', NULL, 'B+', NULL, NULL, ' CSE,DEPT,MIST  MIRPUR CANTONMENT, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1714164894', 3280, NULL, 'সাঈদ হোসেন পাটোয়ারী', 'SAYED HOSSAIN PATWARY', NULL, '1714164894', '922045', 'e10adc3949ba59abbe56e057f20f883e', NULL, 219, NULL, NULL, 'SALAMAT ULLAH PATWARY', 'MRS. TASLIMA BEGUM', 'HASINA BEGUM', '3', 'PRIVATE SERVICE', 'HEAD OF PROCUREMENT', NULL, 'B+', NULL, NULL, '2B. SHELTECH SPONDON 7 DILA ROAD P.O: SHANTINAGAR. P.S: RAMNA, DHAKA-1236', NULL, NULL, NULL, NULL, NULL, NULL, '70 RASULPUR, DAMRA. P.O: DAMRA. P.S: JATRABARI, DHAKA-1236', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('saifunnobu@purelabbd.com', 3281, NULL, 'চৌধুরী সাইফুন্নবী', 'SAGOR CHOWDHURY SAIFUNNOBI', NULL, '1914880584', '926018', 'e10adc3949ba59abbe56e057f20f883e', NULL, 220, NULL, NULL, 'NURUN NABI CHOWDHURY', 'SURAIYA BEGUM', 'IFFAT AHMED', NULL, 'BUSINESS', NULL, NULL, 'O+', NULL, NULL, '333/2, SOUTH JATRABARI, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, '333/2, SOUTH JATRABARI, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('tanviron200975@yahoo.com', 3282, NULL, 'লেঃ কর্ণেল ডাঃ তানভীর আহমেদ শিপন ', 'LT. COLONEL DR TANVIR AHMED SHIPON', NULL, '1725380116', '923035', 'e10adc3949ba59abbe56e057f20f883e', NULL, 221, NULL, NULL, 'DR AZIM UDDIN AHMED', 'MRS MONOWARA BEGUM', 'DR SHAMIMA BEGUM', '2', 'GOVT. SERVICE', 'LIEUTENANT COLONEL', NULL, 'O+', NULL, NULL, '317/2, AHMED NAGAR, PAIRPARA, MIRPUR', NULL, NULL, NULL, NULL, NULL, NULL, '317/2, AHMED NAGAR, PAIRPARA, MIRPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('waekram@hotmail.com', 3283, NULL, 'আব্দুল ইকরাম (বাবু)', 'ABDUL EKRAM (BABU)', NULL, '61402997189', '924063', 'e10adc3949ba59abbe56e057f20f883e', NULL, 222, NULL, NULL, 'Abdul Mannan', 'Ferdousi Begum', NULL, '2', 'Public Service', 'Manager International Health', 'Australian Trade Commission', 'A+', NULL, NULL, 'C/3A, 93 Shah Ali Bagh, Mirpur 2', NULL, NULL, NULL, NULL, NULL, NULL, 'C/3A, 93 Shah Ali Bagh, Mirpur 2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('reaz5233@gmail.com', 3284, NULL, 'রিয়াজ আহমেদ ভুইয়া', 'Engr Reaz Ahmed Bhuiyan', NULL, '01711 951894', '922042', 'e10adc3949ba59abbe56e057f20f883e', NULL, 223, NULL, '8684089165', 'Md Golam Azam Bhuiyan', 'Rahima Begum', 'Kanij Fatema', '0', 'Army Officer', 'Major', 'Bangladesh Army', 'O+', NULL, NULL, '1/D Shornolota officers quarter, Staff road, DhakaCantonment, Dhaka, Bangladesh', NULL, NULL, NULL, NULL, NULL, NULL, '512 Wilsonroa, Bandar, Narayanganj', NULL, NULL, 'Narayanganj', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1020'),
('romel2356@gmail.com', 3285, NULL, 'সাদিকউজ্জামান খান ', 'SADIQUZZAMAN KHAN', NULL, '8.8176E+12', '929066', 'e10adc3949ba59abbe56e057f20f883e', NULL, 224, NULL, '6850290468', 'SHAMSUZZAMAN KHAN', 'ROUSHAN ARA KHAN', 'ROWSON AKTER BADRUN KARIM', '1', 'BANKING', 'HEAD OF TREASURY', NULL, 'O+', NULL, NULL, 'HOUSE: 422, APARTMENT: 3B, BLOCK: C, KHILGAON R/A, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: BALIA, P.O: BALIA, P.S: DHAMRAI, DIST: DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('mkrsagor43@gmail.com', 3286, NULL, 'মোঃ খলিলুর রহমান', 'Md.Khalilur Rahman', NULL, '8.8177E+12', '925008', 'e10adc3949ba59abbe56e057f20f883e', NULL, 225, NULL, '1.97533E+16', 'Sultan Ahmed', 'Mazeda Khatoon', 'Maksuda Begum(Moona)', '2', 'Business', 'Managing Director', NULL, 'A+', NULL, NULL, 'G-73,South Banasree, Dhaka-1219', NULL, NULL, NULL, NULL, NULL, NULL, 'Vill & Post :Shait Shala, P.S:Brahmman Para, Dist :Cumilla', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1020'),
('milton.rozario@gmail.com, milton.rozari@thecitybank.com', 3287, NULL, NULL, 'MILTON D\' ROZARIO', NULL, '1819283861', '929093', 'e10adc3949ba59abbe56e057f20f883e', NULL, 226, NULL, '2699040699481', 'LATE PETER D\' ROZARIO', 'METHELDA D\' ROZARIO', 'IRENE D\' ROZARIO', '3', 'BANKER', 'VP', NULL, 'O+', NULL, NULL, '43/1, INDIRA ROAD, TEJGAON', NULL, NULL, NULL, NULL, NULL, NULL, '43/1, INDIRA ROAD, TEJGAON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('muhammadarifrahman@gmail.com', 3288, NULL, NULL, 'MUHAMMAD ARIF  RAHMAN', NULL, '1914858444', '921085', 'e10adc3949ba59abbe56e057f20f883e', NULL, 227, NULL, NULL, 'DOST MOHAMMAD', 'JAHANARA BEGUM', 'FARIDA YEASMIN', '3', NULL, 'MASTER MARINER', NULL, 'A+', NULL, NULL, 'FLAT 4, HOUSE 1075,ROAD 6A, ANUE MIRPUR DOSH', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: BUBBA, POST.PASCHIMPARA THANA-SARAIL, BRAHMANBARIA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('1711200088', 3289, NULL, NULL, 'MOHAMMAD ABDUR ROB(RUBEL)', NULL, '1711200088', '923077', 'e10adc3949ba59abbe56e057f20f883e', NULL, 228, NULL, NULL, 'MOHAMMAD ABDUO MANNAN', 'HOSNE ARA MANNAN', NULL, '3', 'SERVICE IN BB', 'JOINT DIRECTOR', NULL, 'O+', NULL, NULL, '5, CIRCUIT HOUSE ROAD RAMNA, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('ishakpro@yahoo.com', 3290, NULL, NULL, 'MD. ISHAK MOLLA', NULL, '1911930716', '928320', 'e10adc3949ba59abbe56e057f20f883e', NULL, 229, NULL, NULL, 'MD. ABDUL KARIM MOLLA', 'MOST. AYSHA KHATUN', 'MOST. ASMA KHATUN', '3', 'GOVT. SERVICE', 'EDITOR/PRO', NULL, 'B+', NULL, NULL, 'EDITOR, BCSIR, DR. QUDRAT-I-KHUDA ROAD, DHANMONDI, DHAKA-1205', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: POST: 8 RASHI, P.S: SADARPUR, DIST: FARIDPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('gmg.mostafa@siamcitycement.com, gmg.mostafa@gmail.com', 3291, NULL, 'জি,এম,জি,মোস্তফা', 'GMG Mostafa', NULL, '01904 439448', '923016', 'e10adc3949ba59abbe56e057f20f883e', NULL, 230, NULL, '5500378517', 'Mohammad Abdul Bari Munshi', 'Marium Khatun', 'Jayeda Begum (Lima)', '2', 'PRIVATE SERVICE', 'GENERAL MANAGER - OPERATION', 'SIAM CITY CEMENT (BANGLADESH)LTD.', 'O+', NULL, NULL, 'Flat#5/A, House #6, Road#6, Block-D', NULL, NULL, NULL, NULL, NULL, NULL, 'Vill-Mobarokpur, P.O- Ananda Bazar, P.O- Sonargaon, Dist- Narayangonj, Bangladesh', NULL, NULL, 'NARAYANGANJ', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, 'will be gin'),
('soumit74@gmail.com', 3292, NULL, NULL, 'SOUMIT RANZAN MAZUMDER', NULL, '01819 225804', '929304', 'e10adc3949ba59abbe56e057f20f883e', NULL, 231, NULL, NULL, NULL, NULL, NULL, NULL, 'PRIVATE SERVICE', 'HEAD OF OPERATIONS', 'DREAM YARD ATTIRES LTD.', 'B+', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CHOTTOGRAM', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, 'B+'),
('amar19moner73@gmail.com', 3293, NULL, NULL, 'HLAMONG BOBBY MURRUY', NULL, '1713076118', '929483', 'e10adc3949ba59abbe56e057f20f883e', NULL, 232, NULL, NULL, 'CHINGHLAMONG CHOWDHURY MURRUY', 'LATE INDULEKHA MURRUY', 'DIVORCE', '1', 'TEACHER', NULL, NULL, 'B+', NULL, NULL, '45/5/A SENPARA PARBATA, MIRPUR-10, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL- KARIGOR PARA, P.O- RAIKHALI, UPAZILA- KAPTAI, DIST- RANGAMATI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('lumanear@gmail.com', 3294, NULL, 'লুৎফর রহমান', 'LUTFOR RAHMAN', NULL, '1715647540', '922025', 'e10adc3949ba59abbe56e057f20f883e', NULL, 233, NULL, '1.22131E+12', 'A. I. M. Faizul Huda', 'Lutfa Begum', 'Marufa Ahmed', '2', 'Air Transport Pilot', 'Captain', 'US-Bangla Airlines', 'A+', NULL, NULL, '49/C (ground floor) Road-10, Dhaka cantonment, Dhaka-1206', NULL, NULL, NULL, NULL, NULL, NULL, '702 Shahnewaz Road, Kajipara, Moulovy Hati, Brahmanbaria', NULL, NULL, 'Brahmanbaria', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, 'Bkash ref: lutforrahman'),
('kledrikbipul@gmail.com', 3295, NULL, 'আ. ত. ম. রবিউল ইসলাম খান ', 'ATM Rabiul Islam Khan', NULL, '1717627112', '924086', 'e10adc3949ba59abbe56e057f20f883e', NULL, 234, NULL, '8919015004689', 'MOHAMMAD ABUL QASEM KHAN', 'REZIA KHANAM', 'SABINA AFRIN', NULL, 'TEACHERSHIP', 'INSTRUCTOR(AGRI)', NULL, 'O+', NULL, NULL, '117, KALIR BAZAR. P.O- SHERPUR TOWN, THANA-SHERPUR, SADAR SHERPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('kabir5329@gmail.com', 3296, NULL, NULL, 'Maj Muhammad Luthful Kabir (Retd)', NULL, '1711447494', '924014', 'e10adc3949ba59abbe56e057f20f883e', NULL, 235, NULL, '8676824330', 'ABDUR RASHID', 'KHALEDA BEGUL', 'DR. MOSAMMAT SALMA NOOR', '2', 'BUSINESS', 'DIRECTOR', 'EZZY GROUP', 'B+', NULL, NULL, 'FLAT: B1, HOUSE: 01, ROAD: 1/A, SECTOR-13, UTTARA,DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE: 18, WARD:3, EAST ASHKONA, PO: HAJI CAMP, PS: DHAKSHIN KHAN, DHAKA-1230', NULL, NULL, 'Comilla', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('arif7875@gmail.com', 3297, NULL, NULL, 'Adv Md Ariful Islam', NULL, '1713033898', '9289123', 'e10adc3949ba59abbe56e057f20f883e', NULL, 236, NULL, '4644241828', 'LATE MD SAIDUL ISLAM', 'MRS KOHINOOR ISLAM ', 'MRS MAHMUDA ISLAM', '3', NULL, 'ADVOCATE', NULL, 'O+', NULL, NULL, 'ROAD-19, HOUSENO- 64, SECTOR- 14, UTTARA', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL- MOTRA, P.O -KAWLIBERA, P.S- BHANGA, DIST- FARIDPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('drashnafcmc@gmail.com', 3298, NULL, NULL, 'LtCol Dr Muhammed Ashraful', NULL, '1741170012', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, 237, NULL, '2650898261482', 'MD. ABUL HALIM BHUIYA', 'MRS MAMOTAZ BEGUM', 'DR. ASMA BEGUM', '2', NULL, 'DERMATOLOGIST', NULL, 'O+', NULL, NULL, 'CMH GHATAIL, TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL-BHAKOADI, P.O-TILSON1A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('akader511@gmail.com', 3299, NULL, NULL, 'Captain Mohammad Abdul Kader', NULL, '1769761139', '927102', 'e10adc3949ba59abbe56e057f20f883e', NULL, 238, NULL, NULL, 'MD ABDUS SATTAR', 'MRS SHAHINA BEGUM', 'MRS ANJUMAN ARA', '2', 'GOVT SERVICE', 'CAPTAIN BN', NULL, 'B+', NULL, NULL, 'PLANS & ACQUISTION DTE, CGHQ AGARGAON,SHER-E BANGLANAGAR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, 'MASTERPARA, RAMNBA, CHILMARI ,KURIGRAM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('928363', 3300, NULL, NULL, 'Md Mahmudur Rahman Bhuiya', NULL, NULL, '928363', 'e10adc3949ba59abbe56e057f20f883e', NULL, 239, NULL, NULL, 'MUJIBUR RAHMAN BHUIYA', 'ROWSHAN ARA BEGUM', 'SUPRIYA AHMED', '2', 'TEACHER', NULL, NULL, 'AB+', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('sazzad54us@gmail.com', 3301, NULL, 'মোহাম্মদ সাজ্জাদ হোসাইন ', 'Mohammad Sajjad Hossain', NULL, '1711205060', '928303', 'e10adc3949ba59abbe56e057f20f883e', NULL, 240, NULL, '2690421384774', 'MOHAMMAD SHAHIDULLAH', 'SELINA AKTER KHANOM', 'DR. TANIYA ADITY', '2', 'GOVT SERVICE', 'ASS. PROFESSOR BCS(GENERAL EDUCATION)', NULL, 'A+', NULL, NULL, 'KHA 83, SOUTH BADDA, DHAKA-1212', NULL, NULL, NULL, NULL, NULL, NULL, 'VILLAGE : BHATIYA, P.O: FULDIBAZAR P.S: KALIGONJ, DIST: GAZIPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shawkat789@yahoo.com', 3302, NULL, NULL, 'Mohammad Shawkat Ali Patwary', NULL, '01714122731,+16133637502', '922073', 'e10adc3949ba59abbe56e057f20f883e', NULL, 241, NULL, '2695433073455', 'ALI AKBAR PATWARY', 'JAHANARA BEGUM', 'AYESA SIDDIKA FARHANA', '5', 'TEXTILE ENGINEER', 'PROPRIETOR', NULL, 'A+', NULL, NULL, ' 650 HAMILTON CRESCENT,APT-67 CORNWALL,ON,CANADA-K6H7L4', NULL, NULL, NULL, NULL, NULL, NULL, 'PLOT NO-10,THANA ROAD,TURAG,UTTARA-DHAKA(RAHBAR GARDEN-APT#6C)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('drmuradmp2041@gmail.com', 3303, NULL, 'ডাঃ মো: মুরাদ হাসান ', 'Dr Md Murad Hassan', NULL, '1711541643', '922126', 'e10adc3949ba59abbe56e057f20f883e', NULL, 242, NULL, '3918510072086', 'ADVOCATE MOTIUR RAHMAN TALUKDAR', 'MONOWARA BEGUM', 'DR. JAHANARA AHSAN', '2', NULL, NULL, NULL, 'A+', NULL, NULL, '\"MINISTER APARTMENT\" BAILY ROAD, FLAT# 43 (EAST), DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000');
INSERT INTO `all_info_together` (`email`, `id`, `full_name`, `name_bangla`, `first_name`, `last_name`, `mobile`, `institution_id`, `password`, `registration_date`, `membership_number`, `gender`, `nid_or_passport`, `fathers_name`, `mother_name`, `spouse_name`, `number_of_children`, `profession`, `designation`, `institution`, `blood_group`, `date_of_birth`, `religion`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `second_citizenship_country`, `otp`, `forgot_password_crypto`, `status`, `email_verification_status`, `change_request`, `change_request_time`, `type`, `visibility`, `completeness`, `recent_photo`, `old_photo`, `timestamp`, `membership_fee`) VALUES
('mahfuz.hman@gmail.com\r\n', 3304, NULL, 'মাহফুজ হাসান ভূইয়া', 'Mahfuz Hasan Bhuiyan', NULL, '18607482525', '92399', 'e10adc3949ba59abbe56e057f20f883e', NULL, 243, NULL, '92399', 'ABDUL MANNAN BHUIYAN', 'HASNA HANA BHUIYAN', 'MARZIA RAHMAN BHUIYAN', '2', 'ENGINEER', 'SENIOR DIRECTOR, IT', NULL, 'B+', NULL, NULL, '11721 GREENBRIER LANE CORAL SPRINGS, FL 33071', NULL, NULL, NULL, NULL, NULL, NULL, '59 BHUIYAN BARI, BANKPARA, GOPALGONJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shafiq92314@gmail.com', 3305, NULL, 'S M Shafiqur Rahman (Litu)', 'S M Shafiqur Rahman (Litu)', NULL, '1730588907', '922055', 'e10adc3949ba59abbe56e057f20f883e', NULL, 244, NULL, '3265611255', 'S M SIDDIQUR RAHMAN', 'KANIZ FATEMA', 'NAHID AKHTER', '2', 'Private Service', 'Marketing Manager', NULL, 'O+', NULL, NULL, 'Apartment#A1, Road# 30, House# 13, Sector#7', NULL, NULL, NULL, NULL, NULL, NULL, 'C/O, S M Siddiqur Rahman. 237 kawla Bazar, Dakhsinkhan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('aminul@pharmaimex.com', 3306, NULL, 'মোঃ আমিনুল ইসলাম', 'MD. AMINUL ISLAM', NULL, '1713067287', '922120', 'e10adc3949ba59abbe56e057f20f883e', NULL, 245, NULL, '3263983375', 'MD. ABDUL GAFUR', 'MONOARA BEGUM', 'FARHANA JAHAN', '3', 'SERVICE', 'DRECTOR', NULL, 'B+', NULL, NULL, '360 EAST GORAN, KHILGAON, DHAKA - 1219', NULL, NULL, NULL, NULL, NULL, NULL, '360 EAST GORAN, KHILGAON, DHAKA - 1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('ferdous1657@gmail.com', 3307, NULL, 'ফেরদৌস ওয়াহিদুল ইসলাম', 'FERDOUS WAHIDUL ISLAM', NULL, '1716713154', '924015', 'e10adc3949ba59abbe56e057f20f883e', NULL, 246, NULL, '5990818188', 'A.Q.M. SHAFIQUL ISLAM', 'SHAMSUN NAHAR ISLAM', 'LABONY KHATUN JAMI', '3', 'MARINE ENGINEER', 'CHIEF ENGINEER', NULL, 'A+', NULL, NULL, 'HOLDING NO - 672, PARNANDUALI MOLLA PARA (OPPOSITE OF JUBO UNNOIN OFFICE MAGURA), DIST - MAGURA-7600', NULL, NULL, NULL, NULL, NULL, NULL, 'HOLDING NO - 672, PARNANDUALI MOLLA PARA (OPPOSITE OF JUBO UNNOIN OFFICE MAGURA), DIST - MAGURA-7600', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('shoab.chow@gmail.com', 3308, NULL, 'মোঃ শোয়েব খান চৌধুরী', 'MD. SHOAB KHAN CHOWDHURY', NULL, '01758 697311', '922135', 'e10adc3949ba59abbe56e057f20f883e', NULL, 247, NULL, NULL, 'MD. AKBAR KHAN CHOWDHURY', 'MRS. AFROZA CHOWDHURY', 'ARMIN ARA JUI', '2', 'BUSINESS', 'MANAGING DIRECTOR', 'ROZTEK LTD.', 'B+', NULL, NULL, '14/21 ASAD ANUE (2ND FLOOR), MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, '578, LALMATIA, BLOCK-B, DHAKA-1207', NULL, NULL, 'NAOGAON', NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('taifur.rahman@ifrc.orgg', 3309, NULL, 'তাইফুর রহমান', 'TAIFUR RAHMAN', NULL, '41792513071', '928401', 'e10adc3949ba59abbe56e057f20f883e', NULL, 248, NULL, '2699501902558', 'MD. ABDUL JABBAR', 'HAZERA BEGUM', 'RUMANA PAREN', '1', 'SERVICE', 'MANAGER, GLOBAL ROAD SAFETY PARTNERSHIP', 'IFRC', 'B+', NULL, NULL, '6 RUE DES LILAS, 1202 GENEVA, SWITZERLAND', NULL, NULL, NULL, NULL, NULL, NULL, 'VILLAGE + P/O. - GHOSHER TIKIKATA, UPAZILA - MATHBARI, DISTRICT - PIROJPUR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('mahfuz5353@gmail.com', 3310, NULL, 'মেজর মোহাম্মদ মাহফুজুল ইসলাম', 'MAJOR MOHAMMAD MAHFUZUL ISLAM', NULL, '1769005353', '924102', 'e10adc3949ba59abbe56e057f20f883e', NULL, 249, NULL, '6898337487', 'LATE A. M. SIRAJUL ISLAM', 'MRS. S. M. DILRUBA JAHAN', 'MAJOR ISRAT MARIA MITU', '1', 'GORNMENT SERVICE', 'MAJOR of BANGLADESH ARMY', NULL, 'A+', NULL, NULL, 'HOUSE # 67, ROAD # 07, SECTOR # 4, UTTARA, DHAKA 1219', NULL, NULL, NULL, NULL, NULL, NULL, 'HOUSE # 67, ROAD # 07, SECTOR # 4, UTTARA, DHAKA 1219', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('tanvirahmedtanu@gmail.com', 3311, NULL, 'তানভির আহমেদ তনু', 'TANVIR AHMED TANU', NULL, '1919826847', '927021', 'e10adc3949ba59abbe56e057f20f883e', NULL, 250, NULL, NULL, 'MESBAH UDDIN AHMED', 'ROKEYA AHMED', NULL, '1', 'BANKER', 'SR. ASSTT. V.P.', NULL, 'B+', NULL, NULL, 'R/23, NURJAHAN ROAD, MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, 'R/23, NURJAHAN ROAD, MOHAMMADPUR, DHAKA-1207', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('salimshimu@gmail.com', 3312, NULL, 'মোঃ সেলিম সিকদার', 'MD. SALIM SIKDER', NULL, '15875007401', '924003', 'e10adc3949ba59abbe56e057f20f883e', NULL, 251, NULL, NULL, 'MD. RAWSHAN ALI SIKDER', 'HOSNE ARA BEGUM', 'SHINTHIA SIKDER', '3', 'CONSTRUCTION ENGINEER', 'ESTIMATOR', NULL, NULL, NULL, NULL, '203E-17725 64th A(NW), TST 239, EDMONTON, ALBERTA, CANADA', NULL, NULL, NULL, NULL, NULL, NULL, '464 ABUL HASNATH ROAD, DHAKA-1100, BANGLADESH', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
(' talha100@yahoo.com', 3313, NULL, 'সাইয়েদ মাহবুব আহমাদ', 'SYED MAHBUB AHMAD', NULL, ' 01713-095433', '927037', 'e10adc3949ba59abbe56e057f20f883e', NULL, 252, NULL, '733 307 2077', 'SYED ABUL KASEM MASUD AHMAD', 'UMMEY KULSUM', 'TAHMINA RAHMAN', '2', 'PRIVATE SERVICE', NULL, NULL, 'O+', NULL, NULL, '24/21, BLOCK-C, TAJMAHAL ROAD, MOHAMMADPUR, DHAKA-1207.', NULL, NULL, NULL, NULL, NULL, NULL, '24/21, BLOCK-C, TAJMAHAL ROAD, MOHAMMADPUR, DHAKA-1207.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('sumonmahbub@hotmail.com', 3314, NULL, 'শেখ সুমন মাহবুব', 'Sheikh Sumon Mahbub', NULL, '1713314444', '924034', 'e10adc3949ba59abbe56e057f20f883e', NULL, 253, NULL, '2.6995E+12', 'Mahbubey Alam', 'Binota Mahbub', NULL, '2', 'Journalism ', NULL, NULL, 'B+', NULL, NULL, 'House no: 1/A, Road No: 1, Sector No: 5, Uttara, Dhaka-1230. ', NULL, NULL, NULL, NULL, NULL, NULL, 'House No: 15, Block No: G, Anue No: 3, Section No: 2, Mirpur, Dhaka-1216', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('drtaner1234@gmail.com', 3315, NULL, NULL, 'Dr.Kazi Tanvir Zaman', NULL, '1745819183', '921098', 'e10adc3949ba59abbe56e057f20f883e', NULL, 254, NULL, '6134578868', 'Kazi Ali', 'Hasina', 'Zinat ara', '1', 'Doctor', 'Registrar (CS)', NULL, 'AB +', NULL, NULL, 'House-17, Road-6, Block-A,Banasree', NULL, NULL, NULL, NULL, NULL, NULL, 'Vill+p.o- Paikkandi, PS-Gopalganj sadar, Dist- Gopalganj', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('zahidul.shabuz@gmail.com', 3316, NULL, NULL, 'Dr. Zahidul Islam Khan', NULL, '1744171717', '921069', 'e10adc3949ba59abbe56e057f20f883e', NULL, 255, NULL, '2.69543E+12', 'Nazrul Islam Khan', 'Suraiya Begum', 'Nazmun Nahar', '3', 'Physician', 'Medical Officer', NULL, 'B+', NULL, NULL, '\"Shaikat Villa\" (2nd floor), 49 South Kamalapur, P.S. Motijheel, P.O. Shantinagar, Dhaka - 1217', NULL, NULL, NULL, NULL, NULL, NULL, '\"Shaikat Villa\" (2nd floor), 49 South Kamalapur, P.S. Motijheel, P.O. Shantinagar, Dhaka - 1217', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1000'),
('shahidruma7@gmail.com', 3317, NULL, NULL, 'Md. Shahidur Rahman Miah', NULL, '1855693902', '929211', 'e10adc3949ba59abbe56e057f20f883e', NULL, 256, NULL, '5082473561', 'Md. Naib Ali Miah', 'Mrs. Salaha Khatun', 'Rumana Talukder', '2', 'SERVICE', 'CHIEF ACCOUNTS OFFICER', NULL, 'O+', NULL, NULL, 'FLAT # B-5, HOUSE # 74, ROAD # 06, BLOCK-A, PALLABI, MIRPUR, DHAKA', NULL, NULL, NULL, NULL, NULL, NULL, 'MIRZAPUR, TANGAIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('parialpur.mim@gmail.com', 3318, NULL, 'আবু হাসনাত মোঃ মোস্তাকিম বারী', 'ABU HASNAT MD MUSTAKIM BARI', NULL, '1714033348', '926046', 'e10adc3949ba59abbe56e057f20f883e', NULL, 257, NULL, '2355813599', 'LATE MD. RAFIQUL BARI CHOWDHURY', 'UMEE MOSTAFA BARI CHOWDHURY', 'MRS. AFSANA MOSTARY CHOWDHURY', '1', 'BANKING SERVICE', 'AVP & BDO MANAGER', NULL, 'O+', NULL, NULL, 'VILL: PARIALPUR, P.O: SETABGANJ, P.S.: BOCHAGANJ, DIST: DINAJPUR.', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: PARIALPUR, P.O: SETABGANJ, P.S.: BOCHAGANJ, DIST: DINAJPUR.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('s-islambd@hotmail.com', 3319, NULL, 'কে এম সাইফুল ইসলাম', 'KM Saiful Islam', NULL, '1711612777', '922002', 'e10adc3949ba59abbe56e057f20f883e', NULL, 258, NULL, '8682084572', 'KM Sahidul Alam', 'Jonne ara alam', 'Dr Farzana Yasmin', '2', 'Doctor', 'Laparoscopic & colorectal surgeon.', NULL, 'B+ ', NULL, NULL, 'H/ N: 75, R/ N : 11/A, Dhanmondi', NULL, NULL, NULL, NULL, NULL, NULL, 'H/N: 257, Block- C, Khilgaon', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, '1020'),
('ahsanbapex@gmail.com', 3320, NULL, 'প্রকৌঃ মোহাম্মদ আহসানুল আমিন', 'Engr. Mohammad Ahsanul Amin', NULL, '1716059349', '921121', 'e10adc3949ba59abbe56e057f20f883e', NULL, 259, NULL, '7798254608', 'Md. Ruhul Amin', 'Anowora Khatoon', 'Al Sabiha Sattar', '3', 'Govt. Services', 'Deputy General Manager (ICT) & Project Manager', NULL, 'A+', NULL, NULL, 'BAPEX Bhaban, 4 Kawran Bazar C/A, Dhaka', NULL, NULL, NULL, NULL, NULL, NULL, 'B-36 Eastern Housing Project, Konapara, Dhaka-1362', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, 'Payment made soon'),
('abmsajjadh@gmail.com', 3321, NULL, NULL, 'ABM SAJJAD HUSSAIN', NULL, '1979552017', '928315', 'e10adc3949ba59abbe56e057f20f883e', NULL, 260, NULL, '2.61188E+12', 'ABM SEKANDER HUSSAIN', 'RAHIMA SEKANDER', 'FAHMINA HUSSAIN JOLLY', '2', 'BUSINESS', 'PROPRIETOR', NULL, 'B+', NULL, NULL, 'CHAKLADER BHABAN, H-356/1, (3RD FLOOR, EAST SIDE), MODHUBAGH, MOGHBAZAR, HATIRJHEEL, DHAKA - 1217', NULL, NULL, NULL, NULL, NULL, NULL, 'VILL: WEST SUTERPARA, ROAD - HALLER BAZAR ROAD, P.O. - DOHAR, P.S. - DOHAR, DIST: DHAKA-1330', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, NULL),
('tariqul@ukm.edu.my', 3322, NULL, NULL, 'MOHAMMAD TARQIUL ISLAM', NULL, '1742750833', '924052', 'e10adc3949ba59abbe56e057f20f883e', NULL, 261, NULL, '8705280736', 'MD SHOHIDULLAH', 'MEHERUNNESA', 'FARHA TABASSUM', '2', 'UNIRSITY PROFESSOR', 'PROFESSOR', NULL, '0+', NULL, NULL, '1/38/3 East Basaboo, Dhaka -1214', NULL, NULL, NULL, NULL, NULL, NULL, '1/38/3 East Basaboo, Dhaka -1214', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'user', NULL, NULL, 'not_set', 'not_set', NULL, 'Already paid'),
('riyad298@gmail.com', 3323, NULL, NULL, 'Riyad Ahsan', NULL, '1742750833', '924052', 'e10adc3949ba59abbe56e057f20f883e', NULL, 0, NULL, '8705280736', 'MD SHOHIDULLAH', 'MEHERUNNESA', 'FARHA TABASSUM', '2', 'UNIRSITY PROFESSOR', 'PROFESSOR', NULL, '0+', NULL, NULL, '1/38/3 East Basaboo, Dhaka -1214', NULL, NULL, NULL, NULL, NULL, NULL, '1/38/3 East Basaboo, Dhaka -1214', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', '1234', 'approved', 'not_verified', 'not_requested', NULL, 'admin', NULL, NULL, 'not_set', 'not_set', NULL, 'Already paid');

-- --------------------------------------------------------

--
-- Table structure for table `childrens_info`
--

CREATE TABLE `childrens_info` (
  `id` int(200) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `no` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `gender` varchar(200) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `data_log`
--

CREATE TABLE `data_log` (
  `id` int(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `timestamp` timestamp(6) NULL DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `name_bangla` varchar(100) DEFAULT NULL,
  `institution_id` varchar(100) DEFAULT NULL,
  `mobile` varchar(100) DEFAULT NULL,
  `nid_or_passport` varchar(100) DEFAULT NULL,
  `blood_group` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `fathers_name` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `spouse_name` varchar(100) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `present_line1` varchar(100) DEFAULT NULL,
  `present_line2` varchar(100) DEFAULT NULL,
  `present_district` varchar(100) DEFAULT NULL,
  `present_police_station` varchar(100) DEFAULT NULL,
  `present_post_office_name` varchar(100) DEFAULT NULL,
  `present_post_code` varchar(100) DEFAULT NULL,
  `present_country` varchar(100) DEFAULT NULL,
  `parmanent_line1` varchar(100) DEFAULT NULL,
  `parmanent_line2` varchar(100) DEFAULT NULL,
  `parmanent_police_station` varchar(100) DEFAULT NULL,
  `parmanent_district` varchar(100) DEFAULT NULL,
  `parmanent_post_office_name` varchar(100) DEFAULT NULL,
  `parmanent_post_code` varchar(100) DEFAULT NULL,
  `parmanent_country` varchar(100) DEFAULT NULL,
  `number_of_children` int(10) DEFAULT NULL,
  `profession` varchar(50) DEFAULT NULL,
  `institution` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `data_log`
--

INSERT INTO `data_log` (`id`, `email`, `timestamp`, `first_name`, `last_name`, `name_bangla`, `institution_id`, `mobile`, `nid_or_passport`, `blood_group`, `date_of_birth`, `fathers_name`, `mother_name`, `spouse_name`, `religion`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `number_of_children`, `profession`, `institution`, `designation`) VALUES
(1764, 'noblesoma@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1765, 'mukul_74@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1766, 'reliance.eng.bd@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1767, 'quamrul.m@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1768, 'dip30th@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1769, 'valenTinep80@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1770, '1930040628', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1771, 'rinsarker@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1772, 'edwinranjan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1773, 'monarchtradingbd@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1774, 'asif686947@gmail.com, asif@pragatiinsurance.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1775, 'awayform99@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1776, 'mabashar1975@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1777, 'tarazia@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1778, '1962418325', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1779, 'rahmanimtiazur@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1780, 'mhsohel@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1781, 'harunbiman2014@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1782, 'lithu2116@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1783, 'akdsagar@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1784, 'bablupb2007@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1785, 'asifhchy@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1786, 'shaiful@larougefashions.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1787, 'anisur_74@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1788, 'cosmosgiftgalleey@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1789, 'aaishltd@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1790, 'kiransun2003@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1791, 'zpsukhan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1792, 'nadimbd2000@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1793, 'azgar07@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1794, 'forkan4961@yahoo.cpm', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1795, 'smaruf.habib@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1796, 'syed.fatema@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1797, 'abdullahalam71@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1798, 'mizanur.rahman@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1799, 'riponkumarroy@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1800, 'anmziaulislam@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1801, 'mamun161275@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1802, 'manir90@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1803, 'sajol74@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1804, '1715703316', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1805, 'rokonsikder26@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1806, 'taponrozario2015@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1807, 'tponigues73@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1808, 'kashem@silvapharma.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1809, 'oliullah.caab@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1810, 'mohmmadmahboobkhan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1811, 'shibuk50dmc@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1812, 'uzzwalc@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1813, 'titas75@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1814, 'zahirdhaka@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1815, 'afmperz@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1816, 'ripon_1405_2006_@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1817, 'edward@ctimpex.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1818, 'mukbulurmustazir@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1819, 'adv.avimallick@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1820, 'zana251205@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1821, 'mnislam76@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1822, 'luajfaisal@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1823, 'kabir.mithu@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1824, 'hasan.sarwardi@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1825, '1711568688', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1826, 'mahmud.hosain@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1827, 'joshuaflight@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1828, 'mamun@mtrixs.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1829, 'mahbubhtl@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1830, 'touhid.irfan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1831, 'md.shafiq1174@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1832, 'smgferdous@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1833, 'mohibur_tauhid@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1834, 'anwarulghani@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1835, 'smbabar07@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1836, 'ainulh5@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1837, 'azizur31bh@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1838, 'zakir.khan@dewhirst.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1839, 'rashek_750@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1840, 'sajalmmc@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1841, 'dr_abu_obaida@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1842, 'drmnh2003@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1843, 'shibabadc@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1844, 'manzur_hossain@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1845, 'sumon2376@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1846, 'ariful.islam@metlife.com.bd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1847, 'mirza927043@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1848, 'nasimulhyder@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1849, 'rassel007@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1850, 'saif5163@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1851, 'sah@dem.dk', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1852, 'dr.mahbub@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1853, 'shohag_bcsrr@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1854, 'ashrafahammed1974@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1855, 'mushriq2007@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1856, '921116', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1857, 'arifur@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1858, 'mizandtex@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1859, 'mrahmanmukul_@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1860, 'rafiqul_dream@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1861, 'iqbalasif1975@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1862, 'shahidurosmani@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1863, '1740907288', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1864, 'dmrh2010@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1865, 'sanowar75@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1866, 'mehedimasud@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1867, 'hedayeta@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1868, 'a.kabirripon@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1869, 'chapal010805@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1870, 'enampwd@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1871, 'ashokadsita@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1872, '1711149583', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1873, '1715044474', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1874, 'zrkhanbuet@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1875, 'tanvir.ibrahim@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1876, 'quamruladmn@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1877, 'djoybd@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1878, 'jhammituhin@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1879, 'hmmnpol@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1880, 'syedshukurali@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1881, 'mahfuzsujan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1882, 'maksudursohel@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1883, 'zhr1111@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1884, 'sghose74@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1885, 'juwelthermax@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1886, 'zulker@braincabin.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1887, 'sthissue@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1888, 'mrbinkamal@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1889, 'ashiq25bd@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1890, 'hanurrrashosagar74@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1891, 'reazimam@safiaappmels.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1892, '1716191504', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1893, 'obaidulhm@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1894, '927033', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1895, 'eakhwanimpex@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1896, 'javaalsikder@meghnagroup.biz', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1897, 'abbujan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1898, 'boshirul.haque74@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1899, 'r_faizur1@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1900, '926049', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1901, 'srsazu@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1902, 'badrul_um@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1903, 'ashishsarker@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1904, 'Khokoncom@gmail.Com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1905, 'tikzhasan@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1906, 'atiqzaman25121975@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1907, 'nazmul.haq@bb.org.bd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1908, 'nasiddiqui.bpdb@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1909, 'm.asarker@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1910, 'bsrimunir@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1911, 'anisur.rahman38@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1912, 'tomal14bd@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1913, 'abdulgofur068877@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1914, 'jahid.13s@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1915, 'babujhuma92@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1916, 'noorsayeed29@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1917, '1717147011', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1918, 'hasandhali@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1919, 'oe74@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1920, 'shawonfcma@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1921, 'sayed13143@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1922, 'shamim77bd@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1923, 'mokammelh@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1924, 'saifulpr@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1925, 'mogaronkdnlsl@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1926, 'aminulm30@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1927, 'mushfiq@thakral-bd.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1928, 'asad.goldsmiths@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1929, 'zaman.shams@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1930, 'awbariuk@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1931, 'ruponroy@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1932, '929072', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1933, 'SAROJKNATH@YAHOO.COM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1934, 'ahadadmn@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1935, 'samad359292@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1936, 'litongomes51@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1937, '1839979152', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1938, '8.8182E+12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1939, 'tansif@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1940, 'hmshah76@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1941, '928', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1942, 'd.c.baroi836@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1943, 'asdcoasta@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1944, 'anupam.uos@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1945, 'rbsattar@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1946, 'mehaboobkabir2015@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1947, 'shahnewaz1124@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1948, 'rezaul.hassan@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1949, 'shahednsu@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1950, 'sabbir_doc@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1951, 'ifti12bd@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1952, '1715615225', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1953, 'khossain2010@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1954, 'tipu@gvfashion-asia.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1955, 'prodip2076@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1956, 'mehalashki@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1957, 'ashiqur.rahman2701@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1958, 'mostafaaim@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1959, 'majabbar968@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1960, 'pallab010176@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1961, 'csabeg@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1962, 'mithubiswas015@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1963, '8.8182E+12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1964, 'donny511r@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1965, 'kbdalamin@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1966, 'taneemaziz@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1967, 'saiful.hamid72@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1968, 'mahossain1375@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1969, 'ashiqzahin@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1970, 'pial44@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1971, 'mazaman1727s@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1972, 'MOFASSEL@GMAIL.COM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1973, 'salahuddin02/2@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1974, 'shubharthi@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1975, 'roybk1973@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1976, 'Ahmedmonsur@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1977, 'milton.peris@kochne-nagel.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1978, 'panna.peris@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1979, 'james.collins@juati-bd.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1980, '1819140593', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1981, 'azim51800@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1982, '1714164894', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1983, 'saifunnobu@purelabbd.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1984, 'tanviron200975@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1985, 'waekram@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1986, 'reaz5233@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1987, 'romel2356@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1988, 'mkrsagor43@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1989, 'milton.rozario@gmail.com, milton.rozari@thecitybank.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1990, 'muhammadarifrahman@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1991, '1711200088', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `data_log` (`id`, `email`, `timestamp`, `first_name`, `last_name`, `name_bangla`, `institution_id`, `mobile`, `nid_or_passport`, `blood_group`, `date_of_birth`, `fathers_name`, `mother_name`, `spouse_name`, `religion`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `number_of_children`, `profession`, `institution`, `designation`) VALUES
(1992, 'ishakpro@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1993, 'gmg.mostafa@siamcitycement.com, gmg.mostafa@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1994, 'soumit74@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1995, 'amar19moner73@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1996, 'lumanear@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1997, 'kledrikbipul@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1998, 'kabir5329@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(1999, 'arif7875@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2000, 'drashnafcmc@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2001, 'akader511@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2002, '928363', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2003, 'sazzad54us@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2004, 'shawkat789@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2005, 'drmuradmp2041@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2006, 'mahfuz.hman@gmail.com\r\n', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2007, 'shafiq92314@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2008, 'aminul@pharmaimex.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2009, 'ferdous1657@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2010, 'shoab.chow@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2011, 'taifur.rahman@ifrc.orgg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2012, 'mahfuz5353@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2013, 'tanvirahmedtanu@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2014, 'salimshimu@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2015, ' talha100@yahoo.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2016, 'sumonmahbub@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2017, 'drtaner1234@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2018, 'zahidul.shabuz@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2019, 'shahidruma7@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2020, 'parialpur.mim@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2021, 's-islambd@hotmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2022, 'ahsanbapex@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2023, 'abmsajjadh@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2024, 'tariqul@ukm.edu.my', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2025, 'riyad298@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `id` int(100) NOT NULL,
  `name` varchar(500) NOT NULL,
  `timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `form_fields_rule`
--

CREATE TABLE `form_fields_rule` (
  `id_form_field` int(200) NOT NULL,
  `field_name` varchar(200) DEFAULT NULL,
  `rule` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `form_fields_rule`
--

INSERT INTO `form_fields_rule` (`id_form_field`, `field_name`, `rule`) VALUES
(20, 'nid_or_passport_validity', 'mandatory'),
(21, 'blood_group_validity', 'mandatory'),
(22, 'religion_validity', 'mandatory'),
(23, 'date_of_birth_validity', 'optional'),
(24, 'fathers_name_validity', 'mandatory'),
(25, 'spouses_name_validity', 'mandatory'),
(26, 'number_of_children_validity', 'mandatory'),
(27, 'profession_validity', 'mandatory'),
(28, 'workplace_or_institution_validity', 'optional'),
(30, 'profession_validity', 'mandatory'),
(31, 'designation_validity', 'mandatory');

-- --------------------------------------------------------

--
-- Table structure for table `privacy`
--

CREATE TABLE `privacy` (
  `id` int(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `timestamp` timestamp(6) NULL DEFAULT NULL,
  `first_name` tinyint(1) DEFAULT 1,
  `last_name` tinyint(1) DEFAULT 1,
  `name_bangla` tinyint(1) DEFAULT 1,
  `institution_id` tinyint(1) DEFAULT 1,
  `mobile` tinyint(1) DEFAULT 0,
  `nid_or_passport` tinyint(1) DEFAULT 0,
  `blood_group` tinyint(1) DEFAULT 0,
  `date_of_birth` tinyint(1) DEFAULT 0,
  `fathers_name` tinyint(1) DEFAULT 0,
  `mother_name` tinyint(1) DEFAULT 0,
  `spouse_name` tinyint(1) DEFAULT 0,
  `present_line1` tinyint(1) DEFAULT 0,
  `present_line2` tinyint(1) DEFAULT 0,
  `present_district` tinyint(1) DEFAULT 0,
  `present_police_station` tinyint(1) DEFAULT 0,
  `present_post_office_name` tinyint(1) DEFAULT 0,
  `present_post_code` tinyint(1) DEFAULT 0,
  `present_country` tinyint(1) DEFAULT 0,
  `parmanent_line1` tinyint(1) DEFAULT 0,
  `parmanent_line2` tinyint(1) DEFAULT 0,
  `parmanent_police_station` tinyint(1) DEFAULT 0,
  `parmanent_district` tinyint(1) DEFAULT 0,
  `parmanent_post_office_name` tinyint(1) DEFAULT 0,
  `parmanent_post_code` tinyint(1) DEFAULT 0,
  `parmanent_country` tinyint(1) DEFAULT 0,
  `membership_number` tinyint(1) DEFAULT 0,
  `gender` tinyint(1) DEFAULT 0,
  `number_of_children` tinyint(1) DEFAULT 0,
  `profession` tinyint(1) DEFAULT 0,
  `designation` tinyint(1) DEFAULT 0,
  `institution` tinyint(1) DEFAULT 0,
  `religion` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `change_request` tinyint(1) NOT NULL DEFAULT 0,
  `social_network` tinyint(1) NOT NULL DEFAULT 0,
  `membership_fee` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `privacy`
--

INSERT INTO `privacy` (`id`, `email`, `timestamp`, `first_name`, `last_name`, `name_bangla`, `institution_id`, `mobile`, `nid_or_passport`, `blood_group`, `date_of_birth`, `fathers_name`, `mother_name`, `spouse_name`, `present_line1`, `present_line2`, `present_district`, `present_police_station`, `present_post_office_name`, `present_post_code`, `present_country`, `parmanent_line1`, `parmanent_line2`, `parmanent_police_station`, `parmanent_district`, `parmanent_post_office_name`, `parmanent_post_code`, `parmanent_country`, `membership_number`, `gender`, `number_of_children`, `profession`, `designation`, `institution`, `religion`, `status`, `type`, `change_request`, `social_network`, `membership_fee`) VALUES
(1764, 'noblesoma@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1765, 'mukul_74@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1766, 'reliance.eng.bd@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1767, 'quamrul.m@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1768, 'dip30th@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1769, 'valenTinep80@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1770, '1930040628', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1771, 'rinsarker@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1772, 'edwinranjan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1773, 'monarchtradingbd@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1774, 'asif686947@gmail.com, asif@pragatiinsurance.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1775, 'awayform99@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1776, 'mabashar1975@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1777, 'tarazia@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1778, '1962418325', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1779, 'rahmanimtiazur@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1780, 'mhsohel@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1781, 'harunbiman2014@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1782, 'lithu2116@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1783, 'akdsagar@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1784, 'bablupb2007@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1785, 'asifhchy@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1786, 'shaiful@larougefashions.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1787, 'anisur_74@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1788, 'cosmosgiftgalleey@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1789, 'aaishltd@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1790, 'kiransun2003@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1791, 'zpsukhan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1792, 'nadimbd2000@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1793, 'azgar07@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1794, 'forkan4961@yahoo.cpm', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1795, 'smaruf.habib@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1796, 'syed.fatema@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1797, 'abdullahalam71@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1798, 'mizanur.rahman@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1799, 'riponkumarroy@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1800, 'anmziaulislam@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1801, 'mamun161275@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1802, 'manir90@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1803, 'sajol74@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1804, '1715703316', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1805, 'rokonsikder26@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1806, 'taponrozario2015@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1807, 'tponigues73@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1808, 'kashem@silvapharma.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1809, 'oliullah.caab@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1810, 'mohmmadmahboobkhan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1811, 'shibuk50dmc@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1812, 'uzzwalc@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1813, 'titas75@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1814, 'zahirdhaka@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1815, 'afmperz@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1816, 'ripon_1405_2006_@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1817, 'edward@ctimpex.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1818, 'mukbulurmustazir@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1819, 'adv.avimallick@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1820, 'zana251205@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1821, 'mnislam76@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1822, 'luajfaisal@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1823, 'kabir.mithu@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1824, 'hasan.sarwardi@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1825, '1711568688', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1826, 'mahmud.hosain@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1827, 'joshuaflight@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1828, 'mamun@mtrixs.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1829, 'mahbubhtl@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1830, 'touhid.irfan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1831, 'md.shafiq1174@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1832, 'smgferdous@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1833, 'mohibur_tauhid@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1834, 'anwarulghani@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1835, 'smbabar07@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1836, 'ainulh5@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1837, 'azizur31bh@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1838, 'zakir.khan@dewhirst.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1839, 'rashek_750@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1840, 'sajalmmc@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1841, 'dr_abu_obaida@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1842, 'drmnh2003@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1843, 'shibabadc@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1844, 'manzur_hossain@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1845, 'sumon2376@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1846, 'ariful.islam@metlife.com.bd', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1847, 'mirza927043@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1848, 'nasimulhyder@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1849, 'rassel007@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1850, 'saif5163@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1851, 'sah@dem.dk', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1852, 'dr.mahbub@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1853, 'shohag_bcsrr@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1854, 'ashrafahammed1974@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1855, 'mushriq2007@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1856, '921116', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1857, 'arifur@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1858, 'mizandtex@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1859, 'mrahmanmukul_@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1860, 'rafiqul_dream@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1861, 'iqbalasif1975@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1862, 'shahidurosmani@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1863, '1740907288', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1864, 'dmrh2010@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1865, 'sanowar75@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1866, 'mehedimasud@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1867, 'hedayeta@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1868, 'a.kabirripon@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1869, 'chapal010805@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1870, 'enampwd@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1871, 'ashokadsita@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1872, '1711149583', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1873, '1715044474', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1874, 'zrkhanbuet@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1875, 'tanvir.ibrahim@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1876, 'quamruladmn@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1877, 'djoybd@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1878, 'jhammituhin@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1879, 'hmmnpol@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1880, 'syedshukurali@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1881, 'mahfuzsujan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1882, 'maksudursohel@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1883, 'zhr1111@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1884, 'sghose74@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1885, 'juwelthermax@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1886, 'zulker@braincabin.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1887, 'sthissue@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1888, 'mrbinkamal@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1889, 'ashiq25bd@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1890, 'hanurrrashosagar74@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1891, 'reazimam@safiaappmels.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1892, '1716191504', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1893, 'obaidulhm@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1894, '927033', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1895, 'eakhwanimpex@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1896, 'javaalsikder@meghnagroup.biz', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1897, 'abbujan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1898, 'boshirul.haque74@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1899, 'r_faizur1@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1900, '926049', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1901, 'srsazu@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1902, 'badrul_um@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1903, 'ashishsarker@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1904, 'Khokoncom@gmail.Com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1905, 'tikzhasan@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1906, 'atiqzaman25121975@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1907, 'nazmul.haq@bb.org.bd', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1908, 'nasiddiqui.bpdb@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1909, 'm.asarker@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1910, 'bsrimunir@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1911, 'anisur.rahman38@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1912, 'tomal14bd@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1913, 'abdulgofur068877@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1914, 'jahid.13s@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1915, 'babujhuma92@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1916, 'noorsayeed29@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1917, '1717147011', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1918, 'hasandhali@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1919, 'oe74@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1920, 'shawonfcma@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1921, 'sayed13143@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1922, 'shamim77bd@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1923, 'mokammelh@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1924, 'saifulpr@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1925, 'mogaronkdnlsl@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1926, 'aminulm30@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1927, 'mushfiq@thakral-bd.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1928, 'asad.goldsmiths@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1929, 'zaman.shams@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1930, 'awbariuk@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1931, 'ruponroy@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1932, '929072', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1933, 'SAROJKNATH@YAHOO.COM', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1934, 'ahadadmn@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1935, 'samad359292@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1936, 'litongomes51@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1937, '1839979152', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1938, '8.8182E+12', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1939, 'tansif@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1940, 'hmshah76@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1941, '928', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1942, 'd.c.baroi836@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1943, 'asdcoasta@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1944, 'anupam.uos@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1945, 'rbsattar@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1946, 'mehaboobkabir2015@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1947, 'shahnewaz1124@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1948, 'rezaul.hassan@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1949, 'shahednsu@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1950, 'sabbir_doc@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1951, 'ifti12bd@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1952, '1715615225', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1953, 'khossain2010@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1954, 'tipu@gvfashion-asia.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1955, 'prodip2076@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1956, 'mehalashki@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1957, 'ashiqur.rahman2701@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1958, 'mostafaaim@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1959, 'majabbar968@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1960, 'pallab010176@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1961, 'csabeg@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1962, 'mithubiswas015@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1963, '8.8182E+12', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1964, 'donny511r@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1965, 'kbdalamin@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1966, 'taneemaziz@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1967, 'saiful.hamid72@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1968, 'mahossain1375@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1969, 'ashiqzahin@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1970, 'pial44@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1971, 'mazaman1727s@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1972, 'MOFASSEL@GMAIL.COM', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1973, 'salahuddin02/2@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1974, 'shubharthi@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1975, 'roybk1973@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1976, 'Ahmedmonsur@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1977, 'milton.peris@kochne-nagel.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1978, 'panna.peris@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1979, 'james.collins@juati-bd.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1980, '1819140593', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1981, 'azim51800@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1982, '1714164894', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1983, 'saifunnobu@purelabbd.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1984, 'tanviron200975@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1985, 'waekram@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1986, 'reaz5233@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1987, 'romel2356@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1988, 'mkrsagor43@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1989, 'milton.rozario@gmail.com, milton.rozari@thecitybank.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1990, 'muhammadarifrahman@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1991, '1711200088', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1992, 'ishakpro@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1993, 'gmg.mostafa@siamcitycement.com, gmg.mostafa@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1994, 'soumit74@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1995, 'amar19moner73@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1996, 'lumanear@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1997, 'kledrikbipul@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1998, 'kabir5329@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1999, 'arif7875@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2000, 'drashnafcmc@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2001, 'akader511@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2002, '928363', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2003, 'sazzad54us@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2004, 'shawkat789@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2005, 'drmuradmp2041@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2006, 'mahfuz.hman@gmail.com\r\n', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2007, 'shafiq92314@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2008, 'aminul@pharmaimex.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2009, 'ferdous1657@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2010, 'shoab.chow@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2011, 'taifur.rahman@ifrc.orgg', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2012, 'mahfuz5353@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2013, 'tanvirahmedtanu@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2014, 'salimshimu@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2015, ' talha100@yahoo.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2016, 'sumonmahbub@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2017, 'drtaner1234@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2018, 'zahidul.shabuz@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2019, 'shahidruma7@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2020, 'parialpur.mim@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2021, 's-islambd@hotmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2022, 'ahsanbapex@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2023, 'abmsajjadh@gmail.com', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2024, 'tariqul@ukm.edu.my', NULL, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2025, 'riyad298@gmail.com', NULL, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `social_network`
--

CREATE TABLE `social_network` (
  `id` int(200) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `media_name` varchar(200) DEFAULT NULL,
  `profile_name` varchar(200) DEFAULT NULL,
  `profile_link` varchar(500) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `users_address`
-- (See below for the actual view)
--
CREATE TABLE `users_address` (
`id` int(100)
,`email` varchar(100)
,`present_line1` varchar(300)
,`present_line2` varchar(300)
,`present_district` varchar(100)
,`present_police_station` varchar(200)
,`present_post_office_name` varchar(200)
,`present_post_code` varchar(100)
,`present_country` varchar(100)
,`parmanent_line1` varchar(300)
,`parmanent_line2` varchar(300)
,`parmanent_police_station` varchar(200)
,`parmanent_district` varchar(100)
,`parmanent_post_office_name` varchar(200)
,`parmanent_post_code` varchar(100)
,`parmanent_country` varchar(100)
,`second_citizenship_country` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `users_info`
-- (See below for the actual view)
--
CREATE TABLE `users_info` (
`id` int(100)
,`email` varchar(100)
,`gender` varchar(100)
,`nid_or_passport` varchar(100)
,`fathers_name` varchar(100)
,`mother_name` varchar(100)
,`spouse_name` varchar(100)
,`number_of_children` varchar(100)
,`profession` varchar(100)
,`designation` varchar(100)
,`institution` varchar(100)
,`blood_group` varchar(10)
,`date_of_birth` date
,`religion` varchar(200)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `users_registration`
-- (See below for the actual view)
--
CREATE TABLE `users_registration` (
`id` int(100)
,`email` varchar(100)
,`full_name` varchar(100)
,`first_name` varchar(200)
,`last_name` varchar(100)
,`mobile` varchar(200)
,`institution_id` varchar(100)
,`password` varchar(500)
,`registration_date` datetime(6)
,`membership_number` int(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `user_photos`
--

CREATE TABLE `user_photos` (
  `group_photo` varchar(400) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `id_user_photos` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_uploads`
-- (See below for the actual view)
--
CREATE TABLE `user_uploads` (
`id` int(100)
,`email` varchar(100)
,`recent_photo` varchar(400)
,`old_photo` varchar(400)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `verification_info`
-- (See below for the actual view)
--
CREATE TABLE `verification_info` (
`id` int(100)
,`email` varchar(100)
,`otp` varchar(100)
,`forgot_password_crypto` varchar(500)
,`status` varchar(20)
,`email_verification_status` varchar(100)
,`change_request` varchar(100)
,`change_request_time` datetime(6)
,`type` varchar(20)
,`visibility` varchar(1000)
,`completeness` varchar(10)
);

-- --------------------------------------------------------

--
-- Structure for view `users_address`
--
DROP TABLE IF EXISTS `users_address`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `users_address`  AS  select `all_info_together`.`id` AS `id`,`all_info_together`.`email` AS `email`,`all_info_together`.`present_line1` AS `present_line1`,`all_info_together`.`present_line2` AS `present_line2`,`all_info_together`.`present_district` AS `present_district`,`all_info_together`.`present_police_station` AS `present_police_station`,`all_info_together`.`present_post_office_name` AS `present_post_office_name`,`all_info_together`.`present_post_code` AS `present_post_code`,`all_info_together`.`present_country` AS `present_country`,`all_info_together`.`parmanent_line1` AS `parmanent_line1`,`all_info_together`.`parmanent_line2` AS `parmanent_line2`,`all_info_together`.`parmanent_police_station` AS `parmanent_police_station`,`all_info_together`.`parmanent_district` AS `parmanent_district`,`all_info_together`.`parmanent_post_office_name` AS `parmanent_post_office_name`,`all_info_together`.`parmanent_post_code` AS `parmanent_post_code`,`all_info_together`.`parmanent_country` AS `parmanent_country`,`all_info_together`.`second_citizenship_country` AS `second_citizenship_country` from `all_info_together` ;

-- --------------------------------------------------------

--
-- Structure for view `users_info`
--
DROP TABLE IF EXISTS `users_info`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `users_info`  AS  select `all_info_together`.`id` AS `id`,`all_info_together`.`email` AS `email`,`all_info_together`.`gender` AS `gender`,`all_info_together`.`nid_or_passport` AS `nid_or_passport`,`all_info_together`.`fathers_name` AS `fathers_name`,`all_info_together`.`mother_name` AS `mother_name`,`all_info_together`.`spouse_name` AS `spouse_name`,`all_info_together`.`number_of_children` AS `number_of_children`,`all_info_together`.`profession` AS `profession`,`all_info_together`.`designation` AS `designation`,`all_info_together`.`institution` AS `institution`,`all_info_together`.`blood_group` AS `blood_group`,`all_info_together`.`date_of_birth` AS `date_of_birth`,`all_info_together`.`religion` AS `religion` from `all_info_together` ;

-- --------------------------------------------------------

--
-- Structure for view `users_registration`
--
DROP TABLE IF EXISTS `users_registration`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `users_registration`  AS  select `all_info_together`.`id` AS `id`,`all_info_together`.`email` AS `email`,`all_info_together`.`full_name` AS `full_name`,`all_info_together`.`name_bangla` AS `first_name`,`all_info_together`.`last_name` AS `last_name`,`all_info_together`.`mobile` AS `mobile`,`all_info_together`.`institution_id` AS `institution_id`,`all_info_together`.`password` AS `password`,`all_info_together`.`registration_date` AS `registration_date`,`all_info_together`.`membership_number` AS `membership_number` from `all_info_together` ;

-- --------------------------------------------------------

--
-- Structure for view `user_uploads`
--
DROP TABLE IF EXISTS `user_uploads`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `user_uploads`  AS  select `all_info_together`.`id` AS `id`,`all_info_together`.`email` AS `email`,`all_info_together`.`recent_photo` AS `recent_photo`,`all_info_together`.`old_photo` AS `old_photo` from `all_info_together` ;

-- --------------------------------------------------------

--
-- Structure for view `verification_info`
--
DROP TABLE IF EXISTS `verification_info`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `verification_info`  AS  select `all_info_together`.`id` AS `id`,`all_info_together`.`email` AS `email`,`all_info_together`.`otp` AS `otp`,`all_info_together`.`forgot_password_crypto` AS `forgot_password_crypto`,`all_info_together`.`status` AS `status`,`all_info_together`.`email_verification_status` AS `email_verification_status`,`all_info_together`.`change_request` AS `change_request`,`all_info_together`.`change_request_time` AS `change_request_time`,`all_info_together`.`type` AS `type`,`all_info_together`.`visibility` AS `visibility`,`all_info_together`.`completeness` AS `completeness` from `all_info_together` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_options`
--
ALTER TABLE `admin_options`
  ADD PRIMARY KEY (`admin_options_id`);

--
-- Indexes for table `all_info_together`
--
ALTER TABLE `all_info_together`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `childrens_info`
--
ALTER TABLE `childrens_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `data_log`
--
ALTER TABLE `data_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `form_fields_rule`
--
ALTER TABLE `form_fields_rule`
  ADD PRIMARY KEY (`id_form_field`);

--
-- Indexes for table `privacy`
--
ALTER TABLE `privacy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `social_network`
--
ALTER TABLE `social_network`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_photos`
--
ALTER TABLE `user_photos`
  ADD PRIMARY KEY (`id_user_photos`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_options`
--
ALTER TABLE `admin_options`
  MODIFY `admin_options_id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `all_info_together`
--
ALTER TABLE `all_info_together`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3324;

--
-- AUTO_INCREMENT for table `childrens_info`
--
ALTER TABLE `childrens_info`
  MODIFY `id` int(200) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `data_log`
--
ALTER TABLE `data_log`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2026;

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_fields_rule`
--
ALTER TABLE `form_fields_rule`
  MODIFY `id_form_field` int(200) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `privacy`
--
ALTER TABLE `privacy`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2026;

--
-- AUTO_INCREMENT for table `social_network`
--
ALTER TABLE `social_network`
  MODIFY `id` int(200) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_photos`
--
ALTER TABLE `user_photos`
  MODIFY `id_user_photos` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
