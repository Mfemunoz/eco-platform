/*
==========================================================
ECO PLATFORM
Archivo: 07_views.sql
Versión: 2.1
Descripción:
Vistas operativas para aplicación y dashboard.
==========================================================
*/

SET search_path TO eco, public;


-- ======================================================
-- VISTA: OPERACIONES ACTIVAS
-- ======================================================

CREATE OR REPLACE VIEW vw_operaciones_activas AS

SELECT

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.descripcion AS tipo_contenedor,

    uo.nombre AS origen,

    ud.nombre AS destino,

    p.fecha_programada,

    e.codigo AS codigo_estado,

    e.nombre AS estado,

    v.placa,

    t.nombre AS transportadora,

    mov.inicio_real,

    mov.fin_real,

    mov.duracion,


    CASE

        WHEN mov.inicio_real IS NOT NULL
         AND mov.fin_real IS NULL

        THEN CURRENT_TIMESTAMP - mov.inicio_real

        ELSE mov.duracion

    END AS tiempo_transcurrido,


    p.created_at,

    p.updated_at


FROM programaciones p


INNER JOIN contenedores c
        ON c.id = p.contenedor_id


INNER JOIN tipos_contenedor tc
        ON tc.id = c.tipo_contenedor_id


INNER JOIN ubicaciones uo
        ON uo.id = p.ubicacion_origen_id


INNER JOIN ubicaciones ud
        ON ud.id = p.ubicacion_destino_id


INNER JOIN estados e
        ON e.id = p.estado_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM asignaciones a
    WHERE a.programacion_id = p.id
    ORDER BY a.created_at DESC
    LIMIT 1

) asignacion

ON TRUE


LEFT JOIN vehiculos v
       ON v.id = asignacion.vehiculo_id


LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM movimientos m
    WHERE m.programacion_id = p.id
    ORDER BY m.created_at DESC
    LIMIT 1

) mov

ON TRUE


WHERE e.codigo <> 'FINALIZADO';



-- ======================================================
-- VISTA: CICLOS OPERATIVOS
-- ======================================================

CREATE OR REPLACE VIEW vw_ciclos_operativos AS

SELECT

    mov.id AS movimiento_id,

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.descripcion AS tipo_contenedor,

    uo.nombre AS origen,

    ud.nombre AS destino,

    e.codigo AS codigo_estado,

    e.nombre AS estado_actual,

    v.placa,

    t.nombre AS transportadora,

    mov.inicio_real,

    mov.fin_real,

    mov.duracion,


    ROUND(
        EXTRACT(EPOCH FROM mov.duracion)/60,
        2
    ) AS duracion_minutos,


    ROUND(
        EXTRACT(EPOCH FROM mov.duracion)/3600,
        2
    ) AS duracion_horas,


    CASE

        WHEN mov.fin_real IS NULL
        THEN 'EN PROCESO'

        ELSE 'FINALIZADO'

    END AS estado_ciclo,


    p.fecha_programada,

    p.created_at,

    p.updated_at


FROM movimientos mov


INNER JOIN programaciones p
        ON p.id = mov.programacion_id


INNER JOIN contenedores c
        ON c.id = p.contenedor_id


INNER JOIN tipos_contenedor tc
        ON tc.id = c.tipo_contenedor_id


INNER JOIN estados e
        ON e.id = mov.estado_id


INNER JOIN ubicaciones uo
        ON uo.id = p.ubicacion_origen_id


INNER JOIN ubicaciones ud
        ON ud.id = p.ubicacion_destino_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM asignaciones a
    WHERE a.programacion_id = p.id
    ORDER BY a.created_at DESC
    LIMIT 1

) asignacion

ON TRUE


LEFT JOIN vehiculos v
       ON v.id = asignacion.vehiculo_id


LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id;



-- ======================================================
-- VISTA: REPROGRAMACIONES
-- ======================================================

CREATE OR REPLACE VIEW vw_reprogramaciones AS

SELECT

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.descripcion AS tipo_contenedor,

    p.fecha_programada,

    e.codigo AS codigo_estado,

    e.nombre AS estado_actual,

    uo.nombre AS origen,

    ud.nombre AS destino,

    v.placa,

    t.nombre AS transportadora,

    p.created_at,

    p.updated_at,


    ROUND(
        EXTRACT(
            EPOCH FROM (p.updated_at - p.created_at)
        )/3600,
        2
    ) AS horas_hasta_reprogramacion


FROM programaciones p


