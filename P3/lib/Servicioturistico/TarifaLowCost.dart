import 'PoliticaVuelo.dart';

class TarifaLowCost  implements PoliticaVuelo{
  static const double coste_adicional = 15.0;

  @override
  double calcular(double base) {
    return base + coste_adicional;
  }
}