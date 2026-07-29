/*
==========================================================
ECO PLATFORM
Archivo: 02_tables.sql
Versión: 1.0
Descripción:
Creación de las tablas principales del sistema.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- TABLA: ROLES
-- ======================================================

CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: USUARIOS
-- ======================================================

CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nombre VARCHAR(150) NOT NULL,
    correo VARCHAR(150) NOT NULL,

    rol_id UUID NOT NULL,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: TRANSPORTADORAS
-- ======================================================

CREATE TABLE transportadoras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nombre VARCHAR(120) NOT NULL,
    nit VARCHAR(30) NOT NULL,

    telefono VARCHAR(30),
    email VARCHAR(120),

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: VEHICULOS
-- ======================================================

CREATE TABLE vehiculos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    placa VARCHAR(10) NOT NULL,

    tipo VARCHAR(50) NOT NULL,

    transportadora_id UUID NOT NULL,

    capacidad_teu NUMERIC(5,2),

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: UBICACIONES
-- ======================================================

CREATE TABLE ubicaciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    nombre VARCHAR(120) NOT NULL,

    tipo VARCHAR(30) NOT NULL,

    descripcion TEXT,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: ESTADOS
-- ======================================================

CREATE TABLE estados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    codigo VARCHAR(30) NOT NULL,

    nombre VARCHAR(80) NOT NULL,

    descripcion TEXT,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: TIPOS_EVENTO
-- ======================================================

CREATE TABLE tipos_evento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    codigo VARCHAR(30) NOT NULL,

    nombre VARCHAR(100) NOT NULL,

    descripcion TEXT,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: TIPOS_CONTENEDOR
-- ======================================================

CREATE TABLE tipos_contenedor (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    codigo VARCHAR(20) NOT NULL,

    descripcion VARCHAR(100) NOT NULL,

    capacidad_teu NUMERIC(5,2),

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: CAUSALES
-- ======================================================

CREATE TABLE causales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: CONTENEDORES
-- ======================================================

CREATE TABLE contenedores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    serial VARCHAR(50) NOT NULL,

    tipo_contenedor_id UUID NOT NULL,

    estado_actual_id UUID NOT NULL,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: PROGRAMACIONES
-- ======================================================

CREATE TABLE programaciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    contenedor_id UUID NOT NULL,

    fecha_programada DATE NOT NULL,

    ubicacion_origen_id UUID NOT NULL,
    ubicacion_destino_id UUID NOT NULL,

    observacion TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: ASIGNACIONES
-- ======================================================

CREATE TABLE asignaciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    programacion_id UUID NOT NULL,

    vehiculo_id UUID NOT NULL,

    usuario_id UUID NOT NULL,

    estado_id UUID NOT NULL,

    fecha_asignacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    observacion TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: MOVIMIENTOS
-- ======================================================

CREATE TABLE movimientos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    programacion_id UUID NOT NULL,

    estado_id UUID NOT NULL,

    inicio_real TIMESTAMP,
    fin_real TIMESTAMP,

    observacion TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: EVENTOS
-- ======================================================

CREATE TABLE eventos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    movimiento_id UUID NOT NULL,

    tipo_evento_id UUID NOT NULL,

    usuario_id UUID NOT NULL,

    causal_id UUID,

    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    observacion TEXT,

    evidencia_url TEXT,

    latitud NUMERIC(10,7),
    longitud NUMERIC(10,7),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- TABLA: AUDIT_LOG
-- ======================================================

CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    tabla VARCHAR(100) NOT NULL,

    registro_id UUID NOT NULL,

    accion VARCHAR(30) NOT NULL,

    usuario_id UUID,

    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    datos JSONB
);

