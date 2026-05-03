import 'PoliticaVuelo.dart';

class TarifaLowCost  implements PoliticaVuelo{
  static const double COSTE_ADICIONAL = 15.0;

  @override
  double calcular(double base) {
    return base + COSTE_ADICIONAL;
  }
}