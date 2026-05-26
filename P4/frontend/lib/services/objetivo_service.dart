import '../models/objetivo.dart';
import 'api_service.dart';

class ObjetivoService {
  static Future<List<Objetivo>> getByProyecto(int proyectoId) async {
    final data = await ApiService.get('/proyectos/$proyectoId/objetivos');
    return (data as List).map((j) => Objetivo.fromJson(j)).toList();
  }

  static Future<Objetivo> create(Objetivo o) async {
    final data = await ApiService.post(
        '/proyectos/${o.proyectoId}/objetivos', {'objetivo': o.toJson()});
    return Objetivo.fromJson(data);
  }

  // PATCH y DELETE son shallow — sin proyecto_id en la ruta
  static Future<void> delete(int id) async =>
      ApiService.delete('/objetivos/$id');
}