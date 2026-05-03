import 'PoliticaVuelo.dart';

class TarifaBusiness implements PoliticaVuelo {
  static const double MULTIPLICADOR = 3.0;

  @override
  double calcular(double base) {
    return base * MULTIPLICADOR;
  }
}