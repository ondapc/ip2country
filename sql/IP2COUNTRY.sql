-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 22, 2026 at 09:51 AM
-- Server version: 8.0.46-0ubuntu0.24.04.3
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `IP2COUNTRY`
--

-- --------------------------------------------------------

--
-- Table structure for table `asin`
--

CREATE TABLE `asin` (
  `ip_range_start` bigint NOT NULL,
  `ip_range_end` bigint NOT NULL,
  `autonomous_system_number` bigint DEFAULT NULL,
  `autonomous_system_organization` varchar(220) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `asin_v6`
--

CREATE TABLE `asin_v6` (
  `ip_range_start` decimal(41,0) NOT NULL,
  `ip_range_end` decimal(41,0) NOT NULL,
  `autonomous_system_number` varchar(220) COLLATE utf8mb4_bin DEFAULT NULL,
  `autonomous_system_organization` varchar(220) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

CREATE TABLE `city` (
  `ip_range_start` bigint NOT NULL,
  `ip_range_end` bigint NOT NULL,
  `country_code` char(2) COLLATE utf8mb4_bin DEFAULT NULL,
  `region_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `county_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `city_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `postal_code` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
  `latitude` decimal(7,4) DEFAULT NULL,
  `longitude` decimal(7,4) DEFAULT NULL,
  `timezone` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `city_v6`
--

CREATE TABLE `city_v6` (
  `ip_range_start` decimal(41,0) NOT NULL,
  `ip_range_end` decimal(41,0) NOT NULL,
  `country_code` char(2) COLLATE utf8mb4_bin DEFAULT NULL,
  `region_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `county_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `city_name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL,
  `postal_code` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
  `latitude` decimal(7,4) DEFAULT NULL,
  `longitude` decimal(7,4) DEFAULT NULL,
  `timezone` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `ip_range_start` bigint NOT NULL,
  `ip_range_end` bigint NOT NULL,
  `country_code` char(2) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `country_v6`
--

CREATE TABLE `country_v6` (
  `ip_range_start` decimal(41,0) NOT NULL,
  `ip_range_end` decimal(41,0) NOT NULL,
  `country_code` char(2) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asin`
--
ALTER TABLE `asin`
  ADD PRIMARY KEY (`ip_range_start`,`ip_range_end`),
  ADD KEY `idx_ip_lookup` (`ip_range_start`,`ip_range_end`);

--
-- Indexes for table `asin_v6`
--
ALTER TABLE `asin_v6`
  ADD PRIMARY KEY (`ip_range_start`,`ip_range_end`),
  ADD KEY `idx_ip_lookup` (`ip_range_start`,`ip_range_end`);

--
-- Indexes for table `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`ip_range_start`,`ip_range_end`),
  ADD KEY `idx_ip_lookup` (`ip_range_start`,`ip_range_end`);

--
-- Indexes for table `city_v6`
--
ALTER TABLE `city_v6`
  ADD PRIMARY KEY (`ip_range_start`,`ip_range_end`),
  ADD KEY `idx_ip_lookup` (`ip_range_start`,`ip_range_end`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`ip_range_start`,`ip_range_end`),
  ADD KEY `idx_ip_lookup` (`ip_range_start`,`ip_range_end`);

--
-- Indexes for table `country_v6`
--
ALTER TABLE `country_v6`
  ADD PRIMARY KEY (`ip_range_start`,`ip_range_end`),
  ADD KEY `idx_ip_lookup` (`ip_range_start`,`ip_range_end`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
