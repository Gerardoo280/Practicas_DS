import '../models/tarea.dart';
abstract class IOrdenStrategy {
  List<Tarea> ordenar(List<Tarea> tareas);
}
