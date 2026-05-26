import '../models/tarea.dart';
import 'api_service.dart';

class TareaService {
  // ⚠️ VERIFICAR CON BACKEND — rutas anidadas
  static Future<List<Tarea>> getByObjetivo(int objetivoId) async {
    final data = await ApiService.get('/objetivos/$objetivoId/tareas');
    return (data as List).map((j) => Tarea.fromJson(j)).toList();
  }
  static Future<Tarea> create(Tarea t) async {
    final data = await ApiService.post(
        '/objetivos/${t.objetivoId}/tareas', {'tarea': t.toJson()});
    return Tarea.fromJson(data);
  }
  static Future<Tarea> update(int id, Tarea t) async {
    final data = await ApiService.patch(
        '/objetivos/${t.objetivoId}/tareas/$id', {'tarea': t.toJson()});
    return Tarea.fromJson(data);
  }
  static Future<void> delete(int objetivoId, int id) async =>
      ApiService.delete('/objetivos/$objetivoId/tareas/$id');
}
