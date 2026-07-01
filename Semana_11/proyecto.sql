-- ============================================
-- PROYECTO SEMANAL: Subqueries en tu dominio
-- Semana 11 — Subqueries (escalar, IN, EXISTS, FROM)
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- Renombrar las tablas según tu dominio (Academia de Baile)
-- ============================================
DROP TABLE IF EXISTS monthly_payments;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id_student  INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    mensualidad REAL NOT NULL CHECK (mensualidad > 0),
    categoria   TEXT NOT NULL -- Ejemplo: 'Principiante', 'Intermedio', 'Avanzado'
);

CREATE TABLE monthly_payments (
    id_payment  INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id  INTEGER NOT NULL REFERENCES students (id_student),
    meses_pagos INTEGER NOT NULL DEFAULT 1
);

-- ============================================
-- Insertar datos de prueba realistas
-- ============================================

INSERT INTO students (name, mensualidad, categoria) VALUES 
    ('Juan Rodriguez', 90000.0, 'Principiante'),
    ('Camila Gomez', 110000.0, 'Principiante'),
    ('Andres Martinez', 120000.0, 'Intermedio'),
    ('Valentina Lopez', 140000.0, 'Intermedio'),
    ('Santiago Herrera', 160000.0, 'Avanzado'),
    ('Mariana Casas', 180000.0, 'Avanzado'),
    ('Diego Vargas', 150000.0, 'Avanzado'); -- Estudiante SIN pagos asignados (para NOT EXISTS)

INSERT INTO monthly_payments (student_id, meses_pagos) VALUES 
    (1, 2),
    (2, 1),
    (3, 3),
    (4, 1),
    (5, 2),
    (6, 1);

-- ============================================
-- CONSULTA 1: Subquery escalar en WHERE
-- ============================================

SELECT
    name,
    mensualidad,
    categoria
FROM students s
WHERE mensualidad > (
    SELECT AVG(s2.mensualidad)
    FROM students s2
    WHERE s2.categoria = s.categoria
)
ORDER BY categoria, mensualidad DESC;

-- ============================================
-- CONSULTA 2: Subquery escalar en SELECT
-- ============================================

SELECT
    name,
    mensualidad,
    ROUND((SELECT AVG(mensualidad) FROM students), 2) AS promedio_global
FROM students
ORDER BY mensualidad DESC;

-- ============================================
-- CONSULTA 3: NOT EXISTS — items sin actividad
-- ============================================

SELECT
    name AS estudiante_sin_pagos
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM monthly_payments mp
    WHERE mp.student_id = s.id_student
);

-- ============================================
-- CONSULTA 4: Tabla derivada en FROM
-- ============================================

SELECT
    cat_stats.categoria,
    cat_stats.total_pagos
FROM (
    SELECT
        s.categoria,
        COUNT(mp.id_payment) AS total_pagos
    FROM students s
    LEFT JOIN monthly_payments mp ON mp.student_id = s.id_student
    GROUP BY s.categoria
) AS cat_stats
WHERE cat_stats.total_pagos >= 2
ORDER BY cat_stats.total_pagos DESC;