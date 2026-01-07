-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 21, 2025 at 05:06 AM
-- Server version: 8.0.42-0ubuntu0.22.04.1
-- PHP Version: 8.1.2-1ubuntu2.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `s633_capitalrp`
--

-- --------------------------------------------------------

--
-- Table structure for table `3dtext`
--

CREATE TABLE `3dtext` (
  `textID` int UNSIGNED NOT NULL,
  `text` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `ajustes`
--

CREATE TABLE `ajustes` (
  `ajusteID` int NOT NULL,
  `nombre` text NOT NULL,
  `valor` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `armas_suelo`
--

CREATE TABLE `armas_suelo` (
  `ID` int UNSIGNED NOT NULL,
  `model` int UNSIGNED NOT NULL,
  `ammo` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `dimension` int UNSIGNED NOT NULL DEFAULT '0',
  `characterID` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `banks`
--

CREATE TABLE `banks` (
  `bankID` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL,
  `skin` int NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `cabinas`
--

CREATE TABLE `cabinas` (
  `cabinaID` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL,
  `skin` int NOT NULL DEFAULT '-1',
  `operativa` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `characterID` int UNSIGNED NOT NULL,
  `characterName` varchar(22) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `genero` int NOT NULL DEFAULT '0',
  `edad` int NOT NULL DEFAULT '0',
  `nivel` int NOT NULL DEFAULT '1',
  `objetivos` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `userID` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL,
  `clothes` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `skin` int UNSIGNED NOT NULL DEFAULT '0',
  `andar` int DEFAULT NULL,
  `rotation` float NOT NULL,
  `health` tinyint UNSIGNED NOT NULL DEFAULT '100',
  `armor` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `money` bigint UNSIGNED NOT NULL DEFAULT '700',
  `CKuIDStaff` int NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastLogin` timestamp NULL DEFAULT NULL,
  `lastLogout` timestamp NULL DEFAULT NULL,
  `weapons` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `job` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `dni` int UNSIGNED NOT NULL DEFAULT '0',
  `languages` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `car_license` int UNSIGNED NOT NULL DEFAULT '0',
  `gun_license` int UNSIGNED NOT NULL DEFAULT '0',
  `boat_license` int UNSIGNED NOT NULL DEFAULT '0',
  `sed` int UNSIGNED NOT NULL DEFAULT '100',
  `hambre` int UNSIGNED NOT NULL DEFAULT '100',
  `cansancio` int UNSIGNED NOT NULL DEFAULT '100',
  `gordura` int UNSIGNED NOT NULL DEFAULT '0',
  `musculatura` int UNSIGNED NOT NULL DEFAULT '0',
  `casadocon` int UNSIGNED NOT NULL DEFAULT '0',
  `tpd` int UNSIGNED NOT NULL DEFAULT '0',
  `nuevo` int UNSIGNED NOT NULL DEFAULT '1',
  `ajail` int NOT NULL DEFAULT '0',
  `payday` int UNSIGNED NOT NULL DEFAULT '0',
  `color` int UNSIGNED NOT NULL DEFAULT '0',
  `barco_license` int UNSIGNED NOT NULL DEFAULT '0',
  `camion_license` int UNSIGNED NOT NULL DEFAULT '0',
  `condiciones` float NOT NULL DEFAULT '0',
  `yo` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `loteria` int DEFAULT NULL,
  `banco` int UNSIGNED NOT NULL DEFAULT '0',
  `horas` int UNSIGNED NOT NULL DEFAULT '0',
  `gananciaCasino` int NOT NULL DEFAULT '0',
  `last_arrest_time` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `characters`
--

INSERT INTO `characters` (`characterID`, `characterName`, `genero`, `edad`, `nivel`, `objetivos`, `userID`, `x`, `y`, `z`, `interior`, `dimension`, `clothes`, `skin`, `andar`, `rotation`, `health`, `armor`, `money`, `CKuIDStaff`, `created`, `lastLogin`, `lastLogout`, `weapons`, `job`, `dni`, `languages`, `car_license`, `gun_license`, `boat_license`, `sed`, `hambre`, `cansancio`, `gordura`, `musculatura`, `casadocon`, `tpd`, `nuevo`, `ajail`, `payday`, `color`, `barco_license`, `camion_license`, `condiciones`, `yo`, `loteria`, `banco`, `horas`, `gananciaCasino`, `last_arrest_time`) VALUES
(1, 'Owner David', 1, 26, 1, NULL, 49, 1351.92, 513.257, 45.1031, 0, 0, NULL, 0, NULL, 190.465, 100, 0, 5000650, 0, '2025-08-20 05:02:35', '2025-08-20 09:55:25', NULL, NULL, NULL, 0, '[ { \"en\": { \"skill\": 1000, \"current\": true } } ]', 0, 0, 0, 71, 81, 80, 0, 0, 0, 39, 0, 0, 0, 1, 0, 0, 1, NULL, 0, 5000000, 4, 0, NULL),
(2, 'Owner EcuDev', 1, 22, 1, NULL, 50, 1313.66, -1354.46, 13.2074, 0, 0, NULL, 0, 121, 108.967, 70, 0, 10000650, 0, '2025-08-20 14:56:10', '2025-08-20 15:56:25', NULL, NULL, NULL, 0, '[ { \"en\": { \"skill\": 1000, \"current\": true } } ]', 0, 0, 0, 98, 95, 92, 0, 0, 0, 15, 0, 0, 0, 1, 0, 0, 1, NULL, NULL, 0, 0, 0, NULL),
(3, 'Dev Corde', 1, 26, 1, NULL, 51, 2300.63, -12.6182, 26.4844, 0, 0, NULL, 0, NULL, 179.517, 100, 0, 1150, 0, '2025-08-20 20:29:51', '2025-08-20 21:01:10', NULL, NULL, NULL, 0, '[ { \"en\": { \"skill\": 1000, \"current\": true } } ]', 0, 0, 0, 96, 96, 93, 0, 0, 0, 31, 0, 0, 0, 1, 0, 0, 1, NULL, NULL, 0, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `character_to_factions`
--

CREATE TABLE `character_to_factions` (
  `characterID` int UNSIGNED NOT NULL,
  `factionID` int UNSIGNED NOT NULL,
  `factionLeader` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `factionRank` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `factionSueldo` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `concesionario`
--

CREATE TABLE `concesionario` (
  `registroID` int UNSIGNED NOT NULL,
  `modelID` int UNSIGNED NOT NULL,
  `vehicleID` int UNSIGNED NOT NULL,
  `factionID` int UNSIGNED NOT NULL,
  `precio` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `condiciones`
--

CREATE TABLE `condiciones` (
  `cID` int NOT NULL,
  `version` float NOT NULL,
  `texto` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `condiciones`
--

INSERT INTO `condiciones` (`cID`, `version`, `texto`) VALUES
(1, 1, 'NORMATIVA GENERAL DE LA CAPITAL ROLEPLAY\r\n\r\nPor favor, consúltela vía Discord https://discord.gg/jW2N87fW');

-- --------------------------------------------------------

--
-- Table structure for table `construcciones`
--

CREATE TABLE `construcciones` (
  `construccionID` int UNSIGNED NOT NULL,
  `tipoConstruccion` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `charIDConstructor` int UNSIGNED NOT NULL,
  `charIDTitular` int UNSIGNED NOT NULL,
  `interiorID` int UNSIGNED NOT NULL,
  `diasReforma` int UNSIGNED NOT NULL,
  `inicioReforma` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `deposito`
--

CREATE TABLE `deposito` (
  `depositoID` int NOT NULL,
  `vehicleID` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `modelo` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `color` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `propietario` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `razon` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `agente` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `dinero_sesiones`
--

CREATE TABLE `dinero_sesiones` (
  `sesionID` int NOT NULL,
  `characterID` int NOT NULL,
  `userID` int NOT NULL,
  `cantidadLogin` int NOT NULL,
  `cantidadLogout` int NOT NULL DEFAULT '0',
  `estadoSesion` int NOT NULL DEFAULT '0',
  `timestampLogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `timestampLogout` timestamp NULL DEFAULT NULL,
  `resolucionCaso` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `dropitems`
--

CREATE TABLE `dropitems` (
  `id` int UNSIGNED NOT NULL,
  `item` int UNSIGNED NOT NULL,
  `value` bigint UNSIGNED NOT NULL,
  `posx` float UNSIGNED NOT NULL,
  `posy` float UNSIGNED NOT NULL,
  `posz` float UNSIGNED NOT NULL,
  `interior` int UNSIGNED NOT NULL,
  `dim` int UNSIGNED NOT NULL,
  `ang` float UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `dudas`
--

CREATE TABLE `dudas` (
  `dudaID` int NOT NULL,
  `userIDStaff` int NOT NULL,
  `userIDUsuario` int NOT NULL,
  `charIDUsuario` int NOT NULL,
  `dudaPregunta` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `dudaRespuesta` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `valoracion` int NOT NULL,
  `codigoIncidencia` int NOT NULL,
  `fechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `factionID` int UNSIGNED NOT NULL,
  `groupID` int UNSIGNED NOT NULL,
  `factionType` tinyint UNSIGNED NOT NULL,
  `factionTag` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `factionPresupuesto` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `faction_ranks`
--

CREATE TABLE `faction_ranks` (
  `factionID` int UNSIGNED NOT NULL,
  `factionRankID` int UNSIGNED NOT NULL,
  `factionRankName` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `fuelpoints`
--

CREATE TABLE `fuelpoints` (
  `fuelpointID` int UNSIGNED NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `name` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `historiales`
--

CREATE TABLE `historiales` (
  `historialID` int NOT NULL,
  `nombre` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `dni` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `residencia` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `profesion` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `delitos` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `agente` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `interiors`
--

CREATE TABLE `interiors` (
  `interiorID` int UNSIGNED NOT NULL,
  `outsideX` float NOT NULL,
  `outsideY` float NOT NULL,
  `outsideZ` float NOT NULL,
  `outsideVehRX` float DEFAULT NULL,
  `outsideVehRY` float DEFAULT NULL,
  `outsideVehRZ` float DEFAULT NULL,
  `outsideInterior` tinyint UNSIGNED NOT NULL,
  `outsideDimension` int UNSIGNED NOT NULL,
  `insideX` float NOT NULL,
  `insideY` float NOT NULL,
  `insideZ` float NOT NULL,
  `insideVehRX` float DEFAULT NULL,
  `insideVehRY` float DEFAULT NULL,
  `insideVehRZ` float DEFAULT NULL,
  `insideInterior` tinyint UNSIGNED NOT NULL,
  `interiorName` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `interiorType` tinyint UNSIGNED NOT NULL,
  `interiorPrice` int UNSIGNED NOT NULL,
  `interiorPriceCompra` int NOT NULL DEFAULT '0',
  `characterID` int UNSIGNED NOT NULL DEFAULT '0',
  `locked` tinyint NOT NULL DEFAULT '0',
  `dropoffX` float DEFAULT NULL,
  `dropoffY` float DEFAULT NULL,
  `dropoffZ` float DEFAULT NULL,
  `precintado` int UNSIGNED NOT NULL DEFAULT '0',
  `idasociado` int UNSIGNED NOT NULL DEFAULT '0',
  `alarma` int UNSIGNED NOT NULL DEFAULT '0',
  `camaras` int NOT NULL DEFAULT '0',
  `recaudacion` int UNSIGNED NOT NULL DEFAULT '0',
  `productos` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `index` int UNSIGNED NOT NULL,
  `owner` int UNSIGNED NOT NULL,
  `item` bigint UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `value2` int UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`index`, `owner`, `item`, `value`, `value2`, `name`) VALUES
(1, 1, 1, '274', NULL, NULL),
(2, 2, 1, '275', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `items_mochilas`
--

CREATE TABLE `items_mochilas` (
  `index` int UNSIGNED NOT NULL,
  `mochilaID` int UNSIGNED NOT NULL,
  `item` int UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `value2` int UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `items_muebles`
--

CREATE TABLE `items_muebles` (
  `index` int UNSIGNED NOT NULL,
  `muebleID` int UNSIGNED NOT NULL,
  `item` int UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `value2` int UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `licencias_armas`
--

CREATE TABLE `licencias_armas` (
  `licenciaID` int UNSIGNED NOT NULL,
  `cID` int UNSIGNED NOT NULL,
  `cIDJusticia` int UNSIGNED NOT NULL,
  `cost` int UNSIGNED NOT NULL,
  `weapon` int UNSIGNED NOT NULL,
  `status` int UNSIGNED NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `maleteros`
--

CREATE TABLE `maleteros` (
  `index` int UNSIGNED NOT NULL,
  `vehicleID` int UNSIGNED NOT NULL,
  `item` int UNSIGNED NOT NULL,
  `value` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `value2` int UNSIGNED DEFAULT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `mascotas`
--

CREATE TABLE `mascotas` (
  `ID` int UNSIGNED NOT NULL,
  `raza` int UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `owner` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `dimension` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `mochilas_suelo`
--

CREATE TABLE `mochilas_suelo` (
  `mochilaID` int UNSIGNED NOT NULL,
  `model` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `dimension` int UNSIGNED NOT NULL DEFAULT '0',
  `characterID` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `muebles`
--

CREATE TABLE `muebles` (
  `muebleID` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL,
  `extra` int NOT NULL DEFAULT '0',
  `skin` int NOT NULL DEFAULT '-1',
  `tipo` int NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `multas`
--

CREATE TABLE `multas` (
  `ind` int NOT NULL,
  `characterID` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `agente` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `estado` int NOT NULL DEFAULT '1',
  `pagado` int NOT NULL DEFAULT '0',
  `razon` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `objetivos`
--

CREATE TABLE `objetivos` (
  `objetivoID` int UNSIGNED NOT NULL,
  `nivel` int UNSIGNED NOT NULL,
  `titulo` text NOT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `ordenes`
--

CREATE TABLE `ordenes` (
  `ordenID` int NOT NULL,
  `nombre` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `razon` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `agente` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `estado` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `pagos_prestamos`
--

CREATE TABLE `pagos_prestamos` (
  `id` int NOT NULL,
  `prestamo_id` int NOT NULL,
  `fecha_pago` int NOT NULL,
  `monto` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `periodicos`
--

CREATE TABLE `periodicos` (
  `periodicoID` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL,
  `skin` int NOT NULL DEFAULT '-1',
  `operativa` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `prestamos`
--

CREATE TABLE `prestamos` (
  `prestamoID` int NOT NULL,
  `tipo` int NOT NULL,
  `objetoID` int NOT NULL,
  `cantidad` int NOT NULL,
  `pagado` int NOT NULL,
  `characterID` int NOT NULL,
  `cuota` int NOT NULL,
  `flimite` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `prestamosBanco`
--

CREATE TABLE `prestamosBanco` (
  `id` int NOT NULL,
  `characterID` int NOT NULL,
  `monto` int NOT NULL,
  `interes` float NOT NULL,
  `cuota` int NOT NULL,
  `cuotas_restantes` int NOT NULL,
  `cuotas_pagadas` int DEFAULT '0',
  `estado` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'Pendiente',
  `fecha_aprobacion` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `robos`
--

CREATE TABLE `robos` (
  `roboID` int NOT NULL,
  `userIDStaff` int DEFAULT NULL,
  `charIDLadron` int DEFAULT NULL,
  `tipo` int DEFAULT NULL,
  `objetoID` int DEFAULT NULL,
  `model` int NOT NULL,
  `cantidad` int DEFAULT NULL,
  `fecha` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `sanciones`
--

CREATE TABLE `sanciones` (
  `sancionID` int UNSIGNED NOT NULL,
  `userID` int NOT NULL DEFAULT '-1',
  `staffID` int NOT NULL DEFAULT '-1',
  `regla` int NOT NULL DEFAULT '-1',
  `validez` int NOT NULL DEFAULT '1',
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `shopID` int UNSIGNED NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL,
  `dimension` int UNSIGNED NOT NULL,
  `configuration` varchar(45) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `skin` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `staff_names`
--

CREATE TABLE `staff_names` (
  `userID` int NOT NULL,
  `staffName` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_names`
--

INSERT INTO `staff_names` (`userID`, `staffName`, `lastUpdated`) VALUES
(49, 'cordero', '2025-08-20 07:26:21'),
(50, 'EcuDev', '2025-08-20 15:54:31');

-- --------------------------------------------------------

--
-- Table structure for table `teleports`
--

CREATE TABLE `teleports` (
  `teleportID` int UNSIGNED NOT NULL,
  `aX` float NOT NULL,
  `aY` float NOT NULL,
  `aZ` float NOT NULL,
  `aInterior` tinyint UNSIGNED NOT NULL,
  `aDimension` int UNSIGNED NOT NULL,
  `bX` float NOT NULL,
  `bY` float NOT NULL,
  `bZ` float NOT NULL,
  `bInterior` tinyint UNSIGNED NOT NULL,
  `bDimension` int UNSIGNED NOT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `teleports`
--

INSERT INTO `teleports` (`teleportID`, `aX`, `aY`, `aZ`, `aInterior`, `aDimension`, `bX`, `bY`, `bZ`, `bInterior`, `bDimension`, `name`) VALUES
(8, 123.63, -150.36, 1.58, 0, 0, 121.19, -150.48, 1.58, 0, 0, 'CONCESIONARIO'),
(10, 617.96, -585.04, 17.23, 0, 0, 623.92, -566.71, 26.15, 0, 0, 'Helipuerto');

-- --------------------------------------------------------

--
-- Table structure for table `tlf_contactos`
--

CREATE TABLE `tlf_contactos` (
  `contacto_ID` int NOT NULL,
  `tlf_titular` int NOT NULL,
  `nombre` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `tlf_contacto` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `tlf_data`
--

CREATE TABLE `tlf_data` (
  `registro_ID` int NOT NULL,
  `apagado` int NOT NULL DEFAULT '0',
  `numero` int NOT NULL,
  `imei` bigint NOT NULL,
  `titular` int NOT NULL,
  `estado` int NOT NULL,
  `agenda` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `tlf_data`
--

INSERT INTO `tlf_data` (`registro_ID`, `apagado`, `numero`, `imei`, `titular`, `estado`, `agenda`) VALUES
(1, 0, 6900758, 351304132440980, 2, 0, ''),
(2, 0, 6724791, 352416581501289, 1, 0, ''),
(3, 0, 6377572, 354582240634593, 11, 0, ''),
(4, 0, 6985378, 358496447517694, 20, 0, ''),
(5, 0, 6688295, 358324762578843, 32, 0, ''),
(6, 0, 6449813, 354281561400299, 1, 0, ''),
(7, 0, 6876229, 354849862616382, 46, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `tlf_llamadas`
--

CREATE TABLE `tlf_llamadas` (
  `llamada_ID` int NOT NULL,
  `tlf_emisor` int NOT NULL,
  `tlf_receptor` int NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `duracion` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `tlf_sms`
--

CREATE TABLE `tlf_sms` (
  `sms_ID` int NOT NULL,
  `tlf_receptor` int DEFAULT NULL,
  `tlf_emisor` int DEFAULT NULL,
  `msg` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicleID` int UNSIGNED NOT NULL,
  `model` int UNSIGNED NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotX` float NOT NULL,
  `rotY` float NOT NULL,
  `rotZ` float NOT NULL,
  `interior` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `dimension` int UNSIGNED NOT NULL DEFAULT '0',
  `respawnPosX` float NOT NULL,
  `respawnPosY` float NOT NULL,
  `respawnPosZ` float NOT NULL,
  `respawnRotX` float NOT NULL,
  `respawnRotY` float NOT NULL,
  `respawnRotZ` float NOT NULL,
  `respawnInterior` int UNSIGNED NOT NULL DEFAULT '0',
  `respawnDimension` int UNSIGNED NOT NULL DEFAULT '0',
  `numberplate` varchar(255) NOT NULL DEFAULT '',
  `health` int UNSIGNED NOT NULL DEFAULT '1000',
  `color1` varchar(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `color2` varchar(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `color3` varchar(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `characterID` int NOT NULL DEFAULT '0',
  `locked` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `engineState` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `lightsState` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `tintedWindows` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `fuel` float UNSIGNED NOT NULL DEFAULT '100',
  `pinturas` int NOT NULL DEFAULT '3',
  `tunning` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `neon` int DEFAULT NULL,
  `seguro` int NOT NULL DEFAULT '0',
  `km` int NOT NULL DEFAULT '0',
  `fasemotor` int NOT NULL DEFAULT '0',
  `fasefrenos` int NOT NULL DEFAULT '0',
  `localizador` int NOT NULL DEFAULT '0',
  `alarma` int NOT NULL DEFAULT '0',
  `marchas` int NOT NULL DEFAULT '0',
  `cepo` int NOT NULL DEFAULT '0',
  `diasLimpio` int NOT NULL DEFAULT '0',
  `opcion` int NOT NULL DEFAULT '2',
  `dias` int NOT NULL DEFAULT '20',
  `inactivo` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`vehicleID`, `model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `respawnPosX`, `respawnPosY`, `respawnPosZ`, `respawnRotX`, `respawnRotY`, `respawnRotZ`, `respawnInterior`, `respawnDimension`, `numberplate`, `health`, `color1`, `color2`, `color3`, `characterID`, `locked`, `engineState`, `lightsState`, `tintedWindows`, `fuel`, `pinturas`, `tunning`, `neon`, `seguro`, `km`, `fasemotor`, `fasefrenos`, `localizador`, `alarma`, `marchas`, `cepo`, `diasLimpio`, `opcion`, `dias`, `inactivo`) VALUES
(26, 598, 2298.81, 2463.86, 3.27344, 0, 0, 273.62, 0, 22, 2298.81, 2463.85, 3.16732, 0.516357, 359.989, 273.675, 0, 22, 'N8P5 31Q', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(27, 598, 2290.13, 2431.86, 3.27344, 0, 0, 357.271, 0, 22, 2290.11, 2431.85, 3.14202, 0.615234, 0, 358.577, 0, 22, 'GC52 4P9', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(28, 598, 2285.84, 2432.15, 3.27344, 0, 0, 358.765, 0, 22, 2285.82, 2432.16, 3.17319, 0.494385, 359.989, 358.956, 0, 22, 'W320 ZI0', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(29, 598, 2281.06, 2432.44, 3.27344, 0, 0, 361.523, 0, 22, 2281.35, 2432.48, 3.15187, 0.576782, 0, 358.555, 0, 22, '9XL0 BRN', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(30, 598, 2276.49, 2430.36, 3.27344, 0, 0, 364.297, 0, 22, 2277.21, 2431.48, 3.15473, 0.565796, 0, 359.363, 0, 22, '0JRJ U30', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(31, 598, 2272.93, 2432.12, 3.27344, 0, 0, 354.602, 0, 22, 2272.77, 2432.23, 3.15539, 0.560303, 0, 357.105, 0, 22, '4DQD GIM', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(32, 416, 2314.3, 2499.48, 3.27344, 0, 0, 94.7159, 0, 23, 2314.75, 2500.25, 3.32508, 0.142822, 359.995, 88.5828, 0, 23, 'K3MD T7X', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(33, 416, 2314.45, 2495.27, 3.27344, 0, 0, 91.063, 0, 23, 2315.12, 2489.95, 3.3297, 0.131836, 0.0109863, 91.4172, 0, 23, 'WPXQ 6I1', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(34, 416, 2314.45, 2490.25, 3.27344, 0, 0, 92.288, 0, 23, 2315.71, 2495.3, 3.32472, 0.142822, 359.995, 89.9341, 0, 23, 'CC8B BCI', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(35, 416, 2314.15, 2485.35, 3.27344, 0, 0, 91.9693, 0, 23, 2314.15, 2485.34, 3.33597, 0.115356, 359.978, 92.4115, 0, 23, '2BNF AWT', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(36, 416, 2314.57, 2480.36, 3.27344, 0, 0, 90.7224, 0, 23, 2314.58, 2480.36, 3.32558, 0.142822, 359.995, 90.8405, 0, 23, 'FBWJ 4W0', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(37, 416, 2314.96, 2475.36, 3.27344, 0, 0, 96.1991, 0, 23, 2314.55, 2475.57, 3.32539, 0.142822, 0, 87.3633, 0, 23, 'UK3W DPZ', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(38, 416, 2314.67, 2470.53, 3.27344, 0, 0, 90.6894, 0, 23, 2314.41, 2470.52, 3.32428, 0.142822, 359.995, 90.6537, 0, 23, 'CRUG 8Q6', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(39, 416, 2314.52, 2465.53, 3.27344, 0, 0, 92.3264, 0, 23, 2314.53, 2465.52, 3.33234, 0.126343, 359.995, 93.3563, 0, 23, 'GRLO 84R', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(40, 416, 2314.59, 2460.75, 3.27344, 0, 0, 90.7389, 0, 23, 2314.6, 2460.73, 3.32965, 0.131836, 0.0164795, 92.1094, 0, 23, 'WFT0 GRI', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(41, 416, 2314.75, 2455.87, 3.27344, 0, 0, 92.634, 0, 23, 2314.19, 2455.97, 3.32271, 0.148315, 359.995, 90.1538, 0, 23, 'FJMI 91I', 1000, '#F5F5F5', '#840410', '#FFFFFF', -2, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(42, 525, 2313.84, 2499.27, 3.27344, 0, 0, 94.5182, 0, 27, 2314.79, 2500.13, 3.25406, 358.621, 359.978, 90.7031, 0, 27, 'JH48 A5P', 1000, '#730E1A', '#3B4E78', '#FFFFFF', -3, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(43, 525, 2314.6, 2494.66, 3.27344, 0, 0, 92.7109, 0, 27, 2314.59, 2494.67, 3.30467, 359.291, 359.978, 92.7081, 0, 27, 'N44G 3WP', 1000, '#4D6268', '#272F4B', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(44, 525, 2314.66, 2489.51, 3.27344, 0, 0, 91.5385, 0, 27, 2314.65, 2489.51, 3.30339, 359.275, 359.984, 91.5381, 0, 27, 'D327 ION', 1000, '#730E1A', '#3B4E78', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(45, 525, 2314.46, 2485.04, 3.27344, 0, 0, 92.266, 0, 27, 2314.45, 2485.04, 3.30476, 359.297, 359.962, 92.2577, 0, 27, 'SNUD VVP', 1000, '#7B0A2A', '#3B4E78', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(46, 525, 2314.6, 2480.15, 3.27344, 0, 0, 92.4417, 0, 27, 2314.59, 2480.15, 3.30429, 359.291, 359.989, 92.439, 0, 27, 'HA4Z F32', 1000, '#F5F5F5', '#F5F5F5', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(47, 525, 2314.52, 2475.18, 3.27344, 0, 0, 92.656, 0, 27, 2314.51, 2475.18, 3.30622, 359.313, 359.984, 92.6532, 0, 27, 'NCFZ UOB', 1000, '#193826', '#304F45', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(48, 525, 2314.3, 2470.37, 3.27344, 0, 0, 91.7496, 0, 27, 2314.29, 2470.37, 3.30535, 359.302, 359.989, 91.7468, 0, 27, 'MTGX M07', 1000, '#4D6268', '#272F4B', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(49, 525, 2314.14, 2465.1, 3.27344, 0, 0, 94.0403, 0, 27, 2314.13, 2465.1, 3.30446, 359.291, 359.984, 94.0375, 0, 27, 'YOK5 XBJ', 1000, '#691E3B', '#421F21', '#FFFFFF', -3, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(50, 468, 2309.84, -87.7041, 26.0009, 359.852, 359.995, 3.46619, 0, 0, 952.486, 588.381, 18.8056, 1.07666, 359.962, 126.238, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 2, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(51, 468, 2309.84, -87.7041, 26.0009, 359.852, 359.995, 3.46619, 0, 0, 2309.84, -87.7041, 26.0009, 359.852, 359.995, 3.46619, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(52, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(53, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 4, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(54, 492, 1002.34, 629.027, 19.2535, 0, 0, 283.14, 0, 0, 2313.1, 2485.24, 3.22389, 0.0274658, 0, 90.0659, 0, 32, '2MXZ IVO', 1000, '#6F8297', '#A19983', '#FFFFFF', 4, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(55, 494, 2299.69, 2484.81, 3.27344, 0, 0, 177.84, 0, 32, 2313.29, 2480.32, 2.96955, 0.840454, 0, 88.3905, 0, 32, 'F653 NFI', 1000, '#6D6C6E', '#1F253B', '#FFFFFF', 4, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(57, 502, 2303.72, 2468.54, 3.27344, 0, 0, 193.633, 0, 32, 2314.07, 2474.94, 2.88258, 0.159302, 359.989, 86.8964, 0, 32, 'CH2U 9NZ', 1000, '#0E316D', '#661C26', '#FFFFFF', 4, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(59, 415, 2301.02, 2478.89, 3.27344, 0, 0, 153.389, 0, 32, 2314.53, 2490.14, 2.39975, 0.76355, 0, 89.5441, 0, 32, 'OQF1 DDX', 1000, '#000000', '#F5F5F5', '#FFFFFF', 4, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(60, 602, 2302.24, 2473.27, 3.27344, 0, 0, 300.169, 0, 32, 2314.27, 2470.24, 2.56518, 0.324097, 359.945, 90.9229, 0, 32, '709T ZJM', 1000, '#8494AB', '#F5F5F5', '#FFFFFF', 4, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(61, 466, 2305.29, 2471.83, 3.27344, 0, 0, 91.3705, 0, 32, 2298.79, 2464.46, 3.01528, 0.0109863, 0, 269.962, 0, 32, 'MTPQ DKG', 1000, '#2A77A1', '#A4A096', '#FFFFFF', 4, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(63, 490, 2307.37, 2456.88, 3.27344, 0, 0, 324.669, 0, 32, 2313.9, 2465.64, 3.21409, 0.203247, 359.385, 89.7473, 0, 32, 'HJEG 906', 1000, '#000000', '#000000', '#FFFFFF', 4, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(64, 542, 2303.67, 2460.72, 3.27344, 0, 0, 147.138, 0, 32, -76.1328, 209.63, 2.21811, 356.287, 353.156, 90.412, 0, 0, '8MYC 1RP', 1000, '#515459', '#A3ADC6', '#FFFFFF', 4, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(65, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1334.06, -51.5811, 34.9707, 3.18054, 0.807495, 132.006, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 9, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(66, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1391.57, 33.0977, 29.5306, 357.687, 0.741577, 54.8108, 0, 0, '', 983, '#840410', '#840410', '#FFFFFF', 11, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(67, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 482.153, 201.087, 10.9738, 358.132, 1.96655, 118.163, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 10, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(68, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 125.821, -152.159, 1.21712, 1.31287, 359.951, 178.281, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 12, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(69, 558, 1338.81, -46.0377, 35.18, 0, 0, 105.972, 0, 0, 1365.14, -35.6006, 34.0573, 357.38, 1.13708, 272.505, 0, 0, '3FQB MP9', 933, '#221918', '#F5F5F5', '#FFFFFF', 9, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(70, 533, 1348.8, -41.6338, 34.9132, 0, 0, 383.622, 0, 0, 124.292, -182.305, 1.28815, 359.995, 0.0823975, 159.439, 0, 0, 'FU2O F4G', 1000, '#AA9D84', '#F5F5F5', '#FFFFFF', 9, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(71, 400, 1334.77, -38.583, 35.0858, 0, 0, 169.82, 0, 0, 136.548, -152.808, 1.50177, 1.63696, 2.74658, 197.435, 0, 0, 'OQIJ RR1', 1000, '#221918', '#F5F5F5', '#FFFFFF', 9, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(72, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 13, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(73, 558, 2305.01, 2481.96, 3.27344, 0, 0, 266.237, 0, 36, 2285.88, 2430.09, 2.89255, 359.725, 0, 0.499878, 0, 36, 'KTTP VDO', 1000, '#FF0000', '#F5F5F5', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(74, 492, 2308.88, 2466.87, 3.27344, 0, 0, 182.883, 0, 36, 2263.73, 2474.23, 3.22387, 0.032959, 0, 0.175781, 0, 36, 'ZF23 2UO', 1000, '#000000', '#000000', '#FFFFFF', 11, 1, 0, 1, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(75, 487, 2312.77, 2432.66, 3.27344, 0, 0, 358.919, 0, 36, 288.644, 297.271, 2.13928, 2.25769, 359.995, 109.968, 0, 0, 'FN7N 8WL', 1000, '#A5A9A7', '#840410', '#FFFFFF', 11, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(76, 487, 2306.07, 2432.93, 3.27344, 0, 0, 359.545, 0, 36, 306.048, 293.69, 2.14661, 2.18079, 0, 359.544, 0, 0, 'TSRH GGZ', 1000, '#5D7E8D', '#6D7A88', '#FFFFFF', 11, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(77, 446, 2298, 2434.16, 3.27344, 0, 0, 358.842, 0, 36, 266.341, 283.067, -0.548066, 1.83472, 358.281, 88.0994, 0, 0, 'PGGG K1A', 1000, '#F5F5F5', '#86446E', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(79, 516, 2308.89, 2460.96, 3.27344, 0, 0, 372.548, 0, 36, 2303.22, 2430.93, 2.98278, 359.55, 359.995, 358.907, 0, 36, 'C8RX Y8V', 1000, '#263739', '#F5F5F5', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(80, 522, 2306.68, 2477.02, 3.27344, 0, 0, 448.75, 0, 36, 2298.21, 2455.34, 2.80054, 359.725, 0.00549316, 266.715, 0, 36, 'KVQA LV1', 1000, '#BDBEC6', '#741D28', '#FFFFFF', 11, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(81, 518, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'BI0O QW9', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(82, 565, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'IA2S EO8', 1000, '#FFFFFF', '#000000', '#FFFFFF', 9, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(83, 587, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'KJTR YSX', 1000, '#FFFFFF', '#000000', '#FFFFFF', 9, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(85, 518, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'BDQK X6S', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(86, 475, 2311.08, 2481.35, 3.27344, 0, 0, 381.134, 0, 36, 123.401, -168.623, 1.2371, 0.109863, 359.973, 6.6687, 0, 0, '1SIV YXS', 1000, '#000000', '#000000', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 1),
(87, 411, 2304.86, 2488.81, 3.27344, 0, 0, 96.3255, 0, 36, 2315.57, 2475.34, 2.98447, 0.411987, 0, 88.3356, 0, 36, 'O9GG LR2', 1000, '#000000', '#F5F5F5', '#FFFFFF', 11, 0, 1, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(88, 559, 2301.79, 2486.03, 3.27344, 0, 0, 106.098, 0, 36, 2316.36, 2469.89, 2.75178, 0.791016, 0.247192, 90.423, 0, 36, 'KEW7 H0L', 1000, '#000000', '#000000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(90, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2287.31, -53.3994, 26.122, 1.25793, 359.94, 354.639, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 14, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(92, 477, 2307, 2485.9, 3.27344, 0, 0, 430.43, 0, 36, 2315, 2495.12, 2.95635, 0.32959, 359.995, 90.0385, 0, 36, '6K25 OY8', 1000, '#000000', '#FFFFFF', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(93, 494, 2298.73, 2483.37, 3.27344, 0, 0, 150.209, 0, 36, 2315, 2500.32, 2.96903, 0.834961, 0, 89.8077, 0, 36, 'RI9V DX6', 1000, '#000000', '#000000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(94, 461, 2303, 2482.16, 3.27344, 0, 0, 448.986, 0, 36, 2297.91, 2464.74, 2.83792, 1.19202, 359.995, 274.532, 0, 36, '4S37 A1E', 1000, '#000874', '#0712A7', '#0041FF', 11, 1, 0, 0, 0, 100, 3, '1086', NULL, 0, 0, 3, 3, 0, 1, 0, 0, 0, 2, 20, 0),
(95, 438, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'GPP1 547', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(96, 438, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'HRHM OTC', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(97, 438, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'ERBU 2QR', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(98, 521, 2303.02, 2467.86, 3.27344, 0, 0, 215.732, 0, 36, 2298.2, 2451.68, 2.84059, 2.82349, 0.098877, 267.902, 0, 36, 'IW2H MRU', 1000, '#3F3E45', '#A3ADC6', '#FFFFFF', 11, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(99, 587, 2305.52, 2471.5, 3.27344, 0, 0, 115.799, 0, 36, 2239.35, 2466.28, 2.84416, 359.901, 359.995, 269.555, 0, 36, '6JED CBQ', 1000, '#FF0000', '#F5F5F5', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(100, 438, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, '1RH2 TOP', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(101, 426, 2304.41, 2479.65, 3.27344, 0, 0, 130.323, 0, 36, 2289.74, 2430.93, 3.07142, 0.373535, 359.995, 0.994263, 0, 36, 'PYD9 J57', 1000, '#7C1C2A', '#7C1C2A', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(102, 541, 2297.16, 2482.14, 3.27344, 0, 0, 159.915, 0, 36, 2239.48, 2475.85, 2.99588, 359.583, 0, 269.703, 0, 36, 'VVUM CRP', 1000, '#FF0000', '#FF0000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(103, 566, 2301.66, 2488.34, 3.27344, 0, 0, 449.404, 0, 36, 2276.72, 2473.6, 3.21273, 0.461426, 359.995, 0.203247, 0, 36, 'WTUO 1E9', 1000, '#000000', '#000000', '#FFFFFF', 11, 0, 1, 1, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(104, 565, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'I3B5 6XE', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(105, 580, 2286.99, 2483.67, 3.27344, 0, 0, 184.157, 0, 36, 2272.31, 2474.52, 3.47621, 1.27441, 359.995, 359.555, 0, 36, 'NNXC 4IF', 1000, '#000000', '#000000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(106, 518, 2299.56, 2475.12, 3.27344, 0, 0, 189.595, 0, 36, 2239.23, 2427.81, 3.14968, 1.19202, 359.061, 270.45, 0, 36, 'GIE9 AOZ', 1000, '#2D3A35', '#000000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(107, 551, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -171.148, 334.881, 11.84, 359.868, 351.996, 343.839, 0, 0, '6Q1D DEP', 1000, '#848282', '#000000', '#FFFFFF', 2, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(108, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2306.53, -75.4863, 26.124, 1.24695, 0.0164795, 202.165, 0, 0, '', 980, '#162248', '#162248', '#FFFFFF', 15, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(109, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 125.637, -148.4, 1.2092, 1.3678, 359.934, 162.372, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 16, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(110, 502, 2302.99, 2489.18, 3.27344, 0, 0, 113.497, 0, 36, 2315.69, 2480.03, 2.88199, 0.148315, 359.984, 90.7471, 0, 36, 'BPFE WSF', 1000, '#0A0A0A', '#FF0000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(111, 426, 2297.51, -78.5803, 26.4844, 0, 0, 189.485, 0, 0, 2297.51, -78.5703, 26.1133, 0.477905, 0.0933838, 189.525, 0, 0, 'T5TT UMB', 1000, '#9CA1A3', '#9CA1A3', '#FFFFFF', 15, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(112, 541, 2293.26, -86.4206, 26.343, 0, 0, 201.137, 0, 0, 2293.25, -86.4277, 26.0611, 359.665, 0.164795, 201.094, 0, 0, 'LJVX UOL', 1000, '#58595A', '#BDBEC6', '#FFFFFF', 15, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(113, 522, 2291.73, -92.3113, 26.3359, 0, 0, 171.913, 0, 0, 2297.87, 2474.33, 2.79811, 359.714, 0.00549316, 83.9575, 0, 42, 'SG3K ZQP', 1000, '#D78E10', '#3F3E45', '#FFFFFF', 15, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(114, 490, 137.334, -147.885, 1.42978, 0, 0, 376.267, 0, 0, 2281.13, 2474.02, 3.21417, 0.203247, 359.385, 0.565796, 0, 36, 'L1LK 9OH', 1000, '#000000', '#000000', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(115, 559, 134.469, -158.4, 1.43296, 0, 0, 274.653, 0, 0, 2297.63, 2456, 2.75109, 0.796509, 0.247192, 271.17, 0, 39, 'R867 DTS', 980, '#304F45', '#F5F5F5', '#FFFFFF', 16, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(116, 561, 136.377, -153.45, 1.43407, 0, 0, 345.884, 0, 0, 2259.64, 2473.86, 3.14828, 359.896, 0.00549316, 358.951, 0, 39, 'S4LG AV0', 1000, '#6A7A8C', '#BDBEC6', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(117, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 18, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(118, 470, 2304.62, 2484.45, 3.27344, 0, 0, 280.075, 0, 41, 2314.1, 2485.21, 3.08894, 0.137329, 0.00549316, 91.0217, 0, 41, 'Y7QQ 5PK', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(119, 477, 2303.37, 2486.11, 3.27344, 0, 0, 436.006, 0, 39, 2285.72, 2473.68, 2.95653, 0.32959, 0, 358.242, 0, 39, 'QX9L O7J', 1000, '#204B6B', '#F5F5F5', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(120, 470, 2307.43, 2491.68, 3.27344, 0, 0, 177.01, 0, 41, 2314.62, 2480.47, 3.08873, 0.137329, 359.912, 89.0497, 0, 41, 'U1RE M26', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(121, 470, 2308.81, 2481.85, 3.27344, 0, 0, 233.662, 0, 41, 2315, 2475.58, 3.0881, 0.137329, 359.912, 92.1808, 0, 41, '3KOF WS9', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(122, 502, 2304.48, 2477.39, 3.27344, 0, 0, 313.682, 0, 39, 2276.96, 2474.07, 2.88205, 0.153809, 359.989, 359.962, 0, 39, 'C68P UB4', 1000, '#252527', '#6D2837', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(123, 470, 2310.14, 2478.37, 3.27344, 0, 0, 223.357, 0, 41, 2315.58, 2470.34, 3.08955, 0.131836, 359.912, 89.0717, 0, 41, '0NZW WOO', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(124, 542, 2311.34, 2481.57, 3.27344, 0, 0, 355.953, 0, 39, 2268.23, 2474.05, 3.05243, 359.989, 0, 0.318604, 0, 39, 'M7UU DHU', 1000, '#8494AB', '#6D6C6E', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(125, 470, 2309.83, 2474.06, 3.27344, 0, 0, 216.545, 0, 41, 2316.58, 2459.84, 3.0886, 0.137329, 359.907, 87.9126, 0, 41, '9NNA Q7T', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(126, 475, 2304.84, 2477.22, 3.27344, 0, 0, 265.858, 0, 39, 2272.63, 2474.18, 2.95013, 0.164795, 0, 0.269165, 0, 39, 'W08T QX9', 1000, '#2A77A1', '#6D7A88', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(127, 492, 2308.08, 2469.95, 3.27344, 0, 0, 274.29, 0, 39, 2297.92, 2464.31, 3.22386, 0.032959, 0, 269.846, 0, 39, 'VZB9 C22', 1000, '#AA9D84', '#A5A9A7', '#FFFFFF', 16, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(128, 470, 2309.02, 2468.05, 3.27344, 0, 0, 215.232, 0, 41, 2315.48, 2465.32, 3.08787, 0.137329, 359.912, 87.4512, 0, 41, 'NF9S 5ZJ', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(129, 470, 2304.01, 2471.53, 3.27344, 0, 0, 206.267, 0, 41, 2315.58, 2470.23, 3.08848, 0.137329, 359.912, 92.0819, 0, 41, 'LCU8 7QA', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(130, 411, 2314.57, 2474.33, 3.27344, 0, 0, 347.944, 0, 39, 2281.48, 2473.9, 2.98431, 0.411987, 0, 358.956, 0, 39, 'RM94 UOF', 1000, '#20202C', '#F5F5F5', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(132, 480, 2295.5, 2478.25, 3.27344, 0, 0, 159.712, 0, 39, 2297.81, 2451.6, 3.05174, 359.654, 0, 270.06, 0, 39, 'SMCV UGR', 1000, '#9AA790', '#5D1B20', '#FFFFFF', 16, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(133, 470, 2308.54, 2463.05, 3.27344, 0, 0, 175.362, 0, 41, 2315.73, 2460.93, 3.08898, 0.137329, 359.912, 90.1813, 0, 41, '6S0B IHG', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(134, 522, 2299.37, 2484.86, 3.27344, 0, 0, 102.093, 0, 39, 2289.13, 2473.98, 2.80288, 359.659, 0, 359.725, 0, 39, 'C4AG JS7', 1000, '#252527', '#64686A', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(135, 541, 2289.58, 2483.9, 3.27344, 0, 0, 173.313, 0, 39, 2314.36, 2490.23, 2.99576, 359.588, 359.995, 89.5715, 0, 39, 'L3KB EIV', 1000, '#252527', '#BDBEC6', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(136, 587, 2288.12, 2474.74, 3.27344, 0, 0, 263.309, 0, 39, 2314.2, 2480.08, 2.84427, 359.907, 359.995, 90.3625, 0, 39, 'LIPF MRU', 1000, '#5F0A15', '#F5F5F5', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(137, 426, 2282.82, 2480.58, 3.27344, 0, 0, 160.042, 0, 39, 2314.43, 2485.17, 3.0699, 0.379028, 0, 89.7308, 0, 39, '0DQI 7FO', 1000, '#4C75B7', '#4C75B7', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(138, 487, 2312.95, 2431.68, 3.27344, 0, 0, 358.628, 0, 39, 2312.95, 2431.68, 3.27344, 0, 0, 358.628, 0, 39, 'HQF9 17R', 1000, '#840410', '#979592', '#FFFFFF', 0, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(139, 487, 2306.81, 2433.38, 3.27344, 0, 0, 358.469, 0, 39, 2306.81, 2433.38, 3.27344, 0, 0, 358.469, 0, 39, 'CVPF QZ6', 1000, '#A5A9A7', '#840410', '#FFFFFF', 0, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(140, 566, 2297.56, 2458.33, 3.27344, 0, 0, 175.011, 0, 39, 2299.06, 2431.43, 3.21619, 0.444946, 359.995, 0.098877, 0, 39, 'AHH6 1UD', 1000, '#4D322F', '#BDBEC6', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(141, 429, 2306.19, 2456.01, 3.27344, 0, 0, 343.121, 0, 39, 2314.04, 2470.25, 2.96412, 359.989, 0, 90.1538, 0, 39, 'MG5B JJ7', 1000, '#D6DAD6', '#D6DAD6', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(142, 580, 2310.87, 2463.69, 3.27344, 0, 0, 377.832, 0, 39, 2314.02, 2460.39, 3.47547, 1.26892, 0, 91.7139, 0, 39, 'HUZW JLZ', 1000, '#5F0A15', '#5F0A15', '#FFFFFF', 16, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(145, 518, 2302.48, 2462.3, 3.27344, 0, 0, 211.343, 0, 39, 2314.79, 2495.38, 3.14989, 1.18652, 359.061, 90.434, 0, 39, 'IQF6 SMU', 1000, '#730E1A', '#F5F5F5', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(146, 550, 2314.01, 2452.1, 3.27344, 0, 0, 311.732, 0, 39, 2314.41, 2455.43, 3.19753, 359.467, 0, 89.2914, 0, 39, '0TBC 1ZN', 1000, '#46597A', '#46597A', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(147, 506, 2312.52, 2445.42, 3.27344, 0, 0, 313.243, 0, 39, 2263.67, 2474.13, 2.80896, 0.466919, 0, 359.615, 0, 39, 'EEV5 1H8', 1000, '#4C75B7', '#4C75B7', '#FFFFFF', 16, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(149, 470, 2302.94, 2460.16, 3.27344, 0, 0, 144.545, 0, 41, 2315.5, 2455.83, 3.08879, 0.137329, 359.912, 93.0597, 0, 41, 'UJ5R E37', 1000, '#5F0A15', '#000000', '#FFFFFF', -4, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(150, 517, 2304.26, 2443.31, 3.26601, 0, 0, 232.377, 0, 39, 2297.94, 2460.19, 3.08156, 359.989, 0, 270.72, 0, 39, 'N1WU CDE', 1000, '#252527', '#252527', '#FFFFFF', 16, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(151, 547, 2299.4, 2448.57, 3.27344, 0, 0, 188.958, 0, 39, 2314.34, 2500.36, 2.9463, 0.428467, 359.995, 90.6592, 0, 39, 'WHRG MNK', 1000, '#46597A', '#F5F5F5', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(153, 546, 2306.49, 2449.95, 3.27344, 0, 0, 337.951, 0, 39, 2314.48, 2475.35, 3.01034, 0.258179, 0, 90.4669, 0, 39, 'PNWN Y04', 1000, '#661C26', '#2D3A35', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(154, 497, 295.516, 1954.11, 17.6406, 0, 0, 382.677, 0, 0, 306.132, 1942.63, 17.9069, 358.737, 359.648, 176.605, 0, 0, 'DDEG WHL', 1000, '#000000', '#F5F5F5', '#FFFFFF', -4, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(156, 551, 2300.79, 2453.98, 3.27344, 0, 0, 139.574, 0, 39, 2314.05, 2465.43, 2.93622, 359.863, 359.995, 91.0876, 0, 39, 'TOCQ 40T', 1000, '#6A7A8C', '#F5F5F5', '#FFFFFF', 16, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(157, 497, 307.605, 1912.98, 17.6406, 0, 0, 267.149, 0, 0, 307.071, 1918.62, 17.9085, 358.731, 359.648, 183.697, 0, 0, 'S84G 0UM', 1000, '#000000', '#F5F5F5', '#FFFFFF', -4, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(158, 426, 162.029, 1921.86, 18.5747, 0, 0, 91.2992, 0, 0, 2313.25, 2489.5, 3.06938, 0.379028, 359.989, 90.6647, 0, 42, '5C3S 0XX', 1000, '#4C75B7', '#4C75B7', '#FFFFFF', 15, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(159, 426, 150.866, 1919.15, 18.86, 0, 0, 181.136, 0, 0, 2314.87, 2500.19, 3.07058, 0.379028, 0.032959, 92.1698, 0, 40, '7YR6 VIM', 1000, '#7C1C2A', '#7C1C2A', '#FFFFFF', 18, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(160, 566, 162.974, 1912.66, 18.5934, 0, 0, 296.549, 0, 0, 2314.45, 2480.4, 3.21347, 0.461426, 359.978, 88.0774, 0, 40, '40IZ 5JK', 1000, '#1E2E32', '#F5F5F5', '#FFFFFF', 15, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(161, 522, 169.959, 1922.39, 18.3942, 0, 0, 385.594, 0, 0, 2298.09, 2475.48, 2.80022, 359.731, 0.00549316, 274.114, 0, 42, '2NJX TWB', 1000, '#252527', '#64686A', '#FFFFFF', 18, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(162, 566, 172.034, 1916.67, 18.288, 0, 0, 304.053, 0, 0, 2315.13, 2489.89, 3.21156, 0.466919, 0.0109863, 90.3021, 0, 40, 'QQCZ Y9F', 1000, '#2B3E57', '#F5F5F5', '#FFFFFF', 18, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(163, 502, 2307.32, 2482.25, 3.27344, 0, 0, 282.805, 0, 42, 245.706, -155.529, 1.18811, 0.241699, 0.098877, 58.3923, 0, 0, 'HHNJ 3GJ', 1000, '#0E316D', '#661C26', '#FFFFFF', 18, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(164, 475, 2306.47, 2476.23, 3.27344, 0, 0, 334.304, 0, 42, 251.562, -159.295, 1.23496, 359.945, 0, 288.062, 0, 0, '3D5K HD9', 1000, '#5E7072', '#6D7A88', '#FFFFFF', 18, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(166, 541, 2309.13, 2488.15, 3.27344, 0, 0, 419.883, 0, 42, 2314.9, 2485.29, 2.9984, 359.588, 0.0384521, 87.8192, 0, 42, 'L0HK BV8', 1000, '#691E3B', '#F5F5F5', '#FFFFFF', 18, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(168, 580, 2306.17, 2478.76, 3.27344, 0, 0, 306.623, 0, 42, 2313.92, 2485.23, 3.47567, 1.27991, 359.995, 88.2367, 0, 40, '8Y5C 5HW', 1000, '#5F0A15', '#5F0A15', '#FFFFFF', 18, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(171, 565, 2305.27, 2477.49, 3.27344, 0, 0, 302.212, 0, 42, 2316.2, 2470.06, 3.13656, 0.477905, 0.0274658, 273.653, 0, 42, 'GNQ5 6YN', 1000, '#9CA1A3', '#9CA1A3', '#FFFFFF', 18, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(172, 547, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 2309.93, 2431.95, 2.94616, 0.428467, 359.995, 358.709, 0, 36, 'HQBT 006', 1000, '#FF0000', '#000000', '#FFFFFF', 11, 0, 0, 1, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(173, 550, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 2316.9, 2431.77, 3.19946, 359.478, 0, 0.977783, 0, 36, 'WOK3 9QB', 1000, '#FF0000', '#000000', '#FFFFFF', 11, 0, 0, 1, 0, 100, 3, '1010,1086', NULL, 0, 0, 3, 3, 0, 0, 0, 0, 0, 2, 20, 0),
(174, 586, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 2298.47, 2448.66, 2.80781, 359.242, 359.984, 269.456, 0, 36, '7F34 WVB', 1000, '#FFFFFF', '#000000', '#FFFFFF', 11, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(175, 463, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 2297.18, 2460.43, 2.59975, 2.23022, 359.995, 272.867, 0, 36, 'AMDZ 2YN', 1000, '#FFFFFF', '#000000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(176, 462, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 2298.27, 2445.38, 2.79274, 0, 359.995, 268.352, 0, 36, 'DBU8 9SJ', 1000, '#FFFFFF', '#000000', '#FFFFFF', 11, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(177, 586, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'ZNXQ NT5', 1000, '#FFFFFF', '#000000', '#FFFFFF', 18, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(178, 587, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 2313.54, 2485.26, 2.84393, 359.901, 0.0109863, 90.5823, 0, 40, 'F2FA 393', 1000, '#FFFFFF', '#000000', '#FFFFFF', 15, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(179, 429, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 84.4199, -182.695, 1.22284, 0.395508, 359.588, 137.071, 0, 0, '5LJX M03', 1000, '#FFFFFF', '#000000', '#FFFFFF', 2, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(180, 438, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 1211.21, 589.48, -0.564397, 357.99, 0.274658, 43.6487, 0, 0, 'TUPT UDL', 1000, '#FFFFFF', '#000000', '#FFFFFF', 2, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(181, 411, 2294.33, -72.9391, 26.3359, 0, 0, 164.898, 0, 0, 2294.33, -72.9365, 26.0308, 0.390015, 0, 164.932, 0, 0, 'W58R HUI', 1000, '#223457', '#F5F5F5', '#FFFFFF', 8, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(183, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 375.605, -188.677, 14.3013, 92.1863, 1.52161, 289.21, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 20, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(184, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1210.78, 190.925, 19.8728, 354.43, 359.484, 333.611, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 21, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(185, 542, -607.427, 2645.12, 84.2237, 0, 0, 278.273, 0, 0, 2315.22, 2489.88, 3.05228, 359.989, 359.995, 92.7191, 0, 36, 'SWHJ EGE', 1000, '#000000', '#383030', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(186, 529, -606.804, 2653.51, 83.8095, 0, 0, 441.203, 0, 0, 294.73, -101.022, 2.86659, 359.687, 358.281, 190.25, 0, 0, '3EYW 855', 1000, '#000000', '#000000', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(187, 517, -483.853, 2754.62, 79.2767, 0, 0, 135.855, 0, 0, 2315.8, 2465.02, 3.08206, 359.989, 0, 91.0547, 0, 36, 'PLB2 8ER', 1000, '#000000', '#000000', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(188, 519, -490.573, 2749.42, 78.4667, 0, 0, 197.934, 0, 0, -492.014, 2757.87, 78.3738, 7.99255, 0.296631, 181.939, 0, 0, '7TQ2 NN1', 1000, '#F5F5F5', '#F5F5F5', '#FFFFFF', 11, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(189, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 955.106, 572.169, 19.6445, 0.318604, 2.69714, 121.284, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 17, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(190, 562, -1602.57, 84.7982, 3.54948, 0, 0, 199.049, 0, 0, 2316.56, 2455, 2.94111, 0.719604, 0.00549316, 89.0442, 0, 36, 'A4P9 X9R', 1000, '#252527', '#F5F5F5', '#FFFFFF', 11, 1, 0, 1, 0, 100, 3, '1010,1086', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(191, 506, -1582.84, 83.4348, 3.55469, 0, 0, 376.3, 0, 0, 2316.21, 2460.17, 2.80941, 0.466919, 359.995, 89.7913, 0, 36, 'B82E SK6', 1000, '#000000', '#000000', '#FFFFFF', 11, 1, 0, 0, 0, 100, 3, '1010,1086', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(192, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 635.983, -576.997, 15.9729, 1.27991, 359.912, 169.178, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 22, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(193, 596, 2308.02, 2481.12, 3.27344, 0, 0, 378.294, 0, 22, 2314.86, 2495.31, 3.21093, 0.0439453, 0.0109863, 88.5992, 0, 22, 'J1IJ 3ME', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(194, 596, 2307.83, 2492.22, 3.27344, 0, 0, 177.785, 0, 22, 2314.78, 2490.42, 3.19983, 0.0439453, 0.0164795, 87.9895, 0, 22, 'RPW4 2W0', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(195, 596, 2306.93, 2487.73, 3.27344, 0, 0, 187.013, 0, 22, 2315.26, 2485.08, 3.20411, 0.0439453, 0.0164795, 90.9503, 0, 22, 'AZPM 8XQ', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(196, 596, 2307.78, 2480.45, 3.27344, 0, 0, 229.932, 0, 22, 2315.22, 2480.02, 3.20082, 0.0439453, 0.0164795, 91.4392, 0, 22, '1QMM KOS', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(197, 596, 2306.32, 2477.73, 3.27344, 0, 0, 189.079, 0, 22, 2315.66, 2475.22, 3.21183, 0.0439453, 0.0164795, 92.3456, 0, 22, 'QJYE G6C', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(198, 596, 2307.54, 2472.04, 3.27344, 0, 0, 190.326, 0, 22, 2315.21, 2469.98, 3.2007, 0.0439453, 0.0164795, 88.5443, 0, 22, 'XL55 2IC', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(199, 598, 2307.38, 2468.94, 3.27344, 0, 0, 175.384, 0, 22, 2298.31, 2464.29, 3.15497, 0.565796, 0, 269.802, 0, 22, 'AM2B W1U', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(200, 598, 2305.16, 2464.49, 3.27344, 0, 0, 341.769, 0, 22, 2298.39, 2460.5, 3.15307, 0.571289, 0.0109863, 268.907, 0, 22, 'EJYD MPJ', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(201, 598, 2304.59, 2461.19, 3.27344, 0, 0, 348.784, 0, 22, 2298.28, 2455.91, 3.15381, 0.565796, 0, 274.642, 0, 22, '5K0S B94', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(202, 598, 2305.87, 2457.16, 3.27344, 0, 0, 355.491, 0, 22, 2298.62, 2451.45, 3.15779, 0.55481, 359.973, 270.923, 0, 22, 'N17N BWP', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(203, 597, 2306.96, 2454.65, 3.27344, 0, 0, 367.368, 0, 22, 2315.15, 2465, 3.29429, 0.269165, 0.00549316, 88.6707, 0, 22, 'PZVG 4UA', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(204, 597, 2314.45, 2460.09, 3.27344, 0, 0, 266.254, 0, 22, 2314.57, 2455.75, 3.31033, 0.192261, 359.967, 91.192, 0, 22, 'FAPQ XV5', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(205, 597, 2310.82, 2449.76, 3.27344, 0, 0, 230.872, 0, 22, 2315.2, 2460.42, 3.2959, 0.263672, 359.973, 88.6981, 0, 22, 'PM6Y 7DG', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(206, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1358.43, 303.364, 19.1936, 1.2854, 359.94, 202.72, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 23, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(207, 497, 617.33, -573.922, 26.1432, 0, 0, 209.734, 0, 0, 617.345, -573.939, 26.4214, 358.709, 359.692, 209.734, 0, 0, 'J1XX GNK', 1000, '#000000', '#F5F5F5', '#FFFFFF', -1, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(208, 523, 2294.79, 2483.9, 3.27344, 0, 0, 237.178, 0, 22, 2296.28, 2473.57, 3.03706, 0.109863, 359.995, 309.798, 0, 22, '0U7R UTM', 1000, '#000000', '#000000', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(209, 523, 2291.74, 2476.55, 3.27344, 0, 0, 153.845, 0, 22, 2294.75, 2473.91, 3.03716, 0.109863, 359.995, 326.14, 0, 22, 'N0WA IK1', 1000, '#000000', '#000000', '#FFFFFF', -1, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(210, 523, 2293.15, 2478.51, 3.27344, 0, 0, 103.686, 0, 22, 2292.98, 2474.9, 3.03688, 0.109863, 359.995, 317.395, 0, 22, 'WBQ1 O81', 1000, '#000000', '#000000', '#FFFFFF', -1, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(211, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 636.773, -567.785, 15.8381, 354.908, 359.962, 289.775, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 24, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(212, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 171.348, -40.9951, 1.21529, 1.2085, 359.934, 197.974, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 25, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(213, 566, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 978.743, 610.781, 19.1093, 0.455933, 359.995, 39.7321, 0, 0, 'UO1X 5N3', 1000, '#FFFFFF', '#000000', '#FFFFFF', 25, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(214, 587, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'XLO8 Z9M', 1000, '#FFFFFF', '#000000', '#FFFFFF', 25, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(215, 587, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'BW9E 0YU', 1000, '#FFFFFF', '#000000', '#FFFFFF', 25, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(216, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2706.97, -1958.55, 13.1882, 1.31836, 0.0878906, 107.314, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 27, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(217, 525, 2306.95, 2484.3, 3.27344, 0, 0, 286.419, 0, 28, 2315.1, 2495.18, 3.26851, 358.813, 359.973, 90.9229, 0, 28, 'R5G6 NH2', 1000, '#252527', '#5F0A15', '#FFFFFF', -3, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(218, 525, 2304.14, 2491.47, 3.27344, 0, 0, 170.451, 0, 28, 2315.18, 2490.26, 3.25883, 358.687, 359.978, 90.8899, 0, 28, 'TIZD ML5', 1000, '#252527', '#5F0A15', '#FFFFFF', -3, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(219, 525, 2310.42, 2484.23, 3.27344, 0, 0, 94.5621, 0, 28, 2315.26, 2485.54, 3.25862, 358.687, 0.0164795, 90.8185, 0, 28, 'JGLU 7R5', 1000, '#691E3B', '#421F21', '#FFFFFF', -3, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(220, 525, 2302.92, 2484.2, 3.27344, 0, 0, 188.189, 0, 28, 2315.28, 2479.94, 3.25473, 358.577, 359.824, 89.5715, 0, 28, 'NQL9 JJF', 1000, '#193826', '#304F45', '#FFFFFF', -3, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(221, 525, 2304.11, 2474.79, 3.27344, 0, 0, 179.993, 0, 28, 2315.29, 2475.16, 3.27274, 358.874, 359.978, 85.567, 0, 28, 'KWW9 MXK', 1000, '#730E1A', '#3B4E78', '#FFFFFF', -3, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(222, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 129.138, -153.77, 1.06845, 1.27991, 359.94, 153.995, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 28, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(223, 426, -204.478, -295.181, 1.42969, 0, 0, 334.952, 0, 0, -203.73, -293.267, 1.22949, 0.373535, 359.962, 335.896, 0, 0, 'OWD7 VQI', 1000, '#162248', '#162248', '#FFFFFF', 20, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(224, 522, -210.559, -292.419, 1.42969, 0, 0, 145.973, 0, 0, 484.583, 519.85, 18.9136, 81.5735, 0.00549316, 214.393, 0, 0, '8CYC 2W8', 1000, '#252527', '#64686A', '#FFFFFF', 20, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(225, 492, -206.561, -289.471, 1.42969, 0, 0, 401.052, 0, 0, 128.295, -187.981, 1.45539, 357.72, 359.973, 233.448, 0, 0, 'KTOT 6FB', 980, '#AA9D84', '#A5A9A7', '#FFFFFF', 20, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(226, 426, 1254.9, 265.94, 19.4062, 0, 0, 250.834, 0, 0, 771.486, -151.293, -0.774892, 22.2803, 293.851, 292.994, 0, 0, 'MYFO 3BX', 1000, '#661C26', '#661C26', '#FFFFFF', 23, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(227, 522, 1262.76, 261.388, 19.4062, 0, 0, 310.298, 0, 0, 2208.02, 47.2344, 26.013, 359.742, 0.0109863, 102.14, 0, 0, '4QO1 FAG', 1000, '#840410', '#840410', '#FFFFFF', 23, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(228, 426, 761.467, 326.24, 19.8828, 0, 0, 155.499, 0, 0, 755.717, 331.549, 19.9502, 5.40527, 349.481, 71.7023, 0, 0, 'CTVF TZV', 1000, '#46597A', '#46597A', '#FFFFFF', 17, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(229, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1105.68, 431.863, 25.6723, 5.07019, 358.374, 267.424, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', -3, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(230, 426, 2296.1, -67.5496, 26.3359, 0, 0, 363.924, 0, 0, 127.577, -149.054, 1.29526, 0.455933, 354.633, 178.066, 0, 0, 'NY1B 5ZW', 978, '#4C75B7', '#4C75B7', '#FFFFFF', 30, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(232, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 115.92, -199.513, -49.4079, 272.593, 17.4683, 86.6876, 0, 0, '', 973, '#9D9872', '#9D9872', '#FFFFFF', 31, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(233, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2300.92, 36.5127, 26.1233, 1.38428, 359.989, 101.129, 0, 0, '', 921, '#9D9872', '#9D9872', '#FFFFFF', 32, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(234, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, -171.785, 1940.96, 16.8521, 346.152, 13.2495, 326.574, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 33, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(235, 448, 1355.58, 269.019, 19.5547, 0, 0, 155.784, 0, 0, 1361.7, 261.421, 19.1672, 359.478, 0, 64.4073, 0, 0, 'O7FY 4D3', 1000, '#840410', '#D78E10', '#FFFFFF', 0, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(236, 448, 1354.36, 266.206, 19.5547, 0, 0, 149.852, 0, 0, 1362.38, 263.037, 19.1657, 359.467, 359.995, 67.11, 0, 0, 'Q5WT H4M', 1000, '#840410', '#D78E10', '#FFFFFF', 0, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(237, 448, 1358.46, 265.442, 19.5547, 0, 0, 149.94, 0, 0, 1362.56, 263.882, 19.1666, 359.473, 359.989, 70.3125, 0, 0, 'VGL7 MN5', 1000, '#840410', '#D78E10', '#FFFFFF', 0, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(238, 426, 1356.16, 260.412, 19.5547, 0, 0, 134.861, 0, 0, 991.225, 606.766, 18.9654, 0.379028, 359.984, 309.836, 0, 0, 'U7R4 Q23', 815, '#656A79', '#656A79', '#FFFFFF', 32, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(239, 522, 1350.24, 258.38, 19.4062, 0, 0, 163.024, 0, 0, 2566.57, -1619.58, 18.5309, 81.1121, 359.813, 271.219, 0, 0, 'IMQL JYX', 830, '#252527', '#64686A', '#FFFFFF', 32, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(241, 579, 1349.27, 252.072, 19.4062, 0, 0, 325.311, 0, 0, 785.78, -147.255, 2.70458, 18.1824, 71.7242, 102.343, 0, 0, 'N1L1 WAH', 909, '#656A79', '#656A79', '#FFFFFF', 32, 1, 1, 0, 0, 100, 3, '1010', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(242, 426, 1380.57, 356.081, 19.5248, 0, 0, 351.833, 0, 0, 2297.49, -74.7188, 26.1423, 0.357056, 359.995, 195.617, 0, 0, 'BE58 96Q', 972, '#661C26', '#661C26', '#FFFFFF', 33, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(243, 522, 1374, 356.737, 19.5285, 0, 0, 126.297, 0, 0, 1378.21, 346.018, 18.7574, 357.374, 359.78, 186.877, 0, 0, '5VPB QBD', 1000, '#4C75B7', '#0E316D', '#FFFFFF', 33, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(244, 579, 1373.38, 352.302, 19.5286, 0, 0, 218.743, 0, 0, 2298.36, -80.4932, 26.4556, 1.56006, 2.66968, 197.759, 0, 0, 'G2M2 F6E', 1000, '#661C26', '#661C26', '#FFFFFF', 33, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(245, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 634.076, -578.08, 15.9643, 1.64795, 0, 180.917, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 34, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(246, 521, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 1083.21, -1148.39, 23.2205, 2.80151, 0.10437, 55.5414, 0, 0, 'U4M7 BOZ', 1000, '#FFFFFF', '#000000', '#FFFFFF', 30, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(247, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2286.61, -69.3086, 26.1264, 1.2854, 359.934, 3.47168, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 36, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(248, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1209.03, -144.417, 39.586, 3.34534, 2.18628, 67.533, 0, 0, '', 1000, '#840410', '#840410', '#FFFFFF', 37, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1);
INSERT INTO `vehicles` (`vehicleID`, `model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `respawnPosX`, `respawnPosY`, `respawnPosZ`, `respawnRotX`, `respawnRotY`, `respawnRotZ`, `respawnInterior`, `respawnDimension`, `numberplate`, `health`, `color1`, `color2`, `color3`, `characterID`, `locked`, `engineState`, `lightsState`, `tintedWindows`, `fuel`, `pinturas`, `tunning`, `neon`, `seguro`, `km`, `fasemotor`, `fasefrenos`, `localizador`, `alarma`, `marchas`, `cepo`, `diasLimpio`, `opcion`, `dias`, `inactivo`) VALUES
(258, 438, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'NYCP WDC', 1000, '#FFFFFF', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(259, 518, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, 'Z2UU 88O', 1000, '#000000', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(260, 565, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, -1977.85, 244.741, 34.8308, 0, 0, 359.808, 0, 0, '8QLH SQF', 1000, '#000000', '#000000', '#FFFFFF', 2, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(261, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1324.09, -352.912, 2.58845, 1.26892, 1.26892, 300.553, 0, 0, '', 993, '#9D9872', '#9D9872', '#FFFFFF', 39, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(262, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1239.35, -298.115, 11.6358, 15.1886, 358.781, 19.4623, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 43, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(263, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2351.19, -48.1504, 26.0511, 4.64172, 359.171, 250.988, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 44, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(264, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 725.295, -462.945, 15.9767, 0.499878, 359.89, 176.803, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 45, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(265, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 613.422, -518.848, 15.9928, 1.27991, 359.94, 278.855, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 46, 1, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(266, 411, 2301.65, -29.5012, 26.3359, 0, 0, 422.212, 0, 0, 2269.26, -91.9453, 26.1586, 1.82373, 358, 21.33, 0, 0, 'EDAK POS', 1000, '#20202C', '#F5F5F5', '#FFFFFF', 41, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(267, 412, 2290.34, 75.2778, 26.3359, 0, 0, 176.763, 0, 0, 2297.19, -33.8721, 26.1769, 0.181274, 0.0164795, 195.485, 0, 0, 'BU5K KSW', 1000, '#421F21', '#F5F5F5', '#FFFFFF', 41, 0, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(268, 413, 2292.42, -53.8485, 26.3359, 0, 0, 269.418, 0, 0, 2294.23, -53.8682, 26.4012, 359.967, 0.0604248, 269.594, 0, 0, 'RIVG ZO1', 1000, '#525661', '#F5F5F5', '#FFFFFF', 41, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(269, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 124.737, -151.168, 1.21719, 1.31287, 359.94, 78.7006, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 47, 1, 1, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(270, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 652.887, -581.892, 15.966, 1.27991, 359.945, 89.5276, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 48, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(271, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2284.28, -73.7725, 26.1381, 1.29639, 359.945, 13.3813, 0, 0, '', 1000, '#162248', '#162248', '#FFFFFF', 49, 0, 0, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(272, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2285.66, -73.6475, 26.1236, 1.27991, 359.94, 7.36633, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 50, 1, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(273, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2301.81, 101.487, 25.8329, 352.853, 274.384, 281.981, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 51, 1, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0),
(274, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 2000.08, 38.9746, 30.8476, 3.80127, 0.829468, 91.1096, 0, 0, '', 1000, '#9D9872', '#9D9872', '#FFFFFF', 1, 0, 0, 0, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 1),
(275, 468, 2286.61, -69.2949, 26.4844, 359.852, 359.995, 3.46619, 0, 0, 1332.65, -1466.99, 13.1257, 356.358, 10.7281, 218.123, 0, 0, '', 1000, '#D78E10', '#D78E10', '#FFFFFF', 2, 0, 1, 1, 0, 100, 3, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 20, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles_averias`
--

CREATE TABLE `vehicles_averias` (
  `registroID` int NOT NULL,
  `vehicleID` int DEFAULT NULL,
  `operacionID` int DEFAULT NULL,
  `mecanicoID` int DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `wcf1_group`
--

CREATE TABLE `wcf1_group` (
  `groupID` int UNSIGNED NOT NULL,
  `groupIDForo` int DEFAULT NULL,
  `groupName` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `canBeFactioned` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `priority` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `wcf1_group`
--

INSERT INTO `wcf1_group` (`groupID`, `groupIDForo`, `groupName`, `canBeFactioned`, `priority`) VALUES
(1, 1, 'Developers', 0, 1),
(2, 1, 'MTA Administrators', 0, 2),
(3, 2, 'GameOperator', 0, 3),
(4, 9, 'POLICIA NACIONAL DE COLOMBIA', 1, 5),
(5, 10, 'SURA', 1, 5),
(6, 11, 'MECANICOS', 1, 5),
(7, 12, 'EJERCITO NACIONAL DE COLOMBIA', 1, 5),
(8, 13, 'Red County Govern', 1, 5),
(9, 14, 'Montgomery Court and Justice Dept', 1, 5),
(10, 15, 'Turbo Trans Logistics', 1, 5),
(11, 16, 'Montgomery Public Transport', 1, 5),
(12, 17, 'Helper', 0, 4),
(13, 18, 'Moderador', 0, 4);

-- --------------------------------------------------------

--
-- Table structure for table `wcf1_user`
--

CREATE TABLE `wcf1_user` (
  `userID` int UNSIGNED NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `salt` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `secret` mediumtext COLLATE utf8mb4_general_ci,
  `banned` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `activationCode` int UNSIGNED NOT NULL DEFAULT '0',
  `activationReason` mediumtext COLLATE utf8mb4_general_ci,
  `banReason` longtext COLLATE utf8mb4_general_ci,
  `banUser` int UNSIGNED DEFAULT NULL,
  `lastIP` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lastSerial` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `regSerial2` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `regIP` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `regSerial` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `userOptions` mediumtext COLLATE utf8mb4_general_ci,
  `bs` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `CUS` varchar(6) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `migrado` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `shaderOptions` mediumtext COLLATE utf8mb4_general_ci,
  `vipDays` int UNSIGNED NOT NULL DEFAULT '0',
  `vipSkin` int NOT NULL DEFAULT '-1',
  `vipSkinAdic` int NOT NULL DEFAULT '-1',
  `tjail` int NOT NULL DEFAULT '0',
  `nuevo` int NOT NULL DEFAULT '1',
  `dudas` int NOT NULL DEFAULT '0',
  `valoracion` mediumtext COLLATE utf8mb4_general_ci,
  `tiradas` int NOT NULL DEFAULT '0',
  `kit` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'no_reclamado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wcf1_user`
--

INSERT INTO `wcf1_user` (`userID`, `username`, `password`, `salt`, `secret`, `banned`, `activationCode`, `activationReason`, `banReason`, `banUser`, `lastIP`, `lastSerial`, `regSerial2`, `regIP`, `regSerial`, `userOptions`, `bs`, `CUS`, `migrado`, `shaderOptions`, `vipDays`, `vipSkin`, `vipSkinAdic`, `tjail`, `nuevo`, `dudas`, `valoracion`, `tiradas`, `kit`) VALUES
(49, 'jeicordero', '9092483e207e32525fc7ebfd354dcff5fe006e09', '4ff977f054ec21dc004bb65fe54054609bf795e5', NULL, 0, 0, NULL, NULL, NULL, '190.143.33.119', '779075409BE1916B4D0E2010B8CB3DE4', NULL, '190.143.33.119', '779075409BE1916B4D0E2010B8CB3DE4', NULL, 0, NULL, 0, NULL, 0, -1, -1, 0, 0, 0, NULL, 0, 'reclamado'),
(50, 'Dilan', 'af692d02e9db22e169f91cf6c641a8c8eef97b6b', '82b46603f76c47d97e9b9646daefe0cc9e76aef0', NULL, 0, 0, NULL, NULL, NULL, '177.234.223.150', '8FF2AEBE82711D71583B2DC04EF31CAF', NULL, '177.234.223.150', '8FF2AEBE82711D71583B2DC04EF31CAF', '[ { \"staffduty\": false } ]', 0, NULL, 0, NULL, 0, -1, -1, 0, 0, 0, NULL, 0, 'reclamado'),
(51, 'jeicordero2', 'b17b06af84e71b8c186f33f44e1c4216c61e1e5d', '8482e7f98a477c4f779d9894530a38022eb7c06a', NULL, 0, 0, NULL, NULL, NULL, '181.58.39.228', 'B5E15FBB95FA986DD7301633072A9F31', NULL, '181.58.39.228', 'B5E15FBB95FA986DD7301633072A9F31', NULL, 0, NULL, 0, NULL, 0, -1, -1, 0, 0, 0, NULL, 0, 'no_reclamado');

-- --------------------------------------------------------

--
-- Table structure for table `wcf1_user_to_groups`
--

CREATE TABLE `wcf1_user_to_groups` (
  `userID` int UNSIGNED NOT NULL DEFAULT '0',
  `groupID` int UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `wcf1_user_to_groups`
--

INSERT INTO `wcf1_user_to_groups` (`userID`, `groupID`) VALUES
(49, 1),
(50, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `3dtext`
--
ALTER TABLE `3dtext`
  ADD PRIMARY KEY (`textID`);

--
-- Indexes for table `ajustes`
--
ALTER TABLE `ajustes`
  ADD PRIMARY KEY (`ajusteID`);

--
-- Indexes for table `armas_suelo`
--
ALTER TABLE `armas_suelo`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `banks`
--
ALTER TABLE `banks`
  ADD PRIMARY KEY (`bankID`);

--
-- Indexes for table `cabinas`
--
ALTER TABLE `cabinas`
  ADD PRIMARY KEY (`cabinaID`);

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`characterID`);

--
-- Indexes for table `character_to_factions`
--
ALTER TABLE `character_to_factions`
  ADD PRIMARY KEY (`characterID`,`factionID`);

--
-- Indexes for table `concesionario`
--
ALTER TABLE `concesionario`
  ADD PRIMARY KEY (`registroID`);

--
-- Indexes for table `condiciones`
--
ALTER TABLE `condiciones`
  ADD PRIMARY KEY (`cID`);

--
-- Indexes for table `construcciones`
--
ALTER TABLE `construcciones`
  ADD PRIMARY KEY (`construccionID`);

--
-- Indexes for table `deposito`
--
ALTER TABLE `deposito`
  ADD PRIMARY KEY (`depositoID`);

--
-- Indexes for table `dinero_sesiones`
--
ALTER TABLE `dinero_sesiones`
  ADD PRIMARY KEY (`sesionID`);

--
-- Indexes for table `dropitems`
--
ALTER TABLE `dropitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dudas`
--
ALTER TABLE `dudas`
  ADD PRIMARY KEY (`dudaID`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`factionID`);

--
-- Indexes for table `faction_ranks`
--
ALTER TABLE `faction_ranks`
  ADD PRIMARY KEY (`factionID`,`factionRankID`);

--
-- Indexes for table `fuelpoints`
--
ALTER TABLE `fuelpoints`
  ADD PRIMARY KEY (`fuelpointID`);

--
-- Indexes for table `historiales`
--
ALTER TABLE `historiales`
  ADD PRIMARY KEY (`historialID`);

--
-- Indexes for table `interiors`
--
ALTER TABLE `interiors`
  ADD PRIMARY KEY (`interiorID`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`index`);

--
-- Indexes for table `items_mochilas`
--
ALTER TABLE `items_mochilas`
  ADD PRIMARY KEY (`index`);

--
-- Indexes for table `items_muebles`
--
ALTER TABLE `items_muebles`
  ADD PRIMARY KEY (`index`);

--
-- Indexes for table `licencias_armas`
--
ALTER TABLE `licencias_armas`
  ADD PRIMARY KEY (`licenciaID`);

--
-- Indexes for table `maleteros`
--
ALTER TABLE `maleteros`
  ADD PRIMARY KEY (`index`);

--
-- Indexes for table `mascotas`
--
ALTER TABLE `mascotas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `mochilas_suelo`
--
ALTER TABLE `mochilas_suelo`
  ADD PRIMARY KEY (`mochilaID`);

--
-- Indexes for table `muebles`
--
ALTER TABLE `muebles`
  ADD PRIMARY KEY (`muebleID`);

--
-- Indexes for table `multas`
--
ALTER TABLE `multas`
  ADD PRIMARY KEY (`ind`);

--
-- Indexes for table `objetivos`
--
ALTER TABLE `objetivos`
  ADD PRIMARY KEY (`objetivoID`);

--
-- Indexes for table `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`ordenID`);

--
-- Indexes for table `pagos_prestamos`
--
ALTER TABLE `pagos_prestamos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prestamo_id` (`prestamo_id`);

--
-- Indexes for table `periodicos`
--
ALTER TABLE `periodicos`
  ADD PRIMARY KEY (`periodicoID`);

--
-- Indexes for table `prestamos`
--
ALTER TABLE `prestamos`
  ADD UNIQUE KEY `prestamoID` (`prestamoID`);

--
-- Indexes for table `prestamosBanco`
--
ALTER TABLE `prestamosBanco`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `robos`
--
ALTER TABLE `robos`
  ADD PRIMARY KEY (`roboID`),
  ADD UNIQUE KEY `roboID` (`roboID`);

--
-- Indexes for table `sanciones`
--
ALTER TABLE `sanciones`
  ADD PRIMARY KEY (`sancionID`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`shopID`);

--
-- Indexes for table `staff_names`
--
ALTER TABLE `staff_names`
  ADD PRIMARY KEY (`userID`);

--
-- Indexes for table `teleports`
--
ALTER TABLE `teleports`
  ADD PRIMARY KEY (`teleportID`);

--
-- Indexes for table `tlf_contactos`
--
ALTER TABLE `tlf_contactos`
  ADD PRIMARY KEY (`contacto_ID`);

--
-- Indexes for table `tlf_data`
--
ALTER TABLE `tlf_data`
  ADD PRIMARY KEY (`registro_ID`),
  ADD UNIQUE KEY `numero` (`numero`,`imei`);

--
-- Indexes for table `tlf_llamadas`
--
ALTER TABLE `tlf_llamadas`
  ADD PRIMARY KEY (`llamada_ID`);

--
-- Indexes for table `tlf_sms`
--
ALTER TABLE `tlf_sms`
  ADD PRIMARY KEY (`sms_ID`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicleID`);

--
-- Indexes for table `vehicles_averias`
--
ALTER TABLE `vehicles_averias`
  ADD PRIMARY KEY (`registroID`);

--
-- Indexes for table `wcf1_group`
--
ALTER TABLE `wcf1_group`
  ADD PRIMARY KEY (`groupID`);

--
-- Indexes for table `wcf1_user`
--
ALTER TABLE `wcf1_user`
  ADD PRIMARY KEY (`userID`);

--
-- Indexes for table `wcf1_user_to_groups`
--
ALTER TABLE `wcf1_user_to_groups`
  ADD PRIMARY KEY (`userID`,`groupID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `3dtext`
--
ALTER TABLE `3dtext`
  MODIFY `textID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ajustes`
--
ALTER TABLE `ajustes`
  MODIFY `ajusteID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `armas_suelo`
--
ALTER TABLE `armas_suelo`
  MODIFY `ID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `banks`
--
ALTER TABLE `banks`
  MODIFY `bankID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cabinas`
--
ALTER TABLE `cabinas`
  MODIFY `cabinaID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `characterID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `concesionario`
--
ALTER TABLE `concesionario`
  MODIFY `registroID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `condiciones`
--
ALTER TABLE `condiciones`
  MODIFY `cID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `construcciones`
--
ALTER TABLE `construcciones`
  MODIFY `construccionID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deposito`
--
ALTER TABLE `deposito`
  MODIFY `depositoID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dinero_sesiones`
--
ALTER TABLE `dinero_sesiones`
  MODIFY `sesionID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dropitems`
--
ALTER TABLE `dropitems`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dudas`
--
ALTER TABLE `dudas`
  MODIFY `dudaID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fuelpoints`
--
ALTER TABLE `fuelpoints`
  MODIFY `fuelpointID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `historiales`
--
ALTER TABLE `historiales`
  MODIFY `historialID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interiors`
--
ALTER TABLE `interiors`
  MODIFY `interiorID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `index` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `items_mochilas`
--
ALTER TABLE `items_mochilas`
  MODIFY `index` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `items_muebles`
--
ALTER TABLE `items_muebles`
  MODIFY `index` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `licencias_armas`
--
ALTER TABLE `licencias_armas`
  MODIFY `licenciaID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maleteros`
--
ALTER TABLE `maleteros`
  MODIFY `index` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mascotas`
--
ALTER TABLE `mascotas`
  MODIFY `ID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `muebles`
--
ALTER TABLE `muebles`
  MODIFY `muebleID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `multas`
--
ALTER TABLE `multas`
  MODIFY `ind` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `objetivos`
--
ALTER TABLE `objetivos`
  MODIFY `objetivoID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `ordenID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pagos_prestamos`
--
ALTER TABLE `pagos_prestamos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `periodicos`
--
ALTER TABLE `periodicos`
  MODIFY `periodicoID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prestamos`
--
ALTER TABLE `prestamos`
  MODIFY `prestamoID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prestamosBanco`
--
ALTER TABLE `prestamosBanco`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `robos`
--
ALTER TABLE `robos`
  MODIFY `roboID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sanciones`
--
ALTER TABLE `sanciones`
  MODIFY `sancionID` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `shopID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `teleports`
--
ALTER TABLE `teleports`
  MODIFY `teleportID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tlf_contactos`
--
ALTER TABLE `tlf_contactos`
  MODIFY `contacto_ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tlf_data`
--
ALTER TABLE `tlf_data`
  MODIFY `registro_ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tlf_llamadas`
--
ALTER TABLE `tlf_llamadas`
  MODIFY `llamada_ID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tlf_sms`
--
ALTER TABLE `tlf_sms`
  MODIFY `sms_ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicleID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=276;

--
-- AUTO_INCREMENT for table `vehicles_averias`
--
ALTER TABLE `vehicles_averias`
  MODIFY `registroID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wcf1_group`
--
ALTER TABLE `wcf1_group`
  MODIFY `groupID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `wcf1_user`
--
ALTER TABLE `wcf1_user`
  MODIFY `userID` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pagos_prestamos`
--
ALTER TABLE `pagos_prestamos`
  ADD CONSTRAINT `pagos_prestamos_ibfk_1` FOREIGN KEY (`prestamo_id`) REFERENCES `prestamosBanco` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
