import '../models/tarea.dart';
import 'i_orden_strategy.dart';
class OrdenarPorFecha implements IOrdenStrategy {
  @override
  List<Tarea> ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia.sort((a, b) {
      if (a.fechaLimite == null && b.fechaLimite == null) return 0;
      if (a.fechaLimite == null) return 1;
      if (b.fechaLimite == null) return -1;
      return a.fechaLimite!.compareTo(b.fechaLimite!);
    });
    return copia;
  }
}
