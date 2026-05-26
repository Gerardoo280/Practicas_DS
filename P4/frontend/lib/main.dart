import 'package:flutter/material.dart';
import 'screens/proyectos_screen.dart';

void main() => runApp(const GestionTareasApp());

class GestionTareasApp extends StatelessWidget {
  const GestionTareasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ProyectosScreen(),
    );
  }
}
