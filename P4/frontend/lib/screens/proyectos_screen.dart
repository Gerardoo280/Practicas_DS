import 'package:flutter/material.dart';
import '../models/proyecto.dart';
import '../services/proyecto_service.dart';
import '../strategies/ordenar_por_prioridad.dart';
import 'tareas_screen.dart';

class ProyectosScreen extends StatefulWidget {
  const ProyectosScreen({super.key});
  @override
  State<ProyectosScreen> createState() => _ProyectosScreenState();
}

class _ProyectosScreenState extends State<ProyectosScreen> {
  List<Proyecto> _proyectos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() { super.initState(); _cargar(); }

  Future<void> _cargar() async {
    try {
      final lista = await ProyectoService.getAll();
      setState(() { _proyectos = lista; _cargando = false; _error = null; });
    } catch (e) {
      setState(() { _cargando = false; _error = e.toString(); });
    }
  }

  Future<void> _nuevo() async {
    final nombreCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    await showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Nuevo proyecto'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: descCtrl,
            decoration: const InputDecoration(labelText: 'Descripción')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await ProyectoService.create(Proyecto(
              nombre: nombreCtrl.text, descripcion: descCtrl.text,
              estrategia: OrdenarPorPrioridad(),
            ));
            _cargar();
          },
          child: const Text('Crear'),
        ),
      ],
    ));
  }

  Future<void> _eliminar(Proyecto p) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Eliminar proyecto'),
      content: Text('¿Eliminar "${p.getNombre()}"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
    if (ok == true) { await ProyectoService.delete(p.id!); _cargar(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Proyectos'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  const Text('Error al conectar con el servidor'),
                  const SizedBox(height: 4),
                  Text(_error!, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  // ⚠️ VERIFICAR CON BACKEND si aparece este error
                  ElevatedButton(onPressed: _cargar, child: const Text('Reintentar')),
                ]))
              : _proyectos.isEmpty
                  ? const Center(child: Text('No hay proyectos aún'))
                  : ListView.builder(
                      itemCount: _proyectos.length,
                      itemBuilder: (_, i) {
                        final p = _proyectos[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(p.getNombre(),
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: p.descripcion.isNotEmpty ? Text(p.descripcion) : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminar(p),
                            ),
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => TareasScreen(proyecto: p)),
                            ).then((_) => _cargar()),
                          ),
                        );
                      }),
      floatingActionButton: FloatingActionButton(onPressed: _nuevo, child: const Icon(Icons.add)),
    );
  }
}
