import 'elemento_proyecto.dart';

class Tarea implements ElementoProyecto {
  final int? id;
  final String titulo;
  final bool completada;
  final int prioridad;
  final DateTime? fechaLimite;
  final int objetivoId;

  Tarea({this.id, required this.titulo, this.completada = false,
      this.prioridad = 1, this.fechaLimite, required this.objetivoId});

  @override
  String getNombre() => titulo;

  Tarea copyWith({int? id, String? titulo, bool? completada,
      int? prioridad, DateTime? fechaLimite, int? objetivoId}) =>
      Tarea(
        id: id ?? this.id, titulo: titulo ?? this.titulo,
        completada: completada ?? this.completada,
        prioridad: prioridad ?? this.prioridad,
        fechaLimite: fechaLimite ?? this.fechaLimite,
        objetivoId: objetivoId ?? this.objetivoId,
      );

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        id: json['id'],
        titulo: json['titulo'],               // ⚠️ VERIFICAR CON BACKEND
        completada: json['completada'] ?? false,
        prioridad: json['prioridad'] ?? 1,
        fechaLimite: json['fecha_limite'] != null
            ? DateTime.parse(json['fecha_limite']) : null,
        objetivoId: json['objetivo_id'],      // ⚠️ VERIFICAR CON BACKEND
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,                     // ⚠️ VERIFICAR CON BACKEND
        'completada': completada,
        'prioridad': prioridad,
        'fecha_limite': fechaLimite?.toIso8601String(),
        'objetivo_id': objetivoId,            // ⚠️ VERIFICAR CON BACKEND
      };
}
