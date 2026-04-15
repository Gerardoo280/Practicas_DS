import 'package:flutter/material.dart';

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

class Autenticacion {
  String ejecutar(String correo){
    return "Autenticacion completada con éxito para ${correo}";
  }
}

abstract class Filtro {
  void ejecutar(String correo, String contrasena);
}

class Cadena {
  final List<Filtro> filtros = [];
  Autenticacion objetivo;

  void agregarFiltro(Filtro filtro){
    filtros.add(filtro);
  }

  void establecerObjetivo(Autenticacion objet){
    objetivo = objet;
  }

  void ejecutar(String correo, String contrasena){
    for(int i = 0; i < filtros.length; i++) {
      Filtro filtro = filtros[i];
      filtro.ejecutar(correo, contrasena);
    }

    if (objetivo != null){
      objetivo.ejecutar(correo, contrasena);
    }
    return true;
  }
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: Center(

      ),
    );
  }
}
