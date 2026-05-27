import '../models/objetivo.dart';
import 'api_service.dart';

class ObjetivoService {
  static Future<List<Objetivo>> getByProyecto(int proyectoId) async {
    final datos = await ApiService.get('/proyectos/$proyectoId/objetivos');
    return (datos as List).map((json) => Objetivo.fromJson(json)).toList();
  }

  static Future<Objetivo> create(Objetivo objetivo) async {
    final datos = await ApiService.post(
        '/proyectos/${objetivo.proyectoId}/objetivos',
        {'objetivo': objetivo.toJson()});
    return Objetivo.fromJson(datos);
  }

  static Future<Objetivo> update(int id, Objetivo objetivo) async {
    final datos = await ApiService.patch(
        '/objetivos/$id', {'objetivo': objetivo.toJson()});
    return Objetivo.fromJson(datos);
  }

  static Future<void> delete(int id) async =>
      ApiService.delete('/objetivos/$id');
}
