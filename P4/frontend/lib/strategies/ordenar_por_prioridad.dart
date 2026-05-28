import '../models/tarea.dart';
import 'i_orden_strategy.dart';

// Ordena por prioridad descendente: alta 3 primero, baja 1 al final
class OrdenarPorPrioridad implements IOrdenStrategy {
  @override
  List<Tarea> ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia
        .sort((tareaA, tareaB) => tareaB.prioridad.compareTo(tareaA.prioridad));
    return copia;
  }
}
