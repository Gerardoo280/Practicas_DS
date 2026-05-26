import '../models/proyecto.dart';
import '../strategies/ordenar_por_prioridad.dart';
import 'api_service.dart';

class ProyectoService {
  static Future<List<Proyecto>> getAll() async {
    final datos = await ApiService.get('/proyectos');
    return (datos as List)
        .map((json) => Proyecto.fromJson(json, OrdenarPorPrioridad()))
        .toList();
  }

  static Future<Proyecto> create(Proyecto proyecto) async {
    final datos = await ApiService.post('/proyectos', {'proyecto': proyecto.toJson()});
    return Proyecto.fromJson(datos, OrdenarPorPrioridad());
  }

  static Future<Proyecto> update(int id, Proyecto proyecto) async {
    final datos = await ApiService.patch('/proyectos/$id', {'proyecto': proyecto.toJson()});
    return Proyecto.fromJson(datos, proyecto.estrategia);
  }

  static Future<void> delete(int id) async =>
      ApiService.delete('/proyectos/$id');
}