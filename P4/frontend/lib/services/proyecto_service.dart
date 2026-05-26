import '../models/proyecto.dart';
import '../strategies/ordenar_por_prioridad.dart';
import 'api_service.dart';

class ProyectoService {
  // ⚠️ VERIFICAR CON BACKEND — rutas
  static Future<List<Proyecto>> getAll() async {
    final data = await ApiService.get('/proyectos');
    return (data as List).map((j) => Proyecto.fromJson(j, OrdenarPorPrioridad())).toList();
  }
  static Future<Proyecto> create(Proyecto p) async {
    final data = await ApiService.post('/proyectos', {'proyecto': p.toJson()});
    return Proyecto.fromJson(data, OrdenarPorPrioridad());
  }
  static Future<Proyecto> update(int id, Proyecto p) async {
    final data = await ApiService.patch('/proyectos/$id', {'proyecto': p.toJson()});
    return Proyecto.fromJson(data, p.estrategia);
  }
  static Future<void> delete(int id) async => ApiService.delete('/proyectos/$id');
}
