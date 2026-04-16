import 'package:flutter/material.dart';
import 'package:ejer3/patron_filtros.dart';
import 'package:ejer3/filtros_correo.dart';
import 'package:ejer3/filtro_contrasena.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejercicio grupal de la P2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Servicio de Autenticación'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final List<String> emailsRegistrados = [
    "gerardito@gmail.com",
    "claudio@go.ugr.es",
    "profesor@correo.ugr.es"
  ];

  late GestorFiltros gestor;
  String resultado = "";

  @override
  void initState() {
    super.initState();

    Autenticacion auth = Autenticacion();
    gestor = GestorFiltros(auth);

    gestor.agregarFiltro(FiltroArroba());
    gestor.agregarFiltro(FiltroDominio());
    gestor.agregarFiltro(FiltroLongitud());
    gestor.agregarFiltro(FiltroMayuscula());
    gestor.agregarFiltro(FiltroNumero());
    gestor.agregarFiltro(FiltroCaracterEspecial());
    gestor.agregarFiltro(FiltroCorreoEnContrasena());
    gestor.agregarFiltro(FiltroEmailExistente(emailsRegistrados));
  }

  void autenticar() {
    String correo = correoController.text;
    String pass = passController.text;

    String res = gestor.procesarPeticion(correo, pass);

    setState(() {
      resultado = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Autenticación con filtros")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: correoController,
              decoration: InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: autenticar,
              child: Text("Login"),
            ),
            SizedBox(height: 20),

            Text(
              resultado,
              style: TextStyle(
                color: resultado.startsWith("Error") ? Colors.red : Colors.green,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
