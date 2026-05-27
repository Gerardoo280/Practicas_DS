import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_tareas_app/models/tarea.dart';
import 'package:gestion_tareas_app/strategies/ordenar_por_nombre.dart';

void main() {
  group('OrdenarPorNombre', () {
    final estrategia = OrdenarPorNombre();

    test('ordena alfabéticamente A→Z', () {
      final tareas = [
        Tarea(id: 1, titulo: 'Zebra task', prioridad: 1, objetivoId: 1),
        Tarea(id: 2, titulo: 'Alpha task', prioridad: 1, objetivoId: 1),
        Tarea(id: 3, titulo: 'Middle task', prioridad: 1, objetivoId: 1),
      ];
      final resultado = estrategia.ordenar(tareas);
      expect(resultado[0].titulo, 'Alpha task');
      expect(resultado[1].titulo, 'Middle task');
      expect(resultado[2].titulo, 'Zebra task');
    });

    test('lista vacía no lanza error', () {
      expect(estrategia.ordenar([]), isEmpty);
    });
  });
}
