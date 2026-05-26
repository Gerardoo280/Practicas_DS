import 'elemento_proyecto.dart';
import 'objetivo.dart';
import 'tarea.dart';
import '../strategies/i_orden_strategy.dart';

// Compuesto raíz del patrón Composite — contiene objetivos
class Proyecto implements ElementoProyecto {
  final int? id;
  final String nombre;
  final String descripcion;
  final List<ElementoProyecto> hijos = [];
  IOrdenStrategy estrategia; // patrón Strategy

  Proyecto({
    this.id,
    required this.nombre,
    this.descripcion = '',
    required this.estrategia,
  });

  @override
  String getNombre() => nombre;

  void add(ElementoProyecto elemento) => hijos.add(elemento);
  void remove(ElementoProyecto elemento) => hijos.remove(elemento);

  List<Objetivo> getObjetivos() => hijos.whereType<Objetivo>().toList();

  // Recorre el árbol Proyecto → Objetivo → Tarea y devuelve todas las tareas
  List<Tarea> getTareas() {
    List<Tarea> todasLasTareas = [];
    for (ElementoProyecto hijo in hijos) {
      if (hijo is Objetivo) {
        todasLasTareas.addAll(hijo.getTareas());
      }
    }
    return todasLasTareas;
  }

  // Aplica la estrategia de ordenación elegida por el usuario
  List<Tarea> getTareasOrdenadas() => estrategia.ordenar(getTareas());

  factory Proyecto.fromJson(Map<String, dynamic> json, IOrdenStrategy orden) =>
      Proyecto(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'] ?? '',
        estrategia: orden,
      );

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'descripcion': descripcion,
  };
}