-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

CREATE TABLE styles (
    id_styles      INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_estilo  TEXT NOT NULL UNIQUE,
    horas_totales  INTEGER NOT NULL CHECK(horas_totales > 0)
);

CREATE TABLE students (
    id_students         INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_estudiante   TEXT NOT NULL,
    apellido_estudiante TEXT NOT NULL,
    cedula_estudiante   INTEGER NOT NULL UNIQUE,
    edad                INTEGER NOT NULL CHECK(edad >= 16),
    telefono_contacto   TEXT NULL,
    estado_matricula    TEXT NOT NULL DEFAULT 'Activo',
    style_id            INTEGER NOT NULL,
    FOREIGN KEY (style_id) REFERENCES styles(id_styles) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

INSERT INTO styles (nombre_estilo, horas_totales) VALUES
    ('Salsa', 120),
    ('Bachata', 90),
    ('Hip Hop', 150);

INSERT INTO students (nombre_estudiante, apellido_estudiante, cedula_estudiante, edad, telefono_contacto, style_id) VALUES
    ('Juan', 'Rodriguez', 1023456789, 20, '3112345678', 1),
    ('Camila', 'Gomez', 1034567891, 19, NULL, 2),
    ('Andres', 'Martinez', 1045678912, 25, '3229876543', 1),
    ('Valentina', 'Lopez', 1056789123, 22, NULL, 3),
    ('Santiago', 'Herrera', 1067891234, 17, '3004561234', 2),
    ('Mariana', 'Casas', 1078912345, 30, '3157894561', 3);

-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

SELECT id_students, nombre_estudiante, apellido_estudiante
FROM students
WHERE telefono_contacto IS NULL;

SELECT
    nombre_estudiante,
    apellido_estudiante,
    COALESCE(telefono_contacto, 'Sin teléfono registrado') AS telefono_display
FROM students;