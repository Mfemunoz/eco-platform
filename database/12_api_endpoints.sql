/*
==========================================================
ECO PLATFORM
Archivo: 12_api_endpoints.sql
Versión: 1.0

Descripción:
Documentación de endpoints consumidos por aplicaciones.
Supabase REST + RPC Functions.

==========================================================
*/


SET search_path TO eco, public;



-- ======================================================
-- ENDPOINTS DE CONSULTA
-- ======================================================


/*
----------------------------------------------------------
DASHBOARD PRINCIPAL

Método:
GET

Origen:
vw_dashboard

Uso:
App móvil
Dashboard Web

Ejemplo Flutter:

supabase
.from('vw_dashboard')
.select();

----------------------------------------------------------
*/


COMMENT ON VIEW vw_dashboard IS

'API READ:
Dashboard principal ECO.
Consulta operaciones actuales, estados, vehículos y tiempos';



/*
----------------------------------------------------------
OPERACIONES ACTIVAS

Método:
GET

Origen:
vw_operaciones_activas

----------------------------------------------------------
*/


COMMENT ON VIEW vw_operaciones_activas IS

'API READ:
Consulta operaciones actualmente activas';



/*
----------------------------------------------------------
CICLOS OPERATIVOS

Método:
GET

Origen:
vw_ciclos_operativos

----------------------------------------------------------
*/


COMMENT ON VIEW vw_ciclos_operativos IS

'API READ:
Seguimiento histórico de ciclos operativos';



/*
----------------------------------------------------------
REPROGRAMACIONES

Método:
GET

Origen:
vw_reprogramaciones

----------------------------------------------------------
*/


COMMENT ON VIEW vw_reprogramaciones IS

'API READ:
Consulta operaciones reprogramadas';



/*
----------------------------------------------------------
KPIS

Método:
GET

Origen:
vw_kpi_operacion

----------------------------------------------------------
*/


COMMENT ON VIEW vw_kpi_operacion IS

'API READ:
Indicadores operativos ECO';



-- ======================================================
-- ENDPOINTS RPC
-- FUNCIONES DE NEGOCIO
-- ======================================================



/*
==========================================================
CREAR PROGRAMACIÓN

Método:

POST

RPC:

registrar_programacion


Parametros:

p_contenedor_id
p_fecha_programada
p_origen_id
p_destino_id
p_usuario_id
p_observacion


Respuesta:

UUID programación creada

==========================================================
*/


COMMENT ON FUNCTION registrar_programacion IS

'API RPC:
Crear una nueva programación operativa';



/*
==========================================================
ASIGNAR VEHÍCULO

Método:

POST

RPC:

asignar_vehiculo


Parametros:

p_programacion_id
p_vehiculo_id
p_usuario_id
p_observacion


Respuesta:

UUID asignación creada

==========================================================
*/


COMMENT ON FUNCTION asignar_vehiculo IS

'API RPC:
Asignar vehículo a una programación';



/*
==========================================================
REGISTRAR EVENTO

Método:

POST

RPC:

registrar_evento


Parametros:

p_movimiento_id
p_tipo_evento_id
p_usuario_id
p_causal_id
p_observacion
p_evidencia_url
p_latitud
p_longitud


Respuesta:

UUID evento creado

==========================================================
*/


COMMENT ON FUNCTION registrar_evento IS

'API RPC:
Registrar evento operativo con evidencia';



/*
==========================================================
CERRAR MOVIMIENTO

Método:

POST

RPC:

cerrar_movimiento


Parametros:

p_movimiento_id
p_usuario_id


Respuesta:

BOOLEAN

==========================================================
*/


COMMENT ON FUNCTION cerrar_movimiento IS

'API RPC:
Cerrar ciclo operativo y calcular duración';



/*
==========================================================
REPROGRAMAR OPERACIÓN

Método:

POST

RPC:

reprogramar_operacion


Parametros:

p_programacion_id
p_nueva_fecha
p_usuario_id
p_observacion


Respuesta:

BOOLEAN

==========================================================
*/


COMMENT ON FUNCTION reprogramar_operacion IS

'API RPC:
Modificar fecha y estado de operación';



-- ======================================================
-- STORAGE
-- ======================================================


COMMENT ON TABLE eventos IS

'Storage:
Bucket evidencias.
La URL del archivo se almacena en evidencia_url';



-- ======================================================
-- SEGURIDAD API
-- ======================================================


/*

Todas las llamadas requieren:

Authorization:
Bearer JWT

Proveedor:

Supabase Auth


Control:

Row Level Security

*/


-- ======================================================
-- FIN
-- ======================================================