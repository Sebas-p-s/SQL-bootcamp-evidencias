-- ============================================
-- PROYECTO SEMANAL: Ranking con Window Functions
-- Semana 14 — Window Functions (ROW_NUMBER, RANK, DENSE_RANK)
-- ============================================

DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id_category INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL
);

CREATE TABLE courses (
    id_course   INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    price       REAL NOT NULL,
    category_id INTEGER REFERENCES categories (id_category),
    is_active   INTEGER NOT NULL DEFAULT 1
);

-- Insertar datos representativos (Academia de Baile)
INSERT INTO categories (name) VALUES
    ('Salsa'),
    ('Bachata'),
    ('Hip Hop');

INSERT INTO courses (name, price, category_id) VALUES
    ('Salsa Caleña Avanzada', 120000.0, 1),
    ('Salsa Estilo Cali',     120000.0, 1), -- Empate intencional en precio
    ('Salsa Básica',           85000.0, 1),
    ('Salsa Básica',           85000.0, 1), -- Registro duplicado para el TODO 1
    ('Bachata Sensual Pro',   110000.0, 2),
    ('Bachata Estilo Libre',   95000.0, 2),
    ('Bachata Básica',         70000.0, 2),
    ('Hip Hop Coreografía',   130000.0, 3),
    ('Breaking Intensivo',    130000.0, 3), -- Empate intencional en precio
    ('Popping Fundamentos',    90000.0, 3),
    ('Urban Fusion',           80000.0, 3);

-- ============================================
-- TODO 1: Eliminar duplicados con ROW_NUMBER()
-- ============================================

WITH cursos_deduplicados AS (
    SELECT 
        id_course,
        name,
        price,
        category_id,
        ROW_NUMBER() OVER (PARTITION BY name ORDER BY id_course) AS rn
    FROM courses
)
SELECT 
    id_course,
    name,
    price,
    category_id
FROM cursos_deduplicados
WHERE rn = 1;

-- ============================================
-- TODO 2: RANK y DENSE_RANK por categoría
-- ============================================

SELECT 
    name,
    price,
    category_id,
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS dense_rnk
FROM courses
WHERE is_active = 1;

-- ============================================
-- TODO 3: Top-N por grupo con CTE
-- ============================================

WITH ranking_cursos AS (
    SELECT 
        name,
        price,
        category_id,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS dense_rnk
    FROM courses
    WHERE is_active = 1
)
SELECT 
    name,
    price,
    category_id,
    dense_rnk
FROM ranking_cursos
WHERE dense_rnk <= 2
ORDER BY category_id, dense_rnk;