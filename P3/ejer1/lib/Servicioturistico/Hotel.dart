import 'Servicioturistico.dart';
import 'PoliticaHotel.dart';

class Hotel implements Servicioturistico{
  final String nombre;
  final double precioNoche;
  final int noches;
  PoliticaHotel politica;

  Hotel({
    required this.nombre,
    required this.precioNoche,
    required this.noches,
    required this.politica,
  });


  @override
  double getPrecio() {
    return politica.calcular(precioNoche, noches);
  }
}