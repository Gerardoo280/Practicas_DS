import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_tareas_app/models/objetivo.dart';
import 'package:gestion_tareas_app/models/proyecto.dart';
import 'package:gestion_tareas_app/models/tarea.dart';
import 'package:gestion_tareas_app/strategies/ordenar_por_prioridad.dart';

void main() {
  group('Proyecto', () {
    late Proyecto proyecto;
    late Objetivo objetivo;

    setUp(() {
      proyecto = Proyecto(
        id: 1,
        nombre: 'App test',
        estrategia: OrdenarPorPrioridad(),
      );
      objetivo = Objetivo(id: 1, nombre: 'Obj', proyectoId: 1);
      proyecto.add(objetivo);
    });

    test('fromJson funciona', () {
      final p = Proyecto.fromJson(
        {'id': 9, 'nombre': 'App', 'descripcion': 'Desc JSON'},
        OrdenarPorPrioridad(),
      );
      expect(p.nombre, 'App');
      expect(p.descripcion, 'Desc JSON');
    });

    test('devuelve sus objetivos', () {
      expect(proyecto.getObjetivos().length, 1);
    });

    test('ordena las tareas por prioridad', () {
      objetivo.add(Tarea(id: 1, titulo: 'Baja', prioridad: 1, objetivoId: 1));
      objetivo.add(Tarea(id: 2, titulo: 'Alta', prioridad: 3, objetivoId: 1));

      final ordenadas = proyecto.getTareasOrdenadas();
      expect(ordenadas.first.prioridad, 3);
      expect(ordenadas.last.prioridad, 1);
    });

    test('No permite agregar un proyecto dentro de otro proyecto', () {
      final proyectoPadre = Proyecto(
          id: 1, nombre: 'Proyecto General', estrategia: OrdenarPorPrioridad());
      final proyectoHijo = Proyecto(
          id: 2,
          nombre: 'Subproyecto Colado',
          estrategia: OrdenarPorPrioridad());

      // Comprobamos que el método add lanza un error si intentas meter un Proyecto
      expect(() => proyectoPadre.add(proyectoHijo), throwsArgumentError);
    });
  });
}
