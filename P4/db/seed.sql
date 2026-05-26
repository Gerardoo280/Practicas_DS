-- Base de datos: gestion_tareas
-- PostgreSQL
-- Ejecutar: psql -U <usuario> -d <base_de_datos> -f db/schema.sql

-- ─────────────────────────────────────
--  TABLA: proyectos
-- ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS proyectos (
  id           SERIAL PRIMARY KEY,
  nombre       TEXT        NOT NULL,
  descripcion  TEXT        NOT NULL DEFAULT '',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────
--  TABLA: objetivos
-- ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS objetivos (
  id           SERIAL PRIMARY KEY,
  nombre       TEXT        NOT NULL,
  proyecto_id  INTEGER     NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_objetivos_proyecto
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_objetivos_proyecto_id ON objetivos(proyecto_id);

-- ─────────────────────────────────────
--  TABLA: tareas
-- ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS tareas (
  id           SERIAL PRIMARY KEY,
  titulo       TEXT        NOT NULL,
  completada   BOOLEAN     NOT NULL DEFAULT FALSE,
  prioridad    SMALLINT    NOT NULL DEFAULT 1
               CONSTRAINT chk_tareas_prioridad CHECK (prioridad IN (1, 2, 3)),
  fecha_limite DATE,
  objetivo_id  INTEGER     NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_tareas_objetivo
    FOREIGN KEY (objetivo_id) REFERENCES objetivos(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_tareas_objetivo_id ON tareas(objetivo_id);

-- ─────────────────────────────────────
--  DATOS DE PRUEBA
-- ─────────────────────────────────────
INSERT INTO proyectos (nombre, descripcion) VALUES
  ('App móvil',        'Desarrollo de la app Flutter'),
  ('Web corporativa',  'Rediseño de la web');

INSERT INTO objetivos (nombre, proyecto_id) VALUES
  ('Diseño UI',    1),
  ('Backend API',  1),
  ('Landing page', 2);

INSERT INTO tareas (titulo, completada, prioridad, fecha_limite, objetivo_id) VALUES
  ('Crear pantalla proyectos', FALSE, 3, '2026-06-01', 1),
  ('Crear pantalla tareas',    FALSE, 2, '2026-06-05', 1),
  ('Montar endpoints REST',    FALSE, 3, '2026-06-03', 2),
  ('Escribir tests CRUD',      FALSE, 2, '2026-06-10', 2),
  ('Maqueta en Figma',         TRUE,  1,  NULL,        3);
