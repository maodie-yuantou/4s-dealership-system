-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: project1
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `project1`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `project1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `project1`;

--
-- Table structure for table `accident_report`
--

DROP TABLE IF EXISTS `accident_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accident_report` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `report_no` varchar(30) NOT NULL,
  `customer_id` bigint NOT NULL,
  `vehicle_id` bigint DEFAULT NULL,
  `accident_time` datetime DEFAULT NULL,
  `accident_location` varchar(200) DEFAULT '',
  `accident_type` varchar(30) DEFAULT '' COMMENT 'COLLISION/SCRATCH/REAR_END/OTHER',
  `description` text,
  `damage_images` text COMMENT 'æŸä¼¤ç…§ç‰‡JSONæ•°ç»„',
  `insurance_claimed` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦å·²æŠ¥ä¿é™©',
  `insurance_claim_no` varchar(50) DEFAULT '',
  `status` varchar(20) DEFAULT 'REPORTED' COMMENT 'REPORTED/CONFIRMED/INSPECTING/REPAIRING/COMPLETED',
  `work_order_id` bigint DEFAULT NULL COMMENT 'å…³è”ç»´ä¿®å·¥å•',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_no` (`report_no`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='äº‹æ•…æŠ¥æ¡ˆè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accident_report`
--

LOCK TABLES `accident_report` WRITE;
/*!40000 ALTER TABLE `accident_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `accident_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_chat_history`
--

DROP TABLE IF EXISTS `ai_chat_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_chat_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_id` varchar(50) NOT NULL COMMENT 'ä¼šè¯ID',
  `customer_id` bigint DEFAULT NULL,
  `role` varchar(10) NOT NULL COMMENT 'USER/AI/SYSTEM',
  `content` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIèŠå¤©åŽ†å²è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_chat_history`
--

LOCK TABLES `ai_chat_history` WRITE;
/*!40000 ALTER TABLE `ai_chat_history` DISABLE KEYS */;
INSERT INTO `ai_chat_history` VALUES (1,'test-002',1,'USER','???????','2026-05-28 01:25:37'),(2,'test-002',1,'AI','您好！我是润达4S店的智能客服小润，很高兴为您服务！请问有什么可以帮您的吗？无论是购车咨询、保养预约，还是门店信息，我都能为您解答哦！😊','2026-05-28 01:25:38'),(3,'test-003',1,'USER','???????','2026-05-28 01:38:07'),(4,'test-003',1,'AI','您好！我是润达4S店的智能客服小润，很高兴为您服务！😊 请问您有什么需要咨询的？比如购车、保养、试驾预约，或者门店地址、营业时间等问题，我都可以帮您解答！如果遇到复杂问题，我也会为您转接人工客服哦~','2026-05-28 01:38:08'),(5,'test-004',1,'USER','???????','2026-05-28 01:39:43'),(6,'test-004',1,'AI','您好！我是润达4S店的智能客服小润，很高兴为您服务！请问有什么可以帮您的吗？比如购车咨询、保养预约、门店信息，或者任何其他问题，都可以告诉我哦！😊','2026-05-28 01:39:45'),(7,'test-005',1,'USER','???','2026-05-28 01:40:29'),(8,'test-005',1,'AI','您好！我是润达4S店的智能助手小润，很高兴为您服务！请问有什么可以帮您的？无论是购车咨询、保养预约，还是其他问题，我都会尽力解答哦~ 😊','2026-05-28 01:40:30'),(9,'sess_1779936947800',14,'USER','你好','2026-05-28 02:55:55'),(10,'sess_1779936947800',14,'AI','您好！欢迎来到润达4S店智能助手“小润”为您服务~ 😊\n\n请问有什么可以帮您的？无论是购车咨询、保养预约、保险问题，还是门店地址营业时间，都可以问我哦！','2026-05-28 02:55:58'),(11,'sess_1779938910778',33,'USER','计算金融方案','2026-05-28 03:29:01'),(12,'sess_1779938910778',33,'AI','您好！润达4S店提供多种金融方案，包括分期贷款、低首付、灵活尾款等选项。请问您想了解哪款车型的金融方案？或者您对首付比例、贷款期限（如12/24/36期）有初步想法？我可以根据您的预算帮您计算月供和总利息。例如，部分车型支持“0首付”或“3年免息”活动。具体利率以门店最新政策为准。需要我为您推荐一个方案吗？如果您有更具体的需求，也可以转接金融专员详询。','2026-05-28 03:29:04'),(13,'sess_1783160731675',42,'USER','查询车型和价格','2026-07-04 10:25:58'),(14,'sess_1783160731675',42,'AI','您好！欢迎咨询润达4S店！我们目前主营多个热门品牌车型，包括轿车、SUV和新能源车型。价格方面，不同车型和配置有所差异，例如入门级车型约10万起，中高端车型在20-40万区间。请问您对哪个品牌或车型感兴趣？我可以为您提供更详细的配置和报价信息。','2026-07-04 10:26:00');
/*!40000 ALTER TABLE `ai_chat_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `vehicle_id` bigint NOT NULL,
  `appointment_time` datetime NOT NULL,
  `purpose` varchar(30) NOT NULL DEFAULT 'TEST_DRIVE',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING',
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `vehicle_id` (`vehicle_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_customer`
--

DROP TABLE IF EXISTS `crm_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crm_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_type` varchar(20) NOT NULL DEFAULT 'PROSPECT' COMMENT 'PROSPECT/OWNER',
  `name` varchar(50) NOT NULL,
  `gender` varchar(5) DEFAULT '',
  `phone` varchar(20) NOT NULL,
  `wechat` varchar(50) DEFAULT '',
  `id_card` varchar(20) DEFAULT '',
  `address` varchar(200) DEFAULT '',
  `source` varchar(30) DEFAULT '' COMMENT 'å®¢æˆ·æ¥æº',
  `source_channel` varchar(50) DEFAULT '',
  `intent_vehicle_id` bigint DEFAULT NULL COMMENT 'æ„å‘è½¦åž‹ID',
  `intent_model` varchar(100) DEFAULT '',
  `budget` decimal(12,2) DEFAULT '0.00',
  `competitor_info` varchar(200) DEFAULT '' COMMENT 'å…³æ³¨ç«žå“',
  `grade` varchar(5) DEFAULT 'C' COMMENT 'H/A/B/C/D æ„å‘çº§åˆ«',
  `owner_vehicle_id` bigint DEFAULT NULL COMMENT 'å·²è´­è½¦è¾†IDï¼ˆè½¦ä¸»ä¸“ç”¨ï¼‰',
  `purchase_date` date DEFAULT NULL COMMENT 'è´­è½¦æ—¥æœŸï¼ˆè½¦ä¸»ä¸“ç”¨ï¼‰',
  `owner_vin` varchar(30) DEFAULT '' COMMENT 'VINç ï¼ˆè½¦ä¸»ä¸“ç”¨ï¼‰',
  `birthday` date DEFAULT NULL,
  `insurance_due_date` date DEFAULT NULL COMMENT 'ä¿é™©åˆ°æœŸæ—¥',
  `inspection_due_date` date DEFAULT NULL COMMENT 'å¹´æ£€åˆ°æœŸæ—¥',
  `assignee_id` bigint DEFAULT NULL COMMENT 'è´Ÿè´£é”€å”®é¡¾é—®',
  `remark` varchar(500) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_grade` (`grade`),
  KEY `idx_customer_type` (`customer_type`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å®¢æˆ·æ¡£æ¡ˆè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_customer`
--

LOCK TABLES `crm_customer` WRITE;
/*!40000 ALTER TABLE `crm_customer` DISABLE KEYS */;
INSERT INTO `crm_customer` VALUES (67,'OWNER','张伟','','13900000001','','','','WALK_IN','',NULL,'奥迪A6L',0.00,'','H',NULL,NULL,'',NULL,NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(68,'OWNER','李娜','','13900000002','','','','WALK_IN','',NULL,'宝马325Li',0.00,'','A',NULL,NULL,'',NULL,NULL,NULL,4,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(69,'PROSPECT','王磊','','13900000003','','','','WALK_IN','',NULL,'奔驰C260L',0.00,'','A',NULL,NULL,'',NULL,NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(70,'PROSPECT','赵敏','','13900000004','','','','WALK_IN','',NULL,'特斯拉Model Y',0.00,'','B',NULL,NULL,'',NULL,NULL,NULL,4,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(71,'PROSPECT','陈强','','13900000005','','','','WALK_IN','',NULL,'比亚迪汉EV',0.00,'','B',NULL,NULL,'',NULL,NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(72,'PROSPECT','刘洋','','13900000006','','','','WALK_IN','',NULL,'丰田凯美瑞',0.00,'','C',NULL,NULL,'',NULL,NULL,NULL,4,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(73,'PROSPECT','周静','','13900000007','','','','WALK_IN','',NULL,'本田CR-V',0.00,'','C',NULL,NULL,'',NULL,NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(74,'PROSPECT','吴昊','','13900000008','','','','WALK_IN','',NULL,'理想L8',0.00,'','H',NULL,NULL,'',NULL,NULL,NULL,4,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(75,'PROSPECT','用户9977','','11188899977','','','','','',NULL,'',0.00,'','C',NULL,NULL,'',NULL,NULL,NULL,NULL,'',0,NULL,'2026-07-04 11:39:10','2026-07-04 11:39:10'),(76,'OWNER','maodie','','13812345678','','','','','',NULL,'',0.00,'','C',NULL,NULL,'',NULL,NULL,NULL,NULL,'',0,NULL,'2026-07-04 12:35:04','2026-07-04 12:35:04'),(77,'OWNER','圆头耄耋','','14796906618','','','','','',NULL,'',0.00,'','A',NULL,NULL,'',NULL,NULL,NULL,NULL,'',0,NULL,'2026-07-04 12:46:48','2026-07-04 12:46:48');
/*!40000 ALTER TABLE `crm_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_follow_up`
--

DROP TABLE IF EXISTS `crm_follow_up`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crm_follow_up` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `follow_method` varchar(20) NOT NULL COMMENT 'PHONE/WECHAT/VISIT/OTHER',
  `summary` text NOT NULL,
  `result` varchar(200) DEFAULT '',
  `next_follow_time` datetime DEFAULT NULL,
  `follow_by` bigint NOT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_follow_by` (`follow_by`),
  KEY `idx_next_follow` (`next_follow_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å®¢æˆ·è·Ÿè¿›è®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_follow_up`
--

LOCK TABLES `crm_follow_up` WRITE;
/*!40000 ALTER TABLE `crm_follow_up` DISABLE KEYS */;
/*!40000 ALTER TABLE `crm_follow_up` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_lead`
--

DROP TABLE IF EXISTS `crm_lead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crm_lead` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(50) DEFAULT '',
  `phone` varchar(20) NOT NULL,
  `source` varchar(30) DEFAULT '' COMMENT 'å®¢æˆ·æ¥æº',
  `source_channel` varchar(50) DEFAULT '' COMMENT 'æ¸ é“: æŠ–éŸ³/æ‡‚è½¦å¸/Walk-inç­‰',
  `intent_vehicle_id` bigint DEFAULT NULL,
  `intent_model` varchar(100) DEFAULT '',
  `budget_range` varchar(30) DEFAULT '',
  `status` varchar(20) DEFAULT 'PUBLIC' COMMENT 'PUBLIC/ASSIGNED/CONVERTED/LOST',
  `assignee_id` bigint DEFAULT NULL,
  `assign_time` datetime DEFAULT NULL,
  `claim_days` int DEFAULT '3' COMMENT 'è§„å®šè·Ÿè¿›å¤©æ•°',
  `lost_reason` varchar(200) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='çº¿ç´¢è¡¨ï¼ˆå…¬æµ·æ± ï¼‰';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_lead`
--

LOCK TABLES `crm_lead` WRITE;
/*!40000 ALTER TABLE `crm_lead` DISABLE KEYS */;
INSERT INTO `crm_lead` VALUES (38,'抖音线索A','13700000001','','抖音',NULL,'宝马X3','','PUBLIC',NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(39,'懂车帝线索B','13700000002','','懂车帝',NULL,'奥迪Q5L','','PUBLIC',NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(40,'汽车之家C','13700000003','','汽车之家',NULL,'奔驰GLC','','PUBLIC',NULL,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(41,'百度线索D','13700000004','','百度',NULL,'特斯拉Model3','','ASSIGNED',3,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(42,'Walk-in E','13700000005','','进店',NULL,'比亚迪宋PLUS','','ASSIGNED',4,NULL,3,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `crm_lead` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_lead_assign_log`
--

DROP TABLE IF EXISTS `crm_lead_assign_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crm_lead_assign_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lead_id` bigint NOT NULL,
  `from_user_id` bigint DEFAULT NULL,
  `to_user_id` bigint NOT NULL,
  `assign_type` varchar(20) NOT NULL COMMENT 'MANUAL/AUTO/RETURN',
  `remark` varchar(200) DEFAULT '',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_lead_id` (`lead_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='çº¿ç´¢åˆ†é…æ—¥å¿—è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_lead_assign_log`
--

LOCK TABLES `crm_lead_assign_log` WRITE;
/*!40000 ALTER TABLE `crm_lead_assign_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `crm_lead_assign_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_lost_customer`
--

DROP TABLE IF EXISTS `crm_lost_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crm_lost_customer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `lead_id` bigint DEFAULT NULL,
  `lost_reason` varchar(50) NOT NULL COMMENT 'PRICE/MODEL_MISMATCH/COMPETITOR/SERVICE/OTHER',
  `detail` varchar(500) DEFAULT '',
  `review_status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED',
  `reviewer_id` bigint DEFAULT NULL,
  `review_comment` varchar(200) DEFAULT '',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æˆ˜è´¥å®¢æˆ·è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_lost_customer`
--

LOCK TABLES `crm_lost_customer` WRITE;
/*!40000 ALTER TABLE `crm_lost_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `crm_lost_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crm_reminder`
--

DROP TABLE IF EXISTS `crm_reminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crm_reminder` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `reminder_type` varchar(20) NOT NULL COMMENT 'BIRTHDAY/INSURANCE/INSPECTION/FOLLOW_UP',
  `remind_time` datetime NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/DONE/DISMISSED',
  `assignee_id` bigint NOT NULL,
  `remark` varchar(200) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_remind_time` (`remind_time`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æé†’ä»»åŠ¡è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crm_reminder`
--

LOCK TABLES `crm_reminder` WRITE;
/*!40000 ALTER TABLE `crm_reminder` DISABLE KEYS */;
/*!40000 ALTER TABLE `crm_reminder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cs_ticket`
--

DROP TABLE IF EXISTS `cs_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cs_ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `ticket_no` varchar(30) NOT NULL,
  `customer_id` bigint NOT NULL,
  `customer_name` varchar(50) DEFAULT '',
  `phone` varchar(20) DEFAULT '',
  `category` varchar(30) DEFAULT '' COMMENT 'CONSULTATION/COMPLAINT/RESCUE/OTHER',
  `question` text COMMENT 'å®¢æˆ·é—®é¢˜æ‘˜è¦',
  `chat_context` text COMMENT 'AIå¯¹è¯ä¸Šä¸‹æ–‡JSON',
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/ASSIGNED/PROCESSING/RESOLVED/CLOSED',
  `assignee_id` bigint DEFAULT NULL COMMENT 'åˆ†é…çš„å®¢æœäººå‘˜',
  `resolution` text COMMENT 'è§£å†³æ–¹æ¡ˆ',
  `priority` varchar(10) DEFAULT 'NORMAL' COMMENT 'LOW/NORMAL/HIGH/URGENT',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticket_no` (`ticket_no`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_status` (`status`),
  KEY `idx_assignee` (`assignee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='äººå·¥å®¢æœå·¥å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cs_ticket`
--

LOCK TABLES `cs_ticket` WRITE;
/*!40000 ALTER TABLE `cs_ticket` DISABLE KEYS */;
INSERT INTO `cs_ticket` VALUES (1,'CS1779936949525',14,'用户8910','12345678910','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-05-28 02:55:49',NULL,'2026-05-28 02:55:49'),(2,'CS1779938170792',24,'用户8910','12345678910','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-05-28 03:16:10',NULL,'2026-05-28 03:16:10'),(3,'CS1779938912158',33,'用户8910','12345678910','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-05-28 03:28:32',NULL,'2026-05-28 03:28:32'),(4,'CS1779938912932',33,'用户8910','12345678910','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-05-28 03:28:32',NULL,'2026-05-28 03:28:32'),(5,'CS1779938913075',33,'用户8910','12345678910','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-05-28 03:28:33',NULL,'2026-05-28 03:28:33'),(6,'CS1779938944225',33,'用户8910','12345678910','','计算金融方案','USER: 计算金融方案','PENDING',NULL,NULL,'NORMAL','2026-05-28 03:29:04',NULL,'2026-05-28 03:29:04'),(7,'CS1783160740862',42,'','','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-07-04 10:25:40',NULL,'2026-07-04 10:25:40'),(8,'CS1783160744371',42,'','','','客户请求转人工','','PENDING',NULL,NULL,'NORMAL','2026-07-04 10:25:44',NULL,'2026-07-04 10:25:44');
/*!40000 ALTER TABLE `cs_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_advisor`
--

DROP TABLE IF EXISTS `customer_advisor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_advisor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `sales_advisor_id` bigint DEFAULT NULL COMMENT 'ä¸“å±žé”€å”®é¡¾é—®',
  `service_advisor_id` bigint DEFAULT NULL COMMENT 'ä¸“å±žæœåŠ¡é¡¾é—®',
  `sales_advisor_qrcode` varchar(500) DEFAULT '' COMMENT 'ä¼å¾®äºŒç»´ç ',
  `service_advisor_qrcode` varchar(500) DEFAULT '',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id` (`customer_id`),
  KEY `idx_customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ä¸“å±žé¡¾é—®åˆ†é…è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_advisor`
--

LOCK TABLES `customer_advisor` WRITE;
/*!40000 ALTER TABLE `customer_advisor` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_advisor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_points`
--

DROP TABLE IF EXISTS `customer_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_points` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `total_points` int DEFAULT '0' COMMENT 'å½“å‰ç§¯åˆ†',
  `total_growth` int DEFAULT '0' COMMENT 'æˆé•¿å€¼',
  `member_level` varchar(20) DEFAULT 'NORMAL' COMMENT 'NORMAL/SILVER/GOLD/PLATINUM/DIAMOND',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å®¢æˆ·ç§¯åˆ†è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_points`
--

LOCK TABLES `customer_points` WRITE;
/*!40000 ALTER TABLE `customer_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_points_log`
--

DROP TABLE IF EXISTS `customer_points_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_points_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `change_type` varchar(20) NOT NULL COMMENT 'EARN/CONSUME/EXPIRE',
  `points` int NOT NULL COMMENT 'å˜æ›´ç§¯åˆ†',
  `growth` int DEFAULT '0' COMMENT 'å˜æ›´æˆé•¿å€¼',
  `source` varchar(50) DEFAULT '' COMMENT 'æ¥æº: æ¶ˆè´¹/ç­¾åˆ°/æ´»åŠ¨/æŽ¨è',
  `source_id` bigint DEFAULT NULL COMMENT 'æ¥æºID',
  `remark` varchar(200) DEFAULT '',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç§¯åˆ†å˜åŠ¨æ—¥å¿—è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_points_log`
--

LOCK TABLES `customer_points_log` WRITE;
/*!40000 ALTER TABLE `customer_points_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_points_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_vehicle`
--

DROP TABLE IF EXISTS `customer_vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_vehicle` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL COMMENT 'å…³è” crm_customer.id',
  `vin` varchar(30) DEFAULT '' COMMENT 'VINç ',
  `license_plate` varchar(20) DEFAULT '' COMMENT 'è½¦ç‰Œå·',
  `brand` varchar(50) DEFAULT '',
  `model` varchar(100) DEFAULT '',
  `model_year` int DEFAULT '0',
  `mileage` int DEFAULT '0' COMMENT 'å½“å‰é‡Œç¨‹',
  `engine_no` varchar(30) DEFAULT '',
  `insurance_company` varchar(50) DEFAULT '',
  `insurance_due_date` date DEFAULT NULL,
  `inspection_due_date` date DEFAULT NULL,
  `is_default` tinyint DEFAULT '0' COMMENT 'é»˜è®¤è½¦è¾†',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_vin` (`vin`),
  KEY `idx_plate` (`license_plate`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å®¢æˆ·ç»‘å®šè½¦è¾†è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_vehicle`
--

LOCK TABLES `customer_vehicle` WRITE;
/*!40000 ALTER TABLE `customer_vehicle` DISABLE KEYS */;
INSERT INTO `customer_vehicle` VALUES (1,1,'LSVAA4180E2123456','?A12345','??','A6L',2024,15000,'','',NULL,NULL,0,'2026-05-28 01:17:00','2026-05-28 01:17:00');
/*!40000 ALTER TABLE `customer_vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_daily_settlement`
--

DROP TABLE IF EXISTS `fin_daily_settlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_daily_settlement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `settle_date` date NOT NULL,
  `settle_by` bigint DEFAULT NULL COMMENT 'æ”¶é“¶å‘˜',
  `cash_amount` decimal(12,2) DEFAULT '0.00',
  `card_amount` decimal(12,2) DEFAULT '0.00',
  `wechat_amount` decimal(12,2) DEFAULT '0.00',
  `alipay_amount` decimal(12,2) DEFAULT '0.00',
  `transfer_amount` decimal(12,2) DEFAULT '0.00',
  `total_amount` decimal(12,2) DEFAULT '0.00',
  `bank_amount` decimal(12,2) DEFAULT '0.00' COMMENT 'é“¶è¡Œæµæ°´æ€»é¢',
  `diff_amount` decimal(12,2) DEFAULT '0.00' COMMENT 'å·®å¼‚',
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/CONFIRMED',
  `confirmed_by` bigint DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_user` (`settle_date`,`settle_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ—¥ç»“è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_daily_settlement`
--

LOCK TABLES `fin_daily_settlement` WRITE;
/*!40000 ALTER TABLE `fin_daily_settlement` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_daily_settlement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_invoice`
--

DROP TABLE IF EXISTS `fin_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_invoice` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `invoice_no` varchar(30) NOT NULL,
  `invoice_type` varchar(20) NOT NULL COMMENT 'SALE/SERVICE/OTHER',
  `order_id` bigint DEFAULT NULL,
  `work_order_id` bigint DEFAULT NULL,
  `customer_name` varchar(50) DEFAULT '',
  `amount` decimal(12,2) DEFAULT '0.00',
  `tax_amount` decimal(12,2) DEFAULT '0.00',
  `total_amount` decimal(12,2) DEFAULT '0.00',
  `status` varchar(20) DEFAULT 'ISSUED' COMMENT 'ISSUED/VOIDED/RED_FLUSH',
  `issued_by` bigint DEFAULT NULL,
  `issued_at` datetime DEFAULT NULL,
  `voided_at` datetime DEFAULT NULL,
  `void_reason` varchar(200) DEFAULT '',
  `file_path` varchar(500) DEFAULT '' COMMENT 'å‘ç¥¨æ–‡ä»¶è·¯å¾„',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_no` (`invoice_no`),
  KEY `idx_invoice_no` (`invoice_no`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å‘ç¥¨è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_invoice`
--

LOCK TABLES `fin_invoice` WRITE;
/*!40000 ALTER TABLE `fin_invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_payment`
--

DROP TABLE IF EXISTS `fin_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_payment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `payment_no` varchar(30) NOT NULL,
  `payment_type` varchar(30) NOT NULL COMMENT 'SALE_DEPOSIT/SALE_BALANCE/SERVICE/INSURANCE/OTHER',
  `amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(20) NOT NULL COMMENT 'CASH/BANK_CARD/WECHAT/ALIPAY/TRANSFER',
  `voucher_no` varchar(50) DEFAULT '' COMMENT 'å‡­è¯å·/æµæ°´å·',
  `order_id` bigint DEFAULT NULL COMMENT 'å…³è”é”€å”®è®¢å•',
  `work_order_id` bigint DEFAULT NULL COMMENT 'å…³è”ç»´ä¿®å·¥å•',
  `customer_id` bigint DEFAULT NULL,
  `payer_name` varchar(50) DEFAULT '',
  `remark` varchar(200) DEFAULT '',
  `status` varchar(20) DEFAULT 'COMPLETED' COMMENT 'COMPLETED/REFUNDED/PART_REFUND',
  `received_by` bigint DEFAULT NULL COMMENT 'æ”¶æ¬¾äºº',
  `paid_at` datetime DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_no` (`payment_no`),
  KEY `idx_payment_type` (`payment_type`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_paid_at` (`paid_at`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ”¶æ¬¾è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_payment`
--

LOCK TABLES `fin_payment` WRITE;
/*!40000 ALTER TABLE `fin_payment` DISABLE KEYS */;
INSERT INTO `fin_payment` VALUES (24,'PAY44500','SALE_DEPOSIT',5000.00,'CASH','',NULL,NULL,NULL,'张伟','','COMPLETED',NULL,'2026-06-04 14:07:47',0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(25,'PAY32900','SALE_BALANCE',420000.00,'BANK_CARD','',NULL,NULL,NULL,'李娜','','COMPLETED',NULL,'2026-06-03 14:07:47',0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(26,'PAY95600','SERVICE',2800.00,'WECHAT','',NULL,NULL,NULL,'王磊','','COMPLETED',NULL,'2026-06-02 14:07:47',0,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `fin_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_profit`
--

DROP TABLE IF EXISTS `fin_profit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_profit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `period_type` varchar(10) NOT NULL COMMENT 'MONTH/QUARTER/YEAR',
  `period_value` varchar(20) NOT NULL COMMENT '2026-05',
  `biz_type` varchar(20) NOT NULL COMMENT 'SALE/SERVICE/ACCESSORY',
  `revenue` decimal(14,2) DEFAULT '0.00' COMMENT 'æ”¶å…¥',
  `cost` decimal(14,2) DEFAULT '0.00' COMMENT 'æˆæœ¬',
  `gross_profit` decimal(14,2) DEFAULT '0.00' COMMENT 'æ¯›åˆ©',
  `gross_margin` decimal(5,2) DEFAULT '0.00' COMMENT 'æ¯›åˆ©çŽ‡',
  `expense` decimal(14,2) DEFAULT '0.00' COMMENT 'è´¹ç”¨',
  `net_profit` decimal(14,2) DEFAULT '0.00' COMMENT 'å‡€åˆ©æ¶¦',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_period` (`period_value`,`biz_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='åˆ©æ¶¦æ ¸ç®—è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_profit`
--

LOCK TABLES `fin_profit` WRITE;
/*!40000 ALTER TABLE `fin_profit` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_profit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_receivable`
--

DROP TABLE IF EXISTS `fin_receivable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_receivable` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `receivable_no` varchar(30) NOT NULL,
  `customer_name` varchar(50) NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `paid_amount` decimal(12,2) DEFAULT '0.00',
  `due_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/PARTIAL/PAID/OVERDUE',
  `collection_records` text COMMENT 'å‚¬æ”¶è®°å½• JSON',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receivable_no` (`receivable_no`),
  KEY `idx_due_date` (`due_date`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='åº”æ”¶è´¦æ¬¾è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_receivable`
--

LOCK TABLES `fin_receivable` WRITE;
/*!40000 ALTER TABLE `fin_receivable` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_receivable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_refund`
--

DROP TABLE IF EXISTS `fin_refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fin_refund` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_no` varchar(30) NOT NULL,
  `payment_id` bigint NOT NULL COMMENT 'åŽŸæ”¶æ¬¾è®°å½•',
  `amount` decimal(12,2) NOT NULL,
  `reason` varchar(200) NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/COMPLETED/REJECTED',
  `approved_by` bigint DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `refunded_at` datetime DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `refund_no` (`refund_no`),
  KEY `idx_payment_id` (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é€€æ¬¾è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_refund`
--

LOCK TABLES `fin_refund` WRITE;
/*!40000 ALTER TABLE `fin_refund` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_refund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kb_faq`
--

DROP TABLE IF EXISTS `kb_faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kb_faq` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(30) NOT NULL COMMENT 'MAINTENANCE/INSURANCE/PRICE/PROCESS/OTHER',
  `question` varchar(500) NOT NULL,
  `answer` text NOT NULL,
  `keywords` varchar(200) DEFAULT '' COMMENT 'å…³é”®è¯,é€—å·åˆ†éš”',
  `sort_order` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIçŸ¥è¯†åº“FAQè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kb_faq`
--

LOCK TABLES `kb_faq` WRITE;
/*!40000 ALTER TABLE `kb_faq` DISABLE KEYS */;
INSERT INTO `kb_faq` VALUES (169,'MAINTENANCE','首保什么时候做','新车首保一般为购车后3个月或3000-5000公里','首保,保养,时间',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(170,'MAINTENANCE','小保养和大保养有什么区别','小保养一般指更换机油和机油滤芯，费用约500-1500元','保养,大小保养,机油',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(171,'MAINTENANCE','机油怎么选','选择机油需看粘度等级和品质等级。全合成油10000公里更换','机油,全合成,粘度',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(172,'MAINTENANCE','刹车片多久换一次','前刹车片一般3-5万公里更换，后刹车片5-8万公里','刹车片,更换',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(173,'INSURANCE','新车保险怎么买','新车需购买交强险+车损险+三者险+不计免赔','保险,新车,交强险',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(174,'INSURANCE','出险后怎么处理','开启双闪、放警示牌、拍照取证、拨打保险公司报案','出险,事故,报案',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(175,'PRICE','买车落地价包含哪些费用','落地价=裸车价+购置税+保险费+上牌费','落地价,购置税,保险',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(176,'PRICE','贷款买车和全款哪个划算','全款总支出更低；贷款资金压力小，有厂家免息政策','贷款,全款,利息',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(177,'PROCESS','提车流程是怎样的','验车→交尾款→买保险→临牌→交车仪式→领资料','提车,流程,验车',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(178,'PROCESS','预约保养怎么操作','通过小程序选择类型、日期和时间段，自动排班','预约,保养,小程序',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(179,'OTHER','你们店的营业时间','销售展厅每日9:00-18:00；售后周一至周六8:30-17:30','营业时间,展厅',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(180,'OTHER','有没有代步车服务','重大维修超48小时可申请免费代步车','代步车,免费',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(181,'OTHER','你们店在什么位置','润达4S店位于XX市XX区XX路XX号汽车城内','地址,位置,导航',0,1,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `kb_faq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_order`
--

DROP TABLE IF EXISTS `mall_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) NOT NULL,
  `customer_id` bigint NOT NULL,
  `total_amount` decimal(10,2) DEFAULT '0.00',
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `pay_amount` decimal(10,2) DEFAULT '0.00',
  `status` varchar(20) DEFAULT 'PENDING_PAY' COMMENT 'PENDING_PAY/PAID/SHIPPED/COMPLETED/CANCELLED',
  `pay_method` varchar(20) DEFAULT '',
  `pay_time` datetime DEFAULT NULL,
  `remark` varchar(200) DEFAULT '',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no` (`order_no`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å•†åŸŽè®¢å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_order`
--

LOCK TABLES `mall_order` WRITE;
/*!40000 ALTER TABLE `mall_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `mall_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_order_item`
--

DROP TABLE IF EXISTS `mall_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `product_name` varchar(100) DEFAULT '',
  `price` decimal(10,2) DEFAULT '0.00',
  `quantity` int DEFAULT '1',
  `total_price` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å•†åŸŽè®¢å•æ˜Žç»†è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_order_item`
--

LOCK TABLES `mall_order_item` WRITE;
/*!40000 ALTER TABLE `mall_order_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `mall_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mall_product`
--

DROP TABLE IF EXISTS `mall_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mall_product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) NOT NULL,
  `category` varchar(30) NOT NULL COMMENT 'MAINTENANCE_PACKAGE/ACCESSORY/CHEMICAL/OTHER',
  `image_url` varchar(500) DEFAULT '',
  `original_price` decimal(10,2) DEFAULT '0.00',
  `sale_price` decimal(10,2) DEFAULT '0.00',
  `stock` int DEFAULT '0',
  `sales` int DEFAULT '0' COMMENT 'é”€é‡',
  `description` text,
  `detail_images` text COMMENT 'è¯¦æƒ…å›¾JSONæ•°ç»„',
  `status` varchar(20) DEFAULT 'ON_SALE' COMMENT 'ON_SALE/OFF_SALE',
  `sort_order` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å•†åŸŽå•†å“è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mall_product`
--

LOCK TABLES `mall_product` WRITE;
/*!40000 ALTER TABLE `mall_product` DISABLE KEYS */;
INSERT INTO `mall_product` VALUES (33,'全合成保养套餐','MAINTENANCE_PACKAGE','',0.00,498.00,50,0,NULL,NULL,'ON_SALE',0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(34,'高清行车记录仪','ACCESSORY','',0.00,499.00,50,0,NULL,NULL,'ON_SALE',0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(35,'3D全包围脚垫','ACCESSORY','',0.00,680.00,50,0,NULL,NULL,'ON_SALE',0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(36,'车载空气净化器','ACCESSORY','',0.00,299.00,50,0,NULL,NULL,'ON_SALE',0,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `mall_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mkt_campaign`
--

DROP TABLE IF EXISTS `mkt_campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mkt_campaign` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `campaign_name` varchar(100) NOT NULL,
  `campaign_type` varchar(30) DEFAULT '' COMMENT 'AUTO_SHOW/STORE_EVENT/GROUP_BUY/OTHER',
  `budget` decimal(12,2) DEFAULT '0.00',
  `actual_cost` decimal(12,2) DEFAULT '0.00',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `expected_leads` int DEFAULT '0' COMMENT 'é¢„æœŸèŽ·å®¢æ•°',
  `actual_leads` int DEFAULT '0' COMMENT 'å®žé™…èŽ·å®¢æ•°',
  `status` varchar(20) DEFAULT 'PLANNING' COMMENT 'PLANNING/IN_PROGRESS/COMPLETED/CANCELLED',
  `description` text,
  `responsible_id` bigint DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å¸‚åœºæ´»åŠ¨è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mkt_campaign`
--

LOCK TABLES `mkt_campaign` WRITE;
/*!40000 ALTER TABLE `mkt_campaign` DISABLE KEYS */;
INSERT INTO `mkt_campaign` VALUES (22,'五一车展','AUTO_SHOW',50000.00,0.00,NULL,NULL,0,0,'IN_PROGRESS',NULL,NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(23,'618团购会','GROUP_BUY',50000.00,0.00,NULL,NULL,0,0,'IN_PROGRESS',NULL,NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(24,'周末试驾日','STORE_EVENT',50000.00,0.00,NULL,NULL,0,0,'PLANNING',NULL,NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `mkt_campaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mkt_coupon`
--

DROP TABLE IF EXISTS `mkt_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mkt_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_name` varchar(100) NOT NULL,
  `coupon_type` varchar(30) NOT NULL COMMENT 'MAINTENANCE/LABOR/DISCOUNT/OTHER',
  `face_value` decimal(10,2) DEFAULT '0.00' COMMENT 'é¢å€¼',
  `threshold_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'æ»¡å‡é—¨æ§›',
  `total_quantity` int DEFAULT '0' COMMENT 'å‘è¡Œæ€»æ•°',
  `issued_quantity` int DEFAULT '0',
  `used_quantity` int DEFAULT '0',
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'ACTIVE' COMMENT 'ACTIVE/PAUSED/EXPIRED',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ä¼˜æƒ åˆ¸è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mkt_coupon`
--

LOCK TABLES `mkt_coupon` WRITE;
/*!40000 ALTER TABLE `mkt_coupon` DISABLE KEYS */;
INSERT INTO `mkt_coupon` VALUES (22,'保养现金券','MAINTENANCE',200.00,0.00,20,5,0,'2026-06-04','2026-09-04','ACTIVE',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(23,'工时抵扣券','LABOR',100.00,0.00,20,5,0,'2026-06-04','2026-09-04','ACTIVE',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(24,'新车礼包券','DISCOUNT',500.00,0.00,20,5,0,'2026-06-04','2026-09-04','ACTIVE',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `mkt_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mkt_coupon_issue`
--

DROP TABLE IF EXISTS `mkt_coupon_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mkt_coupon_issue` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint NOT NULL,
  `coupon_code` varchar(30) NOT NULL,
  `customer_id` bigint DEFAULT NULL,
  `issued_to` varchar(50) DEFAULT '',
  `status` varchar(20) DEFAULT 'UNUSED' COMMENT 'UNUSED/USED/EXPIRED',
  `used_at` datetime DEFAULT NULL,
  `work_order_id` bigint DEFAULT NULL COMMENT 'æ ¸é”€å…³è”å·¥å•',
  `order_id` bigint DEFAULT NULL COMMENT 'æ ¸é”€å…³è”è®¢å•',
  `issued_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `coupon_code` (`coupon_code`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_coupon_code` (`coupon_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å¡åˆ¸å‘æ”¾æ ¸é”€è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mkt_coupon_issue`
--

LOCK TABLES `mkt_coupon_issue` WRITE;
/*!40000 ALTER TABLE `mkt_coupon_issue` DISABLE KEYS */;
/*!40000 ALTER TABLE `mkt_coupon_issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mkt_lead_channel`
--

DROP TABLE IF EXISTS `mkt_lead_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mkt_lead_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(50) NOT NULL COMMENT 'æŠ–éŸ³/æ‡‚è½¦å¸/å¿«æ‰‹/ç™¾åº¦ç­‰',
  `channel_code` varchar(30) NOT NULL,
  `lead_count` int DEFAULT '0' COMMENT 'çº¿ç´¢æ€»æ•°',
  `converted_count` int DEFAULT '0' COMMENT 'æˆäº¤æ•°',
  `total_cost` decimal(12,2) DEFAULT '0.00' COMMENT 'æ€»è´¹ç”¨',
  `per_lead_cost` decimal(10,2) DEFAULT '0.00' COMMENT 'å•çº¿ç´¢æˆæœ¬',
  `roi` decimal(5,2) DEFAULT '0.00' COMMENT 'æŠ•èµ„å›žæŠ¥çŽ‡',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_code` (`channel_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ–°åª’ä½“çº¿ç´¢æ¸ é“è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mkt_lead_channel`
--

LOCK TABLES `mkt_lead_channel` WRITE;
/*!40000 ALTER TABLE `mkt_lead_channel` DISABLE KEYS */;
/*!40000 ALTER TABLE `mkt_lead_channel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `publisher_id` bigint NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'PUBLISHED',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `publisher_id` (`publisher_id`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`publisher_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rescue_order`
--

DROP TABLE IF EXISTS `rescue_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rescue_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rescue_no` varchar(30) NOT NULL,
  `customer_id` bigint NOT NULL,
  `vehicle_id` bigint DEFAULT NULL COMMENT 'å…³è” customer_vehicle.id',
  `contact_name` varchar(50) DEFAULT '',
  `contact_phone` varchar(20) NOT NULL,
  `latitude` decimal(10,7) DEFAULT '0.0000000' COMMENT 'çº¬åº¦',
  `longitude` decimal(10,7) DEFAULT '0.0000000' COMMENT 'ç»åº¦',
  `address` varchar(200) DEFAULT '',
  `rescue_type` varchar(30) DEFAULT 'ROADSIDE' COMMENT 'ROADSIDE/TOWING/FLAT_TIRE/DEAD_BATTERY/OTHER',
  `description` varchar(500) DEFAULT '',
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/DISPATCHED/ARRIVED/RESCUING/COMPLETED/CANCELLED',
  `dispatcher_id` bigint DEFAULT NULL COMMENT 'æ´¾å•å‘˜',
  `rescue_company` varchar(100) DEFAULT '',
  `arrived_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rescue_no` (`rescue_no`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é“è·¯æ•‘æ´å·¥å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rescue_order`
--

LOCK TABLES `rescue_order` WRITE;
/*!40000 ALTER TABLE `rescue_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `rescue_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rpt_summary`
--

DROP TABLE IF EXISTS `rpt_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rpt_summary` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `report_date` date NOT NULL,
  `report_type` varchar(30) NOT NULL COMMENT 'DAILY_SALES/DAILY_SERVICE/DAILY_FINANCE',
  `metric_key` varchar(50) NOT NULL COMMENT 'æŒ‡æ ‡é”®',
  `metric_value` decimal(14,2) DEFAULT '0.00' COMMENT 'æŒ‡æ ‡å€¼',
  `metric_json` text COMMENT 'JSONè¡¥å……æ•°æ®',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_type_key` (`report_date`,`report_type`,`metric_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æŠ¥è¡¨æ±‡æ€»è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rpt_summary`
--

LOCK TABLES `rpt_summary` WRITE;
/*!40000 ALTER TABLE `rpt_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `rpt_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_contract`
--

DROP TABLE IF EXISTS `sale_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `contract_no` varchar(30) NOT NULL,
  `order_id` bigint NOT NULL,
  `contract_content` text NOT NULL COMMENT 'åˆåŒHTMLå†…å®¹',
  `signed_status` varchar(20) DEFAULT 'UNSIGNED' COMMENT 'UNSIGNED/SIGNED',
  `signed_at` datetime DEFAULT NULL,
  `file_path` varchar(500) DEFAULT '' COMMENT 'åˆåŒæ–‡ä»¶è·¯å¾„',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_no` (`contract_no`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é”€å”®åˆåŒè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_contract`
--

LOCK TABLES `sale_contract` WRITE;
/*!40000 ALTER TABLE `sale_contract` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_delivery`
--

DROP TABLE IF EXISTS `sale_delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_delivery` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `stock_vehicle_id` bigint DEFAULT NULL,
  `pdi_status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/PASSED/FAILED',
  `pdi_checker_id` bigint DEFAULT NULL,
  `pdi_time` datetime DEFAULT NULL,
  `wash_status` varchar(20) DEFAULT 'PENDING',
  `document_prepared` tinyint DEFAULT '0' COMMENT 'èµ„æ–™å‡†å¤‡å®Œæˆ',
  `ceremony_time` datetime DEFAULT NULL,
  `customer_interview_result` varchar(50) DEFAULT '',
  `delivery_status` varchar(20) DEFAULT 'IN_PROGRESS' COMMENT 'IN_PROGRESS/COMPLETED',
  `delivered_at` datetime DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è½¦è¾†äº¤ä»˜PDIè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_delivery`
--

LOCK TABLES `sale_delivery` WRITE;
/*!40000 ALTER TABLE `sale_delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_derivative`
--

DROP TABLE IF EXISTS `sale_derivative`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_derivative` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `biz_type` varchar(20) NOT NULL COMMENT 'INSURANCE/FINANCE/TRADE_IN/EXTENDED_WARRANTY',
  `provider` varchar(100) DEFAULT '' COMMENT 'ä¿é™©å…¬å¸/é“¶è¡Œç­‰',
  `product_name` varchar(100) DEFAULT '',
  `amount` decimal(12,2) DEFAULT '0.00',
  `detail` text COMMENT 'JSONæ ¼å¼è¯¦ç»†å†…å®¹',
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è¡ç”Ÿä¸šåŠ¡è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_derivative`
--

LOCK TABLES `sale_derivative` WRITE;
/*!40000 ALTER TABLE `sale_derivative` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_derivative` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_opportunity`
--

DROP TABLE IF EXISTS `sale_opportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_opportunity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `lead_id` bigint DEFAULT NULL,
  `vehicle_model_id` bigint DEFAULT NULL COMMENT 'æ„å‘è½¦åž‹ID',
  `intent_color` varchar(30) DEFAULT '',
  `intent_config` varchar(200) DEFAULT '',
  `payment_method` varchar(20) DEFAULT '' COMMENT 'FULL/LOAN',
  `status` varchar(20) DEFAULT 'FOLLOWING' COMMENT 'FOLLOWING/QUOTED/ORDERED/LOST',
  `expected_close_date` date DEFAULT NULL,
  `assignee_id` bigint DEFAULT NULL,
  `remark` varchar(500) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é”€å”®æœºä¼š/æ„å‘å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_opportunity`
--

LOCK TABLES `sale_opportunity` WRITE;
/*!40000 ALTER TABLE `sale_opportunity` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_opportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_order`
--

DROP TABLE IF EXISTS `sale_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) NOT NULL,
  `customer_id` bigint DEFAULT NULL,
  `opportunity_id` bigint DEFAULT NULL,
  `vehicle_model_id` bigint DEFAULT NULL COMMENT 'è½¦åž‹ID',
  `stock_vehicle_id` bigint DEFAULT NULL COMMENT 'é…è½¦VIN ID',
  `guide_price` decimal(12,2) DEFAULT '0.00' COMMENT 'æŒ‡å¯¼ä»·',
  `discount` decimal(12,2) DEFAULT '0.00' COMMENT 'ä¼˜æƒ é‡‘é¢',
  `purchase_tax` decimal(12,2) DEFAULT '0.00' COMMENT 'è´­ç½®ç¨Ž',
  `insurance_amount` decimal(12,2) DEFAULT '0.00' COMMENT 'ä¿é™©è´¹',
  `license_fee` decimal(12,2) DEFAULT '0.00' COMMENT 'ä¸Šç‰Œè´¹',
  `accessory_amount` decimal(12,2) DEFAULT '0.00' COMMENT 'ç²¾å“åŠ è£…è´¹',
  `total_price` decimal(12,2) DEFAULT '0.00' COMMENT 'åŒ…ç‰Œæ€»ä»·',
  `deposit` decimal(12,2) DEFAULT '0.00' COMMENT 'å®šé‡‘',
  `payment_method` varchar(20) DEFAULT '' COMMENT 'FULL/LOAN',
  `status` varchar(20) DEFAULT 'PENDING_APPROVAL' COMMENT 'PENDING_APPROVAL/PENDING_DEPOSIT/PENDING_ALLOCATION/PENDING_DELIVERY/COMPLETED/CANCELLED',
  `assignee_id` bigint DEFAULT NULL,
  `signing_date` date DEFAULT NULL COMMENT 'ç­¾çº¦æ—¥æœŸ',
  `expected_delivery_date` date DEFAULT NULL COMMENT 'é¢„è®¡äº¤è½¦æ—¥æœŸ',
  `remark` varchar(500) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no` (`order_no`),
  KEY `idx_order_no` (`order_no`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é”€å”®è®¢å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_order`
--

LOCK TABLES `sale_order` WRITE;
/*!40000 ALTER TABLE `sale_order` DISABLE KEYS */;
INSERT INTO `sale_order` VALUES (22,'SO20260501001',1,NULL,NULL,NULL,450000.00,30000.00,0.00,0.00,0.00,0.00,466600.00,0.00,'','COMPLETED',3,NULL,NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(23,'SO20260501002',2,NULL,NULL,NULL,360000.00,25000.00,0.00,0.00,0.00,0.00,373680.00,0.00,'','PENDING_DELIVERY',3,NULL,NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(24,'SO20260501003',3,NULL,NULL,NULL,380000.00,40000.00,0.00,0.00,0.00,0.00,380440.00,0.00,'','PENDING_DEPOSIT',3,NULL,NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(25,'SO1783170017592',77,NULL,NULL,NULL,349900.00,0.00,0.00,0.00,0.00,0.00,349900.00,0.00,'','PENDING_DEPOSIT',NULL,NULL,NULL,'',0,NULL,'2026-07-04 13:00:17','2026-07-04 13:00:17'),(26,'SO1783170070774',77,NULL,NULL,NULL,208900.00,0.00,0.00,0.00,0.00,0.00,208900.00,0.00,'','PENDING_DEPOSIT',NULL,NULL,NULL,'',0,NULL,'2026-07-04 13:01:10','2026-07-04 13:01:10');
/*!40000 ALTER TABLE `sale_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_order_approval`
--

DROP TABLE IF EXISTS `sale_order_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_order_approval` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `approval_level` varchar(30) NOT NULL COMMENT 'MANAGER/DIRECTOR/REGIONAL',
  `approver_id` bigint NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED',
  `comment` varchar(200) DEFAULT '',
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ä»·æ ¼å®¡æ‰¹è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_order_approval`
--

LOCK TABLES `sale_order_approval` WRITE;
/*!40000 ALTER TABLE `sale_order_approval` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_order_approval` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_accessory`
--

DROP TABLE IF EXISTS `stock_accessory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_accessory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `accessory_code` varchar(30) NOT NULL,
  `accessory_name` varchar(100) NOT NULL,
  `category` varchar(30) DEFAULT '' COMMENT 'è„šåž«/è´´è†œ/å¯¼èˆª/å…¶ä»–',
  `unit` varchar(10) DEFAULT 'å¥—',
  `price` decimal(10,2) DEFAULT '0.00',
  `quantity` int DEFAULT '0',
  `alert_quantity` int DEFAULT '5' COMMENT 'åº“å­˜é¢„è­¦æ•°é‡',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accessory_code` (`accessory_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç²¾å“é…ä»¶åº“å­˜è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_accessory`
--

LOCK TABLES `stock_accessory` WRITE;
/*!40000 ALTER TABLE `stock_accessory` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_accessory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_accessory_inbound`
--

DROP TABLE IF EXISTS `stock_accessory_inbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_accessory_inbound` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `inbound_no` varchar(30) NOT NULL,
  `accessory_id` bigint NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `total_price` decimal(12,2) DEFAULT '0.00',
  `supplier` varchar(100) DEFAULT '',
  `inbound_date` date NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inbound_no` (`inbound_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é…ä»¶å…¥åº“è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_accessory_inbound`
--

LOCK TABLES `stock_accessory_inbound` WRITE;
/*!40000 ALTER TABLE `stock_accessory_inbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_accessory_inbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_accessory_outbound`
--

DROP TABLE IF EXISTS `stock_accessory_outbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_accessory_outbound` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `outbound_no` varchar(30) NOT NULL,
  `accessory_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL COMMENT 'å…³è”é”€å”®è®¢å•ID',
  `work_order_id` bigint DEFAULT NULL COMMENT 'å…³è”ç»´ä¿®å·¥å•ID',
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `total_price` decimal(12,2) DEFAULT '0.00',
  `outbound_date` date NOT NULL,
  `outbound_type` varchar(20) NOT NULL COMMENT 'SALE/REPAIR/OTHER',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `outbound_no` (`outbound_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é…ä»¶å‡ºåº“è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_accessory_outbound`
--

LOCK TABLES `stock_accessory_outbound` WRITE;
/*!40000 ALTER TABLE `stock_accessory_outbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_accessory_outbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_check`
--

DROP TABLE IF EXISTS `stock_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_check` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `check_no` varchar(30) NOT NULL,
  `check_type` varchar(20) NOT NULL COMMENT 'VEHICLE/ACCESSORY',
  `check_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'IN_PROGRESS' COMMENT 'IN_PROGRESS/COMPLETED',
  `profit_loss_summary` text COMMENT 'ç›˜ç›ˆç›˜äºæ±‡æ€» JSON',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `check_no` (`check_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç›˜ç‚¹å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_check`
--

LOCK TABLES `stock_check` WRITE;
/*!40000 ALTER TABLE `stock_check` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_check_detail`
--

DROP TABLE IF EXISTS `stock_check_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_check_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `check_id` bigint NOT NULL,
  `item_id` bigint NOT NULL COMMENT 'å¯¹åº” stock_vehicle.id æˆ– stock_accessory.id',
  `item_type` varchar(20) NOT NULL COMMENT 'VEHICLE/ACCESSORY',
  `book_quantity` int DEFAULT '0' COMMENT 'è´¦é¢æ•°é‡',
  `actual_quantity` int DEFAULT '0' COMMENT 'å®žç›˜æ•°é‡',
  `diff_quantity` int DEFAULT '0' COMMENT 'å·®å¼‚',
  `diff_reason` varchar(200) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_check_id` (`check_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç›˜ç‚¹æ˜Žç»†è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_check_detail`
--

LOCK TABLES `stock_check_detail` WRITE;
/*!40000 ALTER TABLE `stock_check_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_check_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_vehicle`
--

DROP TABLE IF EXISTS `stock_vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_vehicle` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vin` varchar(30) NOT NULL,
  `engine_no` varchar(30) DEFAULT '',
  `brand` varchar(50) NOT NULL,
  `model` varchar(100) NOT NULL,
  `model_year` int NOT NULL,
  `vehicle_type` varchar(30) DEFAULT '',
  `color` varchar(30) DEFAULT '',
  `image_url` text,
  `config_detail` varchar(200) DEFAULT '',
  `production_date` date DEFAULT NULL,
  `guide_price` decimal(12,2) DEFAULT '0.00',
  `cost_price` decimal(12,2) DEFAULT '0.00' COMMENT 'æˆæœ¬ä»·',
  `status` varchar(20) NOT NULL DEFAULT 'IN_TRANSIT' COMMENT 'IN_TRANSIT/IN_STOCK/SHOWROOM/RESERVED/PDI/PENDING_DELIVERY/DELIVERED',
  `location` varchar(50) DEFAULT '' COMMENT 'åº“ä½',
  `inbound_date` date DEFAULT NULL COMMENT 'å…¥åº“æ—¥æœŸ',
  `outbound_date` date DEFAULT NULL COMMENT 'å‡ºåº“æ—¥æœŸ',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vin` (`vin`),
  KEY `idx_vin` (`vin`),
  KEY `idx_status` (`status`),
  KEY `idx_brand_model` (`brand`,`model`),
  KEY `idx_inbound_date` (`inbound_date`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ•´è½¦åº“å­˜è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_vehicle`
--

LOCK TABLES `stock_vehicle` WRITE;
/*!40000 ALTER TABLE `stock_vehicle` DISABLE KEYS */;
INSERT INTO `stock_vehicle` VALUES (86,'LSVAA4180E2000001','','奥迪','A6L',2024,'SEDAN','黑色','https://p1.ssl.qhimgs1.com/t04aa6a375c6c38432b.jpg','',NULL,427900.00,0.00,'IN_STOCK','','2026-05-30',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(87,'LBV31FH08R2000002','','宝马','325Li',2024,'SEDAN','白色','https://img0.baidu.com/it/u=4286066875,1241136632&fm=253&app=138&f=JPEG?w=1067&h=800','',NULL,349900.00,0.00,'IN_STOCK','','2026-05-25',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(88,'LE4ZG8DB6R2000003','','奔驰','C260L',2024,'SEDAN','银色','https://img0.baidu.com/it/u=1015408147,514055606&fm=253&app=138&f=JPEG?w=800&h=1067','',NULL,351800.00,0.00,'SHOWROOM','','2026-05-20',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 07:22:02'),(89,'LRW3E7FS8R2000004','','特斯拉','Model Y',2024,'SUV','蓝色','/uploads/vehicles/a8e7a957-ae57-4454-aeeb-b3f6943b3b90.webp','',NULL,263900.00,0.00,'IN_STOCK','','2026-05-15',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(90,'LC0CE4CB6R2000005','','比亚迪','汉EV',2024,'SEDAN','红色','https://img0.baidu.com/it/u=606166925,1292112881&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500','',NULL,219800.00,0.00,'IN_STOCK','','2026-05-10',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(91,'LVGBE40KXR2000006','','丰田','凯美瑞',2024,'SEDAN','白色','/uploads/vehicles/f85f74c9-5ee5-4218-b5f2-5fc3667825ba.jpg','',NULL,199800.00,0.00,'RESERVED','','2026-05-05',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(92,'LVHRU585XR2000007','','本田','CR-V',2024,'SUV','黑色','https://img1.baidu.com/it/u=2146389404,1007078342&fm=253&fmt=auto&app=120&f=PNG?w=704&h=441','',NULL,208900.00,0.00,'IN_STOCK','','2026-04-30',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(93,'LSVUD60T8R2000008','','大众','途观L',2024,'SUV','灰色','https://img0.baidu.com/it/u=1955575480,672968043&fm=253&app=138&f=JPEG?w=1067&h=800','',NULL,229800.00,0.00,'SHOWROOM','','2026-04-25',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(94,'LS6A3E0E9R2000009','','长安','深蓝SL03',2024,'SEDAN','青色','/uploads/vehicles/e0ffe495-78e2-4d3f-9352-e3ba150f613d.jpg','',NULL,169900.00,0.00,'IN_STOCK','','2026-04-20',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(95,'HLX33B12XR2000010','','理想','L8',2024,'SUV','金色','https://img1.baidu.com/it/u=1291119795,3312781068&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667','',NULL,359800.00,0.00,'IN_STOCK','','2026-04-15',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(96,'LYVUE10DXR2000011','','沃尔沃','XC60',2024,'SUV','白色','https://img2.baidu.com/it/u=3220270157,2151439474&fm=253&app=138&f=JPEG?w=1067&h=800','',NULL,396900.00,0.00,'IN_STOCK','','2026-04-10',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 07:38:04'),(97,'LSGUD84CXR2000012','','别克','GL8',2024,'MPV','棕色','https://p1.itc.cn/images01/20230624/3eae28d263df42dd90ee5fbb0052b96a.jpeg','',NULL,329900.00,0.00,'IN_STOCK','','2026-04-05',NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:40:35'),(98,'LFV3A24F9P3123456','','奥迪A6','SEDAN',2026,'SEDAN','蓝色','https://img.pcauto.com.cn/images/upload/upc/tx/auto5/2005/24/c45/209956680_1590327092654_1024.jpg','',NULL,450000.00,0.00,'IN_STOCK','','2026-07-04',NULL,0,NULL,'2026-07-04 10:21:46','2026-07-04 10:21:46');
/*!40000 ALTER TABLE `stock_vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_vehicle_inbound`
--

DROP TABLE IF EXISTS `stock_vehicle_inbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_vehicle_inbound` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `inbound_no` varchar(30) NOT NULL,
  `stock_vehicle_id` bigint NOT NULL,
  `supplier` varchar(100) DEFAULT '' COMMENT 'åŽ‚å®¶/ä¾›åº”å•†',
  `inbound_date` date NOT NULL,
  `inbound_type` varchar(30) DEFAULT 'PURCHASE' COMMENT 'PURCHASE/RETURN/TRANSFER',
  `remark` varchar(200) DEFAULT '',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inbound_no` (`inbound_no`),
  KEY `idx_stock_vehicle` (`stock_vehicle_id`),
  KEY `idx_inbound_date` (`inbound_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ•´è½¦å…¥åº“è®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_vehicle_inbound`
--

LOCK TABLES `stock_vehicle_inbound` WRITE;
/*!40000 ALTER TABLE `stock_vehicle_inbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_vehicle_inbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_vehicle_outbound`
--

DROP TABLE IF EXISTS `stock_vehicle_outbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_vehicle_outbound` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `outbound_no` varchar(30) NOT NULL,
  `stock_vehicle_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL COMMENT 'å…³è”é”€å”®è®¢å•',
  `outbound_date` date NOT NULL,
  `outbound_type` varchar(30) NOT NULL COMMENT 'SALE/TRANSFER/TEST_DRIVE',
  `receiver` varchar(50) DEFAULT '',
  `remark` varchar(200) DEFAULT '',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `outbound_no` (`outbound_no`),
  KEY `idx_stock_vehicle` (`stock_vehicle_id`),
  KEY `idx_outbound_date` (`outbound_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ•´è½¦å‡ºåº“è®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_vehicle_outbound`
--

LOCK TABLES `stock_vehicle_outbound` WRITE;
/*!40000 ALTER TABLE `stock_vehicle_outbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_vehicle_outbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_appointment`
--

DROP TABLE IF EXISTS `svc_appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_appointment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `customer_name` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `vehicle_info` varchar(100) DEFAULT '' COMMENT 'è½¦åž‹+è½¦ç‰Œ',
  `appointment_time` datetime NOT NULL,
  `service_type` varchar(30) DEFAULT 'MAINTENANCE' COMMENT 'MAINTENANCE/REPAIR/BODY_WORK/OTHER',
  `description` varchar(500) DEFAULT '' COMMENT 'å®¢æˆ·æè¿°é—®é¢˜',
  `status` varchar(20) DEFAULT 'CONFIRMED' COMMENT 'PENDING/CONFIRMED/ARRIVED/CANCELLED',
  `service_advisor_id` bigint DEFAULT NULL COMMENT 'æœåŠ¡é¡¾é—®',
  `remark` varchar(200) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_appointment_time` (`appointment_time`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_advisor` (`service_advisor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å”®åŽé¢„çº¦è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_appointment`
--

LOCK TABLES `svc_appointment` WRITE;
/*!40000 ALTER TABLE `svc_appointment` DISABLE KEYS */;
INSERT INTO `svc_appointment` VALUES (31,1,'客户1','13900000001','车型1','2026-06-06 14:07:47','REPAIR','','CONFIRMED',NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(32,2,'客户2','13900000002','车型2','2026-06-07 14:07:47','MAINTENANCE','','CONFIRMED',NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(33,3,'客户3','13900000003','车型3','2026-06-08 14:07:47','REPAIR','','CONFIRMED',NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(34,4,'客户4','13900000004','车型4','2026-06-09 14:07:47','MAINTENANCE','','CONFIRMED',NULL,'',0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `svc_appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_dispatch`
--

DROP TABLE IF EXISTS `svc_dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_dispatch` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint NOT NULL,
  `technician_id` bigint NOT NULL COMMENT 'æŠ€å¸ˆ',
  `dispatch_by` bigint DEFAULT NULL COMMENT 'æ´¾å·¥äºº',
  `dispatch_time` datetime DEFAULT NULL,
  `start_time` datetime DEFAULT NULL COMMENT 'æŠ€å¸ˆå¼€å·¥æ—¶é—´',
  `end_time` datetime DEFAULT NULL COMMENT 'æŠ€å¸ˆå®Œå·¥æ—¶é—´',
  `labor_hours` decimal(5,2) DEFAULT '0.00' COMMENT 'å·¥æ—¶æ•°',
  `status` varchar(20) DEFAULT 'ASSIGNED' COMMENT 'ASSIGNED/STARTED/COMPLETED',
  `remark` varchar(200) DEFAULT '',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_wo_id` (`work_order_id`),
  KEY `idx_technician` (`technician_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ´¾å·¥è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_dispatch`
--

LOCK TABLES `svc_dispatch` WRITE;
/*!40000 ALTER TABLE `svc_dispatch` DISABLE KEYS */;
/*!40000 ALTER TABLE `svc_dispatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_follow_up`
--

DROP TABLE IF EXISTS `svc_follow_up`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_follow_up` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `follow_up_time` datetime DEFAULT NULL COMMENT 'å›žè®¿æ—¶é—´',
  `satisfaction_score` int DEFAULT '0' COMMENT 'æ»¡æ„åº¦è¯„åˆ† 1-5',
  `feedback` varchar(500) DEFAULT '',
  `follow_by` bigint DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/DONE/SKIPPED',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_wo_id` (`work_order_id`),
  KEY `idx_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å”®åŽå›žè®¿è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_follow_up`
--

LOCK TABLES `svc_follow_up` WRITE;
/*!40000 ALTER TABLE `svc_follow_up` DISABLE KEYS */;
/*!40000 ALTER TABLE `svc_follow_up` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_parts_requisition`
--

DROP TABLE IF EXISTS `svc_parts_requisition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_parts_requisition` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint NOT NULL,
  `accessory_id` bigint NOT NULL COMMENT 'å…³è”é…ä»¶åº“å­˜',
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) DEFAULT '0.00',
  `total_price` decimal(12,2) DEFAULT '0.00',
  `request_by` bigint DEFAULT NULL COMMENT 'é¢†æ–™äºº',
  `approved_by` bigint DEFAULT NULL COMMENT 'å®¡æ‰¹äºº',
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/DELIVERED',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_wo_id` (`work_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é…ä»¶é¢†æ–™è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_parts_requisition`
--

LOCK TABLES `svc_parts_requisition` WRITE;
/*!40000 ALTER TABLE `svc_parts_requisition` DISABLE KEYS */;
/*!40000 ALTER TABLE `svc_parts_requisition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_quality_check`
--

DROP TABLE IF EXISTS `svc_quality_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_quality_check` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint NOT NULL,
  `checker_id` bigint DEFAULT NULL,
  `check_result` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/PASSED/FAILED',
  `check_items` text COMMENT 'è´¨æ£€é¡¹ç›®JSON',
  `issue_found` varchar(500) DEFAULT '',
  `checked_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_wo_id` (`work_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è´¨æ£€è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_quality_check`
--

LOCK TABLES `svc_quality_check` WRITE;
/*!40000 ALTER TABLE `svc_quality_check` DISABLE KEYS */;
/*!40000 ALTER TABLE `svc_quality_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_settlement`
--

DROP TABLE IF EXISTS `svc_settlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_settlement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint NOT NULL,
  `labor_fee` decimal(12,2) DEFAULT '0.00' COMMENT 'å·¥æ—¶è´¹',
  `parts_fee` decimal(12,2) DEFAULT '0.00' COMMENT 'é…ä»¶è´¹',
  `material_fee` decimal(12,2) DEFAULT '0.00' COMMENT 'è¾…æ–™è´¹',
  `outsourced_fee` decimal(12,2) DEFAULT '0.00' COMMENT 'å¤–åŒ…é¡¹ç›®è´¹',
  `discount` decimal(12,2) DEFAULT '0.00',
  `total_amount` decimal(12,2) DEFAULT '0.00',
  `payment_method` varchar(20) DEFAULT '' COMMENT 'CASH/CARD/TRANSFER/COMBINED',
  `payment_status` varchar(20) DEFAULT 'UNPAID' COMMENT 'UNPAID/PARTIAL/PAID',
  `paid_amount` decimal(12,2) DEFAULT '0.00',
  `settled_by` bigint DEFAULT NULL,
  `settled_at` datetime DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `work_order_id` (`work_order_id`),
  KEY `idx_wo_id` (`work_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å”®åŽç»“ç®—è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_settlement`
--

LOCK TABLES `svc_settlement` WRITE;
/*!40000 ALTER TABLE `svc_settlement` DISABLE KEYS */;
/*!40000 ALTER TABLE `svc_settlement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `svc_work_order`
--

DROP TABLE IF EXISTS `svc_work_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `svc_work_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `wo_no` varchar(30) NOT NULL,
  `appointment_id` bigint DEFAULT NULL,
  `customer_id` bigint NOT NULL,
  `vehicle_desc` varchar(200) DEFAULT '' COMMENT 'è½¦åž‹/è½¦ç‰Œ/VIN',
  `mileage` int DEFAULT '0' COMMENT 'è¿›åŽ‚é‡Œç¨‹',
  `fuel_level` varchar(10) DEFAULT '' COMMENT 'æ²¹é‡',
  `exterior_condition` text COMMENT 'å¤–è§‚çŠ¶å†µè®°å½•',
  `customer_complaint` text NOT NULL COMMENT 'å®¢æˆ·æè¿°é—®é¢˜',
  `technician_finding` text COMMENT 'æŠ€å¸ˆæ£€æŸ¥å‘çŽ°',
  `service_type` varchar(30) DEFAULT 'REPAIR',
  `status` varchar(20) DEFAULT 'RECEPTION' COMMENT 'RECEPTION/DISPATCHED/IN_PROGRESS/QC/WASH/SETTLEMENT/COMPLETED',
  `service_advisor_id` bigint DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wo_no` (`wo_no`),
  KEY `idx_wo_no` (`wo_no`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç»´ä¿®å·¥å•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `svc_work_order`
--

LOCK TABLES `svc_work_order` WRITE;
/*!40000 ALTER TABLE `svc_work_order` DISABLE KEYS */;
INSERT INTO `svc_work_order` VALUES (22,'WO20260501001',NULL,1,'奥迪A6L 京A12345',2791,'',NULL,'发动机异响',NULL,'REPAIR','IN_PROGRESS',NULL,NULL,NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(23,'WO20260501002',NULL,1,'宝马325Li 京B67890',1716,'',NULL,'刹车偏软',NULL,'REPAIR','RECEPTION',NULL,NULL,NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(24,'WO20260501003',NULL,1,'奔驰C260L 京C11111',10961,'',NULL,'空调不制冷',NULL,'REPAIR','COMPLETED',NULL,NULL,NULL,0,NULL,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `svc_work_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_name` varchar(50) NOT NULL,
  `config_key` varchar(50) NOT NULL,
  `config_value` varchar(500) NOT NULL,
  `config_type` varchar(20) DEFAULT 'STRING',
  `remark` varchar(200) DEFAULT '',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç³»ç»Ÿå‚æ•°è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint DEFAULT '0',
  `dept_name` varchar(50) NOT NULL,
  `dept_code` varchar(30) NOT NULL,
  `sort_order` int DEFAULT '0',
  `leader` varchar(50) DEFAULT '',
  `phone` varchar(20) DEFAULT '',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='éƒ¨é—¨è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (1,0,'总经办','HEAD_OFFICE',1,'','',1,0,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(2,0,'销售部','SALES',2,'','',1,0,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(3,0,'售后部','AFTERSALES',3,'','',1,0,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(4,0,'市场部','MARKETING',4,'','',1,0,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(5,0,'财务部','FINANCE',5,'','',1,0,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(6,0,'行政部','ADMIN',6,'','',1,0,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(7,0,'客户管理','CUSTOMER',7,'','',1,0,'2026-07-04 13:02:27','2026-07-04 13:03:44');
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict`
--

DROP TABLE IF EXISTS `sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_type_id` bigint NOT NULL,
  `dict_label` varchar(50) NOT NULL,
  `dict_value` varchar(50) NOT NULL,
  `sort_order` int DEFAULT '0',
  `css_class` varchar(50) DEFAULT '',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_dict_type` (`dict_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=331 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ•°æ®å­—å…¸è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict`
--

LOCK TABLES `sys_dict` WRITE;
/*!40000 ALTER TABLE `sys_dict` DISABLE KEYS */;
INSERT INTO `sys_dict` VALUES (309,1,'进店','WALK_IN',1,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(310,1,'网销','ONLINE',2,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(311,1,'外拓','OUTREACH',3,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(312,1,'老客户介绍','REFERRAL',4,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(313,1,'车展','AUTO_SHOW',5,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(314,1,'电话','PHONE',6,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(315,2,'H级-1周内成交','H',1,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(316,2,'A级-1月内成交','A',2,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(317,2,'B级-3月内成交','B',3,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(318,2,'C级-半年内成交','C',4,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(319,2,'D级-无意向','D',5,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(320,3,'全款','FULL',6,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(321,3,'分期/贷款','LOAN',1,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(322,4,'轿车','SEDAN',2,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(323,4,'SUV','SUV',3,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(324,4,'MPV','MPV',4,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(325,4,'新能源','EV',5,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(326,4,'跑车','SPORTS',6,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(327,7,'电话','PHONE',1,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(328,7,'微信','WECHAT',2,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(329,7,'到店','VISIT',3,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(330,7,'其他','OTHER',4,'',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_name` varchar(50) NOT NULL,
  `dict_code` varchar(50) NOT NULL,
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dict_code` (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='å­—å…¸ç±»åž‹è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'客户来源','customer_source',1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(2,'客户级别','customer_grade',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(3,'付款方式','payment_method',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(4,'车辆类型','vehicle_type',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(5,'订单状态','order_status',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(6,'线索状态','lead_status',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47'),(7,'跟进方式','follow_method',1,0,'2026-06-04 06:07:47','2026-06-04 06:07:47');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_operation_log`
--

DROP TABLE IF EXISTS `sys_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `username` varchar(50) DEFAULT '',
  `module` varchar(50) DEFAULT '',
  `action` varchar(50) DEFAULT '',
  `method` varchar(200) DEFAULT '',
  `request_url` varchar(500) DEFAULT '',
  `request_method` varchar(10) DEFAULT '',
  `request_params` text,
  `response_result` text,
  `ip` varchar(50) DEFAULT '',
  `duration` bigint DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `error_msg` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_module` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ“ä½œæ—¥å¿—è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_operation_log`
--

LOCK TABLES `sys_operation_log` WRITE;
/*!40000 ALTER TABLE `sys_operation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_permission`
--

DROP TABLE IF EXISTS `sys_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint DEFAULT '0',
  `perm_name` varchar(50) NOT NULL,
  `perm_code` varchar(100) DEFAULT '',
  `perm_type` varchar(10) NOT NULL COMMENT 'MENU/BUTTON',
  `path` varchar(200) DEFAULT '',
  `component` varchar(200) DEFAULT '',
  `icon` varchar(50) DEFAULT '',
  `sort_order` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æƒé™èœå•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_permission`
--

LOCK TABLES `sys_permission` WRITE;
/*!40000 ALTER TABLE `sys_permission` DISABLE KEYS */;
INSERT INTO `sys_permission` VALUES (1,0,'系统管理','','MENU','/system','','Setting',1,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(2,1,'用户管理','','MENU','/system/users','','User',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(3,1,'角色管理','','MENU','/system/roles','','Avatar',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(4,1,'权限管理','','MENU','/system/permissions','','Lock',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(5,1,'部门管理','','MENU','/system/depts','','OfficeBuilding',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(6,1,'数据字典','','MENU','/system/dict','','Collection',50,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(7,1,'系统参数','','MENU','/system/config','','Tools',60,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(8,1,'操作日志','','MENU','/system/logs','','Document',70,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(10,0,'客户关系','','MENU','/crm','','UserFilled',2,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(11,10,'客户档案','','MENU','/crm/customers','','UserFilled',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(12,10,'跟进记录','','MENU','/crm/follow-ups','','ChatLineSquare',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(13,10,'线索公海','','MENU','/crm/leads','','Ship',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(14,10,'战败客户','','MENU','/crm/lost','','Warning',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(15,10,'提醒任务','','MENU','/crm/reminders','','AlarmClock',50,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(20,0,'整车销售','','MENU','/sale','','Sell',3,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(21,20,'销售机会','','MENU','/sale/opportunities','','Opportunity',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(22,20,'订单管理','','MENU','/sale/orders','','Tickets',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(23,20,'车辆交付','','MENU','/sale/deliveries','','Van',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(24,20,'合同管理','','MENU','/sale/contracts','','DocumentChecked',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(30,0,'库存管理','','MENU','/stock','','Box',4,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(31,30,'整车库存','','MENU','/stock/vehicles','','Van',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(32,30,'入库管理','','MENU','/stock/inbound','','Download',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(33,30,'出库管理','','MENU','/stock/outbound','','Upload',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(34,30,'配件库存','','MENU','/stock/accessories','','Goods',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(35,30,'盘点管理','','MENU','/stock/checks','','Check',50,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(40,0,'售后维修','','MENU','/service','','Tool',5,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(41,40,'预约管理','','MENU','/service/appointments','','Calendar',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(42,40,'维修工单','','MENU','/service/work-orders','','Notebook',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(43,40,'结算管理','','MENU','/service/settlements','','Money',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(44,40,'回访管理','','MENU','/service/follow-ups','','Phone',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(50,0,'财务结算','','MENU','/finance','','Money',6,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(51,50,'收款管理','','MENU','/finance/payments','','CreditCard',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(52,50,'发票管理','','MENU','/finance/invoices','','Receipt',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(53,50,'退款管理','','MENU','/finance/refunds','','Money',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(54,50,'应收账款','','MENU','/finance/receivables','','Wallet',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(55,50,'日结管理','','MENU','/finance/daily-settle','','DataAnalysis',50,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(60,0,'统计报表','','MENU','/report','','DataAnalysis',7,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(61,60,'销售漏斗','','MENU','/report/sales-funnel','','PieChart',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(62,60,'销售业绩','','MENU','/report/sales-performance','','TrendCharts',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(63,60,'售后业绩','','MENU','/report/service-performance','','TrendCharts',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(64,60,'库存分析','','MENU','/report/inventory','','Odometer',40,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(65,60,'财务报表','','MENU','/report/finance','','TrendCharts',50,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(70,0,'市场营销','','MENU','/marketing','','Promotion',8,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(71,70,'活动管理','','MENU','/marketing/campaigns','','Flag',10,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(72,70,'渠道管理','','MENU','/marketing/channels','','Share',20,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(73,70,'卡券管理','','MENU','/marketing/coupons','','Ticket',30,1,0,'2026-06-04 06:07:46','2026-06-04 06:07:46');
/*!40000 ALTER TABLE `sys_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `role_code` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT '',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_code` (`role_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è§’è‰²è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'系统管理员','ADMIN','拥有所有权限',1,0,NULL,NULL,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(2,'销售经理','SALES_MANAGER','管理销售团队和线索分配',1,0,NULL,NULL,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(3,'销售顾问','SALES_CONSULTANT','跟进客户和创建订单',1,0,NULL,NULL,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(4,'售后经理','SERVICE_MANAGER','管理售后团队',1,0,NULL,NULL,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(5,'服务顾问','SERVICE_ADVISOR','接车和工单管理',1,0,NULL,NULL,'2026-06-04 06:07:45','2026-06-04 06:07:45'),(6,'技师','TECHNICIAN','维修执行',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(7,'财务','FINANCE','收款、发票和结算',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(8,'店长','STORE_MANAGER','查看所有报表和数据',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_permission`
--

DROP TABLE IF EXISTS `sys_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_perm` (`role_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è§’è‰²æƒé™å…³è”è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_permission`
--

LOCK TABLES `sys_role_permission` WRITE;
/*!40000 ALTER TABLE `sys_role_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `real_name` varchar(50) DEFAULT '',
  `phone` varchar(20) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `avatar` varchar(500) DEFAULT '',
  `dept_id` bigint DEFAULT NULL,
  `position` varchar(50) DEFAULT '',
  `status` tinyint DEFAULT '1',
  `is_deleted` tinyint DEFAULT '0',
  `created_by` bigint DEFAULT NULL,
  `updated_by` bigint DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_dept_id` (`dept_id`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç³»ç»Ÿç”¨æˆ·è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','$2a$10$Bp2Oi0zMraKjRYcBAtyiEeLdeZ2YCaFp9y8QaJPmc0K7nKFA1sem2','系统管理员','13800000000','','',1,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(2,'zhangsan','$2a$10$39pXBB/ljEFB7RP350Tn5OG3H9OQBMsxXVBE/ZGXjSsdda8kMmwSm','张经理','13800000001','','',2,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(3,'lisi','$2a$10$.g5breq2zt4urYxrxTNbHOI39tN.PcPZp3.oVPSkae2i4rA92xcIC','李顾问','13800000002','','',2,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(4,'wangwu','$2a$10$d1waehXJFCKdkLDtZ16rl.Ly7AIq8gdE84aczbg32fFx8alcWVm2K','王顾问','13800000003','','',2,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(5,'zhaoliu','$2a$10$k6iorbFRG3YEhctU.KlPpeRZIrjLqG9wI9TSPAItD/brpXZ5LZt4i','赵经理','13800000004','','',3,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(6,'sunqi','$2a$10$i2sjmP6gpts2geSW5k75U.C6E6cxmrju61Vp5kwE7fDS0i4MzIcey','孙顾问','13800000005','','',3,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(7,'zhouba','$2a$10$cCgiNPa5zqy0mR3SgIJbAeslW4sUmECyWNXJAbSkOfVcXMv6O61Li','周师傅','13800000006','','',3,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(8,'wujiu','$2a$10$MEyiLPVUnnbP/XTh3Rk2Eu/meWp/4Qok1Ttf3Fg0tTjsOut9vbjqS','吴财务','13800000007','','',5,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(9,'zhengshi','$2a$10$4HBX5KvLGMYkCGSBvXcW1uK0rELOZ69pMj1kKoJSXNSFCOcoT1fO2','郑店长','13800000008','','',1,'',1,0,NULL,NULL,'2026-06-04 06:07:46','2026-06-04 06:07:46'),(10,'maodie','$2a$10$39pXBB/ljEFB7RP350Tn5OG3H9OQBMsxXVBE/ZGXjSsdda8kMmwSm','圆头耄耋','14796906618','maodie@test.com','http://localhost:9000/4s-images/avatars/4fa2a159-adb5-47a3-a157-858407448bd1.jpg',NULL,'',1,0,NULL,NULL,'2026-07-04 11:39:48','2026-07-04 13:06:14');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='ç”¨æˆ·è§’è‰²å…³è”è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (71,1,1),(72,2,2),(73,3,3),(74,4,3),(75,5,4),(76,6,5),(77,7,6),(78,8,7),(79,9,8),(80,10,3);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `real_name` varchar(50) DEFAULT '',
  `phone` varchar(20) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `role` varchar(20) NOT NULL DEFAULT 'USER',
  `status` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin1','$2a$10$LDJIAChhGohqZpiG.K380u6H77nUkAk55Xz/IhbhgwWmknXTptHiG','管理员','','','ADMIN',1,NULL,NULL),(2,'admin2','$2a$10$w6sTDQz/h1znhu7JboY5VesugquU00UvpEon4wW4Hw9xTjZTTEFQS','管理员','','','ADMIN',1,NULL,NULL),(3,'admin3','$2a$10$3oKsm8QaxkX55xq0XRPoq.4SzVKX3J1e51gCqiIyjcZ6ALYBDT9q2','管理员','','','ADMIN',1,NULL,NULL),(4,'admin4','$2a$10$L29X4VboLIHH5YI5zQnwQOFiPiOx8XBCg.3vwSirChia7cYRoJDTm','管理员','','','ADMIN',1,NULL,NULL),(5,'admin5','$2a$10$IRXsx1zbyvPvwK8GVpgJCOl.wf0z3K92wxqGtjSXc4URdeHe3Pqbe','管理员','','','ADMIN',1,NULL,NULL),(6,'testuser','$2a$10$Nh1qw4ntVtYs6LXNwg0YZeU8RQ7l/tcLlvLnqYFvVGvO8yLYmrROe','????','13800138000','test@test.com','USER',0,NULL,NULL),(7,'maodie','$2a$10$Cqc6BYPU/b9.JD.txqrtFeqr70zxDY8Lx4yN/fdVIaYlW.oLF8nhO','李嘉宇','19189740857','123456789@qq.com','USER',1,NULL,NULL),(8,'cxk','$2a$10$K8wxRcZ3qtEu964zMIMkVeDdyJYKLmFCRY8UZ005XfZU9vBzkJyKi','陆飞荣','19577815179','789456123@91.com','USER',1,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `valuation_request`
--

DROP TABLE IF EXISTS `valuation_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valuation_request` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `vehicle_id` bigint DEFAULT NULL,
  `brand` varchar(50) DEFAULT '',
  `model` varchar(100) DEFAULT '',
  `model_year` int DEFAULT '0',
  `mileage` int DEFAULT '0',
  `license_plate` varchar(20) DEFAULT '',
  `purchase_date` date DEFAULT NULL,
  `estimated_price` decimal(12,2) DEFAULT '0.00' COMMENT 'ç³»ç»Ÿä¼°å€¼',
  `manual_price` decimal(12,2) DEFAULT '0.00' COMMENT 'äººå·¥è¯„ä¼°ä»·',
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'PENDING/EVALUATED/DEAL/CLOSED',
  `evaluator_id` bigint DEFAULT NULL COMMENT 'è¯„ä¼°å¸ˆ',
  `remark` varchar(500) DEFAULT '',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='äºŒæ‰‹è½¦ä¼°ä»·ç”³è¯·è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valuation_request`
--

LOCK TABLES `valuation_request` WRITE;
/*!40000 ALTER TABLE `valuation_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `valuation_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_video`
--

DROP TABLE IF EXISTS `vehicle_video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_video` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `vehicle_id` bigint NOT NULL COMMENT 'å…³è” stock_vehicle.id',
  `title` varchar(100) DEFAULT '' COMMENT 'è§†é¢‘æ ‡é¢˜',
  `video_url` varchar(500) NOT NULL COMMENT 'è§†é¢‘åœ°å€(æœ¬åœ°è·¯å¾„æˆ–å¤–éƒ¨é“¾æŽ¥)',
  `cover_url` varchar(500) DEFAULT '' COMMENT 'å°é¢å›¾åœ°å€',
  `source_type` varchar(10) DEFAULT 'LOCAL' COMMENT 'LOCAL/LINK',
  `sort_order` int DEFAULT '0' COMMENT 'æŽ’åº',
  `created_by` bigint DEFAULT NULL COMMENT 'ä¸Šä¼ äºº',
  `is_deleted` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_vehicle_id` (`vehicle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è½¦è¾†ä»‹ç»è§†é¢‘è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_video`
--

LOCK TABLES `vehicle_video` WRITE;
/*!40000 ALTER TABLE `vehicle_video` DISABLE KEYS */;
INSERT INTO `vehicle_video` VALUES (1,1,'å¥¥è¿ªA6L å¤–è§‚è¯¦è§£','https://www.w3schools.com/html/mov_bbb.mp4','','LINK',1,NULL,0,'2026-07-04 10:57:24','2026-07-04 10:57:24'),(2,1,'å¥¥è¿ªA6L å†…é¥°ä¸Žç§‘æŠ€é…ç½®','https://www.w3schools.com/html/movie.mp4','','LINK',2,NULL,0,'2026-07-04 10:57:24','2026-07-04 10:57:24'),(3,2,'å®é©¬325Li è¿åŠ¨å¥—ä»¶å±•ç¤º','https://www.w3schools.com/html/mov_bbb.mp4','','LINK',1,NULL,0,'2026-07-04 10:57:24','2026-07-04 10:57:24'),(4,3,'å¥”é©°C260L è±ªåŽä½“éªŒ','https://www.w3schools.com/html/movie.mp4','','LINK',1,NULL,0,'2026-07-04 10:57:24','2026-07-04 10:57:24'),(5,4,'ç‰¹æ–¯æ‹‰Model Y æ™ºèƒ½é©¾é©¶','https://www.w3schools.com/html/mov_bbb.mp4','','LINK',1,NULL,0,'2026-07-04 10:57:24','2026-07-04 10:57:24'),(6,98,'奥迪A6奶龙','https://www.bilibili.com/video/BV1PMXfBqEeF/?spm_id_from=333.337.search-card.all.click&vd_source=dab7507750084d542df12cfacf39c3ae','','LINK',0,NULL,0,'2026-07-04 10:59:26','2026-07-04 10:59:26'),(7,98,'7606797cc6ebb21ca83eec4da50cc077.mp4','http://localhost:9000/4s-images/vehicles/videos/7706aa9f-0d92-40bf-9afb-28f89c43ff0a.mp4','','LOCAL',0,NULL,0,'2026-07-04 11:23:22','2026-07-04 11:23:22');
/*!40000 ALTER TABLE `vehicle_video` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `brand` varchar(50) NOT NULL,
  `model` varchar(100) NOT NULL,
  `year` int NOT NULL,
  `type` varchar(30) NOT NULL DEFAULT '???',
  `price` decimal(12,2) NOT NULL,
  `color` varchar(30) DEFAULT '',
  `engine` varchar(100) DEFAULT '',
  `transmission` varchar(50) DEFAULT '',
  `fuel_type` varchar(30) DEFAULT '',
  `description` text,
  `image_url` varchar(500) DEFAULT '',
  `stock` int DEFAULT '1',
  `status` varchar(20) NOT NULL DEFAULT 'ON_SALE',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,'奥迪','A6L 45 TFSI',2026,'轿车',42.79,'黑色','2.0T','7挡双离合','汽油','豪华中大型轿车，商务与家用兼得，科技配置丰富','',5,'ON_SALE',NULL,NULL),(2,'宝马','325Li M运动套装',2026,'轿车',34.99,'白色','2.0T','8挡手自一体','汽油','运动豪华中型轿车，操控精准，动力充沛','',5,'ON_SALE',NULL,NULL),(3,'奔驰','C260L',2026,'轿车',35.18,'银色','1.5T+48V轻混','9挡手自一体','汽油+48V轻混','优雅舒适的中型豪华轿车，内饰设计出众','',5,'ON_SALE',NULL,NULL),(4,'特斯拉','Model Y 长续航',2026,'SUV',29.99,'白色','双电机四驱','固定齿比','纯电','热门纯电SUV，续航688km，智能驾驶体验','',5,'ON_SALE',NULL,NULL),(5,'比亚迪','汉EV 创世版',2026,'新能源',26.98,'红色','双电机四驱','固定齿比','纯电','国产电动轿跑标杆，刀片电池安全可靠，续航715km','',5,'ON_SALE',NULL,NULL),(6,'丰田','凯美瑞 2.5HQ',2026,'轿车',21.98,'黑色','2.5L+电机','E-CVT','油电混动','经典日系B级车，混动省油，品质可靠','',5,'ON_SALE',NULL,NULL),(7,'本田','CR-V e:PHEV',2026,'SUV',24.59,'蓝色','2.0L+电机','E-CVT','插电混动','家用SUV标杆，插混版油耗低，空间出色','',5,'ON_SALE',NULL,NULL),(8,'大众','途观L Pro',2026,'SUV',23.78,'灰色','2.0T','7挡双离合','汽油','德系中型SUV，做工扎实，配置均衡','',5,'ON_SALE',NULL,NULL),(9,'长安','深蓝SL03',2026,'新能源',17.39,'青色','单电机后驱','固定齿比','纯电','高性价比国产纯电轿车，设计前卫，续航515km','',5,'ON_SALE',NULL,NULL),(10,'理想','L8 Pro',2026,'SUV',35.98,'金色','1.5T增程+双电机','固定齿比','增程式','家庭六座SUV，增程无续航焦虑，冰箱彩电大沙发','',5,'ON_SALE',NULL,NULL),(11,'沃尔沃','XC60 B5',2026,'SUV',39.69,'深蓝','2.0T+48V轻混','8挡手自一体','汽油+48V轻混','北欧豪华中型SUV，安全性能一流','',5,'ON_SALE',NULL,NULL),(12,'别克','GL8 ES陆尊',2026,'MPV',31.79,'香槟金','2.0T+48V轻混','9挡手自一体','汽油+48V轻混','商务接待首选MPV，空间宽敞，乘坐舒适','',5,'ON_SALE',NULL,NULL);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 15:14:24
