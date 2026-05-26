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
  List<Proyecto> proyectos = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarProyectos();
  }

  Future<void> cargarProyectos() async {
    try {
      final lista = await ProyectoService.getAll();
      setState(() {
        proyectos = lista;
        cargando = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        cargando = false;
        error = e.toString();
      });
    }
  }

  Future<void> mostrarDialogoNuevoProyecto() async {
    final controladorNombre = TextEditingController();
    final controladorDesc = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo proyecto'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: controladorNombre,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: controladorDesc,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ProyectoService.create(Proyecto(
                nombre: controladorNombre.text,
                descripcion: controladorDesc.text,
                estrategia: OrdenarPorPrioridad(),
              ));
              cargarProyectos();
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> confirmarEliminar(Proyecto proyecto) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar proyecto'),
        content: Text('¿Eliminar "${proyecto.getNombre()}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmado == true) {
      await ProyectoService.delete(proyecto.id!);
      cargarProyectos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Proyectos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            const Text('Error al conectar con el servidor'),
            const SizedBox(height: 4),
            Text(error!,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cargarProyectos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      )
          : proyectos.isEmpty
          ? const Center(child: Text('No hay proyectos aún'))
          : ListView.builder(
        itemCount: proyectos.length,
        itemBuilder: (_, indice) {
          final proyecto = proyectos[indice];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                proyecto.getNombre(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: proyecto.descripcion.isNotEmpty
                  ? Text(proyecto.descripcion)
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => confirmarEliminar(proyecto),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TareasScreen(proyecto: proyecto),
                ),
              ).then((_) => cargarProyectos()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mostrarDialogoNuevoProyecto,
        child: const Icon(Icons.add),
      ),
    );
  }
}