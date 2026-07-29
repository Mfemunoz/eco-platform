# ECO PLATFORM

# Variables de Entorno

## Objetivo

Este documento describe las variables de entorno requeridas para la plataforma ECO.

Estas variables no deben almacenarse en el repositorio con valores reales.

---

# Supabase

## URL del proyecto

SUPABASE_URL=

Descripción:

URL pública del proyecto Supabase.

Ejemplo:

https://xxxxxxxx.supabase.co

---

## Clave pública

SUPABASE_ANON_KEY=

Descripción:

Llave pública utilizada por Flutter y el Dashboard Web.

Esta llave puede distribuirse dentro de las aplicaciones.

---

## Service Role

SUPABASE_SERVICE_ROLE_KEY=

Descripción:

Llave privada utilizada únicamente por procesos administrativos.

Nunca debe exponerse en Flutter ni en aplicaciones cliente.

---

# Base de Datos

DATABASE_URL=

Descripción:

Cadena de conexión PostgreSQL.

Formato:

postgresql://usuario:password@host:5432/database

---

# Realtime

SUPABASE_REALTIME_ENABLED=true

---

# Storage

SUPABASE_STORAGE_BUCKET=evidencias

Descripción:

Bucket donde se almacenarán fotografías y documentos de soporte de los eventos.

---

# Ambientes

## Desarrollo

Variables utilizadas para desarrollo local.

---

## Testing

Variables utilizadas para pruebas.

---

## Producción

Variables utilizadas en producción.

Cada ambiente tendrá sus propias credenciales.

---

# Seguridad

Nunca subir al repositorio:

- Contraseñas
- Service Role Key
- Tokens
- Secretos

Estos valores deben almacenarse mediante variables de entorno.

---

# Estado

Versión: 1.0

Estado: En construcción
