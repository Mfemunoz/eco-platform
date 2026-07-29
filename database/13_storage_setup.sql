/*
==========================================================
ECO PLATFORM
Archivo: 13_storage_setup.sql
Versión: 1.1

Descripción:
Configuración Supabase Storage.

Bucket:
evidencias

==========================================================
*/


-- ======================================================
-- CREAR BUCKET
-- ======================================================


INSERT INTO storage.buckets
(
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
)

VALUES

(
    'evidencias',
    'evidencias',
    false,
    20971520,
    ARRAY[
        'image/jpeg',
        'image/png',
        'image/webp',
        'application/pdf'
    ]
)

ON CONFLICT (id)
DO NOTHING;



-- ======================================================
-- FIN
-- ======================================================