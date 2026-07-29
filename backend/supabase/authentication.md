# ECO PLATFORM

# Autenticación

## Objetivo

Definir el modelo de autenticación y autorización para la plataforma ECO.

La autenticación será gestionada mediante Supabase Authentication.

---

# Proveedor de autenticación

Supabase Auth

Método inicial:

- Correo electrónico
- Contraseña

Versiones futuras:

- Microsoft Entra ID (Azure AD)
- Google
- Single Sign-On (SSO)

---

# Flujo de autenticación

Usuario

↓

Pantalla Login

↓

Supabase Authentication

↓

JWT

↓

Acceso a la aplicación

↓

Consulta de información mediante RLS

---

# Tipos de usuarios

## Administrador

Permisos:

- Administración total
- Crear usuarios
- Eliminar usuarios
- Configuración del sistema
- Consultar auditoría

---

## Coordinador

Permisos:

- Crear programaciones
- Reprogramar operaciones
- Asignar vehículos
- Consultar indicadores
- Consultar historial

---

## Operador

Permisos:

- Registrar eventos
- Subir evidencias
- Consultar operaciones asignadas

---

## Consulta

Permisos:

- Solo lectura
- Dashboard
- KPIs
- Reportes

---

# Sesiones

La sesión será administrada por Supabase.

El token JWT será renovado automáticamente.

---

# Seguridad

Las contraseñas nunca serán almacenadas en la base de datos del proyecto.

Supabase gestionará:

- Hash
- Recuperación
- Cambio de contraseña
- Verificación de correo

---

# Relación con la tabla usuarios

Supabase Auth

↓

auth.users

↓

usuarios (schema eco)

Relación:

auth.users.id = usuarios.id

---

# Row Level Security

Todas las consultas utilizarán RLS.

El acceso dependerá del rol registrado en la tabla usuarios.

---

# Estado

Versión:

1.0

Estado:

En construcción
