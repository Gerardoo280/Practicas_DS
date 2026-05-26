import 'elemento_proyecto.dart';
import 'tarea.dart';

class Objetivo implements ElementoProyecto {
  final int? id;
  final String nombre;
  final int proyectoId;
  final List<ElementoProyecto> _hijos = [];

  Objetivo({this.id, required this.nombre, required this.proyectoId});

  @override
  String getNombre() => nombre;

  void add(ElementoProyecto e) => _hijos.add(e);
  void remove(ElementoProyecto e) => _hijos.remove(e);
  List<Tarea> getTareas() => _hijos.whereType<Tarea>().toList();

  factory Objetivo.fromJson(Map<String, dynamic> json) => Objetivo(
        id: json['id'],
        nombre: json['nombre'],              // ⚠️ VERIFICAR CON BACKEND
        proyectoId: json['proyecto_id'],     // ⚠️ VERIFICAR CON BACKEND
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'proyecto_id': proyectoId,           // ⚠️ VERIFICAR CON BACKEND
      };
}
