import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_tareas_app/models/tarea.dart';
import 'package:gestion_tareas_app/strategies/ordenar_por_prioridad.dart';

void main() {
  group('OrdenarPorPrioridad', () {
    final estrategia = OrdenarPorPrioridad();

    test('ordena alta(3) → media(2) → baja(1)', () {
      final tareas = [
        Tarea(id: 1, titulo: 'Baja', prioridad: 1, objetivoId: 1),
        Tarea(id: 2, titulo: 'Alta', prioridad: 3, objetivoId: 1),
        Tarea(id: 3, titulo: 'Media', prioridad: 2, objetivoId: 1),
      ];
      final resultado = estrategia.ordenar(tareas);
      expect(resultado[0].prioridad, 3);
      expect(resultado[1].prioridad, 2);
      expect(resultado[2].prioridad, 1);
    });

    test('lista vacía no lanza error', () {
      expect(estrategia.ordenar([]), isEmpty);
    });

    test('funciona si todas las tareas tienen la misma prioridad', () {
      final estrategia = OrdenarPorPrioridad();

      final tareas = [
        Tarea(id: 1, titulo: 'Tarea A', prioridad: 2, objetivoId: 1),
        Tarea(id: 2, titulo: 'Tarea B', prioridad: 2, objetivoId: 1),
      ];

      final resultado = estrategia.ordenar(tareas);

      expect(resultado.length, 2);
      expect(resultado[0].prioridad, 2);
      expect(resultado[1].prioridad, 2);
    });
  });
}
