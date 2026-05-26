import '../models/tarea.dart';
import 'i_orden_strategy.dart';
class OrdenarPorPrioridad implements IOrdenStrategy {
  @override
  List<Tarea> ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia.sort((a, b) => b.prioridad.compareTo(a.prioridad));
    return copia;
  }
}
