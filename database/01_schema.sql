/*
==========================================================
ECO PLATFORM
Eficiencia en Ciclos Operativos
Archivo: 01_schema.sql
Descripción: Configuración inicial de la base de datos
Motor: PostgreSQL 16 / Supabase
==========================================================
*/

-- ======================================================
-- EXTENSIONES
-- ======================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ======================================================
-- ESQUEMA
-- ======================================================

CREATE SCHEMA IF NOT EXISTS eco;

-- ======================================================
-- CONFIGURACIÓN
-- ======================================================

SET search_path TO eco, public;

-- ======================================================
-- COMENTARIO DEL ESQUEMA
-- ======================================================

COMMENT ON SCHEMA eco IS
'Base de datos principal de la plataforma ECO.';