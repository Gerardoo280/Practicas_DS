import 'PoliticaHotel.dart';

class Todoincluido implements PoliticaHotel{
  static const double SUPLEMENTO = 50.0;
  @override
  double calcular(double precioNoche, int noches) {
    return (precioNoche + SUPLEMENTO) * noches;
  }
}