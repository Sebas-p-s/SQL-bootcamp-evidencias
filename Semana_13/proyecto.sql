-- ============================================
-- PROYECTO SEMANAL: Jerarquías con CTEs Recursivas
-- Semana 13 — WITH RECURSIVE
-- PostgreSQL 16
-- ============================================

-- Adaptado al dominio: Academia de Baile (Estructura de Categorías y Estilos)

DROP TABLE IF EXISTS dance_categories CASCADE;

CREATE TABLE dance_categories (
    id        SERIAL PRIMARY KEY,
    name      TEXT NOT NULL,
    parent_id INT REFERENCES dance_categories (id)
);

-- ============================================
-- PARTE 2: DATOS CON 3 NIVELES DE PROFUNDIDAD
-- ============================================

INSERT INTO dance_categories (name, parent_id) VALUES
    ('Danza', NULL),                       -- id: 1 (Nivel 1)
    ('Ritmos Latinos', 1),                  -- id: 2 (Nivel 2)
    ('Danza Urbana', 1),                    -- id: 3 (Nivel 2)
    ('Salsa', 2),                           -- id: 4 (Nivel 3)
    ('Bachata', 2),                         -- id: 5 (Nivel 3)
    ('Hip Hop', 3),                         -- id: 6 (Nivel 3)
    ('Breaking', 3),                        -- id: 7 (Nivel 3)
    ('Salsa Estilo Cali', 4);               -- id: 8 (Nivel 4 opcional para demostrar profundidad)

-- ============================================
-- CONSULTA 1: Árbol completo con depth y path
-- ============================================

WITH RECURSIVE arbol AS (
    -- Caso base — nodos raíz
    SELECT
        id,
        name,
        parent_id,
        1        AS depth,
        name     AS path
    FROM dance_categories
    WHERE parent_id IS NULL

    UNION ALL

    -- Caso recursivo — nodos hijo
    SELECT
        n.id,
        n.name,
        n.parent_id,
        a.depth + 1,
        a.path || ' > ' || n.name
    FROM dance_categories n
    INNER JOIN arbol a ON n.parent_id = a.id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || name AS indented_name,
    path
FROM arbol
ORDER BY path;

-- ============================================
-- CONSULTA 2: Nodos de un nivel específico
-- ============================================

WITH RECURSIVE arbol AS (
    SELECT id, name, parent_id, 1 AS depth, name AS path
    FROM dance_categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    SELECT n.id, n.name, n.parent_id, a.depth + 1, a.path || ' > ' || n.name
    FROM dance_categories n
    INNER JOIN arbol a ON n.parent_id = a.id
)
SELECT name, depth, path
FROM arbol
WHERE depth = 3
ORDER BY path;

-- ============================================
-- CONSULTA 3: Hojas del árbol (nodos sin hijos)
-- ============================================

SELECT
    n.id,
    n.name
FROM dance_categories n
WHERE NOT EXISTS (
    SELECT 1
    FROM dance_categories child
    WHERE child.parent_id = n.id
)
ORDER BY n.name;