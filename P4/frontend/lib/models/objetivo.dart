import 'elemento_proyecto.dart';
import 'tarea.dart';

// Compuesto del patrón Composite — contiene tareas
class Objetivo implements ElementoProyecto {
  final int? id;
  final String nombre;
  final int proyectoId;
  final List<ElementoProyecto> hijos = [];

  Objetivo({this.id, required this.nombre, required this.proyectoId});

  @override
  String getNombre() => nombre;

  void add(ElementoProyecto elemento) {
    if (elemento is Proyecto || elemento is Objetivo) {
      throw Exception('Un objetivo solo puede contener tareas');
    }
    hijos.add(elemento);
  }

  void remove(ElementoProyecto elemento) {
    hijos.remove(elemento);
  }

  List<Tarea> getTareas() => hijos.whereType<Tarea>().toList();

  factory Objetivo.fromJson(Map<String, dynamic> json) => Objetivo(
        id: json['id'],
        nombre: json['nombre'],
        proyectoId: json['proyecto_id'],
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'proyecto_id': proyectoId,
      };
}
