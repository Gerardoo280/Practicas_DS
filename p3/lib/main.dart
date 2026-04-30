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
  final Paquete paquete = Paquete('Mi Paquete');

  // Campos del formulario
  final idCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final nochesCtrl = TextEditingController();

  String tipoServicio = 'vuelo';    // 'vuelo' o 'hotel'
  String politicaVuelo = 'lowcost'; // 'lowcost' o 'business'
  String politicaHotel = 'solo';    // 'solo' o 'todo'

  void agregarServicio() {
    final texto = idCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text) ?? 0;

    if (texto.isEmpty || precio <= 0) return;

    setState(() {
      if (tipoServicio == 'vuelo') {
        final politica =
        politicaVuelo == 'lowcost' ? TarifaLowCost() : TarifaBusiness();
        paquete.agregarservicio(
          Vuelo(id: texto, precioBase: precio, politica: politica),
        );
      } else {
        final noches = int.tryParse(nochesCtrl.text) ?? 1;
        final politica =
        politicaHotel == 'solo' ? Soloalojamiento() : Todoincluido();
        paquete.agregarservicio(
          Hotel(nombre: texto, precioNoche: precio, noches: noches, politica: politica),
        );
      }
    });

    idCtrl.clear();
    precioCtrl.clear();
    nochesCtrl.clear();
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
            Row(
              children: [
                const Text('Tipo: '),
                ToggleButtons(
                  isSelected: [
                    tipoServicio == 'vuelo',
                    tipoServicio == 'hotel',
                  ],
                  onPressed: (i) => setState(() {
                    tipoServicio = i == 0 ? 'vuelo' : 'hotel';
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

            TextField(
              controller: idCtrl,
              decoration: InputDecoration(
                labelText:
                tipoServicio == 'vuelo' ? 'ID del vuelo' : 'Nombre del hotel',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: tipoServicio == 'vuelo'
                    ? 'Precio base (€)'
                    : 'Precio por noche (€)',
                border: const OutlineInputBorder(),
              ),
            ),

            if (tipoServicio == 'hotel') ...[
              const SizedBox(height: 8),
              TextField(
                controller: nochesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de noches',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 12),

            if (tipoServicio == 'vuelo')
              DropdownButton<String>(
                value: politicaVuelo,
                items: const [
                  DropdownMenuItem(
                      value: 'lowcost', child: Text('LowCost (base + 15 €)')),
                  DropdownMenuItem(
                      value: 'business', child: Text('Business (base × 3)')),
                ],
                onChanged: (v) => setState(() => politicaVuelo = v!),
              )
            else
              DropdownButton<String>(
                value: politicaHotel,
                items: const [
                  DropdownMenuItem(
                      value: 'solo', child: Text('Solo Alojamiento')),
                  DropdownMenuItem(
                      value: 'todo',
                      child: Text('Todo Incluido (+50 €/noche)')),
                ],
                onChanged: (v) => setState(() => politicaHotel = v!),
              ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: agregarServicio,
              child: const Text('Añadir servicio'),
            ),

            const Divider(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: paquete.servicios.length,
                itemBuilder: (ctx, i) {
                  final s = paquete.servicios[i];
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
                              setState(() => paquete.eliminarservicio(s)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Text(
              'Total: ${paquete.getPrecio().toStringAsFixed(2)} €',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}