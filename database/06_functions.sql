/*
==========================================================
ECO PLATFORM
Archivo: 06_functions.sql
Descripción:
Funciones de negocio del sistema ECO.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- FUNCIÓN: REGISTRAR AUDITORÍA
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_auditoria(
    p_usuario_id UUID,
    p_tabla VARCHAR,
    p_accion VARCHAR,
    p_registro_id UUID,
    p_detalle TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN

    INSERT INTO audit_log
    (
        tabla,
        registro_id,
        accion,
        usuario_id,
        fecha,
        datos
    )
    VALUES
    (
        p_tabla,
        p_registro_id,
        UPPER(p_accion),
        p_usuario_id,
        NOW(),
        jsonb_build_object(
            'detalle', p_detalle
        )
    );

END;
$$;

-- ======================================================
-- FUNCIÓN: VALIDAR EXISTENCIA DE USUARIO
-- ======================================================

CREATE OR REPLACE FUNCTION existe_usuario(
    p_usuario_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE
    v_existe BOOLEAN;
BEGIN

    SELECT EXISTS
    (
        SELECT 1
        FROM usuarios
        WHERE id = p_usuario_id
    )
    INTO v_existe;

    RETURN v_existe;

END;
$$;

-- ======================================================
-- FUNCIÓN: VALIDAR EXISTENCIA DE PROGRAMACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION existe_programacion(
    p_programacion_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE
    v_existe BOOLEAN;
BEGIN

    SELECT EXISTS
    (
        SELECT 1
        FROM programaciones
        WHERE id = p_programacion_id
    )
    INTO v_existe;

    RETURN v_existe;

END;
$$;

-- ======================================================
-- FUNCIÓN: VALIDAR EXISTENCIA DE MOVIMIENTO
-- ======================================================

CREATE OR REPLACE FUNCTION existe_movimiento(
    p_movimiento_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE
    v_existe BOOLEAN;
BEGIN

    SELECT EXISTS
    (
        SELECT 1
        FROM movimientos
        WHERE id = p_movimiento_id
    )
    INTO v_existe;

    RETURN v_existe;

END;
$$;

-- ======================================================
-- FUNCIÓN: REGISTRAR PROGRAMACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_programacion(
    p_contenedor_id UUID,
    p_ubicacion_origen_id UUID,
    p_ubicacion_destino_id UUID,
    p_fecha_programada TIMESTAMP,
    p_usuario_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
AS
$$
DECLARE
    v_programacion_id UUID;
    v_estado_programado UUID;
BEGIN

    -- ============================================
    -- VALIDACIONES
    -- ============================================

    IF NOT existe_usuario(p_usuario_id) THEN
        RAISE EXCEPTION 'El usuario no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM contenedores
        WHERE id = p_contenedor_id
    ) THEN
        RAISE EXCEPTION 'El contenedor no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM ubicaciones
        WHERE id = p_ubicacion_origen_id
    ) THEN
        RAISE EXCEPTION 'La ubicación de origen no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM ubicaciones
        WHERE id = p_ubicacion_destino_id
    ) THEN
        RAISE EXCEPTION 'La ubicación de destino no existe.';
    END IF;

    IF p_fecha_programada IS NULL THEN
        RAISE EXCEPTION 'Debe indicar la fecha programada.';
    END IF;

    -- ============================================
    -- OBTENER ESTADO "PROGRAMADO"
    -- ============================================

    SELECT id
    INTO v_estado_programado
    FROM estados
    WHERE codigo = 'PROGRAMADO';

    IF v_estado_programado IS NULL THEN
        RAISE EXCEPTION 'No existe el estado PROGRAMADO.';
    END IF;

    -- ============================================
    -- CREAR PROGRAMACIÓN
    -- ============================================

    INSERT INTO programaciones
    (
        contenedor_id,
        ubicacion_origen_id,
        ubicacion_destino_id,
        fecha_programada,
        estado_id,
        created_by,
        updated_by
    )
    VALUES
    (
        p_contenedor_id,
        p_ubicacion_origen_id,
        p_ubicacion_destino_id,
        p_fecha_programada,
        v_estado_programado,
        p_usuario_id,
        p_usuario_id
    )
    RETURNING id
    INTO v_programacion_id;

    -- ============================================
    -- AUDITORÍA
    -- ============================================

    PERFORM registrar_auditoria(
        p_usuario_id,
        'programaciones',
        'INSERT',
        v_programacion_id,
        'Programación creada correctamente.'
    );

    RETURN v_programacion_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
        'Error al registrar la programación: %',
        SQLERRM;
END;
$$;

-- ======================================================
-- FUNCIÓN: ASIGNAR VEHÍCULO
-- ======================================================

CREATE OR REPLACE FUNCTION asignar_vehiculo(
    p_programacion_id UUID,
    p_vehiculo_id UUID,
    p_usuario_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
AS
$$
DECLARE
    v_asignacion_id UUID;
    v_estado_asignado UUID;
BEGIN

    -- ============================================
    -- VALIDACIONES
    -- ============================================

    IF NOT existe_usuario(p_usuario_id) THEN
        RAISE EXCEPTION 'El usuario no existe.';
    END IF;

    IF NOT existe_programacion(p_programacion_id) THEN
        RAISE EXCEPTION 'La programación no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM vehiculos
        WHERE id = p_vehiculo_id
    ) THEN
        RAISE EXCEPTION 'El vehículo no existe.';
    END IF;

    -- ============================================
    -- OBTENER ESTADO ASIGNADO
    -- ============================================

    SELECT id
    INTO v_estado_asignado
    FROM estados
    WHERE codigo = 'ASIGNADO';

    IF v_estado_asignado IS NULL THEN
        RAISE EXCEPTION 'No existe el estado ASIGNADO.';
    END IF;

    -- ============================================
    -- VALIDAR ASIGNACIÓN ACTIVA
    -- ============================================

    IF EXISTS (
        SELECT 1
        FROM asignaciones
        WHERE programacion_id = p_programacion_id
          AND estado_id = v_estado_asignado
    ) THEN
        RAISE EXCEPTION 'La programación ya tiene un vehículo asignado.';
    END IF;

    -- ============================================
    -- CREAR ASIGNACIÓN
    -- ============================================

    INSERT INTO asignaciones
    (
        programacion_id,
        vehiculo_id,
        usuario_id,
        estado_id,
        created_by,
        updated_by
    )
    VALUES
    (
        p_programacion_id,
        p_vehiculo_id,
        p_usuario_id,
        v_estado_asignado,
        p_usuario_id,
        p_usuario_id
    )
    RETURNING id
    INTO v_asignacion_id;

    -- ============================================
    -- ACTUALIZAR PROGRAMACIÓN
    -- ============================================

    UPDATE programaciones
       SET estado_id = v_estado_asignado,
           updated_by = p_usuario_id,
           updated_at = NOW()
     WHERE id = p_programacion_id;

    -- ============================================
    -- CREAR MOVIMIENTO
    -- ============================================

    INSERT INTO movimientos
    (
        programacion_id,
        estado_id,
        created_by,
        updated_by
    )
    VALUES
    (
        p_programacion_id,
        v_estado_asignado,
        p_usuario_id,
        p_usuario_id
    );

    -- ============================================
    -- AUDITORÍA
    -- ============================================

    PERFORM registrar_auditoria(
        p_usuario_id,
        'asignaciones',
        'INSERT',
        v_asignacion_id,
        'Vehículo asignado correctamente.'
    );

    RETURN v_asignacion_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
        'Error al asignar vehículo: %',
        SQLERRM;
END;
$$;

-- ======================================================
-- FUNCIÓN: REGISTRAR EVENTO
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_evento(
    p_movimiento_id UUID,
    p_tipo_evento_id UUID,
    p_usuario_id UUID,
    p_causal_id UUID DEFAULT NULL,
    p_observacion TEXT DEFAULT NULL,
    p_evidencia TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
AS
$$
DECLARE

    v_evento_id UUID;

    v_estado_id UUID;

    v_contenedor_id UUID;

    v_codigo_evento VARCHAR;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    IF NOT existe_usuario(p_usuario_id) THEN
        RAISE EXCEPTION 'El usuario no existe.';
    END IF;

    IF NOT existe_movimiento(p_movimiento_id) THEN
        RAISE EXCEPTION 'El movimiento no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM tipos_evento
        WHERE id = p_tipo_evento_id
    ) THEN
        RAISE EXCEPTION 'El tipo de evento no existe.';
    END IF;

    ------------------------------------------------------
    -- OBTENER INFORMACIÓN DEL EVENTO
    ------------------------------------------------------

    SELECT codigo
    INTO v_codigo_evento
    FROM tipos_evento
    WHERE id = p_tipo_evento_id;

    ------------------------------------------------------
    -- INSERTAR EVENTO
    ------------------------------------------------------

INSERT INTO eventos
(
    movimiento_id,
    tipo_evento_id,
    usuario_id,
    causal_id,
    observacion,
    evidencia_url,
    created_by,
    updated_by
)
VALUES
(
    p_movimiento_id,
    p_tipo_evento_id,
    p_usuario_id,
    p_causal_id,
    p_observacion,
    p_evidencia,
    p_usuario_id,
    p_usuario_id
)
RETURNING id
INTO v_evento_id;

    ------------------------------------------------------
    -- DETERMINAR NUEVO ESTADO
    ------------------------------------------------------

    SELECT id
    INTO v_estado_id
    FROM estados
    WHERE codigo =
        CASE v_codigo_evento

            WHEN 'ING_PATIO' THEN 'EN_PATIO'

            WHEN 'LLEG_MUELLE' THEN 'EN_MUELLE'

            WHEN 'INI_CARGUE' THEN 'EN_CARGUE'

            WHEN 'FIN_CARGUE' THEN 'EN_TRANSITO'

            WHEN 'SAL_CD' THEN 'EN_TRANSITO'

            WHEN 'LLEG_DESTINO' THEN 'FINALIZADO'

            ELSE NULL

        END;

    ------------------------------------------------------
    -- ACTUALIZAR MOVIMIENTO
    ------------------------------------------------------

    IF v_estado_id IS NOT NULL THEN

        UPDATE movimientos
        SET estado_id = v_estado_id,
            updated_at = NOW(),
            updated_by = p_usuario_id
        WHERE id = p_movimiento_id;

    END IF;

    ------------------------------------------------------
    -- OBTENER CONTENEDOR
    ------------------------------------------------------

    SELECT p.contenedor_id
    INTO v_contenedor_id
    FROM movimientos m
    INNER JOIN programaciones p
            ON p.id = m.programacion_id
    WHERE m.id = p_movimiento_id;

    ------------------------------------------------------
    -- ACTUALIZAR CONTENEDOR
    ------------------------------------------------------

    IF v_estado_id IS NOT NULL THEN

        UPDATE contenedores
        SET estado_actual_id = v_estado_id,
            updated_at = NOW(),
            updated_by = p_usuario_id
        WHERE id = v_contenedor_id;

    END IF;

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria(

        p_usuario_id,

        'eventos',

        'INSERT',

        v_evento_id,

        CONCAT(
            'Evento registrado: ',
            v_codigo_evento
        )

    );

    ------------------------------------------------------
    -- RETORNO
    ------------------------------------------------------

    RETURN v_evento_id;

EXCEPTION

    WHEN OTHERS THEN

        RAISE EXCEPTION
        'Error registrando evento: %',
        SQLERRM;

END;
$$;

-- ======================================================
-- FUNCIÓN: CERRAR MOVIMIENTO
-- ======================================================

CREATE OR REPLACE FUNCTION cerrar_movimiento(
    p_movimiento_id UUID,
    p_usuario_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE

    v_estado_final UUID;

    v_inicio TIMESTAMP;

    v_fin TIMESTAMP;

    v_duracion INTERVAL;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    IF NOT existe_usuario(p_usuario_id) THEN
        RAISE EXCEPTION 'El usuario no existe.';
    END IF;

    IF NOT existe_movimiento(p_movimiento_id) THEN
        RAISE EXCEPTION 'El movimiento no existe.';
    END IF;

    ------------------------------------------------------
    -- OBTENER ESTADO FINAL
    ------------------------------------------------------

    SELECT id
    INTO v_estado_final
    FROM estados
    WHERE codigo = 'FINALIZADO';

    IF v_estado_final IS NULL THEN
        RAISE EXCEPTION 'No existe el estado FINALIZADO.';
    END IF;

    ------------------------------------------------------
    -- OBTENER FECHA DE INICIO
    ------------------------------------------------------

    SELECT inicio_real
    INTO v_inicio
    FROM movimientos
    WHERE id = p_movimiento_id;

    IF v_inicio IS NULL THEN
        v_inicio := NOW();
    END IF;

    ------------------------------------------------------
    -- CALCULAR TIEMPOS
    ------------------------------------------------------

    v_fin := NOW();

    v_duracion := v_fin - v_inicio;

    ------------------------------------------------------
    -- ACTUALIZAR MOVIMIENTO
    ------------------------------------------------------

    UPDATE movimientos
    SET
        estado_id = v_estado_final,
        fin_real = v_fin,
        duracion = v_duracion,
        updated_at = NOW(),
        updated_by = p_usuario_id
    WHERE id = p_movimiento_id;

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria(
        p_usuario_id,
        'movimientos',
        'UPDATE',
        p_movimiento_id,
        CONCAT(
            'Movimiento finalizado. Duración: ',
            v_duracion
        )
    );

    RETURN TRUE;

EXCEPTION

    WHEN OTHERS THEN

        RAISE EXCEPTION
        'Error cerrando movimiento: %',
        SQLERRM;

END;
$$;

-- ======================================================
-- FUNCIÓN: REPROGRAMAR OPERACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION reprogramar_operacion(
    p_programacion_id UUID,
    p_nueva_fecha TIMESTAMP,
    p_causal_id UUID,
    p_observacion TEXT,
    p_usuario_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE

    v_fecha_anterior TIMESTAMP;

    v_estado_reprogramado UUID;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    IF NOT existe_usuario(p_usuario_id) THEN
        RAISE EXCEPTION 'El usuario no existe.';
    END IF;

    IF NOT existe_programacion(p_programacion_id) THEN
        RAISE EXCEPTION 'La programación no existe.';
    END IF;

    IF p_nueva_fecha IS NULL THEN
        RAISE EXCEPTION 'Debe indicar una nueva fecha.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM causales
        WHERE id = p_causal_id
    ) THEN
        RAISE EXCEPTION 'La causal indicada no existe.';
    END IF;

    ------------------------------------------------------
    -- OBTENER FECHA ACTUAL
    ------------------------------------------------------

    SELECT fecha_programada
    INTO v_fecha_anterior
    FROM programaciones
    WHERE id = p_programacion_id;

    ------------------------------------------------------
    -- OBTENER ESTADO REPROGRAMADO
    ------------------------------------------------------

    SELECT id
    INTO v_estado_reprogramado
    FROM estados
    WHERE codigo = 'REPROGRAMADO';

    IF v_estado_reprogramado IS NULL THEN
        RAISE EXCEPTION 'No existe el estado REPROGRAMADO.';
    END IF;

    ------------------------------------------------------
    -- ACTUALIZAR PROGRAMACIÓN
    ------------------------------------------------------

    UPDATE programaciones
    SET
        fecha_programada = p_nueva_fecha,
        estado_id = v_estado_reprogramado,
        updated_at = NOW(),
        updated_by = p_usuario_id
    WHERE id = p_programacion_id;

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria(
        p_usuario_id,
        'programaciones',
        'UPDATE',
        p_programacion_id,
        CONCAT(
            'Reprogramación. Fecha anterior: ',
            v_fecha_anterior,
            ' | Nueva fecha: ',
            p_nueva_fecha,
            ' | Observación: ',
            COALESCE(p_observacion,'Sin observaciones')
        )
    );

    RETURN TRUE;

EXCEPTION

    WHEN OTHERS THEN

        RAISE EXCEPTION
        'Error reprogramando la operación: %',
        SQLERRM;

END;
$$;

