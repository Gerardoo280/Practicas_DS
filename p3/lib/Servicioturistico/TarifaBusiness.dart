import 'PoliticaVuelo.dart';

class TarifaBusiness implements PoliticaVuelo{
  static const double multiplicador_adicional = 3.0;

  @override
  double calcular(double base) {
    return base * multiplicador_adicional;
  }
}