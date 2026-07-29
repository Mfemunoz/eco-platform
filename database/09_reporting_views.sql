/*
==========================================================
ECO PLATFORM
Archivo: 09_reporting_views.sql
Versión: 1.1
Reporting & Business Intelligence
==========================================================
*/

SET search_path TO eco, public;


-- ======================================================
-- FACT OPERACIONES
-- ======================================================

CREATE OR REPLACE VIEW vw_fact_operaciones AS

SELECT

    p.id                                   AS programacion_id,

    p.fecha_programada,

    DATE(p.fecha_programada)               AS fecha,

    EXTRACT(YEAR FROM p.fecha_programada)  AS anio,

    EXTRACT(MONTH FROM p.fecha_programada) AS mes,

    EXTRACT(WEEK FROM p.fecha_programada)  AS semana,

    EXTRACT(DAY FROM p.fecha_programada)   AS dia,


    c.serial                               AS contenedor,

    tc.descripcion                         AS tipo_contenedor,


    uo.nombre                              AS origen,

    ud.nombre                              AS destino,


    e.codigo,

    e.nombre                               AS estado,


    t.nombre                               AS transportadora,

    v.placa,


    mov.inicio_real,

    mov.fin_real,

    mov.duracion,


    ROUND(
        EXTRACT(EPOCH FROM mov.duracion)/60,
        2
    ) AS duracion_minutos,


    CASE
        WHEN e.codigo='FINALIZADO'
        THEN 1
        ELSE 0
    END AS indicador_finalizado,


    CASE
        WHEN e.codigo='REPROGRAMADO'
        THEN 1
        ELSE 0
    END AS indicador_reprogramado,


    CASE
        WHEN mov.fin_real IS NULL
        THEN 1
        ELSE 0
    END AS indicador_activo,


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



-- ======================================================
-- TIMELINE EVENTOS
-- ======================================================

CREATE OR REPLACE VIEW vw_eventos_timeline AS

SELECT

    p.id                AS programacion_id,

    c.serial,

    te.codigo,

    te.nombre           AS evento,

    ev.fecha_hora,

    u.nombre            AS usuario,

    ca.nombre           AS causal,

    ev.observacion,

    ev.evidencia_url


FROM eventos ev


INNER JOIN movimientos m
        ON m.id=ev.movimiento_id


INNER JOIN programaciones p
        ON p.id=m.programacion_id


INNER JOIN contenedores c
        ON c.id=p.contenedor_id


INNER JOIN tipos_evento te
        ON te.id=ev.tipo_evento_id


INNER JOIN usuarios u
        ON u.id=ev.usuario_id


LEFT JOIN causales ca
       ON ca.id=ev.causal_id;



-- ======================================================
-- PRODUCTIVIDAD TRANSPORTADORAS
-- ======================================================

CREATE OR REPLACE VIEW vw_productividad_transportadoras AS

SELECT

    t.id,

    t.nombre,


    COUNT(DISTINCT p.id) AS total_operaciones,


    ROUND(
        AVG(
            EXTRACT(EPOCH FROM m.duracion)/60
        )::NUMERIC,
        2
    ) AS promedio_minutos,


    COUNT(*) FILTER
    (
        WHERE e.codigo='FINALIZADO'
    ) AS finalizadas,


    COUNT(*) FILTER
    (
        WHERE e.codigo='REPROGRAMADO'
    ) AS reprogramadas


FROM transportadoras t


LEFT JOIN vehiculos v
       ON v.transportadora_id=t.id


LEFT JOIN asignaciones a
       ON a.vehiculo_id=v.id


LEFT JOIN programaciones p
       ON p.id=a.programacion_id


LEFT JOIN movimientos m
       ON m.programacion_id=p.id


LEFT JOIN estados e
       ON e.id=p.estado_id


GROUP BY

t.id,

t.nombre;



-- ======================================================
-- UTILIZACIÓN VEHÍCULOS
-- ======================================================

CREATE OR REPLACE VIEW vw_utilizacion_vehiculos AS

SELECT

    v.id,

    v.placa,


    t.nombre AS transportadora,


    COUNT(DISTINCT p.id) AS operaciones,


    ROUND(
        AVG(
            EXTRACT(EPOCH FROM m.duracion)/60
        )::NUMERIC,
        2
    ) AS promedio_minutos,


    MAX(m.fin_real) AS ultimo_movimiento,


    SUM(
        EXTRACT(EPOCH FROM m.duracion)
    )/3600 AS horas_trabajadas


FROM vehiculos v


LEFT JOIN transportadoras t
       ON t.id=v.transportadora_id


LEFT JOIN asignaciones a
       ON a.vehiculo_id=v.id


LEFT JOIN programaciones p
       ON p.id=a.programacion_id


LEFT JOIN movimientos m
       ON m.programacion_id=p.id


GROUP BY

v.id,

v.placa,

t.nombre;



-- ======================================================
-- DASHBOARD CAUSALES
-- ======================================================

CREATE OR REPLACE VIEW vw_causales AS

SELECT

    ca.codigo,

    ca.nombre,


    COUNT(*) AS cantidad,


    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS porcentaje,


    MAX(ev.fecha_hora) AS ultima_ocurrencia


FROM eventos ev


INNER JOIN causales ca
        ON ca.id=ev.causal_id


GROUP BY

ca.codigo,

ca.nombre;



-- ======================================================
-- FIN
-- ======================================================