INNER JOIN estados e
        ON e.id = p.estado_id


INNER JOIN contenedores c
        ON c.id = p.contenedor_id


INNER JOIN tipos_contenedor tc
        ON tc.id = c.tipo_contenedor_id


INNER JOIN ubicaciones uo
        ON uo.id = p.ubicacion_origen_id


INNER JOIN ubicaciones ud
        ON ud.id = p.ubicacion_destino_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM asignaciones a
    WHERE a.programacion_id = p.id
    ORDER BY a.created_at DESC
    LIMIT 1

) asignacion

ON TRUE


LEFT JOIN vehiculos v
       ON v.id = asignacion.vehiculo_id


LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id


WHERE e.codigo = 'REPROGRAMADO';



-- ======================================================
-- VISTA: KPI OPERACIÓN
-- ======================================================

CREATE OR REPLACE VIEW vw_kpi_operacion AS

SELECT

    COUNT(DISTINCT p.id) AS total_programaciones,


    COUNT(DISTINCT p.id)
    FILTER (
        WHERE e.codigo='FINALIZADO'
    ) AS total_finalizadas,


    COUNT(DISTINCT p.id)
    FILTER (
        WHERE e.codigo<>'FINALIZADO'
    ) AS total_activas,


    COUNT(DISTINCT p.id)
    FILTER (
        WHERE e.codigo='REPROGRAMADO'
    ) AS total_reprogramadas,


    ROUND(
        AVG(EXTRACT(EPOCH FROM m.duracion)/60)::NUMERIC,
        2
    ) AS duracion_promedio_minutos,


    ROUND(
        MAX(EXTRACT(EPOCH FROM m.duracion)/60)::NUMERIC,
        2
    ) AS duracion_maxima_minutos,


    ROUND(
        MIN(EXTRACT(EPOCH FROM m.duracion)/60)::NUMERIC,
        2
    ) AS duracion_minima_minutos


FROM programaciones p


INNER JOIN estados e
        ON e.id = p.estado_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM movimientos m
    WHERE m.programacion_id = p.id
    ORDER BY m.created_at DESC
    LIMIT 1

) m

ON TRUE;



-- ======================================================
-- VISTA: DASHBOARD PRINCIPAL
-- ======================================================

CREATE OR REPLACE VIEW vw_dashboard AS

SELECT

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.descripcion AS tipo_contenedor,

    e.codigo AS codigo_estado,

    e.nombre AS estado,

    uo.nombre AS origen,

    ud.nombre AS destino,

    p.fecha_programada,

    v.placa,

    t.nombre AS transportadora,

    mov.inicio_real,

    mov.fin_real,

    mov.duracion,


    CASE

        WHEN e.codigo='FINALIZADO'
            THEN 'Finalizado'

        WHEN e.codigo='REPROGRAMADO'
            THEN 'Reprogramado'

        WHEN mov.inicio_real IS NULL
            THEN 'Pendiente'

        ELSE 'En proceso'

    END AS estado_operacion,


    CASE

        WHEN mov.inicio_real IS NOT NULL
        AND mov.fin_real IS NULL

        THEN ROUND(
            EXTRACT(
                EPOCH FROM
                (CURRENT_TIMESTAMP - mov.inicio_real)
            )/60,
            2
        )

        WHEN mov.duracion IS NOT NULL

        THEN ROUND(
            EXTRACT(EPOCH FROM mov.duracion)/60,
            2
        )

        ELSE NULL

    END AS minutos_operacion,


    p.created_at,

    p.updated_at


FROM programaciones p


INNER JOIN contenedores c
        ON c.id=p.contenedor_id


INNER JOIN tipos_contenedor tc
        ON tc.id=c.tipo_contenedor_id


INNER JOIN estados e
        ON e.id=p.estado_id


INNER JOIN ubicaciones uo
        ON uo.id=p.ubicacion_origen_id


INNER JOIN ubicaciones ud
        ON ud.id=p.ubicacion_destino_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM asignaciones a
    WHERE a.programacion_id=p.id
    ORDER BY a.created_at DESC
    LIMIT 1

) asignacion

ON TRUE


LEFT JOIN vehiculos v
       ON v.id=asignacion.vehiculo_id


LEFT JOIN transportadoras t
       ON t.id=v.transportadora_id


LEFT JOIN LATERAL
(
    SELECT *
    FROM movimientos m
    WHERE m.programacion_id=p.id
    ORDER BY m.created_at DESC
    LIMIT 1

) mov

ON TRUE;