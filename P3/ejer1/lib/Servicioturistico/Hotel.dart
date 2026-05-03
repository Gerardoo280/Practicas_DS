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
  }) {
    if (noches <= 0) {
      throw ArgumentError('Las noches deben ser mayor que cero');
    } else if(precioNoche <= 0) {
      throw ArgumentError('Las noches deben tener un precio mayor que cero');
    }
  }


  @override
  double getPrecio() {
    return politica.calcular(precioNoche, noches);
  }
}