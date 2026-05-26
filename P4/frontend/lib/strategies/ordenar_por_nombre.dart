import '../models/tarea.dart';
import 'i_orden_strategy.dart';
class OrdenarPorNombre implements IOrdenStrategy {
  @override
  List<Tarea> ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia.sort((a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));
    return copia;
  }
}
