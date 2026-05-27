import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_tareas_app/models/objetivo.dart';
import 'package:gestion_tareas_app/models/tarea.dart';

void main() {
  group('Objetivo', () {
    late Objetivo objetivo;

    setUp(() {
      objetivo = Objetivo(id: 1, nombre: 'Obj test', proyectoId: 1);
    });

    test('fromJson carga los datos', () {
      final obj = Objetivo.fromJson({
        'id': 3,
        'nombre': 'Login',
        'proyecto_id': 7,
      });

      expect(obj.nombre, 'Login');
      expect(obj.proyectoId, 7);
    });

    test('puedo agregar una tarea', () {
      final t = Tarea(id: 1, titulo: 'T1', prioridad: 1, objetivoId: 1);
      objetivo.add(t);
      expect(objetivo.hijos.length, 1);
    });

    test('puedo eliminar una tarea', () {
      final t = Tarea(id: 1, titulo: 'T quitar', prioridad: 1, objetivoId: 1);
      objetivo.add(t);
      objetivo.remove(t);
      expect(objetivo.hijos.length, 0);
    });
  });
}
