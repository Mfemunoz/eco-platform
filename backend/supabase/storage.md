# ECO PLATFORM

# Storage

## Objetivo

Definir la estrategia de almacenamiento de archivos para la plataforma ECO.

Supabase Storage será utilizado para almacenar:

- Fotografías de contenedores
- Evidencias de cargue
- Evidencias de descargue
- Documentos asociados a la operación

---

# Bucket Principal

Nombre:

evidencias

Acceso:

Privado

Solo usuarios autenticados podrán acceder a los archivos.

---

# Organización

evidencias/

    contenedores/

        {contenedor}/

            ingreso/

            cargue/

            salida/

            destino/

---

# Formatos permitidos

Imágenes

- JPG
- JPEG
- PNG
- WEBP

Documentos

- PDF

---

# Tamaño máximo

20 MB por archivo.

---

# Convención de nombres

eventoId_fechaHora.extension

Ejemplo

8e91d3a1_20260730_101530.jpg

---

# Flujo

Operador

↓

Selecciona evento

↓

Toma fotografía

↓

Flutter

↓

Supabase Storage

↓

Se obtiene URL

↓

URL almacenada en eventos.evidencia_url

---

# Eliminación

Las evidencias no serán eliminadas automáticamente.

Se conservarán para auditoría.

---

# Seguridad

Bucket privado.

Acceso únicamente mediante usuarios autenticados.

Las políticas de Storage controlarán quién puede:

- Subir archivos
- Descargar archivos
- Visualizar archivos

---

# Versiones futuras

Se podrán almacenar:

- Videos
- Firmas digitales
- Documentos de transporte
- Actas

---

# Estado

Versión:

1.0

Estado:

En construcción
