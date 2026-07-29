/*
==========================================================
ECO PLATFORM
Archivo: 03_constraints.sql
Versión: 2.0
Descripción:
Llaves foráneas y restricciones CHECK.
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
REFERENCES roles(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- ------------------------------------------------------
-- VEHICULOS
-- ------------------------------------------------------

ALTER TABLE vehiculos
ADD CONSTRAINT fk_vehiculos_transportadoras
FOREIGN KEY (transportadora_id)
REFERENCES transportadoras(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- ------------------------------------------------------
-- CONTENEDORES
-- ------------------------------------------------------

ALTER TABLE contenedores
ADD CONSTRAINT fk_contenedores_tipo
FOREIGN KEY (tipo_contenedor_id)
REFERENCES tipos_contenedor(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE contenedores
ADD CONSTRAINT fk_contenedores_estado
FOREIGN KEY (estado_actual_id)
REFERENCES estados(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- ------------------------------------------------------
-- PROGRAMACIONES
-- ------------------------------------------------------

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_contenedor
FOREIGN KEY (contenedor_id)
REFERENCES contenedores(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_estado
FOREIGN KEY (estado_id)
REFERENCES estados(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_origen
FOREIGN KEY (ubicacion_origen_id)
REFERENCES ubicaciones(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE programaciones
ADD CONSTRAINT fk_programacion_destino
FOREIGN KEY (ubicacion_destino_id)
REFERENCES ubicaciones(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- ------------------------------------------------------
-- ASIGNACIONES
-- ------------------------------------------------------

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_programacion
FOREIGN KEY (programacion_id)
REFERENCES programaciones(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_vehiculo
FOREIGN KEY (vehiculo_id)
REFERENCES vehiculos(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_estado
FOREIGN KEY (estado_id)
REFERENCES estados(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- ------------------------------------------------------
-- MOVIMIENTOS
-- ------------------------------------------------------

ALTER TABLE movimientos
ADD CONSTRAINT fk_movimientos_programacion
FOREIGN KEY (programacion_id)
REFERENCES programaciones(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE movimientos
ADD CONSTRAINT fk_movimientos_estado
FOREIGN KEY (estado_id)
REFERENCES estados(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- ------------------------------------------------------
-- EVENTOS
-- ------------------------------------------------------

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_movimiento
FOREIGN KEY (movimiento_id)
REFERENCES movimientos(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_tipo
FOREIGN KEY (tipo_evento_id)
REFERENCES tipos_evento(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_causal
FOREIGN KEY (causal_id)
REFERENCES causales(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- ------------------------------------------------------
-- AUDIT LOG
-- ------------------------------------------------------

ALTER TABLE audit_log
ADD CONSTRAINT fk_audit_usuario
FOREIGN KEY (usuario_id)
REFERENCES usuarios(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- ======================================================
-- CREATED_BY / UPDATED_BY
-- ======================================================

DO $$
DECLARE
    t TEXT;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'roles',
        'usuarios',
        'transportadoras',
        'vehiculos',
        'ubicaciones',
        'estados',
        'tipos_evento',
        'tipos_contenedor',
        'causales',
        'contenedores',
        'programaciones',
        'asignaciones',
        'movimientos',
        'eventos'
    ]
    LOOP

        EXECUTE format('
            ALTER TABLE %I
            ADD CONSTRAINT fk_%I_created_by
            FOREIGN KEY (created_by)
            REFERENCES usuarios(id)
            ON UPDATE CASCADE
            ON DELETE SET NULL;',
            t, t);

        EXECUTE format('
            ALTER TABLE %I
            ADD CONSTRAINT fk_%I_updated_by
            FOREIGN KEY (updated_by)
            REFERENCES usuarios(id)
            ON UPDATE CASCADE
            ON DELETE SET NULL;',
            t, t);

    END LOOP;
END $$;

-- ======================================================
-- CHECK
-- ======================================================

ALTER TABLE ubicaciones
ADD CONSTRAINT chk_ubicaciones_tipo
CHECK (
    tipo IN ('PATIO','MUELLE','PUERTO','CD')
);

ALTER TABLE eventos
ADD CONSTRAINT chk_eventos_latitud
CHECK (
    latitud IS NULL
    OR (latitud BETWEEN -90 AND 90)
);

ALTER TABLE eventos
ADD CONSTRAINT chk_eventos_longitud
CHECK (
    longitud IS NULL
    OR (longitud BETWEEN -180 AND 180)
);

ALTER TABLE movimientos
ADD CONSTRAINT chk_movimientos_fechas
CHECK (
    fin_real IS NULL
    OR inicio_real IS NULL
    OR fin_real >= inicio_real
);

-- ======================================================
-- FIN
-- ======================================================