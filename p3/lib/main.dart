import 'package:flutter/material.dart';
import 'package:p3/Servicioturistico/Paquete.dart';
import 'package:p3/Servicioturistico/Vuelo.dart';
import 'package:p3/Servicioturistico/Hotel.dart';
import 'package:p3/Servicioturistico/TarifaLowCost.dart';
import 'package:p3/Servicioturistico/TarifaBusiness.dart';
import 'package:p3/Servicioturistico/Soloalojamiento.dart';
import 'package:p3/Servicioturistico/Todoincluido.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paquetes Turísticos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Paquete _paquete = Paquete('Mi Paquete');

  // Campos del formulario
  final _idCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _nochesCtrl = TextEditingController();

  String _tipoServicio = 'vuelo';    // 'vuelo' o 'hotel'
  String _politicaVuelo = 'lowcost'; // 'lowcost' o 'business'
  String _politicaHotel = 'solo';    // 'solo' o 'todo'

  void _agregarServicio() {
    final texto = _idCtrl.text.trim();
    final precio = double.tryParse(_precioCtrl.text) ?? 0;

    if (texto.isEmpty || precio <= 0) return;

    setState(() {
      if (_tipoServicio == 'vuelo') {
        final politica =
        _politicaVuelo == 'lowcost' ? TarifaLowCost() : TarifaBusiness();
        _paquete.agregarservicio(
          Vuelo(id: texto, precioBase: precio, politica: politica),
        );
      } else {
        final noches = int.tryParse(_nochesCtrl.text) ?? 1;
        final politica =
        _politicaHotel == 'solo' ? Soloalojamiento() : Todoincluido();
        _paquete.agregarservicio(
          Hotel(nombre: texto, precioNoche: precio, noches: noches, politica: politica),
        );
      }
    });

    _idCtrl.clear();
    _precioCtrl.clear();
    _nochesCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Paquetes Turísticos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Tipo de servicio ──────────────────────────────────────────
            Row(
              children: [
                const Text('Tipo: '),
                ToggleButtons(
                  isSelected: [
                    _tipoServicio == 'vuelo',
                    _tipoServicio == 'hotel',
                  ],
                  onPressed: (i) => setState(() {
                    _tipoServicio = i == 0 ? 'vuelo' : 'hotel';
                  }),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Vuelo'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Hotel'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── ID / Nombre ───────────────────────────────────────────────
            TextField(
              controller: _idCtrl,
              decoration: InputDecoration(
                labelText:
                _tipoServicio == 'vuelo' ? 'ID del vuelo' : 'Nombre del hotel',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            // ── Precio ────────────────────────────────────────────────────
            TextField(
              controller: _precioCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tipoServicio == 'vuelo'
                    ? 'Precio base (€)'
                    : 'Precio por noche (€)',
                border: const OutlineInputBorder(),
              ),
            ),

            // ── Noches (solo hotel) ───────────────────────────────────────
            if (_tipoServicio == 'hotel') ...[
              const SizedBox(height: 8),
              TextField(
                controller: _nochesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de noches',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ── Política ──────────────────────────────────────────────────
            if (_tipoServicio == 'vuelo')
              DropdownButton<String>(
                value: _politicaVuelo,
                items: const [
                  DropdownMenuItem(
                      value: 'lowcost', child: Text('LowCost (base + 15 €)')),
                  DropdownMenuItem(
                      value: 'business', child: Text('Business (base × 1.5)')),
                ],
                onChanged: (v) => setState(() => _politicaVuelo = v!),
              )
            else
              DropdownButton<String>(
                value: _politicaHotel,
                items: const [
                  DropdownMenuItem(
                      value: 'solo', child: Text('Solo Alojamiento')),
                  DropdownMenuItem(
                      value: 'todo',
                      child: Text('Todo Incluido (+30 €/noche)')),
                ],
                onChanged: (v) => setState(() => _politicaHotel = v!),
              ),

            const SizedBox(height: 8),

            // ── Botón añadir ──────────────────────────────────────────────
            ElevatedButton(
              onPressed: _agregarServicio,
              child: const Text('Añadir servicio'),
            ),

            const Divider(height: 24),

            // ── Lista de servicios ────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                itemCount: _paquete.servicios.length,
                itemBuilder: (ctx, i) {
                  final s = _paquete.servicios[i];
                  final nombre = s is Vuelo
                      ? 'Vuelo ${s.id}'
                      : 'Hotel ${(s as Hotel).nombre}';
                  return ListTile(
                    leading: Icon(s is Vuelo ? Icons.flight : Icons.hotel),
                    title: Text(nombre),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${s.getPrecio().toStringAsFixed(2)} €'),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              setState(() => _paquete.eliminarservicio(s)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Precio total ──────────────────────────────────────────────
            Text(
              'Total: ${_paquete.getPrecio().toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}