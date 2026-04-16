import 'package:flutter/material.dart';
import 'secret_keeper.dart';
import 'basic_secret_keeper.dart';
import 'decoradores.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guardián de Gemini',
      home: const PantallaSeleccion(),
    );
  }
}

class PantallaSeleccion extends StatefulWidget {
  const PantallaSeleccion({super.key});

  @override
  State<PantallaSeleccion> createState() => _PantallaSeleccionState();
}

class _PantallaSeleccionState extends State<PantallaSeleccion> {
  String _dificultad = 'Fácil';

  SecretKeeper _configurarGuardian() {

    SecretKeeper guardian = BasicSecretKeeper("TORNILLO");

    if (_dificultad == 'Medio') {
      guardian = KeywordBlockDecorator(guardian);
    } else if (_dificultad == 'Difícil') {
      guardian = KeywordBlockDecorator(guardian);
      guardian = StrongSystemPromptDecorator(guardian);
      guardian = LengthLimitDecorator(guardian);
    }

    return guardian;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'EL GUARDIÁN DEL SECRETO',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Elige un nivel de dificultad para el desafío:'),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _dificultad,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'Fácil',
                  child: Text('Fácil'),
                ),
                DropdownMenuItem(
                  value: 'Medio',
                  child: Text('Medio'),
                ),
                DropdownMenuItem(
                  value: 'Difícil',
                  child: Text('Difícil'),
                ),
              ],
              onChanged: (valorSeleccionado) {
                setState(() {
                  _dificultad = valorSeleccionado!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaChat(guardian: _configurarGuardian()),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Comenzar Desafío'),
            ),
          ],
        ),
      ),
    );
  }
}

class PantallaChat extends StatefulWidget {
  final SecretKeeper guardian;
  const PantallaChat({super.key, required this.guardian});

  @override
  State<PantallaChat> createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  final _msgCtrl = TextEditingController();
  final List<Map<String, String>> _mensajes = [];
  bool _cargando = false;

  void _enviar() async {
    final texto = _msgCtrl.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _mensajes.add({'rol': 'user', 'texto': texto});
      _cargando = true;
    });
    _msgCtrl.clear();

    try {
      final respuesta = await widget.guardian.ask(texto);
      setState(() {
        _mensajes.add({'rol': 'bot', 'texto': respuesta});
      });
    } catch (e) {
      print(e);
      setState(() {
        _mensajes.add({'rol': 'bot', 'texto': 'Error: Revisa tu API Key o conexión.'});
      });
    } finally {
      setState(() => _cargando = false);
    }
  }

  // Hacemos uso de la IA para programar el visualizado de la conversación
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desafía al Guardián')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final m = _mensajes[index];
                final soyYo = m['rol'] == 'user';
                return Align(
                  alignment: soyYo ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: soyYo ? Colors.deepPurple[50] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(m['texto']!),
                  ),
                );
              },
            ),
          ),
          if (_cargando) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(hintText: 'Convence al guardián...'),
                    onSubmitted: (_) => _enviar(),
                  ),
                ),
                IconButton(onPressed: _enviar, icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}