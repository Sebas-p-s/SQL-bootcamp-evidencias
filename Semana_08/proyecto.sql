-- ============================================
-- PROYECTO INTEGRADOR: Etapa 0 — Capstone
-- Semana 08 — DDL + DML + SELECT completo
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA (DDL)
-- ============================================

-- Tabla de referencia / categorías: Lugares de ensayo
CREATE TABLE locations (
    id_location     INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_lugar    TEXT NOT NULL UNIQUE,
    capacidad_max   INTEGER NOT NULL CHECK (capacidad_max > 0)
);

-- Tabla secundaria: Instructores (conectados a un lugar fijo de ensayo)
CREATE TABLE instructors (
    id_instructor     INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_instructor TEXT NOT NULL,
    especialidad      TEXT NOT NULL,
    pago_por_hora     REAL NOT NULL CHECK (pago_por_hora > 0),
    estado_contrato   TEXT NOT NULL DEFAULT 'Activo',
    location_id       INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(id_location) ON DELETE RESTRICT
);

-- Tabla principal: Estudiantes (conectados a su instructor asignado)
CREATE TABLE students (
    id_student         INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_estudiante  TEXT NOT NULL,
    cedula_estudiante  TEXT NOT NULL UNIQUE,
    telefono_contacto  TEXT, -- Columna opcional (NULL)
    horas_asistidas    REAL NOT NULL CHECK (horas_asistidas >= 0),
    is_active          INTEGER NOT NULL DEFAULT 1,
    instructor_id      INTEGER NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(id_instructor) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: DATOS (DML)
-- ============================================

INSERT INTO locations (nombre_lugar, capacidad_max) VALUES
    ('Salon Bolivar', 30),
    ('Casa Cultural', 20),
    ('Teatro Central', 50);

INSERT INTO instructors (nombre_instructor, especialidad, pago_por_hora, location_id) VALUES
    ('Carlos Ramirez', 'Salsa', 45000.0, 1),
    ('Luisa Fernandez', 'Bachata', 40000.0, 2),
    ('Jhon Castro', 'Hip Hop', 50000.0, 3);

INSERT INTO students (nombre_estudiante, cedula_estudiante, telefono_contacto, horas_asistidas, instructor_id) VALUES
    ('Juan Rodriguez', '1023456789', '3112345678', 12.5, 1),
    ('Camila Gomez', '1034567891', NULL, 8.0, 2), -- NULL
    ('Andres Martinez', '1045678912', '3229876543', 20.0, 1),
    ('Valentina Lopez', '1056789123', NULL, 15.5, 3), -- NULL
    ('Santiago Herrera', '1067891234', '3004561234', 5.0, 2),
    ('Mariana Casas', '1078912345', '3157894561', 22.0, 3),
    ('Diego Vargas', '1089123456', '3101234567', 18.5, 1),
    ('Paula Moreno', '1091234567', '3124567890', 25.0, 3);

-- ============================================
-- PARTE 3: REPORTES (SELECT)
-- ============================================

-- REPORTE 1: Totales globales
SELECT 
    COUNT(*) AS total_estudiantes,
    SUM(horas_asistidas) AS total_horas_acumuladas,
    AVG(horas_asistidas) AS promedio_horas_por_alumno
FROM students;

-- REPORTE 2: Totales por categoría (GROUP BY)
SELECT
    instructor_id,
    COUNT(*) AS total_alumnos,
    AVG(horas_asistidas) AS promedio_horas
FROM students
WHERE is_active = 1
GROUP BY instructor_id
ORDER BY total_alumnos DESC;

-- REPORTE 3: Grupos con umbral (HAVING)
SELECT instructor_id, COUNT(*) AS total_alumnos
FROM students
GROUP BY instructor_id
HAVING total_alumnos > 2;

-- REPORTE 4: Registros con NULL y COALESCE
SELECT nombre_estudiante, COALESCE(telefono_contacto, 'Sin teléfono') AS telefono_display
FROM students
WHERE telefono_contacto IS NULL;

-- REPORTE 5: Búsqueda combinada
SELECT nombre_estudiante, horas_asistidas
FROM students
WHERE horas_asistidas BETWEEN 10.0 AND 25.0
  AND is_active = 1
ORDER BY horas_asistidas DESC
LIMIT 5;