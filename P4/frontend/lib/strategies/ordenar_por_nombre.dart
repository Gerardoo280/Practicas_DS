import '../models/tarea.dart';
import 'i_orden_strategy.dart';

// Ordena alfabéticamente por título ignorando mayúsculas
class OrdenarPorNombre implements IOrdenStrategy {
  @override
  List<Tarea> ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia.sort((tareaA, tareaB) =>
        tareaA.titulo.toLowerCase().compareTo(tareaB.titulo.toLowerCase()));
    return copia;
  }
}
