/*
==========================================================
ECO PLATFORM
Archivo: 04_indexes.sql
Versión: 2.0
Descripción:
Creación de índices para optimizar el rendimiento.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- ÍNDICES PARA LLAVES FORÁNEAS
-- ======================================================

-- USUARIOS

CREATE INDEX idx_usuarios_rol
ON usuarios (rol_id);

-- VEHÍCULOS

CREATE INDEX idx_vehiculos_transportadora
ON vehiculos (transportadora_id);

-- CONTENEDORES

CREATE INDEX idx_contenedores_tipo
ON contenedores (tipo_contenedor_id);

CREATE INDEX idx_contenedores_estado
ON contenedores (estado_actual_id);

-- PROGRAMACIONES

CREATE INDEX idx_programaciones_contenedor
ON programaciones (contenedor_id);

CREATE INDEX idx_programaciones_estado
ON programaciones (estado_id);

CREATE INDEX idx_programaciones_origen
ON programaciones (ubicacion_origen_id);

CREATE INDEX idx_programaciones_destino
ON programaciones (ubicacion_destino_id);

-- ======================================================
-- ÍNDICES PARA ASIGNACIONES
-- ======================================================

CREATE INDEX idx_asignaciones_programacion
ON asignaciones (programacion_id);

CREATE INDEX idx_asignaciones_vehiculo
ON asignaciones (vehiculo_id);

CREATE INDEX idx_asignaciones_usuario
ON asignaciones (usuario_id);

CREATE INDEX idx_asignaciones_estado
ON asignaciones (estado_id);

-- ======================================================
-- ÍNDICES PARA MOVIMIENTOS
-- ======================================================

CREATE INDEX idx_movimientos_programacion
ON movimientos (programacion_id);

CREATE INDEX idx_movimientos_estado
ON movimientos (estado_id);

CREATE INDEX idx_movimientos_inicio_real
ON movimientos (inicio_real);

CREATE INDEX idx_movimientos_fin_real
ON movimientos (fin_real);

-- ======================================================
-- ÍNDICES PARA EVENTOS
-- ======================================================

CREATE INDEX idx_eventos_movimiento
ON eventos (movimiento_id);

CREATE INDEX idx_eventos_tipo
ON eventos (tipo_evento_id);

CREATE INDEX idx_eventos_usuario
ON eventos (usuario_id);

CREATE INDEX idx_eventos_causal
ON eventos (causal_id);

CREATE INDEX idx_eventos_fecha
ON eventos (fecha_hora);

-- ======================================================
-- ÍNDICES PARA AUDITORÍA
-- ======================================================

CREATE INDEX idx_audit_usuario
ON audit_log (usuario_id);

CREATE INDEX idx_audit_fecha
ON audit_log (fecha);

CREATE INDEX idx_audit_tabla
ON audit_log (tabla);

-- ======================================================
-- ÍNDICES PARA CONSULTAS OPERATIVAS
-- ======================================================

CREATE INDEX idx_programaciones_fecha
ON programaciones (fecha_programada);

CREATE INDEX idx_programaciones_contenedor_fecha
ON programaciones (contenedor_id, fecha_programada);

CREATE INDEX idx_programaciones_estado_fecha
ON programaciones (estado_id, fecha_programada);

CREATE INDEX idx_eventos_movimiento_fecha
ON eventos (movimiento_id, fecha_hora);

CREATE INDEX idx_movimientos_programacion_estado
ON movimientos (programacion_id, estado_id);

-- ======================================================
-- FIN DEL ARCHIVO
-- ======================================================