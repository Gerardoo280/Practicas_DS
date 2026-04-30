import 'PoliticaHotel.dart';

class Soloalojamiento implements PoliticaHotel{
  @override
  double calcular(double precioNoche, int noches) {
    return precioNoche * noches;
  }
}