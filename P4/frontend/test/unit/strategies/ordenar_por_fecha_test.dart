import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_tareas_app/models/tarea.dart';
import 'package:gestion_tareas_app/strategies/ordenar_por_fecha.dart';

void main() {
  group('OrdenarPorFecha', () {
    test('ordena de mas antigua a mas reciente con varias tareas', () {
      final estrategia = OrdenarPorFecha();
      final tareas = [
        Tarea(
            id: 1,
            titulo: 'Entrega Final',
            prioridad: 1,
            objetivoId: 1,
            fechaLimite: DateTime(2025, 12, 20)),
        Tarea(
            id: 2,
            titulo: 'Examen Parcial',
            prioridad: 1,
            objetivoId: 1,
            fechaLimite: DateTime(2025, 4, 15)),
        Tarea(
            id: 3,
            titulo: 'Entrega Practica 1',
            prioridad: 1,
            objetivoId: 1,
            fechaLimite: DateTime(2025, 3, 1)),
        Tarea(
            id: 4,
            titulo: 'Revision de notas',
            prioridad: 1,
            objetivoId: 1,
            fechaLimite: DateTime(2025, 6, 10)),
      ];

      final resultado = estrategia.ordenar(tareas);
      expect(resultado.length, 4);
      expect(resultado[0].titulo, 'Entrega Practica 1');
      expect(resultado[1].titulo, 'Examen Parcial');
      expect(resultado[2].titulo, 'Revision de notas');
      expect(resultado[3].titulo, 'Entrega Final');
    });

    test('las tareas sin fecha limite se quedan al final', () {
      final estrategia = OrdenarPorFecha();
      final tareas = [
        Tarea(
            id: 1,
            titulo: 'Tarea con fecha',
            prioridad: 1,
            objetivoId: 1,
            fechaLimite: DateTime(2025, 5, 1)),
        Tarea(
            id: 2,
            titulo: 'Tarea sin fecha',
            prioridad: 1,
            objetivoId: 1,
            fechaLimite: null),
      ];

      final resultado = estrategia.ordenar(tareas);
      expect(resultado[0].titulo, 'Tarea con fecha');
      expect(resultado[1].titulo, 'Tarea sin fecha');
    });
  });
}
