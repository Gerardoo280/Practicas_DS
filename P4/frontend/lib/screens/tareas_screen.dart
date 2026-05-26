import 'package:flutter/material.dart';
import '../models/proyecto.dart';
import '../models/objetivo.dart';
import '../models/tarea.dart';
import '../services/objetivo_service.dart';
import '../services/tarea_service.dart';
import '../strategies/i_orden_strategy.dart';
import '../strategies/ordenar_por_prioridad.dart';
import '../strategies/ordenar_por_fecha.dart';
import '../strategies/ordenar_por_nombre.dart';

class TareasScreen extends StatefulWidget {
  final Proyecto proyecto;
  const TareasScreen({super.key, required this.proyecto});
  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  List<Objetivo> objetivos = [];
  int? objetivoFiltrado; // null significa mostrar todos
  bool cargando = true;
  String ordenActual = 'prioridad';

  // Mapa de estrategias disponibles — patrón Strategy
  final Map<String, IOrdenStrategy> estrategias = {
    'prioridad': OrdenarPorPrioridad(),
    'fecha':     OrdenarPorFecha(),
    'nombre':    OrdenarPorNombre(),
  };

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    // Limpia el árbol para no duplicar al recargar
    for (final objetivo in widget.proyecto.getObjetivos()) {
      widget.proyecto.remove(objetivo);
    }
    final listaObjetivos = await ObjetivoService.getByProyecto(widget.proyecto.id!);
    for (final objetivo in listaObjetivos) {
      final listaTareas = await TareaService.getByObjetivo(objetivo.id!);
      for (final tarea in listaTareas) objetivo.add(tarea);
      widget.proyecto.add(objetivo); // construye el árbol Composite
    }
    setState(() {
      objetivos = listaObjetivos;
      cargando = false;
    });
  }

  // Cambia la estrategia en tiempo de ejecución — patrón Strategy
  void cambiarOrden(String nuevoOrden) {
    setState(() {
      ordenActual = nuevoOrden;
      widget.proyecto.estrategia = estrategias[nuevoOrden]!;
    });
  }

  // Devuelve las tareas filtradas por objetivo si hay uno seleccionado
  List<Tarea> obtenerTareasMostradas() {
    if (objetivoFiltrado == null) {
      return widget.proyecto.getTareasOrdenadas();
    }
    final objetivo = objetivos.firstWhere((o) => o.id == objetivoFiltrado);
    return estrategias[ordenActual]!.ordenar(objetivo.getTareas());
  }

  Future<void> mostrarDialogoNuevoObjetivo() async {
    final controlador = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo objetivo'),
        content: TextField(
          controller: controlador,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ObjetivoService.create(
                Objetivo(nombre: controlador.text, proyectoId: widget.proyecto.id!),
              );
              cargarDatos();
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> mostrarDialogoNuevaTarea() async {
    if (objetivos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crea un objetivo primero')),
      );
      return;
    }

    final controladorTitulo = TextEditingController();
    int prioridad = 1;
    DateTime? fechaLimite;
    int objetivoElegido = objetivoFiltrado ?? objetivos.first.id!;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, actualizarDialogo) => AlertDialog(
          title: const Text('Nueva tarea'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [

            DropdownButtonFormField<int>(
              value: objetivoElegido,
              decoration: const InputDecoration(labelText: 'Objetivo'),
              items: objetivos.map((o) => DropdownMenuItem(
                value: o.id,
                child: Text(o.getNombre()),
              )).toList(),
              onChanged: (valor) => actualizarDialogo(() => objetivoElegido = valor!),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: controladorTitulo,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              value: prioridad,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 — Baja')),
                DropdownMenuItem(value: 2, child: Text('2 — Media')),
                DropdownMenuItem(value: 3, child: Text('3 — Alta')),
              ],
              onChanged: (valor) => actualizarDialogo(() => prioridad = valor ?? 1),
            ),
            const SizedBox(height: 8),

            Row(children: [
              Text(fechaLimite == null
                  ? 'Sin fecha'
                  : fechaLimite!.toLocal().toString().split(' ')[0]),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final fecha = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (fecha != null) actualizarDialogo(() => fechaLimite = fecha);
                },
                child: const Text('Elegir fecha'),
              ),
            ]),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await TareaService.create(Tarea(
                  titulo: controladorTitulo.text,
                  prioridad: prioridad,
                  fechaLimite: fechaLimite,
                  objetivoId: objetivoElegido,
                ));
                cargarDatos();
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tareasMostradas = obtenerTareasMostradas();
    final coloresPrioridad = {1: Colors.green, 2: Colors.orange, 3: Colors.red};
    final etiquetasPrioridad = {1: 'Baja', 2: 'Media', 3: 'Alta'};

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proyecto.getNombre()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Selector de estrategia de ordenación — patrón Strategy
          DropdownButton<String>(
            value: ordenActual,
            dropdownColor: Theme.of(context).colorScheme.primary,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'prioridad',
                  child: Text('↑ Prioridad', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'fecha',
                  child: Text('📅 Fecha', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'nombre',
                  child: Text('🔤 Nombre', style: TextStyle(color: Colors.white))),
            ],
            onChanged: (valor) => cambiarOrden(valor!),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [

        // Chips para filtrar por objetivo
        if (objetivos.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: const Text('Todos'),
                    selected: objetivoFiltrado == null,
                    onSelected: (_) => setState(() => objetivoFiltrado = null),
                  ),
                ),
                ...objetivos.map((objetivo) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(objetivo.getNombre()),
                    selected: objetivoFiltrado == objetivo.id,
                    onSelected: (_) => setState(() => objetivoFiltrado = objetivo.id),
                  ),
                )),
              ],
            ),
          ),

        // Lista de tareas ordenadas y filtradas
        Expanded(
          child: tareasMostradas.isEmpty
              ? const Center(child: Text('Sin tareas aún'))
              : ListView.builder(
            itemCount: tareasMostradas.length,
            itemBuilder: (_, indice) {
              final tarea = tareasMostradas[indice];
              final nombreObjetivo = objetivos
                  .firstWhere(
                    (o) => o.id == tarea.objetivoId,
                orElse: () => Objetivo(nombre: '?', proyectoId: 0),
              )
                  .getNombre();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: Checkbox(
                    value: tarea.completada,
                    onChanged: (_) async {
                      await TareaService.update(
                        tarea.id!,
                        tarea.copyWith(completada: !tarea.completada),
                      );
                      cargarDatos();
                    },
                  ),
                  title: Text(
                    tarea.getNombre(),
                    style: TextStyle(
                      decoration: tarea.completada
                          ? TextDecoration.lineThrough
                          : null,
                      color: tarea.completada ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text(
                    '📁 $nombreObjetivo  •  '
                        '${tarea.fechaLimite != null ? "📅 ${tarea.fechaLimite!.toLocal().toString().split(" ")[0]}" : "Sin fecha"}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: coloresPrioridad[tarea.prioridad]!
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: coloresPrioridad[tarea.prioridad]!),
                        ),
                        child: Text(
                          etiquetasPrioridad[tarea.prioridad]!,
                          style: TextStyle(
                            color: coloresPrioridad[tarea.prioridad],
                            fontSize: 11,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 20),
                        onPressed: () async {
                          await TareaService.delete(tarea.id!);
                          cargarDatos();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'botonObjetivo',
            onPressed: mostrarDialogoNuevoObjetivo,
            tooltip: 'Nuevo objetivo',
            child: const Icon(Icons.flag),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'botonTarea',
            onPressed: mostrarDialogoNuevaTarea,
            tooltip: 'Nueva tarea',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}