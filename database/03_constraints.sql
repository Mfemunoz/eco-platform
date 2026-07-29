/*
==========================================================
ECO PLATFORM
Archivo: 03_constraints.sql
Versión: 1.0
Descripción:
Llaves primarias, foráneas, restricciones UNIQUE y CHECK.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- FOREIGN KEYS
-- ======================================================

-- ------------------------------------------------------
-- USUARIOS
-- ------------------------------------------------------

ALTER TABLE usuarios
ADD CONSTRAINT fk_usuarios_roles
FOREIGN KEY (rol_id)
REFERENCES roles(id);

-- ------------------------------------------------------
-- VEHICULOS
-- ------------------------------------------------------

ALTER TABLE vehiculos
ADD CONSTRAINT fk_vehiculos_transportadoras
FOREIGN KEY (transportadora_id)
REFERENCES transportadoras(id);

-- ------------------------------------------------------
-- CONTENEDORES
-- ------------------------------------------------------

ALTER TABLE contenedores
ADD CONSTRAINT fk_contenedores_tipo
FOREIGN KEY (tipo_contenedor_id)
REFERENCES tipos_contenedor(id);

ALTER TABLE contenedores
ADD CONSTRAINT fk_contenedores_estado
FOREIGN KEY (estado_actual_id)
REFERENCES estados(id);

-- ------------------------------------------------------
-- PROGRAMACIONES
-- ------------------------------------------------------

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_contenedor
FOREIGN KEY (contenedor_id)
REFERENCES contenedores(id);

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_origen
FOREIGN KEY (ubicacion_origen_id)
REFERENCES ubicaciones(id);

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_destino
FOREIGN KEY (ubicacion_destino_id)
REFERENCES ubicaciones(id);

-- ======================================================
-- ASIGNACIONES
-- ======================================================

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_programacion
FOREIGN KEY (programacion_id)
REFERENCES programaciones(id);

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_vehiculo
FOREIGN KEY (vehiculo_id)
REFERENCES vehiculos(id);

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id);

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_estado
FOREIGN KEY (estado_id)
REFERENCES estados(id);

-- ======================================================
-- MOVIMIENTOS
-- ======================================================

ALTER TABLE movimientos
ADD CONSTRAINT fk_movimientos_programacion
FOREIGN KEY (programacion_id)
REFERENCES programaciones(id);

ALTER TABLE movimientos
ADD CONSTRAINT fk_movimientos_estado
FOREIGN KEY (estado_id)
REFERENCES estados(id);

-- ======================================================
-- EVENTOS
-- ======================================================

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_movimiento
FOREIGN KEY (movimiento_id)
REFERENCES movimientos(id);

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_tipo
FOREIGN KEY (tipo_evento_id)
REFERENCES tipos_evento(id);

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id);

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_causal
FOREIGN KEY (causal_id)
REFERENCES causales(id);

-- ======================================================
-- AUDIT LOG
-- ======================================================

ALTER TABLE audit_log
ADD CONSTRAINT fk_audit_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id);

-- ======================================================
-- RESTRICCIONES UNIQUE
-- ======================================================

ALTER TABLE roles
ADD CONSTRAINT uq_roles_nombre
UNIQUE (nombre);

ALTER TABLE usuarios
ADD CONSTRAINT uq_usuarios_correo
UNIQUE (correo);

ALTER TABLE transportadoras
ADD CONSTRAINT uq_transportadoras_nit
UNIQUE (nit);

ALTER TABLE vehiculos
ADD CONSTRAINT uq_vehiculos_placa
UNIQUE (placa);

ALTER TABLE estados
ADD CONSTRAINT uq_estados_codigo
UNIQUE (codigo);

ALTER TABLE tipos_evento
ADD CONSTRAINT uq_tipos_evento_codigo
UNIQUE (codigo);

ALTER TABLE tipos_contenedor
ADD CONSTRAINT uq_tipos_contenedor_codigo
UNIQUE (codigo);

ALTER TABLE causales
ADD CONSTRAINT uq_causales_codigo
UNIQUE (codigo);

ALTER TABLE contenedores
ADD CONSTRAINT uq_contenedores_serial
UNIQUE (serial);

-- ======================================================
-- RESTRICCIONES CHECK
-- ======================================================

ALTER TABLE ubicaciones
ADD CONSTRAINT chk_ubicaciones_tipo
CHECK (
    tipo IN ('PATIO','MUELLE','PUERTO','CD')
);

ALTER TABLE eventos
ADD CONSTRAINT chk_eventos_latitud
CHECK (
    latitud IS NULL OR
    (latitud >= -90 AND latitud <= 90)
);

ALTER TABLE eventos
ADD CONSTRAINT chk_eventos_longitud
CHECK (
    longitud IS NULL OR
    (longitud >= -180 AND longitud <= 180)
);

ALTER TABLE movimientos
ADD CONSTRAINT chk_movimientos_fechas
CHECK (
    fin_real IS NULL
    OR inicio_real IS NULL
    OR fin_real >= inicio_real
);

-- ======================================================
-- FIN DEL ARCHIVO
-- ======================================================