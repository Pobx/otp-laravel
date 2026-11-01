-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: localhost    Database: envsogo_main
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
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `acc_user_id` bigint unsigned NOT NULL,
  `deposit` float NOT NULL COMMENT 'ยอดฝาก',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`acc_user_id`),
  CONSTRAINT `accounts_acc_user_id_foreign` FOREIGN KEY (`acc_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annual_trash_payments`
--

DROP TABLE IF EXISTS `annual_trash_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annual_trash_payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `wbs_id` bigint unsigned NOT NULL,
  `pay_mon` tinyint unsigned NOT NULL,
  `pay_yr` smallint unsigned NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `pay_date` date NOT NULL,
  `notes` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `staff_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `annual_trash_payments_wbs_id_pay_mon_pay_yr_unique` (`wbs_id`,`pay_mon`,`pay_yr`),
  KEY `annual_trash_payments_staff_id_foreign` (`staff_id`),
  CONSTRAINT `annual_trash_payments_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `annual_trash_payments_wbs_id_foreign` FOREIGN KEY (`wbs_id`) REFERENCES `annual_trash_subscriptions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annual_trash_payrate_permonth`
--

DROP TABLE IF EXISTS `annual_trash_payrate_permonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annual_trash_payrate_permonth` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kp_usergroup_idfk` bigint unsigned NOT NULL,
  `budgetyear_idfk` bigint unsigned NOT NULL,
  `payrate_permonth` float NOT NULL,
  `vat` float NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `deleted` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `annual_trash_payrate_permonth_kp_usergroup_idfk_foreign` (`kp_usergroup_idfk`),
  KEY `annual_trash_payrate_permonth_budgetyear_idfk_foreign` (`budgetyear_idfk`),
  CONSTRAINT `annual_trash_payrate_permonth_budgetyear_idfk_foreign` FOREIGN KEY (`budgetyear_idfk`) REFERENCES `budget_year` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `annual_trash_payrate_permonth_kp_usergroup_idfk_foreign` FOREIGN KEY (`kp_usergroup_idfk`) REFERENCES `kp_usergroups` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annual_trash_subscriptions`
--

DROP TABLE IF EXISTS `annual_trash_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annual_trash_subscriptions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `fiscal_year` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `waste_bin_id` bigint unsigned DEFAULT NULL,
  `payrate_permonth_id_fk` bigint unsigned DEFAULT NULL,
  `annual_fee` decimal(10,2) NOT NULL,
  `month_fee` decimal(10,2) NOT NULL,
  `total_paid_amt` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `annual_trash_subscriptions_user_id_foreign` (`user_id`),
  KEY `annual_trash_subscriptions_waste_bin_id_foreign` (`waste_bin_id`),
  KEY `annual_trash_subscriptions_payrate_permonth_id_fk_foreign` (`payrate_permonth_id_fk`),
  CONSTRAINT `annual_trash_subscriptions_payrate_permonth_id_fk_foreign` FOREIGN KEY (`payrate_permonth_id_fk`) REFERENCES `annual_trash_payrate_permonth` (`id`) ON DELETE CASCADE,
  CONSTRAINT `annual_trash_subscriptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `annual_trash_subscriptions_waste_bin_id_foreign` FOREIGN KEY (`waste_bin_id`) REFERENCES `annual_trashs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `annual_trashs`
--

DROP TABLE IF EXISTS `annual_trashs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annual_trashs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `bin_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bin_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `status` enum('active','inactive','damaged','removed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `is_active_for_annual_collection` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `annual_trashs_bin_code_unique` (`bin_code`),
  KEY `annual_trashs_user_id_foreign` (`user_id`),
  CONSTRAINT `annual_trashs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `approval_workflow_steps`
--

DROP TABLE IF EXISTS `approval_workflow_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approval_workflow_steps` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workflow_id` bigint unsigned NOT NULL,
  `step_order` int NOT NULL,
  `role_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specific_user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_workflow_steps_workflow_id_foreign` (`workflow_id`),
  CONSTRAINT `approval_workflow_steps_workflow_id_foreign` FOREIGN KEY (`workflow_id`) REFERENCES `approval_workflows` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `approval_workflows`
--

DROP TABLE IF EXISTS `approval_workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approval_workflows` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approval_workflows_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `approval_workflows_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `budget_year`
--

DROP TABLE IF EXISTS `budget_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budget_year` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `budgetyear_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `status` enum('inactive','active') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `compost_bins`
--

DROP TABLE IF EXISTS `compost_bins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compost_bins` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `bin_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bin_size` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_date` date NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `compost_bins_bin_code_unique` (`bin_code`),
  KEY `compost_bins_user_id_foreign` (`user_id`),
  CONSTRAINT `compost_bins_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cp_sensor_data`
--

DROP TABLE IF EXISTS `cp_sensor_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cp_sensor_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `temperature` decimal(8,2) NOT NULL,
  `humidity` decimal(8,2) NOT NULL,
  `methane_gas` decimal(8,2) NOT NULL,
  `weight` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `districts`
--

DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `districts` (
  `id` bigint unsigned NOT NULL,
  `district_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `province_id` bigint unsigned NOT NULL,
  `go_id` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `districts_province_id_foreign` (`province_id`),
  CONSTRAINT `districts_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emission_factors`
--

DROP TABLE IF EXISTS `emission_factors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emission_factors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `material_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kg',
  `ef_value` decimal(10,5) NOT NULL,
  `source` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `example` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `food_waste_accounts`
--

DROP TABLE IF EXISTS `food_waste_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food_waste_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `points_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `money_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_weight_kg` double NOT NULL DEFAULT '0',
  `last_contributed_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `food_waste_accounts_user_id_foreign` (`user_id`),
  KEY `food_waste_accounts_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `food_waste_accounts_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `food_waste_accounts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwast_iotboxes`
--

DROP TABLE IF EXISTS `foodwast_iotboxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwast_iotboxes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `iotbox_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `temp_humid_sensor` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `gas_sensor` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight_sensor` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `foodwast_iotboxes_iotbox_code_unique` (`iotbox_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwast_meal_logs`
--

DROP TABLE IF EXISTS `foodwast_meal_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwast_meal_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `photo_path` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_calories` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foodwast_meal_logs_user_id_foreign` (`user_id`),
  CONSTRAINT `foodwast_meal_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_bins`
--

DROP TABLE IF EXISTS `foodwaste_bins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_bins` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bin_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bin_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location_description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `status` enum('active','inactive','damaged','removed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `u_pref_id_fk` bigint unsigned DEFAULT NULL,
  `bin_code_fk` bigint unsigned DEFAULT NULL,
  `iotbox_id_fk` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `foodwaste_bins_bin_code_unique` (`bin_code`),
  KEY `foodwaste_bins_u_pref_id_fk_index` (`u_pref_id_fk`),
  KEY `foodwaste_bins_bin_code_fk_index` (`bin_code_fk`),
  KEY `foodwaste_bins_iotbox_id_fk_index` (`iotbox_id_fk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_compost_batches`
--

DROP TABLE IF EXISTS `foodwaste_compost_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_compost_batches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `batch_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `closed_date` date DEFAULT NULL,
  `status` enum('filling','composting','ready') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'filling',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foodwaste_compost_batches_user_id_foreign` (`user_id`),
  CONSTRAINT `foodwaste_compost_batches_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_issue_reports`
--

DROP TABLE IF EXISTS `foodwaste_issue_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_issue_reports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `batch_id` bigint unsigned DEFAULT NULL,
  `issue_type_id` bigint unsigned DEFAULT NULL,
  `assigned_staff_id` bigint unsigned DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','in_progress','resolved','cancel') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_note` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `staff_comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foodwaste_issue_reports_user_id_foreign` (`user_id`),
  KEY `foodwaste_issue_reports_batch_id_foreign` (`batch_id`),
  KEY `foodwaste_issue_reports_issue_type_id_foreign` (`issue_type_id`),
  KEY `foodwaste_issue_reports_assigned_staff_id_foreign` (`assigned_staff_id`),
  CONSTRAINT `foodwaste_issue_reports_assigned_staff_id_foreign` FOREIGN KEY (`assigned_staff_id`) REFERENCES `staffs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `foodwaste_issue_reports_batch_id_foreign` FOREIGN KEY (`batch_id`) REFERENCES `foodwaste_compost_batches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `foodwaste_issue_reports_issue_type_id_foreign` FOREIGN KEY (`issue_type_id`) REFERENCES `foodwaste_issue_types` (`id`) ON DELETE SET NULL,
  CONSTRAINT `foodwaste_issue_reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_issue_types`
--

DROP TABLE IF EXISTS `foodwaste_issue_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_issue_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foodwaste_issue_types_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `foodwaste_issue_types_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_reward_settings`
--

DROP TABLE IF EXISTS `foodwaste_reward_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_reward_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `unit` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `foodwaste_reward_settings_key_unique` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_transactions`
--

DROP TABLE IF EXISTS `foodwaste_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `fw_pref_id_fk` bigint unsigned NOT NULL,
  `waste_log_id` bigint unsigned DEFAULT NULL,
  `transaction_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `points` int NOT NULL DEFAULT '0',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `note` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `staff_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foodwaste_transactions_fw_pref_id_fk_foreign` (`fw_pref_id_fk`),
  KEY `foodwaste_transactions_staff_id_foreign` (`staff_id`),
  CONSTRAINT `foodwaste_transactions_fw_pref_id_fk_foreign` FOREIGN KEY (`fw_pref_id_fk`) REFERENCES `foodwaste_user_preferences` (`id`),
  CONSTRAINT `foodwaste_transactions_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_user_bin_iotbox_matchings`
--

DROP TABLE IF EXISTS `foodwaste_user_bin_iotbox_matchings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_user_bin_iotbox_matchings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `fw_user_id_fk` bigint unsigned NOT NULL,
  `bin_id_fk` bigint unsigned NOT NULL,
  `iotbox_id_fk` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_matching_combination` (`fw_user_id_fk`,`bin_id_fk`,`iotbox_id_fk`),
  KEY `foodwaste_user_bin_iotbox_matchings_bin_id_fk_foreign` (`bin_id_fk`),
  KEY `foodwaste_user_bin_iotbox_matchings_iotbox_id_fk_foreign` (`iotbox_id_fk`),
  CONSTRAINT `foodwaste_user_bin_iotbox_matchings_bin_id_fk_foreign` FOREIGN KEY (`bin_id_fk`) REFERENCES `foodwaste_bins` (`id`) ON DELETE CASCADE,
  CONSTRAINT `foodwaste_user_bin_iotbox_matchings_fw_user_id_fk_foreign` FOREIGN KEY (`fw_user_id_fk`) REFERENCES `kp_user_waste_preferences` (`id`) ON DELETE CASCADE,
  CONSTRAINT `foodwaste_user_bin_iotbox_matchings_iotbox_id_fk_foreign` FOREIGN KEY (`iotbox_id_fk`) REFERENCES `foodwast_iotboxes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_user_preferences`
--

DROP TABLE IF EXISTS `foodwaste_user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_user_preferences` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foodwaste_user_preferences_user_id_foreign` (`user_id`),
  CONSTRAINT `foodwaste_user_preferences_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foodwaste_waste_logs`
--

DROP TABLE IF EXISTS `foodwaste_waste_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foodwaste_waste_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `weight_kg` decimal(8,2) NOT NULL,
  `photo_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_mixed` tinyint(1) NOT NULL DEFAULT '0',
  `moisture` enum('dry','good','wet') COLLATE utf8mb4_unicode_ci NOT NULL,
  `temperature_feel` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carbon_saved_kg` decimal(8,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `estimated_weight` decimal(8,2) NOT NULL,
  `actual_moisture_avg` decimal(5,2) DEFAULT NULL,
  `verified_dry_weight` decimal(8,2) DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `foodwaste_waste_logs_user_id_foreign` (`user_id`),
  KEY `foodwaste_waste_logs_batch_id_foreign` (`batch_id`),
  CONSTRAINT `foodwaste_waste_logs_batch_id_foreign` FOREIGN KEY (`batch_id`) REFERENCES `foodwaste_compost_batches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `foodwaste_waste_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_categories`
--

DROP TABLE IF EXISTS `inv_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `approval_workflow_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_categories_org_id_fk_foreign` (`org_id_fk`),
  KEY `inv_categories_approval_workflow_id_foreign` (`approval_workflow_id`),
  CONSTRAINT `inv_categories_approval_workflow_id_foreign` FOREIGN KEY (`approval_workflow_id`) REFERENCES `approval_workflows` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inv_categories_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_hazard_levels`
--

DROP TABLE IF EXISTS `inv_hazard_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_hazard_levels` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_hazard_levels_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `inv_hazard_levels_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_item_details`
--

DROP TABLE IF EXISTS `inv_item_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_item_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inv_item_id_fk` bigint unsigned NOT NULL,
  `lot_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_doc` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serial_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `initial_qty` decimal(10,2) NOT NULL,
  `current_qty` decimal(10,2) NOT NULL,
  `expire_date` date DEFAULT NULL,
  `location_id_fk` bigint unsigned DEFAULT NULL,
  `conversion_rate` decimal(10,2) NOT NULL DEFAULT '1.00',
  `received_date` date DEFAULT NULL,
  `received_by` bigint unsigned DEFAULT NULL,
  `status` enum('ACTIVE','EMPTY','EXPIRED','DISPOSED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_item_details_inv_item_id_fk_foreign` (`inv_item_id_fk`),
  KEY `inv_item_details_received_by_foreign` (`received_by`),
  KEY `inv_item_details_location_id_fk_foreign` (`location_id_fk`),
  CONSTRAINT `inv_item_details_inv_item_id_fk_foreign` FOREIGN KEY (`inv_item_id_fk`) REFERENCES `inv_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inv_item_details_location_id_fk_foreign` FOREIGN KEY (`location_id_fk`) REFERENCES `inv_locations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inv_item_details_received_by_foreign` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_item_hazard`
--

DROP TABLE IF EXISTS `inv_item_hazard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_item_hazard` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inv_item_id` bigint unsigned NOT NULL,
  `inv_hazard_level_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_item_hazard_inv_item_id_foreign` (`inv_item_id`),
  KEY `inv_item_hazard_inv_hazard_level_id_foreign` (`inv_hazard_level_id`),
  CONSTRAINT `inv_item_hazard_inv_hazard_level_id_foreign` FOREIGN KEY (`inv_hazard_level_id`) REFERENCES `inv_hazard_levels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inv_item_hazard_inv_item_id_foreign` FOREIGN KEY (`inv_item_id`) REFERENCES `inv_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_items`
--

DROP TABLE IF EXISTS `inv_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `inv_category_id_fk` bigint unsigned DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `unit` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `min_stock` int NOT NULL DEFAULT '0',
  `item_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERAL',
  `image_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_chemical` tinyint(1) NOT NULL DEFAULT '0',
  `return_required` tinyint(1) NOT NULL DEFAULT '0',
  `expire_date` date DEFAULT NULL,
  `cas_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chemical_formula` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grade` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `storage_condition` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `msds_link` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_items_inv_category_id_fk_foreign` (`inv_category_id_fk`),
  CONSTRAINT `inv_items_inv_category_id_fk_foreign` FOREIGN KEY (`inv_category_id_fk`) REFERENCES `inv_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_locations`
--

DROP TABLE IF EXISTS `inv_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_locations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `department` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_transaction_approvals`
--

DROP TABLE IF EXISTS `inv_transaction_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_transaction_approvals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ref_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inventory',
  `approval_workflow_id` bigint unsigned NOT NULL,
  `step_order` int NOT NULL DEFAULT '1',
  `approver_id` bigint unsigned NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `action_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_transaction_approvals_approval_workflow_id_foreign` (`approval_workflow_id`),
  CONSTRAINT `inv_transaction_approvals_approval_workflow_id_foreign` FOREIGN KEY (`approval_workflow_id`) REFERENCES `inv_transaction_approvals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_transactions`
--

DROP TABLE IF EXISTS `inv_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ref_no` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `requester_id_fk` bigint unsigned NOT NULL,
  `requester_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approver_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approve_workflow_id_fk` bigint unsigned NOT NULL,
  `inv_item_id_fk` bigint unsigned DEFAULT NULL,
  `inv_item_detail_id_fk` bigint unsigned DEFAULT NULL,
  `quantity` int NOT NULL,
  `purpose` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','COMPLETED','RETURNED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `current_step` int NOT NULL DEFAULT '1',
  `transaction_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint unsigned DEFAULT NULL,
  `rejected_by` bigint unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `canceled_by` bigint unsigned DEFAULT NULL,
  `canceled_at` timestamp NULL DEFAULT NULL,
  `dispensed_by` bigint unsigned DEFAULT NULL,
  `dispensed_at` timestamp NULL DEFAULT NULL,
  `completed_by` bigint unsigned DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `returned_by` bigint unsigned DEFAULT NULL,
  `returned_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_transactions_inv_item_id_fk_foreign` (`inv_item_id_fk`),
  CONSTRAINT `inv_transactions_inv_item_id_fk_foreign` FOREIGN KEY (`inv_item_id_fk`) REFERENCES `inv_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inv_units`
--

DROP TABLE IF EXISTS `inv_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inv_units` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inv_units_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `inv_units_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_period`
--

DROP TABLE IF EXISTS `invoice_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_period` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `inv_p_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inv_p_name_int` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `budgetyear_id` bigint unsigned NOT NULL,
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_period_budgetyear_id_foreign` (`budgetyear_id`),
  KEY `invoice_period_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `invoice_period_budgetyear_id_foreign` FOREIGN KEY (`budgetyear_id`) REFERENCES `budget_year` (`id`),
  CONSTRAINT `invoice_period_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `issue_types`
--

DROP TABLE IF EXISTS `issue_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `issue_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `system_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_suggested` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kiosk_matches`
--

DROP TABLE IF EXISTS `kiosk_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiosk_matches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kiosk_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `status` enum('pending','active','completed','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kiosk_matches_user_id_foreign` (`user_id`),
  KEY `kiosk_matches_kiosk_id_index` (`kiosk_id`),
  CONSTRAINT `kiosk_matches_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kiosk_sensors`
--

DROP TABLE IF EXISTS `kiosk_sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiosk_sensors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sensor_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sensor_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('ok','warning','error','offline') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ok',
  `last_val` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_ping_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `kiosk_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kiosk_sensors_kiosk_id_foreign` (`kiosk_id`),
  CONSTRAINT `kiosk_sensors_kiosk_id_foreign` FOREIGN KEY (`kiosk_id`) REFERENCES `kiosks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kiosks`
--

DROP TABLE IF EXISTS `kiosks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiosks` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `lng` decimal(11,8) DEFAULT NULL,
  `status` enum('idle','active','maintenance','offline') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'offline',
  `current_user_id` bigint unsigned DEFAULT NULL,
  `total_waste_count` int NOT NULL DEFAULT '0',
  `last_online_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kiosks_current_user_id_foreign` (`current_user_id`),
  KEY `kiosks_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `kiosks_current_user_id_foreign` FOREIGN KEY (`current_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kiosks_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_bank_accounts`
--

DROP TABLE IF EXISTS `kp_bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_bank_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `u_wpref_id_fk` bigint unsigned DEFAULT NULL,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `entity_type` enum('recycle_bank','foodwaste_bank','org_recycle') COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `balance` float NOT NULL DEFAULT '0',
  `points` float NOT NULL DEFAULT '0',
  `status` enum('active','inactive','deleted') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_bank_accounts_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_bank_accounts_user_id_foreign` (`user_id`),
  CONSTRAINT `kp_bank_accounts_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_bank_accounts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_bulk_sale_details`
--

DROP TABLE IF EXISTS `kp_bulk_sale_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_bulk_sale_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bulk_sale_id` bigint unsigned NOT NULL,
  `kp_tbank_item_id` bigint unsigned NOT NULL,
  `weight_kg` decimal(10,2) NOT NULL,
  `price_per_unit` decimal(10,2) NOT NULL,
  `sub_total` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_bulk_sale_details_bulk_sale_id_foreign` (`bulk_sale_id`),
  KEY `kp_bulk_sale_details_kp_tbank_item_id_foreign` (`kp_tbank_item_id`),
  CONSTRAINT `kp_bulk_sale_details_bulk_sale_id_foreign` FOREIGN KEY (`bulk_sale_id`) REFERENCES `kp_bulk_sales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_bulk_sale_details_kp_tbank_item_id_foreign` FOREIGN KEY (`kp_tbank_item_id`) REFERENCES `kp_tbank_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_bulk_sales`
--

DROP TABLE IF EXISTS `kp_bulk_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_bulk_sales` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `sale_date` date NOT NULL,
  `buyer_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_cost` decimal(12,2) NOT NULL,
  `total_revenue` decimal(12,2) NOT NULL,
  `profit_amount` decimal(12,2) NOT NULL,
  `receipt_image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recorder_id` bigint unsigned NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_bulk_sales_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_bulk_sales_recorder_id_foreign` (`recorder_id`),
  CONSTRAINT `kp_bulk_sales_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`),
  CONSTRAINT `kp_bulk_sales_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_kiosk_unknown_items`
--

DROP TABLE IF EXISTS `kp_kiosk_unknown_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_kiosk_unknown_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kp_purchase_trans_id` bigint unsigned NOT NULL COMMENT 'ไอดีอ้างอิงใบเสร็จ/ธุรกรรมหลัก',
  `org_id_fk` bigint unsigned DEFAULT NULL COMMENT 'ไอดีหน่วยงาน/องค์กร',
  `kiosk_id_fk` bigint unsigned NOT NULL DEFAULT '1' COMMENT 'ไอดีประจำตู้คีออส',
  `user_id_fk` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'รหัสผู้ใช้งานที่หย่อนสิ่งแปลกปลอม',
  `detected_label` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ชื่อคลาสขยะที่ AI อ่านได้ ณ ตอนนั้น',
  `confidence_score` int NOT NULL DEFAULT '0' COMMENT 'ค่าความมั่นใจของ AI (0-100)',
  `image_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'พาร์ทเก็บรูปภาพขยะสิ่งแปลกปลอมในโฟลเดอร์ public',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_review' COMMENT 'สถานะ: pending_review, verified, rejected',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_kiosk_unknown_items_kp_purchase_trans_id_index` (`kp_purchase_trans_id`),
  KEY `kp_kiosk_unknown_items_user_id_fk_index` (`user_id_fk`),
  KEY `kp_kiosk_unknown_items_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_money_requests`
--

DROP TABLE IF EXISTS `kp_money_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_money_requests` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `batch_id_fk` bigint unsigned DEFAULT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `verification_code` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `hold_status` enum('held','released','settled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'held',
  `is_proxy` tinyint(1) NOT NULL DEFAULT '0',
  `proxy_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `proxy_id_card` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `proxy_relationship` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payout_date` date DEFAULT NULL,
  `admin_id` bigint unsigned DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `signature_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payout_method` enum('cash','transfer') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cash',
  `payout_note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_money_requests_user_id_foreign` (`user_id`),
  KEY `kp_money_requests_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_money_requests_admin_id_foreign` (`admin_id`),
  KEY `kp_money_requests_batch_id_fk_foreign` (`batch_id_fk`),
  CONSTRAINT `kp_money_requests_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`),
  CONSTRAINT `kp_money_requests_batch_id_fk_foreign` FOREIGN KEY (`batch_id_fk`) REFERENCES `kp_withdraw_batches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_money_requests_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_money_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_point_transfers`
--

DROP TABLE IF EXISTS `kp_point_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_point_transfers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sender_id` bigint unsigned NOT NULL,
  `receiver_id` bigint unsigned NOT NULL,
  `amount` int NOT NULL,
  `note` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_point_transfers_sender_id_foreign` (`sender_id`),
  KEY `kp_point_transfers_receiver_id_foreign` (`receiver_id`),
  CONSTRAINT `kp_point_transfers_receiver_id_foreign` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `kp_point_transfers_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_purchase_route_zones`
--

DROP TABLE IF EXISTS `kp_purchase_route_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_purchase_route_zones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kp_purchase_route_id` bigint unsigned NOT NULL,
  `zone_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_purchase_route_zones_kp_purchase_route_id_foreign` (`kp_purchase_route_id`),
  KEY `kp_purchase_route_zones_zone_id_foreign` (`zone_id`),
  CONSTRAINT `kp_purchase_route_zones_kp_purchase_route_id_foreign` FOREIGN KEY (`kp_purchase_route_id`) REFERENCES `kp_purchase_routes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_purchase_route_zones_zone_id_foreign` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_purchase_routes`
--

DROP TABLE IF EXISTS `kp_purchase_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_purchase_routes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `route_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_purchase_routes_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `kp_purchase_routes_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_purchase_shops`
--

DROP TABLE IF EXISTS `kp_purchase_shops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_purchase_shops` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `contact_person` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_purchase_shops_shop_name_unique` (`shop_name`),
  KEY `kp_purchase_shops_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `kp_purchase_shops_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_purchase_transactions`
--

DROP TABLE IF EXISTS `kp_purchase_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_purchase_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `kp_purchase_route_id` bigint unsigned DEFAULT NULL,
  `kp_u_trans_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `machine_id_fk` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `kiosk_id_fk` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `total_weight` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_points` int NOT NULL DEFAULT '0',
  `total_carbon_saved` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT 'ยอดรวมคาร์บอนที่ลดได้ทั้งบิล (kgCO2e)',
  `cash_back` tinyint NOT NULL DEFAULT '0',
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'completed',
  `recorder_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_purchase_transactions_kp_u_trans_no_unique` (`kp_u_trans_no`),
  KEY `kp_purchase_transactions_user_id_foreign` (`user_id`),
  KEY `kp_purchase_transactions_recorder_id_foreign` (`recorder_id`),
  KEY `kp_purchase_transactions_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_purchase_transactions_kp_purchase_route_id_foreign` (`kp_purchase_route_id`),
  KEY `kp_purchase_transactions_kiosk_id_foreign` (`kiosk_id_fk`),
  CONSTRAINT `kp_purchase_transactions_kiosk_id_foreign` FOREIGN KEY (`kiosk_id_fk`) REFERENCES `kiosks` (`id`),
  CONSTRAINT `kp_purchase_transactions_kp_purchase_route_id_foreign` FOREIGN KEY (`kp_purchase_route_id`) REFERENCES `kp_purchase_routes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_purchase_transactions_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_purchase_transactions_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_purchase_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_purchase_transactions_details`
--

DROP TABLE IF EXISTS `kp_purchase_transactions_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_purchase_transactions_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kp_purchase_trans_id` bigint unsigned NOT NULL,
  `kp_recycle_item_id` bigint unsigned NOT NULL,
  `kp_tbank_items_pricepoint_id` bigint unsigned DEFAULT NULL,
  `items_pricepoint_id` bigint unsigned DEFAULT NULL,
  `recorder_id` bigint unsigned DEFAULT NULL,
  `kp_units_idfk` bigint unsigned NOT NULL,
  `amount_in_units` decimal(10,2) NOT NULL,
  `price_per_unit` decimal(8,2) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `points` int NOT NULL DEFAULT '0',
  `carbon_saved` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT 'ปริมาณคาร์บอนที่ลดได้ (kgCO2e)',
  `image_path` text COLLATE utf8mb4_unicode_ci,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_purchase_transactions_details_kp_purchase_trans_id_foreign` (`kp_purchase_trans_id`),
  KEY `kp_purchase_transactions_details_kp_recycle_item_id_foreign` (`kp_recycle_item_id`),
  KEY `kp_purchase_transactions_details_items_pricepoint_id_foreign` (`items_pricepoint_id`),
  KEY `kp_purchase_transactions_details_recorder_id_foreign` (`recorder_id`),
  KEY `kp_purchase_transactions_details_kp_units_idfk_foreign` (`kp_units_idfk`),
  CONSTRAINT `kp_purchase_transactions_details_items_pricepoint_id_foreign` FOREIGN KEY (`items_pricepoint_id`) REFERENCES `kp_tbank_items_pricepoint` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_purchase_transactions_details_kp_purchase_trans_id_foreign` FOREIGN KEY (`kp_purchase_trans_id`) REFERENCES `kp_purchase_transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_purchase_transactions_details_kp_recycle_item_id_foreign` FOREIGN KEY (`kp_recycle_item_id`) REFERENCES `kp_tbank_items` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `kp_purchase_transactions_details_kp_units_idfk_foreign` FOREIGN KEY (`kp_units_idfk`) REFERENCES `kp_tbank_items_units` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_purchase_transactions_details_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_sell_details`
--

DROP TABLE IF EXISTS `kp_sell_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_sell_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `kp_sell_trans_id` bigint unsigned NOT NULL,
  `kp_recycle_item_id` bigint unsigned NOT NULL,
  `weight` decimal(10,2) NOT NULL,
  `price_per_unit` decimal(8,2) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_sell_details_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_sell_details_kp_sell_trans_id_foreign` (`kp_sell_trans_id`),
  KEY `kp_sell_details_kp_recycle_item_id_foreign` (`kp_recycle_item_id`),
  CONSTRAINT `kp_sell_details_kp_recycle_item_id_foreign` FOREIGN KEY (`kp_recycle_item_id`) REFERENCES `kp_tbank_items` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `kp_sell_details_kp_sell_trans_id_foreign` FOREIGN KEY (`kp_sell_trans_id`) REFERENCES `kp_sell_transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_sell_details_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_sell_transactions`
--

DROP TABLE IF EXISTS `kp_sell_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_sell_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `user_id_fk` bigint unsigned DEFAULT NULL,
  `kp_u_trans_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shop_id_fk` bigint unsigned DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `total_weight` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'completed',
  `recorder_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_sell_transactions_kp_u_trans_no_unique` (`kp_u_trans_no`),
  KEY `kp_sell_transactions_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_sell_transactions_user_id_fk_foreign` (`user_id_fk`),
  KEY `kp_sell_transactions_shop_id_fk_foreign` (`shop_id_fk`),
  KEY `kp_sell_transactions_recorder_id_foreign` (`recorder_id`),
  CONSTRAINT `kp_sell_transactions_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_sell_transactions_shop_id_fk_foreign` FOREIGN KEY (`shop_id_fk`) REFERENCES `kp_purchase_shops` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_sell_transactions_user_id_fk_foreign` FOREIGN KEY (`user_id_fk`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_settings`
--

DROP TABLE IF EXISTS `kp_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `key_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `key_value` text COLLATE utf8mb4_unicode_ci,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_settings_org_id_fk_key_name_unique` (`org_id_fk`,`key_name`),
  CONSTRAINT `kp_settings_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_shop_categories`
--

DROP TABLE IF EXISTS `kp_shop_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_shop_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_shop_order_details`
--

DROP TABLE IF EXISTS `kp_shop_order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_shop_order_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kp_shop_order_id` bigint unsigned NOT NULL,
  `kp_shop_product_id` bigint unsigned NOT NULL,
  `order_type` enum('points','cash') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `points_at_purchase` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_at_purchase` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('pending','complete','cancled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_shop_order_details_kp_shop_order_id_foreign` (`kp_shop_order_id`),
  KEY `kp_shop_order_details_kp_shop_product_id_foreign` (`kp_shop_product_id`),
  CONSTRAINT `kp_shop_order_details_kp_shop_order_id_foreign` FOREIGN KEY (`kp_shop_order_id`) REFERENCES `kp_shop_orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_shop_order_details_kp_shop_product_id_foreign` FOREIGN KEY (`kp_shop_product_id`) REFERENCES `kp_shop_products` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_shop_orders`
--

DROP TABLE IF EXISTS `kp_shop_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_shop_orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_wpref_id` bigint unsigned NOT NULL,
  `order_type` enum('points','cash') COLLATE utf8mb4_unicode_ci NOT NULL,
  `points_per_unit` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_per_unit` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_points` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_cash` decimal(10,2) NOT NULL DEFAULT '0.00',
  `order_status` enum('pending','processing','completed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `recorder_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_shop_orders_user_wpref_id_foreign` (`user_wpref_id`),
  KEY `kp_shop_orders_recorder_id_foreign` (`recorder_id`),
  CONSTRAINT `kp_shop_orders_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `staffs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_shop_orders_user_wpref_id_foreign` FOREIGN KEY (`user_wpref_id`) REFERENCES `kp_user_waste_preferences` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_shop_products`
--

DROP TABLE IF EXISTS `kp_shop_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_shop_products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kp_shop_category_id` bigint unsigned NOT NULL,
  `point_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cash_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock` int NOT NULL DEFAULT '0',
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_shop_products_product_code_unique` (`product_code`),
  KEY `kp_shop_products_kp_shop_category_id_foreign` (`kp_shop_category_id`),
  CONSTRAINT `kp_shop_products_kp_shop_category_id_foreign` FOREIGN KEY (`kp_shop_category_id`) REFERENCES `kp_shop_categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_tbank_items`
--

DROP TABLE IF EXISTS `kp_tbank_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_tbank_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kp_itemscode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kp_itemsname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_bank_idfk` bigint unsigned DEFAULT NULL,
  `unit_kiosk_idfk` bigint unsigned DEFAULT NULL,
  `kp_items_group_idfk` bigint unsigned NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `ef_id_fk` bigint unsigned DEFAULT NULL,
  `favorite` int NOT NULL DEFAULT '0',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_tbank_items_kp_items_group_idfk_foreign` (`kp_items_group_idfk`),
  KEY `kp_tbank_items_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_tbank_items_ef_id_fk_foreign` (`ef_id_fk`),
  KEY `kp_tbank_items_unit_bank_idfk_foreign` (`unit_bank_idfk`),
  KEY `kp_tbank_items_unit_kiosk_idfk_foreign` (`unit_kiosk_idfk`),
  CONSTRAINT `kp_tbank_items_ef_id_fk_foreign` FOREIGN KEY (`ef_id_fk`) REFERENCES `emission_factors` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_tbank_items_kp_items_group_idfk_foreign` FOREIGN KEY (`kp_items_group_idfk`) REFERENCES `kp_tbank_items_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `kp_tbank_items_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `kp_tbank_items_unit_bank_idfk_foreign` FOREIGN KEY (`unit_bank_idfk`) REFERENCES `kp_tbank_items_units` (`id`),
  CONSTRAINT `kp_tbank_items_unit_kiosk_idfk_foreign` FOREIGN KEY (`unit_kiosk_idfk`) REFERENCES `kp_tbank_items_units` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_tbank_items_groups`
--

DROP TABLE IF EXISTS `kp_tbank_items_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_tbank_items_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `kp_items_groupname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kp_items_group_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `sequence_number` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `kp_tbank_items_groups_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `kp_tbank_items_groups_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_tbank_items_pricepoint`
--

DROP TABLE IF EXISTS `kp_tbank_items_pricepoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_tbank_items_pricepoint` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `kp_items_idfk` bigint unsigned NOT NULL,
  `price_from_dealer` float NOT NULL,
  `price_for_member` float NOT NULL,
  `point` double NOT NULL,
  `type` enum('tbank','tbox') COLLATE utf8mb4_unicode_ci NOT NULL,
  `kp_units_idfk` bigint unsigned NOT NULL,
  `effective_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `recorder_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_tbank_items_pricepoint_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_tbank_items_pricepoint_kp_items_idfk_foreign` (`kp_items_idfk`),
  KEY `kp_tbank_items_pricepoint_kp_units_idfk_foreign` (`kp_units_idfk`),
  KEY `kp_tbank_items_pricepoint_recorder_id_foreign` (`recorder_id`),
  CONSTRAINT `kp_tbank_items_pricepoint_kp_items_idfk_foreign` FOREIGN KEY (`kp_items_idfk`) REFERENCES `kp_tbank_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `kp_tbank_items_pricepoint_kp_units_idfk_foreign` FOREIGN KEY (`kp_units_idfk`) REFERENCES `kp_tbank_items_units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `kp_tbank_items_pricepoint_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kp_tbank_items_pricepoint_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `staffs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_tbank_items_units`
--

DROP TABLE IF EXISTS `kp_tbank_items_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_tbank_items_units` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `unitname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_short_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_tbank_items_units_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `kp_tbank_items_units_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_user_waste_preferences`
--

DROP TABLE IF EXISTS `kp_user_waste_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_user_waste_preferences` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `org_id` bigint unsigned NOT NULL,
  `is_annual_collection` tinyint(1) NOT NULL DEFAULT '0',
  `is_recycle_bank` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci COMMENT 'ที่อยู่เฉพาะประจำองค์กร',
  `tambon_code` bigint unsigned DEFAULT NULL,
  `district_code` bigint unsigned DEFAULT NULL,
  `province_code` bigint unsigned DEFAULT NULL,
  `zone_id` bigint unsigned DEFAULT NULL,
  `subzone_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_user_waste_preferences_user_id_unique` (`user_id`),
  CONSTRAINT `kp_user_waste_preferences_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_usergroups`
--

DROP TABLE IF EXISTS `kp_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_usergroups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `usergroup_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','invactive') COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_waste_bank_transactions`
--

DROP TABLE IF EXISTS `kp_waste_bank_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_waste_bank_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `staff_id` bigint unsigned DEFAULT NULL,
  `total_member_payout_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `estimated_factory_revenue` decimal(10,2) NOT NULL DEFAULT '0.00',
  `transaction_date` date NOT NULL,
  `receipt_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('completed','pending','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'completed',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_waste_bank_transactions_receipt_code_unique` (`receipt_code`),
  KEY `kp_waste_bank_transactions_user_id_foreign` (`user_id`),
  KEY `kp_waste_bank_transactions_staff_id_foreign` (`staff_id`),
  CONSTRAINT `kp_waste_bank_transactions_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_waste_bank_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_waste_groups`
--

DROP TABLE IF EXISTS `kp_waste_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_waste_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_waste_groups_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_waste_types`
--

DROP TABLE IF EXISTS `kp_waste_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_waste_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `waste_group_id` bigint unsigned DEFAULT NULL,
  `default_unit` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'kg',
  `factory_buy_price_per_kg` decimal(10,2) DEFAULT '0.00',
  `member_buy_price_per_kg` decimal(10,2) DEFAULT '0.00',
  `factory_buy_price_per_piece` decimal(10,2) DEFAULT '0.00',
  `member_buy_price_per_piece` decimal(10,2) DEFAULT '0.00',
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_recyclable` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_waste_types_name_unique` (`name`),
  KEY `kp_waste_types_waste_group_id_foreign` (`waste_group_id`),
  CONSTRAINT `kp_waste_types_waste_group_id_foreign` FOREIGN KEY (`waste_group_id`) REFERENCES `kp_waste_groups` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_welfare_configs`
--

DROP TABLE IF EXISTS `kp_welfare_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_welfare_configs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `min_months_active` int NOT NULL DEFAULT '6',
  `min_total_weight` int NOT NULL DEFAULT '50',
  `default_payout_amount` decimal(12,2) NOT NULL DEFAULT '5000.00',
  `criteria_description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `workflow_id` bigint unsigned DEFAULT NULL,
  `contribution_fee_per_case` decimal(10,2) NOT NULL DEFAULT '60.00',
  PRIMARY KEY (`id`),
  KEY `kp_welfare_configs_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_welfare_configs_workflow_id_foreign` (`workflow_id`),
  CONSTRAINT `kp_welfare_configs_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`),
  CONSTRAINT `kp_welfare_configs_workflow_id_foreign` FOREIGN KEY (`workflow_id`) REFERENCES `approval_workflows` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_welfare_payouts`
--

DROP TABLE IF EXISTS `kp_welfare_payouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_welfare_payouts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `deceased_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `beneficiary_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `death_certificate_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `requester_id` bigint unsigned NOT NULL,
  `approver_id` bigint unsigned DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `current_step_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kp_welfare_payouts_org_id_fk_foreign` (`org_id_fk`),
  KEY `kp_welfare_payouts_user_id_foreign` (`user_id`),
  KEY `kp_welfare_payouts_requester_id_foreign` (`requester_id`),
  KEY `kp_welfare_payouts_approver_id_foreign` (`approver_id`),
  KEY `kp_welfare_payouts_current_step_id_foreign` (`current_step_id`),
  CONSTRAINT `kp_welfare_payouts_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`),
  CONSTRAINT `kp_welfare_payouts_current_step_id_foreign` FOREIGN KEY (`current_step_id`) REFERENCES `approval_workflow_steps` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kp_welfare_payouts_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`),
  CONSTRAINT `kp_welfare_payouts_requester_id_foreign` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`),
  CONSTRAINT `kp_welfare_payouts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kp_withdraw_batches`
--

DROP TABLE IF EXISTS `kp_withdraw_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kp_withdraw_batches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `batch_no` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cutoff_date` date NOT NULL,
  `payout_date` date NOT NULL,
  `total_requests` int NOT NULL DEFAULT '0',
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` enum('draft','in_review','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `current_step_order` int NOT NULL DEFAULT '1',
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kp_withdraw_batches_batch_no_unique` (`batch_no`),
  KEY `kp_withdraw_batches_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `kp_withdraw_batches_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `local_foods`
--

DROP TABLE IF EXISTS `local_foods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `local_foods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `menu_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `calories` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `local_foods_menu_name_unique` (`menu_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `machines`
--

DROP TABLE IF EXISTS `machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `machines` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `machine_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `current_user_active_id` bigint unsigned NOT NULL,
  `has_new_object` tinyint NOT NULL COMMENT 'สถานะขวดใหม่ (0: ไม่มี, 1: แจ้งเตือนแล้ว/รอ AI, 2: AI ตัดสินใจแล้ว)',
  `pending_command` tinyint NOT NULL COMMENT 'คำสั่งที่ AI ตัดสินใจแล้ว (null: ไม่มีคำสั่ง, 0: ACCEPT, 1: REJECT)',
  `buycomplete` enum('0','1') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('wakeup','pending_login','object_detected','ready','active_session','sleep') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sleep',
  `machine_ready` tinyint(1) NOT NULL DEFAULT '0',
  `last_heartbeat_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machines_machine_id_unique` (`machine_id`),
  KEY `machines_org_id_fk_foreign` (`org_id_fk`),
  KEY `machines_current_user_active_id_foreign` (`current_user_active_id`),
  CONSTRAINT `machines_current_user_active_id_foreign` FOREIGN KEY (`current_user_active_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `machines_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meal_items`
--

DROP TABLE IF EXISTS `meal_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meal_log_id` bigint unsigned NOT NULL,
  `menu_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calories` int NOT NULL DEFAULT '0',
  `status` enum('verified','pending_review') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'verified',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meal_items_meal_log_id_foreign` (`meal_log_id`),
  CONSTRAINT `meal_items_meal_log_id_foreign` FOREIGN KEY (`meal_log_id`) REFERENCES `foodwast_meal_logs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `org_accounts`
--

DROP TABLE IF EXISTS `org_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `org_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `acc_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tabwater_balance` float NOT NULL DEFAULT '0',
  `annaul_balance` float NOT NULL DEFAULT '0',
  `recycle_bank_balance` float NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization_types`
--

DROP TABLE IF EXISTS `organization_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'เช่น เทศบาลตำบล, อบต., เทศบาลเมือง',
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'รหัสย่อถ้ามี',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organizations`
--

DROP TABLE IF EXISTS `organizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organizations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `org_type_id` bigint unsigned DEFAULT NULL,
  `org_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `org_address` text COLLATE utf8mb4_unicode_ci,
  `org_zone_id_fk` bigint unsigned DEFAULT NULL,
  `org_tambon_id_fk` bigint unsigned DEFAULT NULL,
  `org_district_id_fk` bigint unsigned DEFAULT NULL,
  `org_province_id_fk` bigint unsigned DEFAULT NULL,
  `org_route` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_zipcode` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_dept_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_dept_short_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_dept_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_head_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fin_head_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tw_head_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fin_head_license_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_head_license_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tw_head_license_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_logo_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meternumbercode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_database` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cutmeter_count` int NOT NULL DEFAULT '0',
  `vat` float NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `lat` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `long` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `organizations_org_code_unique` (`org_code`),
  KEY `organizations_org_zone_id_fk_foreign` (`org_zone_id_fk`),
  KEY `organizations_org_tambon_id_fk_foreign` (`org_tambon_id_fk`),
  KEY `organizations_org_district_id_fk_foreign` (`org_district_id_fk`),
  KEY `organizations_org_province_id_fk_foreign` (`org_province_id_fk`),
  CONSTRAINT `organizations_org_district_id_fk_foreign` FOREIGN KEY (`org_district_id_fk`) REFERENCES `districts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `organizations_org_province_id_fk_foreign` FOREIGN KEY (`org_province_id_fk`) REFERENCES `provinces` (`id`) ON DELETE SET NULL,
  CONSTRAINT `organizations_org_tambon_id_fk_foreign` FOREIGN KEY (`org_tambon_id_fk`) REFERENCES `tambons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `organizations_org_zone_id_fk_foreign` FOREIGN KEY (`org_zone_id_fk`) REFERENCES `zones` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `provinces`
--

DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provinces` (
  `id` bigint unsigned NOT NULL,
  `province_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `go_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recycle_transactions`
--

DROP TABLE IF EXISTS `recycle_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recycle_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` enum('deposit','withdraw') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `weight_kg` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recycle_transactions_user_id_foreign` (`user_id`),
  CONSTRAINT `recycle_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sequence_number`
--

DROP TABLE IF EXISTS `sequence_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequence_number` (
  `id` int NOT NULL,
  `tabmeter` int NOT NULL,
  `user` int NOT NULL COMMENT 'ผู้ใช้น้ำเท่านั้น',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sequence_number_org_id_fk_index` (`org_id_fk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `values` text COLLATE utf8mb4_unicode_ci,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staffs`
--

DROP TABLE IF EXISTS `staffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staffs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staffs_user_id_foreign` (`user_id`),
  KEY `staffs_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `staffs_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `staffs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subzones`
--

DROP TABLE IF EXISTS `subzones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subzones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `zone_id` bigint unsigned NOT NULL,
  `subzone_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subzones_zone_id_foreign` (`zone_id`),
  KEY `subzones_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `subzones_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subzones_zone_id_foreign` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `department` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_person` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `tax_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_modules`
--

DROP TABLE IF EXISTS `system_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_modules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `system_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 0xF09F938C,
  `description` text COLLATE utf8mb4_unicode_ci,
  `color` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'primary',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `system_modules_system_type_unique` (`system_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_device_logs`
--

DROP TABLE IF EXISTS `tabwater_device_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_device_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `device_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_devices.id',
  `staff_id` bigint unsigned DEFAULT NULL COMMENT 'ผู้สั่งงาน (NULL กรณี Auto System สั่ง)',
  `action` enum('ON','OFF') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'คำสั่งเปิด หรือ ปิด',
  `mode` enum('auto','manual') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual' COMMENT 'สั่งด้วยโหมด Auto หรือ Manual',
  `trigger_reason` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'สาเหตุ เช่น ระดับน้ำเต็ม 95% (Auto), นายสมชาย สั่งปิด (Manual)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tabwater_device_logs_device_id_foreign` (`device_id`),
  KEY `tabwater_device_logs_staff_id_foreign` (`staff_id`),
  CONSTRAINT `tabwater_device_logs_device_id_foreign` FOREIGN KEY (`device_id`) REFERENCES `tabwater_devices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tabwater_device_logs_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `staffs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_devices`
--

DROP TABLE IF EXISTS `tabwater_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_devices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `station_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_stations.id',
  `device_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'รหัสอุปกรณ์ เช่น PUMP-RAW-01',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ชื่ออุปกรณ์ เช่น ปั๊มน้ำดิบ 5 กม., วาล์วถังใส',
  `type` enum('pump_raw','pump_clear','dosing_pump','electric_valve','relay') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pump_raw',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'สถานะปัจจุบัน (0=ปิด, 1=เปิด)',
  `control_mode` enum('auto','manual') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'auto' COMMENT 'โหมด Auto หรือ Manual',
  `auto_control_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'เปิด/ปิดการตัดอัตโนมัติ',
  `mqtt_topic` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Topic สำหรับสั่งงาน IoT',
  `relay_channel` int DEFAULT NULL COMMENT 'ช่อง Relay',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tabwater_devices_station_id_foreign` (`station_id`),
  CONSTRAINT `tabwater_devices_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `tabwater_stations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_pipe_nodes`
--

DROP TABLE IF EXISTS `tabwater_pipe_nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_pipe_nodes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `station_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_stations.id (สถานีต้นทาง)',
  `node_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'รหัสจุด เช่น JNC-01',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ชื่อจุดเชื่อมต่อ/จุดกระจายน้ำ',
  `type` enum('station','main_junction','sub_junction','valve_point','tank','end_point') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'main_junction' COMMENT 'ประเภทโหนด',
  `lat` decimal(10,7) NOT NULL COMMENT 'ละติจูด',
  `lng` decimal(10,7) NOT NULL COMMENT 'ลองจิจูด',
  `remark` text COLLATE utf8mb4_unicode_ci,
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tabwater_pipe_nodes_station_id_foreign` (`station_id`),
  CONSTRAINT `tabwater_pipe_nodes_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `tabwater_stations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_pipelines`
--

DROP TABLE IF EXISTS `tabwater_pipelines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_pipelines` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `station_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_stations.id',
  `pipe_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'รหัสเส้นท่อ เช่น PIPE-M01',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ชื่อสายท่อ',
  `from_node_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_pipe_nodes.id',
  `to_node_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_pipe_nodes.id',
  `level` enum('main','sub_main','distribution') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'main' COMMENT 'ท่อเมน / ท่อรอง / ท่อซอย',
  `size_mm` int NOT NULL DEFAULT '110' COMMENT 'ขนาดท่อ (มม.) เช่น 110, 63, 32',
  `material` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PE' COMMENT 'ประเภทวัสดุ เช่น PE, PVC, STEEL',
  `length_m` decimal(8,2) DEFAULT NULL COMMENT 'ความยาวท่อ (เมตร)',
  `path_coordinates` json NOT NULL COMMENT 'พิกัดแนวท่อผ่าน',
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tabwater_pipelines_station_id_foreign` (`station_id`),
  KEY `tabwater_pipelines_from_node_id_foreign` (`from_node_id`),
  KEY `tabwater_pipelines_to_node_id_foreign` (`to_node_id`),
  CONSTRAINT `tabwater_pipelines_from_node_id_foreign` FOREIGN KEY (`from_node_id`) REFERENCES `tabwater_pipe_nodes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tabwater_pipelines_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `tabwater_stations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tabwater_pipelines_to_node_id_foreign` FOREIGN KEY (`to_node_id`) REFERENCES `tabwater_pipe_nodes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_quality_logs`
--

DROP TABLE IF EXISTS `tabwater_quality_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_quality_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `station_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_stations.id',
  `data_source` enum('manual','iot') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual' COMMENT 'ที่มาของข้อมูล',
  `staff_id` bigint unsigned DEFAULT NULL COMMENT 'FK -> staffs.id',
  `device_mac` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'MAC Address กล่อง IoT',
  `secchi_depth_cm` decimal(5,2) DEFAULT NULL COMMENT 'ระยะไม้จุ่ม (cm)',
  `turbidity_ntu` decimal(5,2) DEFAULT NULL COMMENT 'ค่าความขุ่น (NTU)',
  `tds_ppm` decimal(6,2) DEFAULT NULL COMMENT 'สารละลายรวม (TDS PPM)',
  `ph_value` decimal(3,1) DEFAULT NULL COMMENT 'ค่า pH',
  `ph_litmus_image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'รูปถ่ายกระดาษลิตมัส',
  `water_temp_c` decimal(4,1) DEFAULT NULL COMMENT 'อุณหภูมิน้ำ (°C)',
  `water_level_percent` decimal(5,2) DEFAULT NULL COMMENT 'ระดับน้ำใสในถังพัก (%)',
  `alum_valve_level` enum('low','medium','high') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ระดับการเปิดก๊อกสารส้ม',
  `lime_bucket_count` int DEFAULT NULL COMMENT 'จำนวนถังน้ำปูนขาวที่ผสม',
  `alum_used_kg` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'สารส้มที่ใส่จริง (kg)',
  `lime_used_kg` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'ปูนขาวที่ใส่จริง (kg)',
  `log_date` date NOT NULL COMMENT 'วันที่บันทึก',
  `log_time` time NOT NULL COMMENT 'เวลาที่บันทึก',
  `remark` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tabwater_quality_logs_station_id_foreign` (`station_id`),
  KEY `tabwater_quality_logs_staff_id_foreign` (`staff_id`),
  CONSTRAINT `tabwater_quality_logs_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `staffs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tabwater_quality_logs_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `tabwater_stations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_station_staffs`
--

DROP TABLE IF EXISTS `tabwater_station_staffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_station_staffs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `station_id` bigint unsigned NOT NULL COMMENT 'FK -> tabwater_stations.id',
  `staff_id` bigint unsigned NOT NULL COMMENT 'FK -> staffs.id',
  `role` enum('primary','secondary') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'secondary' COMMENT 'ระดับการรับผิดชอบ หลัก/รอง',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tabwater_station_staffs_station_id_staff_id_unique` (`station_id`,`staff_id`),
  KEY `tabwater_station_staffs_staff_id_foreign` (`staff_id`),
  CONSTRAINT `tabwater_station_staffs_staff_id_foreign` FOREIGN KEY (`staff_id`) REFERENCES `staffs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tabwater_station_staffs_station_id_foreign` FOREIGN KEY (`station_id`) REFERENCES `tabwater_stations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tabwater_stations`
--

DROP TABLE IF EXISTS `tabwater_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tabwater_stations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL COMMENT 'รหัสเทศบาล/องค์กร',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'รหัสสถานี เช่น ST-01',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ชื่อสถานีผลิตน้ำ',
  `lat` decimal(10,7) DEFAULT NULL COMMENT 'พิกัด ละติจูด',
  `lng` decimal(10,7) DEFAULT NULL COMMENT 'พิกัด ลองจิจูด',
  `max_turbidity_ntu` decimal(5,2) NOT NULL DEFAULT '5.00' COMMENT 'เกณฑ์ความขุ่นวิกฤต (NTU)',
  `min_ph` decimal(3,1) NOT NULL DEFAULT '6.5' COMMENT 'ค่า pH ต่ำสุด',
  `max_ph` decimal(3,1) NOT NULL DEFAULT '8.5' COMMENT 'ค่า pH สูงสุด',
  `max_tds_ppm` decimal(6,2) NOT NULL DEFAULT '300.00' COMMENT 'เกณฑ์ TDS สูงสุด',
  `min_water_level_percent` decimal(5,2) NOT NULL DEFAULT '30.00' COMMENT 'ระดับน้ำต่ำเตือนเร่งสูบ (%)',
  `max_water_level_percent` decimal(5,2) NOT NULL DEFAULT '95.00' COMMENT 'ระดับน้ำสูงเตือนตัดปั๊ม (%)',
  `secchi_k_factor` decimal(6,2) NOT NULL DEFAULT '350.00' COMMENT 'ค่า K สำหรับคำนวณไม้จุ่ม',
  `status` enum('normal','warning','danger') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tambons`
--

DROP TABLE IF EXISTS `tambons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tambons` (
  `id` bigint unsigned NOT NULL,
  `tambon_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district_id` bigint unsigned NOT NULL,
  `zipcode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`district_id`),
  KEY `tambons_district_id_foreign` (`district_id`),
  CONSTRAINT `tambons_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction_approvals`
--

DROP TABLE IF EXISTS `transaction_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_approvals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workflow_id` bigint unsigned NOT NULL,
  `approvable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approvable_id` bigint unsigned NOT NULL,
  `step_order` int NOT NULL,
  `approver_id` bigint unsigned NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `action_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_approvals_workflow_id_foreign` (`workflow_id`),
  CONSTRAINT `transaction_approvals_workflow_id_foreign` FOREIGN KEY (`workflow_id`) REFERENCES `approval_workflows` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction_details`
--

DROP TABLE IF EXISTS `transaction_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `waste_bank_transaction_id` bigint unsigned NOT NULL,
  `waste_type_id` bigint unsigned NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_used` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_price_per_unit` decimal(10,2) NOT NULL,
  `total_member_amount` decimal(10,2) NOT NULL,
  `factory_price_per_unit` decimal(10,2) NOT NULL,
  `total_factory_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_details_waste_bank_transaction_id_foreign` (`waste_bank_transaction_id`),
  KEY `transaction_details_waste_type_id_foreign` (`waste_type_id`),
  CONSTRAINT `transaction_details_waste_bank_transaction_id_foreign` FOREIGN KEY (`waste_bank_transaction_id`) REFERENCES `kp_waste_bank_transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transaction_details_waste_type_id_foreign` FOREIGN KEY (`waste_type_id`) REFERENCES `kp_waste_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_acc_transactions`
--

DROP TABLE IF EXISTS `tw_acc_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_acc_transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meter_id_fk` bigint unsigned NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `paidsum` float NOT NULL DEFAULT '0',
  `vatsum` float NOT NULL DEFAULT '0',
  `reserve_meter_sum` float NOT NULL DEFAULT '0',
  `totalpaidsum` float NOT NULL DEFAULT '0',
  `status` enum('1','0') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '1= active, 0=deleted',
  `cashier` bigint unsigned NOT NULL COMMENT 'ผู้รับเงิน',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tw_acc_transactions_meter_id_fk_foreign` (`meter_id_fk`),
  KEY `tw_acc_transactions_cashier_foreign` (`cashier`),
  CONSTRAINT `tw_acc_transactions_cashier_foreign` FOREIGN KEY (`cashier`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_acc_transactions_meter_id_fk_foreign` FOREIGN KEY (`meter_id_fk`) REFERENCES `tw_meter_infos` (`meter_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_cutmeter`
--

DROP TABLE IF EXISTS `tw_cutmeter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_cutmeter` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meter_id_fk` bigint unsigned NOT NULL,
  `owe_count` int NOT NULL DEFAULT '0',
  `warning_print` int NOT NULL DEFAULT '0',
  `status` enum('pending','cutmeter','install','complete','cancel') COLLATE utf8mb4_unicode_ci NOT NULL,
  `operate_by` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'รหัส staffs ถ้า >1 ใช้ | แยก',
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tw_cutmeter_meter_id_fk_foreign` (`meter_id_fk`),
  CONSTRAINT `tw_cutmeter_meter_id_fk_foreign` FOREIGN KEY (`meter_id_fk`) REFERENCES `tw_meter_infos` (`meter_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_invoice`
--

DROP TABLE IF EXISTS `tw_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_invoice` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `meter_id_fk` bigint unsigned NOT NULL,
  `inv_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inv_period_id_fk` bigint unsigned NOT NULL,
  `lastmeter` decimal(8,2) NOT NULL,
  `currentmeter` decimal(8,2) NOT NULL,
  `water_used` decimal(8,2) NOT NULL,
  `inv_type` enum('r','u') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'r =รักษามิเตอร์, u=ใช้น้ำ',
  `paid` decimal(8,2) NOT NULL,
  `reserve_meter` decimal(6,2) NOT NULL,
  `vat` decimal(8,2) NOT NULL,
  `totalpaid` decimal(8,2) NOT NULL,
  `previous_balance` decimal(8,2) NOT NULL,
  `status` enum('init','invoice','paid','owe','deleted') COLLATE utf8mb4_unicode_ci NOT NULL,
  `acc_trans_id_fk` bigint unsigned DEFAULT NULL,
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recorder_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tw_invoice_inv_no_unique` (`inv_no`),
  KEY `tw_invoice_meter_id_fk_foreign` (`meter_id_fk`),
  KEY `tw_invoice_inv_period_id_fk_foreign` (`inv_period_id_fk`),
  KEY `tw_invoice_acc_trans_id_fk_foreign` (`acc_trans_id_fk`),
  KEY `tw_invoice_recorder_id_foreign` (`recorder_id`),
  KEY `tw_invoice_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `tw_invoice_acc_trans_id_fk_foreign` FOREIGN KEY (`acc_trans_id_fk`) REFERENCES `tw_acc_transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_inv_period_id_fk_foreign` FOREIGN KEY (`inv_period_id_fk`) REFERENCES `invoice_period` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_meter_id_fk_foreign` FOREIGN KEY (`meter_id_fk`) REFERENCES `tw_meter_infos` (`meter_id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_invoice_history`
--

DROP TABLE IF EXISTS `tw_invoice_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_invoice_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `meter_id_fk` bigint unsigned NOT NULL,
  `inv_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inv_period_id_fk` bigint unsigned NOT NULL,
  `lastmeter` decimal(8,2) NOT NULL,
  `currentmeter` decimal(8,2) NOT NULL,
  `water_used` decimal(8,2) NOT NULL,
  `inv_type` enum('r','u') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'r =รักษามิเตอร์, u=ใช้น้ำ',
  `paid` decimal(8,2) NOT NULL,
  `reserve_meter` decimal(6,2) NOT NULL,
  `vat` decimal(8,2) NOT NULL,
  `totalpaid` decimal(8,2) NOT NULL,
  `previous_balance` decimal(8,2) NOT NULL,
  `status` enum('init','invoice','paid','owe','deleted') COLLATE utf8mb4_unicode_ci NOT NULL,
  `acc_trans_id_fk` bigint unsigned DEFAULT NULL,
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recorder_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tw_invoice_inv_no_unique` (`inv_no`),
  KEY `tw_invoice_meter_id_fk_foreign` (`meter_id_fk`),
  KEY `tw_invoice_inv_period_id_fk_foreign` (`inv_period_id_fk`),
  KEY `tw_invoice_acc_trans_id_fk_foreign` (`acc_trans_id_fk`),
  KEY `tw_invoice_recorder_id_foreign` (`recorder_id`),
  KEY `tw_invoice_org_id_fk_foreign` (`org_id_fk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_invoice_temp`
--

DROP TABLE IF EXISTS `tw_invoice_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_invoice_temp` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meter_id_fk` bigint unsigned NOT NULL,
  `inv_period_id_fk` bigint unsigned NOT NULL,
  `lastmeter` float NOT NULL,
  `currentmeter` float NOT NULL,
  `water_used` float NOT NULL,
  `inv_type` enum('r','u') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'r =รักษามิเตอร์, u=ใช้น้ำ',
  `paid` float NOT NULL,
  `reserve_meter` float NOT NULL,
  `vat` float NOT NULL,
  `totalpaid` float NOT NULL,
  `status` enum('init','invoice','paid','owe','deleted') COLLATE utf8mb4_unicode_ci NOT NULL,
  `acc_trans_id_fk` bigint unsigned DEFAULT NULL,
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recorder_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tw_invoice_temp_meter_id_fk_foreign` (`meter_id_fk`),
  KEY `tw_invoice_temp_inv_period_id_fk_foreign` (`inv_period_id_fk`),
  KEY `tw_invoice_temp_acc_trans_id_fk_foreign` (`acc_trans_id_fk`),
  KEY `tw_invoice_temp_recorder_id_foreign` (`recorder_id`),
  CONSTRAINT `tw_invoice_temp_acc_trans_id_fk_foreign` FOREIGN KEY (`acc_trans_id_fk`) REFERENCES `tw_acc_transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_temp_inv_period_id_fk_foreign` FOREIGN KEY (`inv_period_id_fk`) REFERENCES `invoice_period` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_temp_meter_id_fk_foreign` FOREIGN KEY (`meter_id_fk`) REFERENCES `tw_meter_infos` (`meter_id`) ON DELETE CASCADE,
  CONSTRAINT `tw_invoice_temp_recorder_id_foreign` FOREIGN KEY (`recorder_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_meter_infos`
--

DROP TABLE IF EXISTS `tw_meter_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_meter_infos` (
  `meter_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `meternumber` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `factory_no` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submeter_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meter_address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `undertake_zone_id` bigint unsigned NOT NULL,
  `undertake_subzone_id` bigint unsigned NOT NULL,
  `acceptance_date` date NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `comment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owe_count` int NOT NULL DEFAULT '0',
  `cutmeter` enum('1','0') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `inv_no_index` int NOT NULL DEFAULT '0',
  `payment_id` int NOT NULL DEFAULT '0',
  `recorder_id` int NOT NULL,
  `last_meter_recording` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `metertype_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`meter_id`),
  KEY `tw_meter_infos_user_id_foreign` (`user_id`),
  KEY `tw_meter_infos_undertake_zone_id_foreign` (`undertake_zone_id`),
  KEY `tw_meter_infos_undertake_subzone_id_foreign` (`undertake_subzone_id`),
  KEY `tw_meter_infos_metertype_id_foreign` (`metertype_id`),
  CONSTRAINT `tw_meter_infos_metertype_id_foreign` FOREIGN KEY (`metertype_id`) REFERENCES `tw_meter_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_meter_infos_undertake_subzone_id_foreign` FOREIGN KEY (`undertake_subzone_id`) REFERENCES `subzones` (`id`),
  CONSTRAINT `tw_meter_infos_undertake_zone_id_foreign` FOREIGN KEY (`undertake_zone_id`) REFERENCES `zones` (`id`),
  CONSTRAINT `tw_meter_infos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_meter_type_rate_configs`
--

DROP TABLE IF EXISTS `tw_meter_type_rate_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_meter_type_rate_configs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meter_type_id_fk` bigint unsigned NOT NULL,
  `pricing_type_id` bigint unsigned NOT NULL,
  `tier_calculation_type` tinyint NOT NULL DEFAULT '1' COMMENT 'Progressive =>1=คิดเงินซอยคิดทีละช่วง, 2เอาหน่วยน้ำ x อัตราของช่วงนั้น',
  `charge_min_only_zero_use` tinyint NOT NULL DEFAULT '0' COMMENT 'check ว่าเก็บค่ารักษามิเตอร์ไหม',
  `min_usage_charge` decimal(8,2) DEFAULT NULL COMMENT 'ค่ารักษามิเตอร์',
  `vat` decimal(4,2) NOT NULL DEFAULT '0.00',
  `fixed_rate_per_unit` decimal(8,2) DEFAULT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tw_meter_type_rate_configs_meter_type_id_fk_foreign` (`meter_type_id_fk`),
  KEY `tw_meter_type_rate_configs_pricing_type_id_foreign` (`pricing_type_id`),
  KEY `tw_meter_type_rate_configs_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `tw_meter_type_rate_configs_meter_type_id_fk_foreign` FOREIGN KEY (`meter_type_id_fk`) REFERENCES `tw_meter_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_meter_type_rate_configs_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_meter_type_rate_configs_pricing_type_id_foreign` FOREIGN KEY (`pricing_type_id`) REFERENCES `tw_pricing_types` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_meter_type_rate_tiers`
--

DROP TABLE IF EXISTS `tw_meter_type_rate_tiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_meter_type_rate_tiers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meter_type_rate_config_id` bigint unsigned NOT NULL,
  `min_units` int NOT NULL,
  `max_units` int DEFAULT NULL,
  `rate_per_unit` float NOT NULL,
  `tier_order` int NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tier_order_unique_per_config` (`meter_type_rate_config_id`,`tier_order`),
  CONSTRAINT `tw_meter_type_rate_tiers_meter_type_rate_config_id_foreign` FOREIGN KEY (`meter_type_rate_config_id`) REFERENCES `tw_meter_type_rate_configs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_meter_types`
--

DROP TABLE IF EXISTS `tw_meter_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_meter_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `meter_type_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metersize` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tw_meter_types_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `tw_meter_types_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_notifies`
--

DROP TABLE IF EXISTS `tw_notifies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_notifies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `reporter_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reporter_phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_type_id` bigint unsigned NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `photo_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','processing','complete','cancel') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tw_notifies_user_id_foreign` (`user_id`),
  KEY `tw_notifies_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `tw_notifies_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_notifies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_notify_staff`
--

DROP TABLE IF EXISTS `tw_notify_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_notify_staff` (
  `notify_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `staff_status` enum('accepted','working','completed','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'accepted',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`notify_id`,`user_id`),
  KEY `tw_notify_staff_user_id_foreign` (`user_id`),
  CONSTRAINT `tw_notify_staff_notify_id_foreign` FOREIGN KEY (`notify_id`) REFERENCES `tw_notifies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tw_notify_staff_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tw_pricing_types`
--

DROP TABLE IF EXISTS `tw_pricing_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tw_pricing_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tw_pricing_types_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `undertaker_subzones`
--

DROP TABLE IF EXISTS `undertaker_subzones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `undertaker_subzones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  `twman_id` bigint unsigned DEFAULT NULL,
  `subzone_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `undertaker_subzones_subzone_id_foreign` (`subzone_id`),
  CONSTRAINT `undertaker_subzones_subzone_id_foreign` FOREIGN KEY (`subzone_id`) REFERENCES `subzones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prefix` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province_code` bigint unsigned DEFAULT NULL,
  `district_code` bigint unsigned DEFAULT NULL,
  `tambon_code` bigint unsigned DEFAULT NULL,
  `subzone_id` bigint unsigned DEFAULT NULL,
  `zone_id` bigint unsigned DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `age` int NOT NULL DEFAULT '0',
  `weight` double NOT NULL DEFAULT '0',
  `height` double NOT NULL DEFAULT '0',
  `line_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `line_user_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'มาจาก Api',
  `id_card` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` text COLLATE utf8mb4_unicode_ci,
  `gender` enum('m','w') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive','deleted') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `org_id_fk` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_org_id_fk_foreign` (`org_id_fk`),
  KEY `users_zone_id_foreign` (`zone_id`),
  KEY `users_subzone_id_foreign` (`subzone_id`),
  KEY `users_tambon_code_foreign` (`tambon_code`),
  KEY `users_district_code_foreign` (`district_code`),
  KEY `users_province_code_foreign` (`province_code`),
  CONSTRAINT `users_district_code_foreign` FOREIGN KEY (`district_code`) REFERENCES `districts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `users_province_code_foreign` FOREIGN KEY (`province_code`) REFERENCES `provinces` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_subzone_id_foreign` FOREIGN KEY (`subzone_id`) REFERENCES `subzones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_tambon_code_foreign` FOREIGN KEY (`tambon_code`) REFERENCES `tambons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_zone_id_foreign` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `welfare_contributions`
--

DROP TABLE IF EXISTS `welfare_contributions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `welfare_contributions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `payout_id` bigint unsigned DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT '60.00',
  `payment_method` enum('auto_wallet','cash','transfer','pending_deduct') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_deduct',
  `status` enum('pending','paid','exempted') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL,
  `slip_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `welfare_contributions_user_id_foreign` (`user_id`),
  CONSTRAINT `welfare_contributions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `welfare_members`
--

DROP TABLE IF EXISTS `welfare_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `welfare_members` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `org_id_fk` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `membership_type` enum('both','waste_only','contribution_only') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'both',
  `status` enum('active','suspended','terminated') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `registered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `welfare_members_org_id_fk_user_id_unique` (`org_id_fk`,`user_id`),
  KEY `welfare_members_user_id_foreign` (`user_id`),
  CONSTRAINT `welfare_members_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `welfare_payout_logs`
--

DROP TABLE IF EXISTS `welfare_payout_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `welfare_payout_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payout_id` bigint unsigned NOT NULL,
  `step_id` bigint unsigned DEFAULT NULL,
  `action_by_user_id` bigint unsigned NOT NULL,
  `status` enum('submitted','approved','rejected','returned') COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment_path` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `welfare_payout_logs_step_id_foreign` (`step_id`),
  KEY `welfare_payout_logs_action_by_user_id_foreign` (`action_by_user_id`),
  CONSTRAINT `welfare_payout_logs_action_by_user_id_foreign` FOREIGN KEY (`action_by_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `welfare_payout_logs_step_id_foreign` FOREIGN KEY (`step_id`) REFERENCES `approval_workflow_steps` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zones`
--

DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zones` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `zone_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `tambon_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `org_id_fk` bigint unsigned NOT NULL,
  `lat` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `long` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `zones_tambon_id_foreign` (`tambon_id`),
  KEY `zones_org_id_fk_foreign` (`org_id_fk`),
  CONSTRAINT `zones_org_id_fk_foreign` FOREIGN KEY (`org_id_fk`) REFERENCES `organizations` (`id`),
  CONSTRAINT `zones_tambon_id_foreign` FOREIGN KEY (`tambon_id`) REFERENCES `tambons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-31 12:33:38
