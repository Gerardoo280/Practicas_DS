import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_tareas_app/models/tarea.dart';

void main() {
  group('Tarea', () {
    test('fromJson carga los campos principales', () {
      final json = {
        'id': 5,
        'titulo': 'Revisar PR',
        'completada': true,
        'prioridad': 3,
        'fecha_limite': '2025-12-01T00:00:00.000',
        'objetivo_id': 2,
      };

      final tarea = Tarea.fromJson(json);

      expect(tarea.id, 5);
      expect(tarea.titulo, 'Revisar PR');
      expect(tarea.completada, true);
      expect(tarea.prioridad, 3);
      expect(tarea.objetivoId, 2);
    });

    test('toJson convierte a mapa correctamente', () {
      final tarea = Tarea(
        id: 1,
        titulo: 'Tarea serializada',
        prioridad: 2,
        objetivoId: 1,
      );
      final json = tarea.toJson();

      expect(json['titulo'], 'Tarea serializada');
      expect(json['prioridad'], 2);
      expect(json['objetivo_id'], 1);
    });
  });
}
