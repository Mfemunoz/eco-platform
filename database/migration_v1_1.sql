/*
==========================================================
ECO PLATFORM
Archivo: 09_migration_v1_1.sql
Versión: 1.1
Descripción:
Mejoras al modelo de datos.
- Auditoría de usuarios.
- Preparación para backend.
==========================================================
*/

SET search_path TO eco, public;

-- ======================================================
-- AUDITORÍA
-- ======================================================

ALTER TABLE usuarios
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE transportadoras
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE vehiculos
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE ubicaciones
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE estados
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE tipos_evento
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE tipos_contenedor
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE causales
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE contenedores
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE programaciones
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE asignaciones
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE movimientos
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

ALTER TABLE eventos
ADD COLUMN created_by UUID,
ADD COLUMN updated_by UUID;

-- ======================================================
-- FOREIGN KEYS PARA AUDITORÍA
-- ======================================================

ALTER TABLE transportadoras
ADD CONSTRAINT fk_transportadoras_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE transportadoras
ADD CONSTRAINT fk_transportadoras_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE vehiculos
ADD CONSTRAINT fk_vehiculos_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE vehiculos
ADD CONSTRAINT fk_vehiculos_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE ubicaciones
ADD CONSTRAINT fk_ubicaciones_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE ubicaciones
ADD CONSTRAINT fk_ubicaciones_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE estados
ADD CONSTRAINT fk_estados_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE estados
ADD CONSTRAINT fk_estados_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE tipos_evento
ADD CONSTRAINT fk_tipos_evento_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE tipos_evento
ADD CONSTRAINT fk_tipos_evento_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE tipos_contenedor
ADD CONSTRAINT fk_tipos_contenedor_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE tipos_contenedor
ADD CONSTRAINT fk_tipos_contenedor_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE causales
ADD CONSTRAINT fk_causales_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE causales
ADD CONSTRAINT fk_causales_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE contenedores
ADD CONSTRAINT fk_contenedores_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE contenedores
ADD CONSTRAINT fk_contenedores_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE programaciones
ADD CONSTRAINT fk_programaciones_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE programaciones
ADD CONSTRAINT fk_programaciones_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE asignaciones
ADD CONSTRAINT fk_asignaciones_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE movimientos
ADD CONSTRAINT fk_movimientos_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE movimientos
ADD CONSTRAINT fk_movimientos_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_created_by
FOREIGN KEY (created_by)
REFERENCES usuarios(id);

ALTER TABLE eventos
ADD CONSTRAINT fk_eventos_updated_by
FOREIGN KEY (updated_by)
REFERENCES usuarios(id);