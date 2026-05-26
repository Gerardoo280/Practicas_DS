import '../models/tarea.dart';
import 'api_service.dart';

class TareaService {
  static Future<List<Tarea>> getByObjetivo(int objetivoId) async {
    final datos = await ApiService.get('/objetivos/$objetivoId/tareas');
    return (datos as List).map((json) => Tarea.fromJson(json)).toList();
  }

  static Future<Tarea> create(Tarea tarea) async {
    final datos = await ApiService.post(
        '/objetivos/${tarea.objetivoId}/tareas',
        {'tarea': tarea.toJson()});
    return Tarea.fromJson(datos);
  }

  static Future<Tarea> update(int id, Tarea tarea) async {
    final datos = await ApiService.patch('/tareas/$id', {'tarea': tarea.toJson()});
    return Tarea.fromJson(datos);
  }

  static Future<void> delete(int id) async =>
      ApiService.delete('/tareas/$id');
}