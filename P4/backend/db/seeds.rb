proyecto1 = Proyecto.create!(nombre: "App móvil", descripcion: "Desarrollo de la app Flutter")
proyecto2 = Proyecto.create!(nombre: "Web corporativa", descripcion: "Rediseño de la web")

objetivo1 = Objetivo.create!(nombre: "Diseño UI",    proyecto: proyecto1)
objetivo2 = Objetivo.create!(nombre: "Backend API",  proyecto: proyecto1)
objetivo3 = Objetivo.create!(nombre: "Landing page", proyecto: proyecto2)

Tarea.create!(titulo: "Crear pantalla proyectos", completada: false, prioridad: 3, fecha_limite: "2026-06-01", objetivo: objetivo1)
Tarea.create!(titulo: "Crear pantalla tareas",    completada: false, prioridad: 2, fecha_limite: "2026-06-05", objetivo: objetivo1)
Tarea.create!(titulo: "Montar endpoints REST",    completada: false, prioridad: 3, fecha_limite: "2026-06-03", objetivo: objetivo2)
Tarea.create!(titulo: "Escribir tests CRUD",      completada: false, prioridad: 2, fecha_limite: "2026-06-10", objetivo: objetivo2)
Tarea.create!(titulo: "Maqueta en Figma",         completada: true,  prioridad: 1, fecha_limite: nil,          objetivo: objetivo3)
