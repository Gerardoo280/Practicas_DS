import '../models/tarea.dart';
import 'i_orden_strategy.dart';

// Ordena por fecha límite ascendente, tareas sin fecha van al final
class OrdenarPorFecha implements IOrdenStrategy {
  @override
  List<Tarea> ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia.sort((tareaA, tareaB) {
      if (tareaA.fechaLimite == null && tareaB.fechaLimite == null) return 0;
      if (tareaA.fechaLimite == null) return 1;
      if (tareaB.fechaLimite == null) return -1;
      return tareaA.fechaLimite!.compareTo(tareaB.fechaLimite!);
    });
    return copia;
  }
}