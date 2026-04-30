import 'PoliticaHotel.dart';

class Todoincluido implements PoliticaHotel{
  static const double sumplemento = 50.0;
  @override
  double calcular(double precioNoche, int noches) {
    return (precioNoche+sumplemento) * noches;
  }
}