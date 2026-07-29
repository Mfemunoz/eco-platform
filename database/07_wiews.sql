/*
==========================================================
ECO PLATFORM
Archivo: 07_views.sql
Descripción:
Vistas de consulta para dashboards y operación.
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

    tc.nombre AS tipo_contenedor,

    uo.nombre AS origen,

    ud.nombre AS destino,

    p.fecha_programada,

    e.nombre AS estado,

    v.placa,

    t.nombre AS transportadora,

    m.inicio_real,

    m.fin_real,

    m.duracion,

    CASE
        WHEN m.inicio_real IS NOT NULL
             AND m.fin_real IS NULL
        THEN NOW() - m.inicio_real
        ELSE m.duracion
    END AS tiempo_transcurrido,

    p.created_at

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

LEFT JOIN asignaciones a
       ON a.programacion_id = p.id

LEFT JOIN vehiculos v
       ON v.id = a.vehiculo_id

LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id

LEFT JOIN movimientos m
       ON m.programacion_id = p.id

WHERE e.codigo <> 'FINALIZADO'

ORDER BY
    p.fecha_programada,
    c.serial;
-- ======================================================
-- VISTA: CICLOS OPERATIVOS
-- ======================================================

CREATE OR REPLACE VIEW vw_ciclos_operativos AS

SELECT

    m.id AS movimiento_id,

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.nombre AS tipo_contenedor,

    uo.nombre AS origen,

    ud.nombre AS destino,

    e.nombre AS estado_actual,

    v.placa,

    t.nombre AS transportadora,

    m.inicio_real,

    m.fin_real,

    m.duracion,

    EXTRACT(EPOCH FROM m.duracion)/60 AS duracion_minutos,

    EXTRACT(EPOCH FROM m.duracion)/3600 AS duracion_horas,

    CASE
        WHEN m.fin_real IS NULL THEN 'EN PROCESO'
        ELSE 'FINALIZADO'
    END AS estado_ciclo,

    p.fecha_programada,

    p.created_at,

    p.updated_at

FROM movimientos m

INNER JOIN programaciones p
        ON p.id = m.programacion_id

INNER JOIN contenedores c
        ON c.id = p.contenedor_id

INNER JOIN tipos_contenedor tc
        ON tc.id = c.tipo_contenedor_id

INNER JOIN estados e
        ON e.id = m.estado_id

INNER JOIN ubicaciones uo
        ON uo.id = p.ubicacion_origen_id

INNER JOIN ubicaciones ud
        ON ud.id = p.ubicacion_destino_id

LEFT JOIN asignaciones a
       ON a.programacion_id = p.id

LEFT JOIN vehiculos v
       ON v.id = a.vehiculo_id

LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id

ORDER BY
    p.fecha_programada DESC,
    m.inicio_real DESC;
-- ======================================================
-- VISTA: REPROGRAMACIONES
-- ======================================================

CREATE OR REPLACE VIEW vw_reprogramaciones AS

SELECT

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.nombre AS tipo_contenedor,

    p.fecha_programada,

    e.nombre AS estado_actual,

    uo.nombre AS origen,

    ud.nombre AS destino,

    v.placa,

    t.nombre AS transportadora,

    p.created_at,

    p.updated_at,

    EXTRACT(EPOCH FROM (p.updated_at - p.created_at))/3600
        AS horas_hasta_reprogramacion

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

LEFT JOIN asignaciones a
       ON a.programacion_id = p.id

LEFT JOIN vehiculos v
       ON v.id = a.vehiculo_id

LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id

WHERE e.codigo = 'REPROGRAMADO'

ORDER BY
    p.updated_at DESC;

-- ======================================================
-- VISTA: KPI OPERACIÓN
-- ======================================================

CREATE OR REPLACE VIEW vw_kpi_operacion AS

SELECT

    COUNT(DISTINCT p.id) AS total_programaciones,

    COUNT(DISTINCT CASE
        WHEN e.codigo = 'FINALIZADO'
        THEN p.id
    END) AS total_finalizadas,

    COUNT(DISTINCT CASE
        WHEN e.codigo <> 'FINALIZADO'
        THEN p.id
    END) AS total_activas,

    COUNT(DISTINCT CASE
        WHEN e.codigo = 'REPROGRAMADO'
        THEN p.id
    END) AS total_reprogramadas,

    ROUND(
        AVG(
            EXTRACT(EPOCH FROM m.duracion) / 60
        )::NUMERIC,
        2
    ) AS duracion_promedio_minutos,

    ROUND(
        MAX(
            EXTRACT(EPOCH FROM m.duracion) / 60
        )::NUMERIC,
        2
    ) AS duracion_maxima_minutos,

    ROUND(
        MIN(
            EXTRACT(EPOCH FROM m.duracion) / 60
        )::NUMERIC,
        2
    ) AS duracion_minima_minutos

FROM programaciones p

LEFT JOIN movimientos m
       ON m.programacion_id = p.id

INNER JOIN estados e
        ON e.id = p.estado_id;

-- ======================================================
-- VISTA: DASHBOARD PRINCIPAL
-- ======================================================

CREATE OR REPLACE VIEW vw_dashboard AS

SELECT

    p.id AS programacion_id,

    c.serial AS contenedor,

    tc.nombre AS tipo_contenedor,

    e.codigo AS codigo_estado,

    e.nombre AS estado,

    uo.nombre AS origen,

    ud.nombre AS destino,

    p.fecha_programada,

    v.placa,

    t.nombre AS transportadora,

    m.inicio_real,

    m.fin_real,

    m.duracion,

    CASE

        WHEN e.codigo = 'FINALIZADO'
            THEN 'Finalizado'

        WHEN e.codigo = 'REPROGRAMADO'
            THEN 'Reprogramado'

        WHEN m.inicio_real IS NULL
            THEN 'Pendiente'

        ELSE 'En proceso'

    END AS estado_operacion,

    CASE

        WHEN m.inicio_real IS NOT NULL
         AND m.fin_real IS NULL

            THEN ROUND(
                EXTRACT(EPOCH FROM (NOW() - m.inicio_real))/60,
                2
            )

        ELSE ROUND(
            EXTRACT(EPOCH FROM m.duracion)/60,
            2
        )

    END AS minutos_operacion,

    p.created_at,

    p.updated_at

FROM programaciones p

INNER JOIN contenedores c
        ON c.id = p.contenedor_id

INNER JOIN tipos_contenedor tc
        ON tc.id = c.tipo_contenedor_id

INNER JOIN estados e
        ON e.id = p.estado_id

INNER JOIN ubicaciones uo
        ON uo.id = p.ubicacion_origen_id

INNER JOIN ubicaciones ud
        ON ud.id = p.ubicacion_destino_id

LEFT JOIN asignaciones a
       ON a.programacion_id = p.id

LEFT JOIN vehiculos v
       ON v.id = a.vehiculo_id

LEFT JOIN transportadoras t
       ON t.id = v.transportadora_id

LEFT JOIN movimientos m
       ON m.programacion_id = p.id

ORDER BY

    p.fecha_programada DESC,
    p.created_at DESC;

