-- ============================================
-- ESTRUCTURA DE BASE DE DATOS
-- SISTEMA DE TRABAJO COMUNITARIO
-- ============================================
-- Copyright (c) 2025 Community Service System
-- Versión: 1.0-OPTIMIZED
-- ============================================

-- Crear tabla de trabajo comunitario
CREATE TABLE IF NOT EXISTS `community_service` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `account` VARCHAR(50) NOT NULL COMMENT 'Nombre de cuenta del jugador',
    `serial` VARCHAR(100) NOT NULL COMMENT 'Serial del jugador',
    `userID` INT(11) NOT NULL COMMENT 'ID del usuario en la base de datos',
    `basuras_pendientes` INT(11) NOT NULL DEFAULT 0 COMMENT 'Cantidad de basuras pendientes de recoger',
    `basuras_totales` INT(11) NOT NULL DEFAULT 0 COMMENT 'Total de basuras asignadas originalmente',
    `razon` TEXT NOT NULL COMMENT 'Razón de la sanción comunitaria',
    `activo` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = Activo, 0 = Completado',
    `staff_id` INT(11) DEFAULT -1 COMMENT 'ID del staff que asignó la sanción',
    `staff_nombre` VARCHAR(100) DEFAULT 'Sistema' COMMENT 'Nombre del staff que asignó',
    `fecha_asignacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de asignación',
    `fecha_completado` DATETIME DEFAULT NULL COMMENT 'Fecha y hora de finalización',
    `posicion_x` FLOAT DEFAULT NULL COMMENT 'Posición X donde completó el trabajo',
    `posicion_y` FLOAT DEFAULT NULL COMMENT 'Posición Y donde completó el trabajo',
    `posicion_z` FLOAT DEFAULT NULL COMMENT 'Posición Z donde completó el trabajo',
    PRIMARY KEY (`id`),
    INDEX `idx_userID` (`userID`),
    INDEX `idx_activo` (`activo`),
    INDEX `idx_fecha_asignacion` (`fecha_asignacion`),
    INDEX `idx_userID_activo` (`userID`, `activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla de trabajos comunitarios activos y completados';

-- ============================================
-- NOTAS IMPORTANTES:
-- ============================================
-- 1. La tabla usa índices para optimizar las consultas frecuentes
-- 2. El campo 'activo' permite tener historial de sanciones completadas
-- 3. Las posiciones se guardan cuando se completa el trabajo
-- 4. El campo 'razon' puede concatenarse con CONCAT() para múltiples sanciones
-- 5. El sistema permite múltiples sanciones acumuladas por jugador
-- ============================================

