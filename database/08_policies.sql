/*
==========================================================
ECO PLATFORM
Archivo: 08_policies.sql
Versión: 2.0
Descripción:
Políticas de seguridad Row Level Security (RLS)
Supabase Authentication
==========================================================
*/

SET search_path TO eco, public;


-- ======================================================
-- HABILITAR RLS
-- ======================================================

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE transportadoras ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehiculos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contenedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE programaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE asignaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;
ALTER TABLE eventos ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;



-- ======================================================
-- LIMPIAR POLÍTICAS ANTERIORES
-- ======================================================

DROP POLICY IF EXISTS usuarios_all ON usuarios;
DROP POLICY IF EXISTS transportadoras_all ON transportadoras;
DROP POLICY IF EXISTS vehiculos_all ON vehiculos;
DROP POLICY IF EXISTS contenedores_all ON contenedores;
DROP POLICY IF EXISTS programaciones_all ON programaciones;
DROP POLICY IF EXISTS asignaciones_all ON asignaciones;
DROP POLICY IF EXISTS movimientos_all ON movimientos;
DROP POLICY IF EXISTS eventos_all ON eventos;
DROP POLICY IF EXISTS audit_log_all ON audit_log;



-- ======================================================
-- USUARIOS
-- ======================================================

CREATE POLICY usuarios_authenticated
ON usuarios
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);



-- ======================================================
-- MAESTROS
-- ======================================================

CREATE POLICY transportadoras_authenticated
ON transportadoras
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);


CREATE POLICY vehiculos_authenticated
ON vehiculos
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);


CREATE POLICY contenedores_authenticated
ON contenedores
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);



-- ======================================================
-- OPERACIÓN
-- ======================================================

CREATE POLICY programaciones_authenticated
ON programaciones
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);


CREATE POLICY asignaciones_authenticated
ON asignaciones
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);


CREATE POLICY movimientos_authenticated
ON movimientos
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);


CREATE POLICY eventos_authenticated
ON eventos
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);



-- ======================================================
-- AUDITORÍA
-- ======================================================

CREATE POLICY audit_log_authenticated
ON audit_log
FOR SELECT
TO authenticated
USING (true);



-- ======================================================
-- FIN
-- ======================================================