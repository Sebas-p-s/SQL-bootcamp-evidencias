-- ============================================
-- PROYECTO SEMANAL: JOINs aplicados a tu dominio
-- Semana 09 — INNER JOIN y LEFT JOIN
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- Renombrar las tablas según tu dominio (Academia de Baile)
-- ============================================

DROP TABLE IF EXISTS attendance_logs;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS styles;

-- Tabla de referencia: Estilos de baile
CREATE TABLE styles (
    id_style       INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_estilo  TEXT NOT NULL UNIQUE
);

-- Tabla principal: Estudiantes
CREATE TABLE students (
    id_student     INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_alumno  TEXT NOT NULL,
    style_id       INTEGER REFERENCES styles (id_style)
);

-- Tabla hija: Registro de asistencias a clases
CREATE TABLE attendance_logs (
    id_attendance  INTEGER PRIMARY KEY AUTOINCREMENT,
    recorded_at    TEXT NOT NULL DEFAULT (DATE('now')),
    student_id     INTEGER REFERENCES students (id_student)
);

-- ============================================
-- Insertar datos de prueba realistas
-- ============================================

INSERT INTO styles (nombre_estilo) VALUES 
    ('Salsa'), 
    ('Bachata'), 
    ('Hip Hop');

INSERT INTO students (nombre_alumno, style_id) VALUES 
    ('Juan Rodriguez', 1),
    ('Camila Gomez', 2),
    ('Andres Martinez', 1),
    ('Valentina Lopez', 3); -- Registro huérfano (No asistirá a ninguna clase en attendance_logs)

INSERT INTO attendance_logs (recorded_at, student_id) VALUES 
    ('2026-05-10', 1),
    ('2026-05-11', 2),
    ('2026-05-12', 1),
    ('2026-05-12', 3);

-- ============================================
-- CONSULTA 1: INNER JOIN principal
-- ============================================

SELECT
    s.nombre_alumno AS alumno,
    a.recorded_at AS fecha_asistencia
FROM students s
INNER JOIN attendance_logs a ON a.student_id = s.id_student;

-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- ============================================

SELECT
    s.nombre_alumno AS alumno,
    st.nombre_estilo AS estilo,
    a.recorded_at AS fecha_asistencia
FROM students s
INNER JOIN styles st ON s.style_id = st.id_style
INNER JOIN attendance_logs a ON a.student_id = s.id_student;

-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los registros
-- ============================================

SELECT
    s.nombre_alumno AS alumno,
    a.recorded_at AS fecha_asistencia
FROM students s
LEFT JOIN attendance_logs a ON a.student_id = s.id_student;

-- ============================================
-- CONSULTA 4: Detectar huérfanos (registros sin actividad)
-- ============================================

SELECT
    s.nombre_alumno AS alumno_sin_asistencias
FROM students s
LEFT JOIN attendance_logs a ON a.student_id = s.id_student;
WHERE a.id_attendance IS NULL;

-- ============================================
-- CONSULTA 5: Reporte agregado con LEFT JOIN + COUNT
-- ============================================

SELECT
    s.nombre_alumno AS alumno,
    COUNT(a.id_attendance) AS total_asistencias
FROM students s
LEFT JOIN attendance_logs a ON a.student_id = s.id_student;
GROUP BY s.nombre_alumno
ORDER BY total_asistencias DESC;