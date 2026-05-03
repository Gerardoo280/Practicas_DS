import 'Servicioturistico.dart';
import 'PoliticaVuelo.dart';

class Vuelo implements Servicioturistico {
  final String id;
  final double precioBase;
  PoliticaVuelo politica;

  Vuelo({
    required this.id,
    required this.precioBase,
    required this.politica,
  }) {
    if (precioBase < 0) {
      throw ArgumentError('El precio base no puede ser negativo');
    }
  }

  @override
  double getPrecio() {
    return politica.calcular(precioBase);
  }
}