/*
==========================================================
ECO PLATFORM
Archivo: 06_functions.sql
Versión: 2.0
Descripción:
Funciones de negocio del sistema ECO Platform.
Optimizado para PostgreSQL 16 y Supabase.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- FUNCIÓN
-- OBTENER ID DE UN ESTADO
-- ======================================================

CREATE OR REPLACE FUNCTION obtener_estado_id(
    p_codigo VARCHAR
)
RETURNS UUID
LANGUAGE plpgsql
STABLE
AS
$$
DECLARE
    v_estado UUID;
BEGIN

    SELECT id
      INTO v_estado
      FROM estados
     WHERE codigo = UPPER(p_codigo);

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'No existe el estado %', p_codigo;
    END IF;

    RETURN v_estado;

END;
$$;

-- ======================================================
-- FUNCIÓN
-- VALIDAR EXISTENCIA DE USUARIO
-- ======================================================

CREATE OR REPLACE FUNCTION existe_usuario(
    p_usuario UUID
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS
$$
SELECT EXISTS
(
    SELECT 1
    FROM usuarios
    WHERE id = p_usuario
);
$$;

-- ======================================================
-- VALIDAR PROGRAMACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION existe_programacion(
    p_programacion UUID
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS
$$
SELECT EXISTS
(
    SELECT 1
    FROM programaciones
    WHERE id = p_programacion
);
$$;

-- ======================================================
-- VALIDAR MOVIMIENTO
-- ======================================================

CREATE OR REPLACE FUNCTION existe_movimiento(
    p_movimiento UUID
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS
$$
SELECT EXISTS
(
    SELECT 1
    FROM movimientos
    WHERE id = p_movimiento
);
$$;

-- ======================================================
-- VALIDAR VEHÍCULO
-- ======================================================

CREATE OR REPLACE FUNCTION existe_vehiculo(
    p_vehiculo UUID
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS
$$
SELECT EXISTS
(
    SELECT 1
    FROM vehiculos
    WHERE id = p_vehiculo
);
$$;

-- ======================================================
-- REGISTRAR AUDITORÍA
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_auditoria
(
    p_usuario UUID,
    p_tabla VARCHAR,
    p_accion VARCHAR,
    p_registro UUID,
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
        LOWER(p_tabla),
        p_registro,
        UPPER(p_accion),
        p_usuario,
        NOW(),
        jsonb_build_object
        (
            'detalle',p_detalle,
            'fecha',NOW()
        )
    );

END;
$$;

-- ======================================================
-- VALIDAR USUARIO
-- ======================================================

CREATE OR REPLACE FUNCTION validar_usuario(
    p_usuario UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT existe_usuario(p_usuario) THEN
        RAISE EXCEPTION
        'El usuario indicado no existe.';
    END IF;

END;
$$;

-- ======================================================
-- VALIDAR PROGRAMACIÓN
-- ======================================================

CREATE OR REPLACE FUNCTION validar_programacion(
    p_programacion UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT existe_programacion(p_programacion) THEN
        RAISE EXCEPTION
        'La programación no existe.';
    END IF;

END;
$$;

-- ======================================================
-- VALIDAR MOVIMIENTO
-- ======================================================

CREATE OR REPLACE FUNCTION validar_movimiento(
    p_movimiento UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT existe_movimiento(p_movimiento) THEN
        RAISE EXCEPTION
        'El movimiento no existe.';
    END IF;

END;
$$;

-- ======================================================
-- VALIDAR VEHÍCULO
-- ======================================================

CREATE OR REPLACE FUNCTION validar_vehiculo(
    p_vehiculo UUID
)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT existe_vehiculo(p_vehiculo) THEN
        RAISE EXCEPTION
        'El vehículo indicado no existe.';
    END IF;

END;
$$;
-- ======================================================
-- REGISTRAR PROGRAMACIÓN
-- VERSIÓN 2.0
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_programacion
(
    p_contenedor_id UUID,
    p_ubicacion_origen_id UUID,
    p_ubicacion_destino_id UUID,
    p_fecha_programada TIMESTAMPTZ,
    p_usuario_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
AS
$$
DECLARE

    v_programacion UUID;

    v_estado_programado UUID;

BEGIN

    ------------------------------------------------------
    -- VALIDAR USUARIO
    ------------------------------------------------------

    PERFORM validar_usuario(p_usuario_id);

    ------------------------------------------------------
    -- VALIDAR CONTENEDOR
    ------------------------------------------------------

    PERFORM 1
    FROM contenedores
    WHERE id = p_contenedor_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'El contenedor no existe.';
    END IF;

    ------------------------------------------------------
    -- VALIDAR ORIGEN
    ------------------------------------------------------

    PERFORM 1
    FROM ubicaciones
    WHERE id = p_ubicacion_origen_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'La ubicación de origen no existe.';
    END IF;

    ------------------------------------------------------
    -- VALIDAR DESTINO
    ------------------------------------------------------

    PERFORM 1
    FROM ubicaciones
    WHERE id = p_ubicacion_destino_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'La ubicación destino no existe.';
    END IF;

    ------------------------------------------------------
    -- VALIDAR ORIGEN != DESTINO
    ------------------------------------------------------

    IF p_ubicacion_origen_id = p_ubicacion_destino_id THEN

        RAISE EXCEPTION
        'La ubicación origen y destino no pueden ser iguales.';

    END IF;

    ------------------------------------------------------
    -- VALIDAR FECHA
    ------------------------------------------------------

    IF p_fecha_programada IS NULL THEN

        RAISE EXCEPTION
        'Debe indicar una fecha programada.';

    END IF;

    IF p_fecha_programada < NOW() THEN

        RAISE EXCEPTION
        'No es posible programar en una fecha pasada.';

    END IF;

    ------------------------------------------------------
    -- VALIDAR DUPLICADOS
    ------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM programaciones
        WHERE contenedor_id = p_contenedor_id
          AND estado_id <> obtener_estado_id('FINALIZADO')
          AND fecha_programada = p_fecha_programada
    )
    THEN

        RAISE EXCEPTION
        'Ya existe una programación para este contenedor.';

    END IF;

    ------------------------------------------------------
    -- ESTADO
    ------------------------------------------------------

    v_estado_programado := obtener_estado_id('PROGRAMADO');

    ------------------------------------------------------
    -- INSERT
    ------------------------------------------------------

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
    INTO v_programacion;

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria
    (
        p_usuario_id,
        'programaciones',
        'INSERT',
        v_programacion,
        CONCAT
        (
            'Programación creada para contenedor ',
            p_contenedor_id,
            ' el ',
            p_fecha_programada
        )
    );

    ------------------------------------------------------
    -- RETORNO
    ------------------------------------------------------

    RETURN v_programacion;

END;
$$;

-- ======================================================
-- ASIGNAR VEHÍCULO
-- VERSIÓN 2.0
-- ======================================================

CREATE OR REPLACE FUNCTION asignar_vehiculo
(
    p_programacion_id UUID,
    p_vehiculo_id UUID,
    p_usuario_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
AS
$$

DECLARE

    v_asignacion UUID;

    v_estado_asignado UUID;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    PERFORM validar_usuario(p_usuario_id);

    PERFORM validar_programacion(p_programacion_id);

    PERFORM validar_vehiculo(p_vehiculo_id);

    ------------------------------------------------------
    -- BLOQUEAR PROGRAMACIÓN
    ------------------------------------------------------

    PERFORM 1
    FROM programaciones
    WHERE id = p_programacion_id
    FOR UPDATE;

    ------------------------------------------------------
    -- OBTENER ESTADO
    ------------------------------------------------------

    v_estado_asignado :=
        obtener_estado_id('ASIGNADO');

    ------------------------------------------------------
    -- VALIDAR PROGRAMACIÓN ACTIVA
    ------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM asignaciones
        WHERE programacion_id = p_programacion_id
        AND estado_id = v_estado_asignado
    )
    THEN

        RAISE EXCEPTION
        'La programación ya tiene un vehículo asignado.';

    END IF;

    ------------------------------------------------------
    -- VALIDAR VEHÍCULO LIBRE
    ------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM asignaciones
        WHERE vehiculo_id = p_vehiculo_id
        AND estado_id = v_estado_asignado
    )
    THEN

        RAISE EXCEPTION
        'El vehículo ya tiene una asignación activa.';

    END IF;

    ------------------------------------------------------
    -- INSERTAR ASIGNACIÓN
    ------------------------------------------------------

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
    INTO v_asignacion;

    ------------------------------------------------------
    -- ACTUALIZAR PROGRAMACIÓN
    ------------------------------------------------------

    UPDATE programaciones
       SET estado_id = v_estado_asignado,
           updated_at = NOW(),
           updated_by = p_usuario_id
     WHERE id = p_programacion_id;

    ------------------------------------------------------
    -- CREAR MOVIMIENTO
    ------------------------------------------------------

    INSERT INTO movimientos
    (
        programacion_id,
        estado_id,
        inicio_real,
        created_by,
        updated_by
    )
    VALUES
    (
        p_programacion_id,
        v_estado_asignado,
        NOW(),
        p_usuario_id,
        p_usuario_id
    );

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria
    (
        p_usuario_id,
        'asignaciones',
        'INSERT',
        v_asignacion,
        CONCAT
        (
            'Vehículo ',
            p_vehiculo_id,
            ' asignado a programación ',
            p_programacion_id
        )
    );

    ------------------------------------------------------
    -- RETORNO
    ------------------------------------------------------

    RETURN v_asignacion;

END;
$$;

-- ======================================================
-- REGISTRAR EVENTO
-- VERSIÓN 2.0
-- ======================================================

CREATE OR REPLACE FUNCTION registrar_evento
(
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

    v_evento UUID;

    v_estado UUID;

    v_programacion UUID;

    v_contenedor UUID;

    v_codigo_evento VARCHAR;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    PERFORM validar_usuario(p_usuario_id);

    PERFORM validar_movimiento(p_movimiento_id);

    ------------------------------------------------------
    -- BLOQUEAR MOVIMIENTO
    ------------------------------------------------------

    PERFORM 1
    FROM movimientos
    WHERE id = p_movimiento_id
    FOR UPDATE;

    ------------------------------------------------------
    -- VALIDAR TIPO EVENTO
    ------------------------------------------------------

    SELECT codigo
      INTO v_codigo_evento
      FROM tipos_evento
     WHERE id = p_tipo_evento_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION
        'El tipo de evento no existe.';
    END IF;

    ------------------------------------------------------
    -- VALIDAR CAUSAL
    ------------------------------------------------------

    IF v_codigo_evento IN
    (
        'NOVEDAD',
        'REPROGRAMACION',
        'CAMBIO_VEHICULO'
    )
    THEN

        IF p_causal_id IS NULL THEN

            RAISE EXCEPTION
            'Debe indicar una causal.';

        END IF;

    END IF;

    ------------------------------------------------------
    -- CREAR EVENTO
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
    INTO v_evento;

    ------------------------------------------------------
    -- DETERMINAR ESTADO
    ------------------------------------------------------

    CASE v_codigo_evento

        WHEN 'ING_PATIO' THEN
            v_estado := obtener_estado_id('EN_PATIO');

        WHEN 'LLEG_MUELLE' THEN
            v_estado := obtener_estado_id('EN_MUELLE');

        WHEN 'INI_CARGUE' THEN
            v_estado := obtener_estado_id('EN_CARGUE');

        WHEN 'FIN_CARGUE' THEN
            v_estado := obtener_estado_id('EN_TRANSITO');

        WHEN 'SAL_CD' THEN
            v_estado := obtener_estado_id('EN_TRANSITO');

        WHEN 'LLEG_DESTINO' THEN
            v_estado := obtener_estado_id('FINALIZADO');

        WHEN 'REPROGRAMACION' THEN
            v_estado := obtener_estado_id('REPROGRAMADO');

        ELSE

            v_estado := NULL;

    END CASE;

    ------------------------------------------------------
    -- ACTUALIZAR MOVIMIENTO
    ------------------------------------------------------

    IF v_estado IS NOT NULL THEN

        UPDATE movimientos
           SET estado_id = v_estado,
               updated_at = NOW(),
               updated_by = p_usuario_id
         WHERE id = p_movimiento_id;

    END IF;

    ------------------------------------------------------
    -- OBTENER PROGRAMACIÓN Y CONTENEDOR
    ------------------------------------------------------

    SELECT
        p.id,
        p.contenedor_id
    INTO
        v_programacion,
        v_contenedor
    FROM movimientos m
    INNER JOIN programaciones p
        ON p.id = m.programacion_id
    WHERE m.id = p_movimiento_id;

    ------------------------------------------------------
    -- ACTUALIZAR PROGRAMACIÓN
    ------------------------------------------------------

    IF v_estado IS NOT NULL THEN

        UPDATE programaciones
           SET estado_id = v_estado,
               updated_at = NOW(),
               updated_by = p_usuario_id
         WHERE id = v_programacion;

    END IF;

    ------------------------------------------------------
    -- ACTUALIZAR CONTENEDOR
    ------------------------------------------------------

    IF v_estado IS NOT NULL THEN

        UPDATE contenedores
           SET estado_actual_id = v_estado,
               updated_at = NOW(),
               updated_by = p_usuario_id
         WHERE id = v_contenedor;

    END IF;

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria
    (
        p_usuario_id,
        'eventos',
        'INSERT',
        v_evento,
        CONCAT
        (
            'Evento registrado: ',
            v_codigo_evento
        )
    );

    ------------------------------------------------------
    -- RETORNO
    ------------------------------------------------------

    RETURN v_evento;

END;
$$;

-- ======================================================
-- CERRAR MOVIMIENTO
-- VERSIÓN 2.0
-- ======================================================

CREATE OR REPLACE FUNCTION cerrar_movimiento
(
    p_movimiento_id UUID,
    p_usuario_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$

DECLARE

    v_estado_final UUID;

    v_inicio TIMESTAMPTZ;

    v_fin TIMESTAMPTZ;

    v_duracion INTERVAL;

    v_programacion UUID;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    PERFORM validar_usuario(p_usuario_id);

    PERFORM validar_movimiento(p_movimiento_id);

    ------------------------------------------------------
    -- BLOQUEAR MOVIMIENTO
    ------------------------------------------------------

    PERFORM 1
    FROM movimientos
    WHERE id = p_movimiento_id
    FOR UPDATE;

    ------------------------------------------------------
    -- ESTADO FINAL
    ------------------------------------------------------

    v_estado_final :=
        obtener_estado_id('FINALIZADO');

    ------------------------------------------------------
    -- FECHA INICIO
    ------------------------------------------------------

    SELECT
        inicio_real,
        programacion_id
    INTO
        v_inicio,
        v_programacion
    FROM movimientos
    WHERE id = p_movimiento_id;

    IF v_inicio IS NULL THEN
        v_inicio := NOW();
    END IF;

    v_fin := NOW();

    v_duracion := age(v_fin,v_inicio);

    ------------------------------------------------------
    -- ACTUALIZAR MOVIMIENTO
    ------------------------------------------------------

    UPDATE movimientos
       SET estado_id = v_estado_final,
           fin_real = v_fin,
           duracion = v_duracion,
           updated_at = NOW(),
           updated_by = p_usuario_id
     WHERE id = p_movimiento_id;

    ------------------------------------------------------
    -- ACTUALIZAR PROGRAMACIÓN
    ------------------------------------------------------

    UPDATE programaciones
       SET estado_id = v_estado_final,
           updated_at = NOW(),
           updated_by = p_usuario_id
     WHERE id = v_programacion;

    ------------------------------------------------------
    -- ACTUALIZAR CONTENEDOR
    ------------------------------------------------------

    UPDATE contenedores
       SET estado_actual_id = v_estado_final,
           updated_at = NOW(),
           updated_by = p_usuario_id
     WHERE id =
     (
        SELECT contenedor_id
        FROM programaciones
        WHERE id = v_programacion
     );

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria
    (
        p_usuario_id,
        'movimientos',
        'UPDATE',
        p_movimiento_id,
        CONCAT
        (
            'Movimiento finalizado. Duración: ',
            v_duracion
        )
    );

    RETURN TRUE;

END;
$$;

-- ======================================================
-- REPROGRAMAR OPERACIÓN
-- VERSIÓN 2.0
-- ======================================================

CREATE OR REPLACE FUNCTION reprogramar_operacion
(
    p_programacion_id UUID,
    p_nueva_fecha TIMESTAMPTZ,
    p_causal_id UUID,
    p_observacion TEXT,
    p_usuario_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$

DECLARE

    v_fecha_anterior TIMESTAMPTZ;

    v_estado UUID;

BEGIN

    ------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------

    PERFORM validar_usuario(p_usuario_id);

    PERFORM validar_programacion(p_programacion_id);

    IF p_nueva_fecha IS NULL THEN

        RAISE EXCEPTION
        'Debe indicar una nueva fecha.';

    END IF;

    IF p_nueva_fecha <= NOW() THEN

        RAISE EXCEPTION
        'La nueva fecha debe ser futura.';

    END IF;

    PERFORM 1
    FROM causales
    WHERE id = p_causal_id;

    IF NOT FOUND THEN

        RAISE EXCEPTION
        'La causal indicada no existe.';

    END IF;

    ------------------------------------------------------
    -- BLOQUEAR PROGRAMACIÓN
    ------------------------------------------------------

    PERFORM 1
    FROM programaciones
    WHERE id = p_programacion_id
    FOR UPDATE;

    ------------------------------------------------------
    -- OBTENER INFORMACIÓN
    ------------------------------------------------------

    SELECT fecha_programada
    INTO v_fecha_anterior
    FROM programaciones
    WHERE id = p_programacion_id;

    v_estado :=
        obtener_estado_id('REPROGRAMADO');

    ------------------------------------------------------
    -- ACTUALIZAR
    ------------------------------------------------------

    UPDATE programaciones
       SET fecha_programada = p_nueva_fecha,
           estado_id = v_estado,
           updated_at = NOW(),
           updated_by = p_usuario_id
     WHERE id = p_programacion_id;

    ------------------------------------------------------
    -- AUDITORÍA
    ------------------------------------------------------

    PERFORM registrar_auditoria
    (
        p_usuario_id,
        'programaciones',
        'UPDATE',
        p_programacion_id,
        CONCAT
        (
            'Reprogramación de ',
            v_fecha_anterior,
            ' a ',
            p_nueva_fecha,
            '. ',
            COALESCE(p_observacion,'Sin observaciones.')
        )
    );

    RETURN TRUE;

END;
$$;

-- ======================================================
-- OBTENER ESTADO ACTUAL
-- ======================================================

CREATE OR REPLACE FUNCTION obtener_estado_actual_programacion
(
    p_programacion UUID
)
RETURNS TABLE
(
    programacion_id UUID,
    estado VARCHAR,
    fecha_programada TIMESTAMPTZ
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    p.id,

    e.nombre,

    p.fecha_programada

FROM programaciones p

INNER JOIN estados e
        ON e.id = p.estado_id

WHERE p.id = p_programacion;

$$;

-- ======================================================
-- HISTORIAL EVENTOS
-- ======================================================

CREATE OR REPLACE FUNCTION obtener_historial_eventos
(
    p_programacion UUID
)
RETURNS TABLE
(
    fecha TIMESTAMPTZ,
    evento VARCHAR,
    usuario VARCHAR,
    observacion TEXT
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    ev.fecha_hora,

    te.nombre,

    u.nombre,

    ev.observacion

FROM movimientos m

INNER JOIN eventos ev
        ON ev.movimiento_id=m.id

INNER JOIN tipos_evento te
        ON te.id=ev.tipo_evento_id

INNER JOIN usuarios u
        ON u.id=ev.usuario_id

WHERE m.programacion_id=p_programacion

ORDER BY ev.fecha_hora;

$$;

-- ======================================================
-- PROGRAMACIONES PENDIENTES
-- ======================================================

CREATE OR REPLACE FUNCTION obtener_programaciones_pendientes()
RETURNS TABLE
(
    programacion UUID,
    contenedor VARCHAR,
    estado VARCHAR,
    fecha TIMESTAMPTZ
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    p.id,

    c.serial,

    e.nombre,

    p.fecha_programada

FROM programaciones p

INNER JOIN contenedores c

ON c.id=p.contenedor_id

INNER JOIN estados e

ON e.id=p.estado_id

WHERE e.codigo<>'FINALIZADO'

ORDER BY p.fecha_programada;

$$;

-- ======================================================
-- OPERACIONES ACTIVAS
-- ======================================================

CREATE OR REPLACE FUNCTION obtener_operaciones_activas()
RETURNS TABLE
(
    movimiento UUID,
    contenedor VARCHAR,
    estado VARCHAR,
    inicio TIMESTAMPTZ
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    m.id,

    c.serial,

    e.nombre,

    m.inicio_real

FROM movimientos m

INNER JOIN programaciones p

ON p.id=m.programacion_id

INNER JOIN contenedores c

ON c.id=p.contenedor_id

INNER JOIN estados e

ON e.id=m.estado_id

WHERE m.fin_real IS NULL

ORDER BY m.inicio_real;

$$;

-- ======================================================
-- DASHBOARD GENERAL
-- ======================================================

CREATE OR REPLACE FUNCTION dashboard_operacion()
RETURNS TABLE
(
    programadas BIGINT,
    activas BIGINT,
    finalizadas BIGINT,
    reprogramadas BIGINT
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    COUNT(*) FILTER
    (
        WHERE e.codigo='PROGRAMADO'
    ),

    COUNT(*) FILTER
    (
        WHERE e.codigo IN
        (
            'ASIGNADO',
            'EN_PATIO',
            'EN_MUELLE',
            'EN_CARGUE',
            'EN_TRANSITO'
        )
    ),

    COUNT(*) FILTER
    (
        WHERE e.codigo='FINALIZADO'
    ),

    COUNT(*) FILTER
    (
        WHERE e.codigo='REPROGRAMADO'
    )

FROM programaciones p

INNER JOIN estados e

ON e.id=p.estado_id;

$$;

-- ======================================================
-- INDICADORES OPERATIVOS
-- ======================================================

CREATE OR REPLACE FUNCTION dashboard_indicadores()
RETURNS TABLE
(
    tiempo_promedio INTERVAL,
    total_movimientos BIGINT,
    total_eventos BIGINT
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    AVG(duracion),

    COUNT(*),

    (
        SELECT COUNT(*)
        FROM eventos
    )

FROM movimientos

WHERE duracion IS NOT NULL;

$$;

-- ======================================================
-- CONTENEDORES POR ESTADO
-- ======================================================

CREATE OR REPLACE FUNCTION dashboard_contenedores()
RETURNS TABLE
(
    estado VARCHAR,
    cantidad BIGINT
)
LANGUAGE sql
STABLE
AS
$$

SELECT

    e.nombre,

    COUNT(*)

FROM contenedores c

INNER JOIN estados e

ON e.id=c.estado_actual_id

GROUP BY e.nombre

ORDER BY e.nombre;

$$;

