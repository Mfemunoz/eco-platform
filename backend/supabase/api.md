# ECO PLATFORM

# API

## Objetivo

Documentar los recursos que serán consumidos por las aplicaciones de la plataforma ECO.

Flutter y el Dashboard Web consumirán principalmente:

- Vistas
- Funciones
- Tablas de configuración

La lógica de negocio permanecerá en PostgreSQL.

---

# Tablas

## usuarios

Uso:

Información de usuarios del sistema.

---

## programaciones

Uso:

Registro de operaciones.

---

## movimientos

Uso:

Seguimiento del ciclo operativo.

---

## eventos

Uso:

Registro cronológico de eventos.

---

## contenedores

Uso:

Información del contenedor.

---

## vehiculos

Uso:

Información del vehículo.

---

# Funciones

## registrar_programacion()

Crear una nueva programación.

---

## asignar_vehiculo()

Asignar vehículo.

---

## registrar_evento()

Registrar un evento operativo.

---

## cerrar_movimiento()

Cerrar un ciclo operativo.

---

## reprogramar_operacion()

Reprogramar una operación.

---

# Views

## vw_dashboard

Dashboard principal.

---

## vw_operaciones_activas

Operaciones en ejecución.

---

## vw_ciclos_operativos

Seguimiento completo del ciclo.

---

## vw_reprogramaciones

Consulta de reprogramaciones.

---

## vw_kpi_operacion

Indicadores ejecutivos.

---

# Consumo desde Flutter

Ejemplos

Obtener Dashboard

SELECT \* FROM vw_dashboard;

---

Registrar evento

SELECT registrar_evento(...);

---

Crear programación

SELECT registrar_programacion(...);

---

Consultar KPIs

SELECT \* FROM vw_kpi_operacion;

---

# Seguridad

Todo acceso se realizará mediante:

Supabase Authentication

-

Row Level Security

---

# Versiones futuras

API REST

Realtime

Notificaciones Push

Integración Power BI

Integración SAP

Integración TMS

---

# Estado

Versión:

1.0

Estado:

En construcción.
