import 'elemento_proyecto.dart';
import 'objetivo.dart';
import 'tarea.dart';
import '../strategies/i_orden_strategy.dart';

class Proyecto implements ElementoProyecto {
  final int? id;
  final String nombre;
  final String descripcion;
  final List<ElementoProyecto> _hijos = [];
  IOrdenStrategy estrategia;

  Proyecto({this.id, required this.nombre, this.descripcion = '',
      required this.estrategia});

  @override
  String getNombre() => nombre;

  void add(ElementoProyecto e) => _hijos.add(e);
  void remove(ElementoProyecto e) => _hijos.remove(e);
  List<Objetivo> getObjetivos() => _hijos.whereType<Objetivo>().toList();

  List<Tarea> getTareas() {
    final tareas = <Tarea>[];
    for (final hijo in _hijos) {
      if (hijo is Objetivo) tareas.addAll(hijo.getTareas());
    }
    return tareas;
  }

  List<Tarea> getTareasOrdenadas() => estrategia.ordenar(getTareas());

  factory Proyecto.fromJson(Map<String, dynamic> json, IOrdenStrategy e) =>
      Proyecto(
        id: json['id'],
        nombre: json['nombre'],              // ⚠️ VERIFICAR CON BACKEND
        descripcion: json['descripcion'] ?? '',
        estrategia: e,
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'descripcion': descripcion,
      };
}
