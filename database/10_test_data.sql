/*
==========================================================
ECO PLATFORM
Archivo: 10_test_data.sql
Versión: 1.0
Descripción:
Datos de prueba operación completa ECO.
==========================================================
*/

SET search_path TO eco, public;


DO $$

DECLARE

    v_usuario UUID;

    v_transportadora UUID;

    v_vehiculo UUID;

    v_tipo_contenedor UUID;

    v_estado_programado UUID;

    v_estado_asignado UUID;

    v_estado_finalizado UUID;

    v_tipo_evento_ingreso UUID;

    v_tipo_evento_salida UUID;

    v_tipo_evento_cierre UUID;

    v_ubicacion_origen UUID;

    v_ubicacion_destino UUID;

    v_contenedor UUID;

    v_programacion UUID;

    v_asignacion UUID;

    v_movimiento UUID;


BEGIN


-- ======================================================
-- USUARIO
-- ======================================================

SELECT id
INTO v_usuario
FROM usuarios
WHERE correo='admin@eco.local';



-- ======================================================
-- TRANSPORTADORA
-- ======================================================

INSERT INTO transportadoras
(
    nombre,
    nit,
    telefono,
    email,
    created_by
)
VALUES
(
    'Transportadora ECO Test',
    '900999999-1',
    '3000000000',
    'test@eco.com',
    v_usuario
)

RETURNING id INTO v_transportadora;



-- ======================================================
-- VEHICULO
-- ======================================================

INSERT INTO vehiculos
(
    placa,
    tipo,
    transportadora_id,
    capacidad_teu,
    created_by
)
VALUES
(
    'ECO001',
    'TURBO',
    v_transportadora,
    1.00,
    v_usuario
)

RETURNING id INTO v_vehiculo;



-- ======================================================
-- TIPO CONTENEDOR
-- ======================================================

SELECT id
INTO v_tipo_contenedor
FROM tipos_contenedor
WHERE codigo='40HC';



-- ======================================================
-- ESTADOS
-- ======================================================

SELECT id
INTO v_estado_programado
FROM estados
WHERE codigo='PROGRAMADO';


SELECT id
INTO v_estado_asignado
FROM estados
WHERE codigo='ASIGNADO';


SELECT id
INTO v_estado_finalizado
FROM estados
WHERE codigo='FINALIZADO';



-- ======================================================
-- UBICACIONES
-- ======================================================

SELECT id
INTO v_ubicacion_origen
FROM ubicaciones
WHERE nombre='Puerto Buenaventura';


SELECT id
INTO v_ubicacion_destino
FROM ubicaciones
WHERE nombre='Centro de Distribución';



-- ======================================================
-- CONTENEDOR
-- ======================================================

INSERT INTO contenedores
(
    serial,
    tipo_contenedor_id,
    estado_actual_id,
    created_by
)
VALUES
(
    'ECOCONT001',
    v_tipo_contenedor,
    v_estado_programado,
    v_usuario
)

RETURNING id INTO v_contenedor;



-- ======================================================
-- PROGRAMACION
-- ======================================================

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
    v_contenedor,
    v_estado_programado,
    CURRENT_TIMESTAMP,
    v_ubicacion_origen,
    v_ubicacion_destino,
    'Movimiento de prueba ECO',
    v_usuario
)

RETURNING id INTO v_programacion;



-- ======================================================
-- ASIGNACION
-- ======================================================

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
    v_programacion,
    v_vehiculo,
    v_usuario,
    v_estado_asignado,
    'Asignación prueba ECO',
    v_usuario
)

RETURNING id INTO v_asignacion;



-- ======================================================
-- MOVIMIENTO
-- ======================================================

INSERT INTO movimientos
(
    programacion_id,
    estado_id,
    inicio_real,
    fin_real,
    duracion,
    observacion,
    created_by
)
VALUES
(
    v_programacion,
    v_estado_finalizado,
    CURRENT_TIMESTAMP - INTERVAL '4 hours',
    CURRENT_TIMESTAMP,
    INTERVAL '4 hours',
    'Ciclo operativo prueba',
    v_usuario
)

RETURNING id INTO v_movimiento;



-- ======================================================
-- EVENTOS
-- ======================================================


SELECT id
INTO v_tipo_evento_ingreso
FROM tipos_evento
WHERE codigo='ING_PATIO';


SELECT id
INTO v_tipo_evento_salida
FROM tipos_evento
WHERE codigo='SAL_PATIO';


SELECT id
INTO v_tipo_evento_cierre
FROM tipos_evento
WHERE codigo='CIERRE';



INSERT INTO eventos
(
    movimiento_id,
    tipo_evento_id,
    usuario_id,
    fecha_hora,
    observacion,
    created_by
)
VALUES

(
    v_movimiento,
    v_tipo_evento_ingreso,
    v_usuario,
    CURRENT_TIMESTAMP - INTERVAL '4 hours',
    'Ingreso patio prueba',
    v_usuario
),

(
    v_movimiento,
    v_tipo_evento_salida,
    v_usuario,
    CURRENT_TIMESTAMP - INTERVAL '3 hours',
    'Salida patio prueba',
    v_usuario
),

(
    v_movimiento,
    v_tipo_evento_cierre,
    v_usuario,
    CURRENT_TIMESTAMP,
    'Cierre operación prueba',
    v_usuario
);



RAISE NOTICE 'Datos de prueba ECO creados correctamente';


END $$;