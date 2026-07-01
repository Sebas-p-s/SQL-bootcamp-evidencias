-- ============================================
-- PROYECTO SEMANAL: CTEs y CASE WHEN en tu dominio
-- Semana 12 — Common Table Expressions + Condicionales
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- Renombrar las tablas según tu dominio (Academia de Baile)
-- ============================================

DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS courses;

CREATE TABLE courses (
    id_course INTEGER PRIMARY KEY AUTOINCREMENT,
    name      TEXT NOT NULL,
    price     REAL NOT NULL CHECK (price > 0),
    category  TEXT NOT NULL -- Ejemplo: 'Salsa', 'Bachata', 'Hip Hop'
);

CREATE TABLE registrations (
    id_registration INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id       INTEGER NOT NULL REFERENCES courses (id_course),
    quantity        INTEGER NOT NULL DEFAULT 1, -- Cupos reservados en la transacción
    tx_date         TEXT NOT NULL  -- formato YYYY-MM-DD
);

-- ============================================
-- Insertar datos de prueba
-- ============================================

INSERT INTO courses (name, price, category) VALUES 
    ('Salsa Básica', 45000.0, 'Salsa'),
    ('Salsa Estilo Cali', 85000.0, 'Salsa'),
    ('Bachata Sensual', 50000.0, 'Bachata'),
    ('Bachata Avanzada', 90000.0, 'Bachata'),
    ('Hip Hop Coreografía', 60000.0, 'Hip Hop'),
    ('Breaking Intensivo', 120000.0, 'Hip Hop');

INSERT INTO registrations (course_id, quantity, tx_date) VALUES 
    (1, 2, '2026-05-01'),
    (1, 1, '2026-05-03'),
    (2, 1, '2026-05-05'),
    (3, 3, '2026-05-10'),
    (3, 1, '2026-05-12'),
    (4, 2, '2026-05-15'),
    (5, 1, '2026-05-18'),
    (5, 2, '2026-05-20'),
    (6, 1, '2026-05-22'),
    (6, 1, '2026-05-25');

-- ============================================
-- CONSULTA 1: CTE simple + CASE WHEN de clasificación
-- ============================================

WITH courses_con_actividad AS (
    SELECT
        c.id_course,
        c.name,
        c.price,
        c.category,
        COUNT(r.id_registration) AS total_registrations
    FROM courses c
    LEFT JOIN registrations r ON r.course_id = c.id_course
    GROUP BY c.id_course, c.name, c.price, c.category
)
SELECT
    name,
    price,
    total_registrations,
    CASE
        WHEN price >= 100000.0 THEN 'Premium'
        WHEN price >= 60000.0  THEN 'Estándar'
        ELSE                        'Económico'
    END AS price_band
FROM courses_con_actividad
ORDER BY price DESC;

-- ============================================
-- CONSULTA 2: Dos CTEs encadenados
-- ============================================

WITH ventas_por_categoria AS (
    SELECT
        c.category,
        SUM(r.quantity) AS total_vendido
    FROM courses c
    INNER JOIN registrations r ON r.course_id = c.id_course
    GROUP BY c.category
),
categorias_top AS (
    SELECT category
    FROM ventas_por_categoria
    WHERE total_vendido > (SELECT AVG(total_vendido) FROM ventas_por_categoria)
)
SELECT
    vc.category,
    vc.total_vendido
FROM ventas_por_categoria vc
WHERE vc.category IN (SELECT category FROM categorias_top)
ORDER BY vc.total_vendido DESC;

-- ============================================
-- CONSULTA 3: CTE + COUNT condicional por banda
-- ============================================

WITH clasificados AS (
    SELECT
        name,
        category,
        price,
        CASE
            WHEN price >= 100000.0 THEN 'Premium'
            WHEN price >= 60000.0  THEN 'Estándar'
            ELSE                        'Económico'
        END AS price_band
    FROM courses
)
SELECT
    category,
    COUNT(CASE WHEN price_band = 'Premium'   THEN 1 END) AS premium_count,
    COUNT(CASE WHEN price_band = 'Estándar'  THEN 1 END) AS estandar_count,
    COUNT(CASE WHEN price_band = 'Económico' THEN 1 END) AS economico_count
FROM clasificados
GROUP BY category
ORDER BY category;