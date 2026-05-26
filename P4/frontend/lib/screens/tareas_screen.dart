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
  List<Objetivo> _objetivos = [];
  int? _objetivoSeleccionado; // null = mostrar todos
  bool _cargando = true;
  String _estrategiaActual = 'prioridad';

  final Map<String, IOrdenStrategy> _estrategias = {
    'prioridad': OrdenarPorPrioridad(),
    'fecha':     OrdenarPorFecha(),
    'nombre':    OrdenarPorNombre(),
  };

  @override
  void initState() { super.initState(); _cargar(); }

  Future<void> _cargar() async {
    for (final o in widget.proyecto.getObjetivos()) {
      widget.proyecto.remove(o);
    }
    final objetivos = await ObjetivoService.getByProyecto(widget.proyecto.id!);
    for (final o in objetivos) {
      final tareas = await TareaService.getByObjetivo(o.id!);
      for (final t in tareas) o.add(t);
      widget.proyecto.add(o);
    }
    setState(() { _objetivos = objetivos; _cargando = false; });
  }

  void _cambiarEstrategia(String nueva) {
    setState(() {
      _estrategiaActual = nueva;
      widget.proyecto.estrategia = _estrategias[nueva]!;
    });
  }

  // Devuelve tareas filtradas por objetivo si hay uno seleccionado
  List<Tarea> _tareasFiltradas() {
    if (_objetivoSeleccionado == null) {
      return widget.proyecto.getTareasOrdenadas();
    }
    final obj = _objetivos.firstWhere((o) => o.id == _objetivoSeleccionado);
    return _estrategias[_estrategiaActual]!.ordenar(obj.getTareas());
  }

  Future<void> _nuevoObjetivo() async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo objetivo'),
        content: TextField(controller: ctrl,
            decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ObjetivoService.create(
                  Objetivo(nombre: ctrl.text, proyectoId: widget.proyecto.id!));
              _cargar();
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> _nuevaTarea() async {
    if (_objetivos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crea un objetivo primero')),
      );
      return;
    }

    final ctrl = TextEditingController();
    int prioridad = 1;
    DateTime? fechaLimite;
    // Si hay objetivo seleccionado lo preseleccionamos, si no el primero
    int objetivoElegido = _objetivoSeleccionado ?? _objetivos.first.id!;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Nueva tarea'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [

            // Selector de objetivo
            DropdownButtonFormField<int>(
              value: objetivoElegido,
              decoration: const InputDecoration(labelText: 'Objetivo'),
              items: _objetivos.map((o) => DropdownMenuItem(
                value: o.id,
                child: Text(o.getNombre()),
              )).toList(),
              onChanged: (v) => setS(() => objetivoElegido = v!),
            ),
            const SizedBox(height: 8),

            TextField(controller: ctrl,
                decoration: const InputDecoration(labelText: 'Título')),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              value: prioridad,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 — Baja')),
                DropdownMenuItem(value: 2, child: Text('2 — Media')),
                DropdownMenuItem(value: 3, child: Text('3 — Alta')),
              ],
              onChanged: (v) => setS(() => prioridad = v ?? 1),
            ),
            const SizedBox(height: 8),

            Row(children: [
              Text(fechaLimite == null ? 'Sin fecha' :
              fechaLimite!.toLocal().toString().split(' ')[0]),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final p = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (p != null) setS(() => fechaLimite = p);
                },
                child: const Text('Elegir fecha'),
              ),
            ]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await TareaService.create(Tarea(
                  titulo: ctrl.text,
                  prioridad: prioridad,
                  fechaLimite: fechaLimite,
                  objetivoId: objetivoElegido,
                ));
                _cargar();
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
    final tareas = _tareasFiltradas();
    final prioColors = {1: Colors.green, 2: Colors.orange, 3: Colors.red};
    final prioLabels = {1: 'Baja', 2: 'Media', 3: 'Alta'};

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proyecto.getNombre()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Selector Strategy
          DropdownButton<String>(
            value: _estrategiaActual,
            dropdownColor: Theme.of(context).colorScheme.primary,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'prioridad',
                  child: Text('↑ Prioridad',
                      style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'fecha',
                  child: Text('📅 Fecha',
                      style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'nombre',
                  child: Text('🔤 Nombre',
                      style: TextStyle(color: Colors.white))),
            ],
            onChanged: (v) => _cambiarEstrategia(v!),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [

        // Filtro por objetivo
        if (_objetivos.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              children: [
                // Chip "Todos"
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: const Text('Todos'),
                    selected: _objetivoSeleccionado == null,
                    onSelected: (_) =>
                        setState(() => _objetivoSeleccionado = null),
                  ),
                ),
                // Un chip por objetivo
                ..._objetivos.map((o) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(o.getNombre()),
                    selected: _objetivoSeleccionado == o.id,
                    onSelected: (_) =>
                        setState(() => _objetivoSeleccionado = o.id),
                  ),
                )),
              ],
            ),
          ),

        // Lista de tareas
        Expanded(
          child: tareas.isEmpty
              ? const Center(child: Text('Sin tareas aún'))
              : ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (_, i) {
              final t = tareas[i];
              // Nombre del objetivo de esta tarea
              final objNombre = _objetivos
                  .firstWhere((o) => o.id == t.objetivoId,
                  orElse: () => Objetivo(
                      nombre: '?', proyectoId: 0))
                  .getNombre();

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: Checkbox(
                    value: t.completada,
                    onChanged: (_) async {
                      await TareaService.update(t.id!,
                          t.copyWith(completada: !t.completada));
                      _cargar();
                    },
                  ),
                  title: Text(t.getNombre(),
                    style: TextStyle(
                      decoration: t.completada
                          ? TextDecoration.lineThrough : null,
                      color: t.completada ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Text(
                    '📁 $objNombre  •  '
                        '${t.fechaLimite != null ? "📅 ${t.fechaLimite!.toLocal().toString().split(" ")[0]}" : "Sin fecha"}',
                  ),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: prioColors[t.prioridad]!
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: prioColors[t.prioridad]!),
                          ),
                          child: Text(prioLabels[t.prioridad]!,
                              style: TextStyle(
                                  color: prioColors[t.prioridad],
                                  fontSize: 11)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 20),
                          onPressed: () async {
                            await TareaService.delete(t.id!);
                            _cargar();
                          },
                        ),
                      ]),
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
            heroTag: 'obj',
            onPressed: _nuevoObjetivo,
            tooltip: 'Nuevo objetivo',
            child: const Icon(Icons.flag),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'tar',
            onPressed: _nuevaTarea,
            tooltip: 'Nueva tarea',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}