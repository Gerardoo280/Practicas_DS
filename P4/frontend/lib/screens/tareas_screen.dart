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
    for (final o in widget.proyecto.getObjetivos()) widget.proyecto.remove(o);
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

  Future<void> _nuevoObjetivo() async {
    final ctrl = TextEditingController();
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Nuevo objetivo'),
      content: TextField(controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
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
    ));
  }

  Future<void> _nuevaTarea(Objetivo o) async {
    final ctrl = TextEditingController();
    int prioridad = 1;
    DateTime? fechaLimite;
    await showDialog(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text('Nueva tarea — ${o.getNombre()}'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
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
                final p = await showDatePicker(context: ctx,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (p != null) setS(() => fechaLimite = p);
              },
              child: const Text('Elegir fecha'),
            ),
          ]),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await TareaService.create(Tarea(
                titulo: ctrl.text, prioridad: prioridad,
                fechaLimite: fechaLimite, objetivoId: o.id!,
              ));
              _cargar();
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final tareasOrdenadas = widget.proyecto.getTareasOrdenadas();
    final prioColors = {1: Colors.green, 2: Colors.orange, 3: Colors.red};
    final prioLabels = {1: 'Baja', 2: 'Media', 3: 'Alta'};

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proyecto.getNombre()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            value: _estrategiaActual,
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
            onChanged: (v) => _cambiarEstrategia(v!),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              if (_objetivos.isNotEmpty)
                SizedBox(height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _objetivos.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.all(6),
                      child: ActionChip(
                        label: Text(_objetivos[i].getNombre()),
                        onPressed: () => _nuevaTarea(_objetivos[i]),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: tareasOrdenadas.isEmpty
                    ? const Center(child: Text('Sin tareas — pulsa un objetivo para añadir'))
                    : ListView.builder(
                        itemCount: tareasOrdenadas.length,
                        itemBuilder: (_, i) {
                          final t = tareasOrdenadas[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                                  decoration: t.completada ? TextDecoration.lineThrough : null,
                                  color: t.completada ? Colors.grey : null,
                                ),
                              ),
                              subtitle: Text(t.fechaLimite != null
                                  ? '📅 ${t.fechaLimite!.toLocal().toString().split(" ")[0]}'
                                  : 'Sin fecha límite'),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: prioColors[t.prioridad]!.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: prioColors[t.prioridad]!),
                                  ),
                                  child: Text(prioLabels[t.prioridad]!,
                                      style: TextStyle(color: prioColors[t.prioridad], fontSize: 11)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () async {
                                    await TareaService.delete(t.objetivoId, t.id!);
                                    _cargar();
                                  },
                                ),
                              ]),
                            ),
                          );
                        }),
              ),
            ]),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.small(
          heroTag: 'obj',
          onPressed: _nuevoObjetivo,
          tooltip: 'Nuevo objetivo',
          child: const Icon(Icons.flag),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'tar',
          onPressed: _objetivos.isEmpty ? null : () => _nuevaTarea(_objetivos.first),
          tooltip: 'Nueva tarea',
          child: const Icon(Icons.add),
        ),
      ]),
    );
  }
}
