/*
==========================================================
ECO PLATFORM
Archivo: 10_migration_v1_2.sql
Versión: 1.2
Descripción:
Ajustes al modelo de datos derivados de la auditoría técnica.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- 1. CAMBIAR FECHA_PROGRAMADA A TIMESTAMP
-- ======================================================

ALTER TABLE programaciones
ALTER COLUMN fecha_programada
TYPE TIMESTAMP
USING fecha_programada::timestamp;

-- ======================================================
-- 2. AGREGAR ESTADO A PROGRAMACIONES
-- ======================================================

ALTER TABLE programaciones
ADD COLUMN estado_id UUID;

ALTER TABLE programaciones
ADD CONSTRAINT fk_programaciones_estado
FOREIGN KEY (estado_id)
REFERENCES estados(id);

CREATE INDEX idx_programaciones_estado
ON programaciones (estado_id);

-- ======================================================
-- 3. AGREGAR DURACIÓN A MOVIMIENTOS
-- ======================================================

ALTER TABLE movimientos
ADD COLUMN duracion INTERVAL;