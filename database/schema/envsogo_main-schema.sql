/*M!999999\- enable the sandbox mode */ 
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;
DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `annual_trash_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `annual_trash_payrate_permonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `annual_trash_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `annual_trashs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `approval_workflow_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `approval_workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `budget_year`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `compost_bins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `cp_sensor_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `emission_factors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `food_waste_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwast_iotboxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwast_meal_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_bins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_compost_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_issue_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_issue_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_reward_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_user_bin_iotbox_matchings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `foodwaste_waste_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_hazard_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_item_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_item_hazard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_transaction_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `inv_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `invoice_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `issue_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kiosk_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kiosk_sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kiosks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_bulk_sale_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_bulk_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_kiosk_unknown_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_money_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_point_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_purchase_route_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_purchase_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_purchase_shops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_purchase_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_purchase_transactions_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_sell_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_sell_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_shop_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_shop_order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_shop_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_shop_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_tbank_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_tbank_items_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_tbank_items_pricepoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_tbank_items_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_user_waste_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_usergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_waste_bank_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_waste_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_waste_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_welfare_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_welfare_payouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `kp_withdraw_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `local_foods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `local_foods` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `menu_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `calories` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `local_foods_menu_name_unique` (`menu_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `meal_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `org_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `organization_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `organizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `provinces` (
  `id` bigint unsigned NOT NULL,
  `province_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `go_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `recycle_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sequence_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `staffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `subzones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `system_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_device_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_pipe_nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_pipelines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_quality_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_station_staffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tabwater_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tambons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `transaction_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `transaction_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_acc_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_cutmeter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_invoice_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_invoice_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_meter_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_meter_type_rate_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_meter_type_rate_tiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_meter_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_notifies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_notify_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `tw_pricing_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `undertaker_subzones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `welfare_contributions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `welfare_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `welfare_payout_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

/*M!999999\- enable the sandbox mode */ 
SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (1,'2014_10_12_000000_create_users_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (2,'2014_10_12_100000_create_password_resets_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (3,'2019_08_19_000000_create_failed_jobs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (4,'2019_12_14_000001_create_personal_access_tokens_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (5,'2022_03_01_151919_create_permission_tables',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (6,'2023_10_27_171314_create_number_sequences_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (7,'2023_10_27_182335_create_meter_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (8,'2023_10_27_184222_create_provinces_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (9,'2023_10_27_184223_create_districts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (10,'2023_10_27_184223_create_tambons_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (11,'2023_10_27_184224_create_zones_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (12,'2023_10_27_184225_create_subzones_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (13,'2023_10_30_040857_create_budget_year',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (14,'2023_10_30_130210_create_tw_merter_infos_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (15,'2023_10_30_132633_create_invoice_period',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (16,'2023_10_31_074745_create_settings_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (17,'2023_11_01_083652_create_accounts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (18,'2023_11_01_083653_create_acc_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (19,'2023_11_01_083655_create_invoice_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (20,'2023_11_01_083656_create_invoice_temp_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (21,'2023_11_03_084012_create_undertaker_subzones_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (22,'2024_04_16_005012_create_cutmeter_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (23,'2025_04_25_084012_create_organizations_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (24,'2025_04_25_141151_create_kp_tbank_items_units_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (25,'2025_04_25_143303_create_kp_tbank_items_groups_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (26,'2025_04_25_143434_create_kp_tbank_items_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (27,'2025_04_25_171102_create_staff_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (28,'2025_04_25_171119_create_kp_tbank_items_price_point_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (29,'2025_05_28_175914_create_pricing_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (30,'2025_05_28_180217_create_meter_type_rate_configs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (31,'2025_05_28_180229_create_meter_type_rate_tiers_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (32,'2025_07_21_044920_create_kiosks_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (33,'2025_07_23_020202_create_kp_user_waste_preferences_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (34,'2025_07_23_020236_create_annual_trashs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (35,'2025_07_23_020324_create_waste_bank_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (36,'2025_07_23_062840_create_waste_groups_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (37,'2025_07_23_063015_create_waste_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (38,'2025_07_23_063259_create_transaction_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (39,'2025_08_11_065735_create_machines_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (40,'2025_08_11_112538_create_kp_purchase_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (41,'2025_08_11_123535_create_kp_purchase_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (42,'2025_08_12_034322_create_kp_purchase_shops_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (43,'2025_08_12_041717_create_kp_sell_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (44,'2025_08_12_041741_create_kp_sell_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (45,'2025_08_15_141549_create_cp_sensor_data_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (46,'2025_08_15_164438_create_compost_bins_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (47,'2025_09_07_070256_add_org_id_fk_to_users_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (48,'2025_09_12_061429_add_new_column_to_kp_tbank_items_groups_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (49,'2025_09_15_162206_create_kp_accounts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (50,'2025_09_15_233548_create_org_accounts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (51,'2025_09_15_234725_create_kp_shop_categories_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (52,'2025_09_15_234922_create_kp_shop_products_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (53,'2025_09_15_235415_create_kp_shop_orders_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (54,'2025_09_15_235444_create_kp_shop_order_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (55,'2025_10_07_004125_create_kp_usergroups_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (56,'2025_10_07_005831_create_annual_trash_payrate_permonth_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (57,'2025_10_07_005925_create_annual_trash_subscriptions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (58,'2025_10_08_033219_create_foodwast_iotboxes_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (59,'2025_10_08_040939_create_foodwaste_bins_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (60,'2025_10_08_044226_create_user_bin_iotbox_matchings_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (61,'2025_10_25_061648_add_column_to_zone_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (62,'2025_10_25_065456_add_column_to_tw_meter_infos_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (63,'2025_10_25_082842_add_column_in_users_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (64,'2025_10_26_211119_add_org_id_fk_intw_meter_type_rate_configs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (65,'2025_11_12_133602_add_lat_long_column_in_organizations_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (66,'2025_11_12_145208_add_lat_long_column_in_zones_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (67,'2025_11_25_002201_create_tw_notifies_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (68,'2025_11_25_003016_create_tw_notify_staff_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (69,'2026_01_04_053935_add_org_id_to_twinvoice_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (70,'2026_01_04_060851_add_org_id_to_invoiceperiod_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (71,'2026_01_04_060852_add_org_id_to_subzone_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (72,'2026_01_04_060853_add_org_id_to_ tw_meter_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (73,'2026_01_04_060854_add_org_id_to_kp_purchase_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (74,'2026_01_07_161730_create_tw_invoice_history_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (75,'2026_01_12_081344_create_inv_units_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (76,'2026_01_12_092055_create_inv_categories_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (77,'2026_01_12_092056_create_inv_items_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (78,'2026_01_12_092058_create_inv_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (79,'2026_01_12_094524_create_inv_item_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (80,'2026_01_12_155337_add_detail_id_to_inv_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (81,'2026_01_12_165229_add_approver_to_inv_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (82,'2026_01_12_170128_create_inv_hazard_levels_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (83,'2026_01_12_170303_create_inv_item_hazard_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (84,'2026_01_12_174237_add_status_ref_to_transactions',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (85,'2026_02_03_001852_create_emission_factors_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (86,'2026_02_03_013605_add_carbon_saved_to_transaction_details',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (87,'2026_02_03_020557_add_emission_factor_id_to_kp_tbank_items',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (88,'2026_02_03_025050_add_total_carbon_saved_to_kp_purchase_transactions',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (89,'2026_02_15_071146_create_foodwaste_user_preferences_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (90,'2026_02_17_051427_create_kiosk_matches_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (91,'2026_03_15_032044_create_airo_logs_tables',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (92,'2026_03_15_044640_create_local_foods_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (93,'2026_03_15_085233_create_new_meal_structure',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (94,'2026_03_15_111052_add_waste_logs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (95,'2026_03_15_111942_create_compost_batches_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (96,'2026_03_15_113838_add_user_id_to_compost_batches_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (97,'2026_03_15_120213_add_batch_id_to_waste_logs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (98,'2026_03_15_121935_add_temperature_to_waste_logs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (99,'2026_03_15_124413_create_foodwaste_issue_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (100,'2026_03_18_044452_create_foodwaste_issue_report_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (101,'2026_03_18_084630_create_foodwaste_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (102,'2026_03_18_101201_add_waste_log_id_to_foodwaste_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (103,'2026_03_18_124658_add_metrics_to_users_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (104,'2026_03_18_174606_create_foodwaste_reward_settings_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (105,'2026_03_19_160122_update_kp_tbank_items_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (106,'2026_03_19_161027_update_foodwaste_issue_reports_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (107,'2026_03_20_005533_add_deleted_to_kp_purchase_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (108,'2026_03_20_013608_update_kp_tbank_items_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (109,'2026_03_20_040311_update_kp_tbank_items',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (110,'2026_03_20_042837_add_soft_deletes_to_kp_tbank_items_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (111,'2026_03_23_102155_create_recycle_bank_accounts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (112,'2026_03_23_102244_create_recycle_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (113,'2026_03_23_102311_create_food_waste_accounts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (114,'2026_03_25_010630_create_organization_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (115,'2026_03_25_132057_add_unit_and_item_to_kp_purchase_transactions_details',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (116,'2026_03_26_145827_create_kp_money_requests_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (117,'2026_03_26_151038_create_kp_point_transfers_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (118,'2026_03_26_153822_create_kp_welfare_payouts_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (119,'2026_03_26_154032_create_kp_bulk_sales_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (120,'2026_03_26_154112_create_kp_bulk_sale_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (121,'2026_03_26_164105_create_kp_welfare_configs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (122,'2026_05_19_040514_add_columns_to_kp_user_waste_preferences_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (123,'2026_06_11_134609_create_kp_kiosk_unknown_items_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (124,'2026_08_25_000000_fix_meal_items_table_name',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (125,'2026_08_26_013357_create_issue_types_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (126,'2026_08_26_014508_add_system_type_and_custom_issue_to_tw_notifies_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (127,'2026_08_26_015000_update_columns_in_tw_notifies_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (128,'2026_08_26_015830_create_system_modules_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (129,'2026_08_28_025204_add_column_charge_min_only_zero_use_in_meter_type_rate_configs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (130,'2026_08_28_031004_add_column_tier_calculation_type_in_meter_type_rate_configs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (131,'2026_09_25_085045_add_audit_logs_to_inv_transactions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (132,'2026_09_25_090011_create_inv_transaction_approvals_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (133,'2026_09_25_090554_create_approval_workflows_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (134,'2026_09_25_090555_create_approval_workflow_steps_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (135,'2026_09_25_090555_create_transaction_approvals_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (136,'2026_09_25_103925_add_approvalworkflow_id_column_in_inv_categories_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (137,'2026_09_25_164846_create_inv_locations_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (138,'2026_09_25_164847_add_location_id_to_inv_item_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (139,'2026_09_25_171122_add_conversion_rate_to_inv_item_details_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (140,'2026_09_26_005147_create_suppliers_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (141,'2026_10_04_000001_add_org_id_fk_to_tenant_tables',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (142,'2026_10_04_000002_add_missing_columns_to_foodwaste_bins_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (143,'2026_10_08_110038_create_kp_purchase_routes_table_and_kp_purchase_route_zones_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (144,'2026_10_09_001549_create_kp_settings_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (145,'2026_10_09_014537_create_kp_withdraw_batches_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (146,'2026_10_09_014604_update_kp_money_requests_table_for_latest_workflow',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (147,'2026_10_09_042443_add_modulename_column_in_inv_transaction_approvals_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (148,'2026_10_12_090000_sync_kp_purchase_and_sell_tables_with_schema',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (149,'2026_10_13_022536_create_kp_welfare_payout_logs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (150,'2026_10_13_022559_create_kp_welfare_contributions_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (151,'2026_10_13_022623_add_workflow_and_status_to_welfare_tables',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (152,'2026_10_13_025520_create_welfare_members_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (153,'2026_10_15_135128_create_tabwater_stations_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (154,'2026_10_15_135129_create_tabwater_station_staffs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (155,'2026_10_15_135130_create_tabwater_devices_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (156,'2026_10_15_135915_create_tabwater_quality_logs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (157,'2026_10_15_135943_create_tabwater_device_logs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (158,'2026_10_15_160030_create_tabwater_pipe_nodes_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (159,'2026_10_15_160058_create_tabwater_pipelines_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (160,'2026_10_16_043428_create_kiosk_sensors_table',1);
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
