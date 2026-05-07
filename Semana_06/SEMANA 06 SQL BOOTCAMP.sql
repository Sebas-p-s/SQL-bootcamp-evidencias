CREATE DATABASE sqlbootcamp;

USE sqlbootcamp;

-- Tabla students

CREATE TABLE students(
id_students INT PRIMARY KEY AUTO_INCREMENT,
nombre_estudiante VARCHAR(50) NOT NULL,
apellido_estudiante VARCHAR(50) NOT NULL,
cedula_estudiante INT NOT NULL
);

INSERT INTO students(nombre_estudiante, apellido_estudiante, cedula_estudiante)
VALUES
('Juan', 'Rodriguez', 1023456789),
('Camila', 'Gomez', 1034567891),
('Andres', 'Martinez', 1045678912),
('Valentina', 'Lopez', 1056789123),
('Santiago', 'Herrera', 1067891234);

-- Tabla styles

CREATE TABLE styles(
id_styles INT PRIMARY KEY AUTO_INCREMENT,
nombre_estilo VARCHAR(50),
horas_totales INT
);

INSERT INTO styles(nombre_estilo, horas_totales)
VALUES
('Salsa', 120),
('Bachata', 90),
('Hip Hop', 150),
('Folclor', 80),
('Tango', 100);

-- Tabla rehearsals

CREATE TABLE rehearsals(
id_ensayos INT PRIMARY KEY AUTO_INCREMENT,
fecha_ensayo DATETIME NOT NULL,
lugar_ensayo VARCHAR(50) NOT NULL
);

INSERT INTO rehearsals(fecha_ensayo, lugar_ensayo)
VALUES
('2026-05-01 14:00:00', 'Salon Bolivar'),
('2026-05-03 16:00:00', 'Casa Cultural'),
('2026-05-05 18:00:00', 'Teatro Central'),
('2026-05-07 15:30:00', 'Salon Santander'),
('2026-05-09 17:00:00', 'Auditorio Principal');

-- Tabla instructors

CREATE TABLE instructors(
id_instructor INT PRIMARY KEY AUTO_INCREMENT,
nombre_instructor VARCHAR(50),
apellido_instructor VARCHAR (50),
especialidad VARCHAR(80)	
);

INSERT INTO instructors(nombre_instructor, apellido_instructor, especialidad)
VALUES
('Carlos', 'Ramirez', 'Salsa'),
('Luisa', 'Fernandez', 'Bachata'),
('Jhon', 'Castro', 'Hip Hop'),
('Paula', 'Moreno', 'Folclor'),
('Diego', 'Vargas', 'Tango');

-- Reporte 1

SELECT
COUNT(*) AS total_registros,
SUM(horas_totales) AS suma_total,
AVG(horas_totales) AS promedio
FROM styles;

-- Reporte 2

SELECT
MIN(horas_totales) AS minimo,
MAX(horas_totales) AS maximo
FROM styles;

-- Reporte 3

SELECT
nombre_estilo,
AVG(horas_totales) AS promedio_horas
FROM styles
GROUP BY nombre_estilo
ORDER BY promedio_horas DESC;

-- Reporte 4

SELECT
especialidad,
COUNT(*) AS total
FROM instructors
GROUP BY especialidad
HAVING COUNT(*) >= 1;