-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.36 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db_bss_parking
CREATE DATABASE IF NOT EXISTS `db_bss_parking` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_bss_parking`;

-- Dumping structure for table db_bss_parking.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.cache: ~2 rows (approximately)
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
	('laravel_cache_5d6d88fff41b40cc306e3a7747c4b180', 'i:1;', 1748968095),
	('laravel_cache_5d6d88fff41b40cc306e3a7747c4b180:timer', 'i:1748968095;', 1748968095);

-- Dumping structure for table db_bss_parking.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.cache_locks: ~0 rows (approximately)

-- Dumping structure for table db_bss_parking.carlists
CREATE TABLE IF NOT EXISTS `carlists` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rate_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `plate` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `carlists_rate_id_foreign` (`rate_id`),
  CONSTRAINT `carlists_rate_id_foreign` FOREIGN KEY (`rate_id`) REFERENCES `rates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.carlists: ~0 rows (approximately)

-- Dumping structure for table db_bss_parking.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.failed_jobs: ~0 rows (approximately)

-- Dumping structure for table db_bss_parking.histories
CREATE TABLE IF NOT EXISTS `histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate_id` bigint unsigned NOT NULL,
  `total_rate` int DEFAULT NULL,
  `gate_in` datetime DEFAULT NULL,
  `gate_out` datetime DEFAULT NULL,
  `status` enum('Temporary','Completed','Rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_in` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `processing_time_in` double NOT NULL,
  `confidence_in` double NOT NULL,
  `x1_in` int NOT NULL,
  `x2_in` int NOT NULL,
  `y1_in` int NOT NULL,
  `y2_in` int NOT NULL,
  `image_out` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `processing_time_out` double DEFAULT NULL,
  `confidence_out` double DEFAULT NULL,
  `x1_out` int DEFAULT NULL,
  `x2_out` int DEFAULT NULL,
  `y1_out` int DEFAULT NULL,
  `y2_out` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `histories_rate_id_foreign` (`rate_id`),
  CONSTRAINT `histories_rate_id_foreign` FOREIGN KEY (`rate_id`) REFERENCES `rates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.histories: ~4 rows (approximately)
INSERT INTO `histories` (`id`, `plate`, `rate_id`, `total_rate`, `gate_in`, `gate_out`, `status`, `image_in`, `processing_time_in`, `confidence_in`, `x1_in`, `x2_in`, `y1_in`, `y2_in`, `image_out`, `processing_time_out`, `confidence_out`, `x1_out`, `x2_out`, `y1_out`, `y2_out`, `created_at`, `updated_at`) VALUES
	(16, 'DK1322SM', 4, 5000, '2025-06-03 23:10:58', '2025-06-03 23:17:20', 'Completed', 'histories/OQv0PqErGBkX7UTuQPgseUElKjKu6VTxUmIXG1am.jpg', 3.2459654808044, 0.8290466606617, 1265, 1462, 860, 961, 'histories/3ZMCOoaGn6UWoEw03518uu0z5gBtr4jNP6GRIwJG.jpg', 3.3542342185974, 0.8290466606617, 1265, 1462, 860, 961, '2025-06-03 14:10:58', '2025-06-03 15:17:20'),
	(20, 'DK1012SA', 4, 5000, '2025-06-03 23:09:34', '2025-06-03 23:13:34', 'Completed', 'histories/unzVGM9YIZ91mAeILv6cSdGhkBB7IESGIQZTw5df.jpg', 3.2382688522339, 0.83221572041512, 1285, 1475, 801, 889, 'histories/zRIY7MaLPzeMgbxo3mUzUVrsoPPkWwZ1jTQ3Of7e.jpg', 3.2454812526703, 0.83221572041512, 1285, 1475, 801, 889, '2025-06-03 15:09:34', '2025-06-03 15:13:34'),
	(21, 'DK1012SA', 4, 0, '2025-06-03 23:15:43', '2025-06-03 23:16:04', 'Completed', 'histories/t8yeunXcqAcf6r73CHz97VcADIBTaknMdk0IETiX.jpg', 3.2133293151855, 0.83221572041512, 1285, 1475, 801, 889, 'histories/Grf84LWo4otjCUtf5tBp5yobsKT0okD6IpXCtoDe.jpg', 3.2424736022949, 0.83221572041512, 1285, 1475, 801, 889, '2025-06-03 15:15:43', '2025-06-03 15:16:04'),
	(23, 'DK1012SA', 4, 0, '2025-06-03 23:30:30', '2025-06-03 23:31:39', 'Completed', 'histories/awhajCMCvKITk2Uc5DhtwxAxTUnobqfT1OXCznkA.jpg', 3.2067158222198, 0.83221572041512, 1285, 1475, 801, 889, 'histories/4nJQ1zESIgefFAUYoKNECpTSMZIyw8IfbO1WLCc3.jpg', 3.2121984958649, 0.83221572041512, 1285, 1475, 801, 889, '2025-06-03 15:30:30', '2025-06-03 15:31:39'),
	(24, 'DK1322SM', 4, 0, '2025-06-03 23:33:51', '2025-06-03 23:34:21', 'Completed', 'histories/jLCa8Y3B9jqLRGsUdEkg56u60ODkHu4i3r7jg7jj.jpg', 3.2671525478363, 0.8290466606617, 1265, 1462, 860, 961, 'histories/lDmpKwdpoinNKcC7zCNEu1OiaAvalyKBxFiBYr8w.jpg', 3.2604675292969, 0.8290466606617, 1265, 1462, 860, 961, '2025-06-03 15:33:51', '2025-06-03 15:34:21'),
	(25, 'DK1012SA', 4, 0, '2025-06-03 23:35:58', '2025-06-03 23:38:47', 'Completed', 'histories/Y1dQXqFXGzxfuV137t8oMLciCHclXewqdEAxwzc1.jpg', 3.228818655014, 0.83221572041512, 1285, 1475, 801, 889, 'histories/Fno5IJkzW9QyeBsEcYT1x3e3acf6QrlwFEghfxRi.jpg', 3.2437026500702, 0.83221572041512, 1285, 1475, 801, 889, '2025-06-03 15:35:58', '2025-06-03 15:38:47'),
	(26, 'DK1322SM', 4, 0, '2025-06-03 23:39:45', '2025-06-03 23:41:22', 'Completed', 'histories/yJOxijSlloTWs0OeW8G7oVJ3JuQjYPDtb8Voq3pk.jpg', 3.2819912433624, 0.8290466606617, 1265, 1462, 860, 961, 'histories/EdzeDXKIAWmDWKV0kOJhMjs3TBNECBsCG9Tt6cqY.jpg', 3.2707335948944, 0.8290466606617, 1265, 1462, 860, 961, '2025-06-03 15:39:45', '2025-06-03 15:41:22'),
	(27, 'DK1012SA', 4, NULL, '2025-06-03 23:42:08', NULL, 'Temporary', 'histories/bYxxAh5jtpyAfOKGKRyTbbydNo6eePU8yCnNPCHO.jpg', 3.2125942707062, 0.83221572041512, 1285, 1475, 801, 889, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-03 15:42:08', '2025-06-03 15:42:08'),
	(28, 'RI37', 8, 0, '2025-06-04 00:11:18', '2025-06-04 00:12:40', 'Completed', 'histories/vJBQ3omMzWn2ClVv98bOsmjgBnOWZShJLLjJFY1I.jpg', 2.4346940517426, 0.78599161505699, 290, 345, 290, 318, 'histories/x5cNLjGX4mtfaC9k59lLPuUaUsL4yrLNtxQhLrtd.jpg', 2.4080085754395, 0.78599161505699, 290, 345, 290, 318, '2025-06-03 16:11:18', '2025-06-03 16:12:40'),
	(29, 'RI37', 8, 0, '2025-06-04 00:17:08', '2025-06-04 00:19:12', 'Completed', 'histories/L88lZEJw84V2rOvlqco6KAFIT7OTGVT9DPDNmfj2.jpg', 2.415454864502, 0.78599161505699, 290, 345, 290, 318, 'histories/MSdqF7nf9tLNmMDGq5zM4zctXAvmsPHPerAPqGE0.jpg', 2.4359533786774, 0.78599161505699, 290, 345, 290, 318, '2025-06-03 16:17:08', '2025-06-03 16:19:12'),
	(30, 'RI37', 8, NULL, '2025-06-04 00:19:28', NULL, 'Temporary', 'histories/oyWR5esPC0ThguaiDRGw7jvNtGU9tEusrKXAs2hP.jpg', 2.4197840690613, 0.78599161505699, 290, 345, 290, 318, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-03 16:19:28', '2025-06-03 16:19:28');

-- Dumping structure for table db_bss_parking.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.jobs: ~0 rows (approximately)

-- Dumping structure for table db_bss_parking.job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.job_batches: ~0 rows (approximately)

-- Dumping structure for table db_bss_parking.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.migrations: ~9 rows (approximately)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1),
	(3, '0001_01_01_000002_create_jobs_table', 1),
	(4, '2025_05_26_143821_add_two_factor_columns_to_users_table', 1),
	(5, '2025_05_28_213929_create_vehicles_table', 2),
	(6, '2025_05_28_213933_create_plates_table', 2),
	(7, '2025_05_28_214242_create_rates_table', 2),
	(8, '2025_05_29_000554_create_carlists_table', 2),
	(11, '2025_06_01_081155_create_histories_table', 3);

-- Dumping structure for table db_bss_parking.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.password_reset_tokens: ~0 rows (approximately)

-- Dumping structure for table db_bss_parking.plates
CREATE TABLE IF NOT EXISTS `plates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.plates: ~4 rows (approximately)
INSERT INTO `plates` (`id`, `type`, `description`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Sipil', '-', 'Y', '2025-06-01 13:24:59', '2025-06-01 13:24:59'),
	(2, 'Dinas Pemerintah', '-', 'Y', '2025-06-01 13:25:15', '2025-06-01 13:25:19'),
	(3, 'Perwakilan Negara Asing dan Lembaga Internasional', NULL, 'Y', '2025-06-01 13:25:36', '2025-06-01 13:25:36'),
	(4, 'Dinas TNI dan POLRI', NULL, 'Y', '2025-06-01 13:25:47', '2025-06-01 13:25:47'),
	(5, 'Diplomatik', NULL, 'Y', '2025-06-03 16:01:43', '2025-06-03 16:01:43');

-- Dumping structure for table db_bss_parking.rates
CREATE TABLE IF NOT EXISTS `rates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `vehicle_id` bigint unsigned NOT NULL,
  `plate_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('Flat','Per Jam') COLLATE utf8mb4_unicode_ci NOT NULL,
  `flat_rate` int DEFAULT NULL,
  `first_hour_rate` int DEFAULT NULL,
  `next_hour_rate` int DEFAULT NULL,
  `max_hour_rate` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rates_vehicle_id_foreign` (`vehicle_id`),
  KEY `rates_plate_id_foreign` (`plate_id`),
  CONSTRAINT `rates_plate_id_foreign` FOREIGN KEY (`plate_id`) REFERENCES `plates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rates_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.rates: ~0 rows (approximately)
INSERT INTO `rates` (`id`, `vehicle_id`, `plate_id`, `name`, `type`, `flat_rate`, `first_hour_rate`, `next_hour_rate`, `max_hour_rate`, `description`, `status`, `created_at`, `updated_at`) VALUES
	(3, 2, 1, 'Sepeda Motor - Sipil (Per Jam)', 'Per Jam', NULL, 3000, 1000, 5000, NULL, 'Y', '2025-06-03 13:57:10', '2025-06-03 13:58:07'),
	(4, 1, 1, 'Mobil Penumpang - Sipil (Per Jam)', 'Per Jam', NULL, 5000, 2000, 10000, NULL, 'Y', '2025-06-03 13:57:54', '2025-06-03 13:57:54'),
	(5, 3, 1, 'Mobil Bus - Sipil (Per Jam)', 'Per Jam', NULL, 5000, 2000, 10000, NULL, 'Y', '2025-06-03 13:58:40', '2025-06-03 13:58:40'),
	(6, 4, 1, 'Mobil Barang - Sipil (Per Jam)', 'Per Jam', NULL, 5000, 2000, 10000, NULL, 'Y', '2025-06-03 13:59:06', '2025-06-03 13:59:06'),
	(7, 5, 1, 'Kendaraan Khusus - Sipil (Per Jam)', 'Per Jam', NULL, 5000, 2000, 10000, NULL, 'Y', '2025-06-03 13:59:44', '2025-06-03 13:59:44'),
	(8, 1, 2, 'Mobil Penumpang - Dinas Pemerintah (Per Jam)', 'Flat', 0, NULL, NULL, NULL, NULL, 'Y', '2025-06-03 16:10:49', '2025-06-03 16:10:49'),
	(9, 1, 5, 'Mobil Penumpang - DIplomatik', 'Flat', 0, NULL, NULL, NULL, NULL, 'Y', '2025-06-03 16:11:07', '2025-06-03 16:11:07');

-- Dumping structure for table db_bss_parking.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.sessions: ~2 rows (approximately)
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
	('yeL3LxMWYu4JmrTcUq7oOwfnCN9uhW2prG1MAlAD', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZTVaREVCV0NobmNMS2lWbk9DRHRYS2dnWHdocllKb2xYdzNiaml5biI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9oaXN0b3JpZXMvMzAiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=', 1748971360);

-- Dumping structure for table db_bss_parking.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text COLLATE utf8mb4_unicode_ci,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.users: ~0 rows (approximately)
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'Tride Agency', 'agency.tride@gmail.com', NULL, '$2y$12$y9Ywj9SjeD3hrl0g4WlZkuzfYvefspczYDnqc9PhCXSTMfUN0QRD2', NULL, NULL, NULL, NULL, '2025-05-26 09:03:56', '2025-05-26 09:03:56');

-- Dumping structure for table db_bss_parking.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('Y','N') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db_bss_parking.vehicles: ~4 rows (approximately)
INSERT INTO `vehicles` (`id`, `type`, `description`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Mobil Penumpang', NULL, 'Y', '2025-06-01 13:26:02', '2025-06-03 16:03:22'),
	(2, 'Sepeda Motor', NULL, 'Y', '2025-06-01 13:26:21', '2025-06-03 16:03:18'),
	(3, 'Mobil Bus', NULL, 'Y', '2025-06-01 13:26:35', '2025-06-03 16:03:13'),
	(4, 'Mobil Barang', NULL, 'Y', '2025-06-01 13:26:50', '2025-06-03 16:03:09'),
	(5, 'Kendaraan Khusus', NULL, 'Y', '2025-06-01 13:27:02', '2025-06-03 16:03:04'),
	(6, 'Kendaraan Militer', NULL, 'Y', '2025-06-03 16:00:44', '2025-06-03 16:00:44');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
