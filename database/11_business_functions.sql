/*
==========================================================
ECO PLATFORM
Archivo: 11_business_functions.sql
Versión: 1.0

Descripción:
Funciones de negocio para operación ECO.

Funciones:
- Registrar programación
- Asignar vehículo
- Registrar evento
- Cerrar movimiento
- Reprogramar operación

==========================================================
*/


SET search_path TO eco, public;



-- ======================================================
-- 1. REGISTRAR PROGRAMACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_programacion
(
    p_contenedor_id UUID,
    p_fecha_programada TIMESTAMPTZ,
    p_origen_id UUID,
    p_destino_id UUID,
    p_usuario_id UUID,
    p_observacion TEXT DEFAULT NULL
)

RETURNS UUID

LANGUAGE plpgsql

AS $$

DECLARE

    v_estado UUID;
    v_programacion UUID;

BEGIN


    SELECT id
    INTO v_estado
    FROM estados
    WHERE codigo='PROGRAMADO';



    INSERT INTO programaciones
    (
        contenedor_id,
        estado_id,
        fecha_programada,
        ubicacion_origen_id,
        ubicacion_destino_id,
        observacion,
        created_by
    )

    VALUES

    (
        p_contenedor_id,
        v_estado,
        p_fecha_programada,
        p_origen_id,
        p_destino_id,
        p_observacion,
        p_usuario_id
    )

    RETURNING id INTO v_programacion;



    RETURN v_programacion;


END;

$$;



-- ======================================================
-- 2. ASIGNAR VEHÍCULO
-- ======================================================

CREATE OR REPLACE FUNCTION asignar_vehiculo
(
    p_programacion_id UUID,
    p_vehiculo_id UUID,
    p_usuario_id UUID,
    p_observacion TEXT DEFAULT NULL
)

RETURNS UUID

LANGUAGE plpgsql

AS $$

DECLARE

    v_estado UUID;
    v_asignacion UUID;

BEGIN


    SELECT id
    INTO v_estado
    FROM estados
    WHERE codigo='ASIGNADO';



    INSERT INTO asignaciones
    (
        programacion_id,
        vehiculo_id,
        usuario_id,
        estado_id,
        observacion,
        created_by
    )

    VALUES

    (
        p_programacion_id,
        p_vehiculo_id,
        p_usuario_id,
        v_estado,
        p_observacion,
        p_usuario_id
    )

    RETURNING id INTO v_asignacion;



    UPDATE programaciones

    SET

        estado_id = v_estado,
        updated_by = p_usuario_id,
        updated_at = CURRENT_TIMESTAMP

    WHERE id=p_programacion_id;



    RETURN v_asignacion;


END;

$$;



-- ======================================================
-- 3. REGISTRAR EVENTO
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_evento
(
    p_movimiento_id UUID,
    p_tipo_evento_id UUID,
    p_usuario_id UUID,
    p_causal_id UUID DEFAULT NULL,
    p_observacion TEXT DEFAULT NULL,
    p_evidencia_url TEXT DEFAULT NULL,
    p_latitud NUMERIC DEFAULT NULL,
    p_longitud NUMERIC DEFAULT NULL
)

RETURNS UUID

LANGUAGE plpgsql

AS $$

DECLARE

    v_evento UUID;


BEGIN


    INSERT INTO eventos
    (
        movimiento_id,
        tipo_evento_id,
        usuario_id,
        causal_id,
        observacion,
        evidencia_url,
        latitud,
        longitud,
        created_by
    )


    VALUES

    (
        p_movimiento_id,
        p_tipo_evento_id,
        p_usuario_id,
        p_causal_id,
        p_observacion,
        p_evidencia_url,
        p_latitud,
        p_longitud,
        p_usuario_id
    )


    RETURNING id INTO v_evento;



    RETURN v_evento;


END;

$$;



-- ======================================================
-- 4. CERRAR MOVIMIENTO
-- ======================================================

CREATE OR REPLACE FUNCTION cerrar_movimiento
(
    p_movimiento_id UUID,
    p_usuario_id UUID
)

RETURNS BOOLEAN

LANGUAGE plpgsql

AS $$

DECLARE

    v_estado UUID;

BEGIN


    SELECT id
    INTO v_estado
    FROM estados
    WHERE codigo='FINALIZADO';



    UPDATE movimientos

    SET

        fin_real = CURRENT_TIMESTAMP,

        duracion =
        CURRENT_TIMESTAMP - inicio_real,

        estado_id = v_estado,

        updated_by = p_usuario_id,

        updated_at=CURRENT_TIMESTAMP


    WHERE id=p_movimiento_id;



    UPDATE programaciones p

    SET

        estado_id=v_estado,

        updated_by=p_usuario_id,

        updated_at=CURRENT_TIMESTAMP


    FROM movimientos m

    WHERE m.id=p_movimiento_id

    AND p.id=m.programacion_id;



    RETURN TRUE;


END;

$$;



-- ======================================================
-- 5. REPROGRAMAR OPERACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION reprogramar_operacion
(
    p_programacion_id UUID,
    p_nueva_fecha TIMESTAMPTZ,
    p_usuario_id UUID,
    p_observacion TEXT DEFAULT NULL
)

RETURNS BOOLEAN

LANGUAGE plpgsql

AS $$

DECLARE

    v_estado UUID;


BEGIN


    SELECT id
    INTO v_estado
    FROM estados
    WHERE codigo='REPROGRAMADO';



    UPDATE programaciones

    SET

        fecha_programada=p_nueva_fecha,

        estado_id=v_estado,

        observacion=p_observacion,

        updated_by=p_usuario_id,

        updated_at=CURRENT_TIMESTAMP


    WHERE id=p_programacion_id;



    RETURN TRUE;


END;

$$;



-- ======================================================
-- FIN FUNCIONES NEGOCIO
-- ======================================================