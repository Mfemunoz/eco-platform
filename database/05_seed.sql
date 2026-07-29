/*
==========================================================
ECO PLATFORM
Archivo: 05_seed.sql
Versión: 2.0
Descripción:
Carga inicial de catálogos del sistema.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- ROLES
-- ======================================================

INSERT INTO roles (nombre, descripcion)
VALUES
('Administrador','Acceso total al sistema'),
('Coordinador Transporte','Gestiona la operación logística'),
('Analista Transporte','Administra las programaciones'),
('Operador Patio','Registra movimientos en patio'),
('Operador Muelle','Registra operaciones de muelle'),
('Supervisor','Supervisa la operación'),
('Consulta','Usuario con acceso de solo lectura')
ON CONFLICT (nombre) DO NOTHING;

-- ======================================================
-- ESTADOS
-- ======================================================

INSERT INTO estados (codigo, nombre, descripcion)
VALUES
('PROGRAMADO','Programado','Movimiento programado'),
('ASIGNADO','Asignado','Vehículo asignado'),
('EN_PATIO','En Patio','Contenedor ubicado en patio'),
('EN_MUELLE','En Muelle','Contenedor en muelle'),
('EN_CARGUE','En Cargue','Proceso de cargue'),
('EN_TRANSITO','En Tránsito','Vehículo en tránsito'),
('DESCARGANDO','Descargando','Proceso de descargue'),
('FINALIZADO','Finalizado','Operación completada'),
('REPROGRAMADO','Reprogramado','Movimiento reprogramado'),
('CANCELADO','Cancelado','Movimiento cancelado')
ON CONFLICT (codigo) DO NOTHING;

-- ======================================================
-- TIPOS DE CONTENEDOR
-- ======================================================

INSERT INTO tipos_contenedor
(codigo, descripcion, capacidad_teu)
VALUES
('20GP','Contenedor 20 Pies Dry',1.00),
('40GP','Contenedor 40 Pies Dry',2.00),
('40HC','Contenedor 40 Pies High Cube',2.00)
ON CONFLICT (codigo) DO NOTHING;

-- ======================================================
-- TIPOS DE EVENTO
-- ======================================================

INSERT INTO tipos_evento
(codigo, nombre, descripcion)
VALUES
('ING_PATIO','Ingreso a Patio','Ingreso del contenedor al patio'),
('SAL_PATIO','Salida de Patio','Salida del patio hacia muelle'),
('LLEG_MUELLE','Llegada a Muelle','Ingreso al muelle de cargue'),
('INI_CARGUE','Inicio Cargue','Inicio del cargue del contenedor'),
('FIN_CARGUE','Fin Cargue','Finalización del cargue'),
('SAL_CD','Salida CD','Salida del Centro de Distribución'),
('LLEG_DESTINO','Llegada Destino','Llegada al destino final'),
('REPROGRAMACION','Reprogramación','Cambio de programación'),
('CAMBIO_VEHICULO','Cambio Vehículo','Cambio del vehículo asignado'),
('NOVEDAD','Novedad','Registro de una novedad'),
('CIERRE','Cierre Operación','Finalización de la operación')
ON CONFLICT (codigo) DO NOTHING;

-- ======================================================
-- CAUSALES
-- ======================================================

INSERT INTO causales
(codigo, nombre, descripcion)
VALUES
('TRAFICO','Tráfico','Congestión vial'),
('ACCIDENTE','Accidente','Accidente en la vía'),
('AVERIA','Avería Vehículo','Falla mecánica del vehículo'),
('CLIMA','Condiciones Climáticas','Lluvia o condiciones climáticas'),
('PERSONAL','Falta de Personal','No hay personal disponible'),
('DOCUMENTOS','Documentación','Documentación incompleta'),
('PROVEEDOR','Retraso Proveedor','Demora del proveedor'),
('CLIENTE','Cliente','Novedad generada por el cliente'),
('MANTENIMIENTO','Mantenimiento','Mantenimiento operativo'),
('OPERACION','Operación Interna','Novedad interna del centro logístico'),
('OTRO','Otro','Otra causal')
ON CONFLICT (codigo) DO NOTHING;

-- ======================================================
-- UBICACIONES
-- ======================================================

INSERT INTO ubicaciones
(nombre, tipo, descripcion)
VALUES
('Patio Norte','PATIO','Patio principal de almacenamiento'),
('Patio Sur','PATIO','Patio alterno de almacenamiento'),
('Muelle 1','MUELLE','Muelle de cargue No. 1'),
('Muelle 2','MUELLE','Muelle de cargue No. 2'),
('Muelle 3','MUELLE','Muelle de cargue No. 3'),
('Centro de Distribución','CD','Centro de distribución principal'),
('Puerto Buenaventura','PUERTO','Puerto de origen de los contenedores')
ON CONFLICT DO NOTHING;

-- ======================================================
-- USUARIO ADMINISTRADOR INICIAL
-- ======================================================

INSERT INTO usuarios
(
    nombre,
    correo,
    rol_id
)
SELECT
    'Administrador ECO',
    'admin@eco.local',
    id
FROM roles
WHERE nombre = 'Administrador'
ON CONFLICT (correo) DO NOTHING;

-- ======================================================
-- MENSAJE FINAL
-- ======================================================

DO $$
BEGIN
    RAISE NOTICE 'Seed inicial de ECO Platform ejecutado correctamente.';
END $$;