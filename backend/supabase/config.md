# ECO PLATFORM

# Configuración de Supabase

## Objetivo

Este documento define la configuración técnica de Supabase para la plataforma ECO (Eficiencia en Ciclos Operativos).

Supabase será el Backend as a Service (BaaS) encargado de proporcionar:

- Base de datos PostgreSQL
- Autenticación de usuarios
- Almacenamiento de evidencias
- API REST automática
- API Realtime
- Seguridad mediante Row Level Security (RLS)

---

# Arquitectura

Flutter App
│
▼
Supabase SDK
│
▼
────────────────────────────────────
Authentication
PostgreSQL
Storage
Realtime
────────────────────────────────────
│
▼
Business Logic (Funciones SQL + Views)

---

# Información del proyecto

Nombre del proyecto:

ECO PLATFORM

Descripción:

Sistema para la gestión de ciclos operativos de contenedores.

Repositorio:

eco-platform

---

# Región

Se recomienda crear el proyecto en:

South America (São Paulo)

Motivos:

- Baja latencia para Colombia.
- Alta disponibilidad.
- Cercanía geográfica.
- Mejor rendimiento para usuarios nacionales.

---

# Base de datos

Motor:

PostgreSQL

Esquema principal:

eco

Extensiones utilizadas:

- pgcrypto

---

# Servicios habilitados

- PostgreSQL
- Authentication
- Storage
- Realtime
- REST API

---

# Ambientes

Se manejarán tres ambientes:

Desarrollo

Testing

Producción

Inicialmente se trabajará únicamente sobre Desarrollo.

---

# Convenciones

Todas las tablas:

UUID como llave primaria.

Todas las fechas:

UTC.

Soft Delete:

No implementado en la versión MVP.

Auditoría:

Implementada mediante audit_log.

---

# Estado

Versión:

1.0

Estado:

En construcción.
